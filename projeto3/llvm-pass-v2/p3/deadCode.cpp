#include "llvm/Pass.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/ValueSymbolTable.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/InstIterator.h"

#include "llvm/Transforms/Scalar.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/ConstantFolding.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Target/TargetLibraryInfo.h"
#include <set>

using namespace llvm;

namespace {
	struct deadCode : public FunctionPass
	{
	private:
	public:
		static char ID;
		deadCode() : FunctionPass(ID) {}

	    virtual void getAnalysisUsage(AnalysisUsage &AU) const {
	    	AU.setPreservesCFG();
	    	AU.addRequired<TargetLibraryInfo>();
	    }

		virtual bool runOnFunction(Function &F)
		{
			bool has_changed = false;
			bool is_iterating = true;

			// work list to do constant propagation
			std::set<Instruction*> WorkList;
			// instructions map; tuple (instruction, live)
			DenseMap<Instruction*, bool> inst_map;
			for (Function::iterator b = F.begin(), be = F.end(); b != be; ++b) {
				for (BasicBlock::iterator i = b->begin(), ie = b->end(); i != ie; ++i) {
					WorkList.insert(&*i);
					if (isa<Instruction>(i))
						inst_map.insert(std::make_pair(&*i, false));
				}
			}

			DataLayout *TD = getAnalysisIfAvailable<DataLayout>();
			TargetLibraryInfo *TLI = &getAnalysis<TargetLibraryInfo>();

			while (is_iterating) {
				is_iterating = false;

				// iterating over the instruction list to check for liveness
				DenseMap<Instruction *, bool>::iterator i = inst_map.begin();
				DenseMap<Instruction *, bool>::iterator i_end = inst_map.end();
				while (i != i_end) {
					Instruction *inst = (*i).first;
					if ((*i).second == false) {
						// checks for trivial liveness
						if (	inst->mayHaveSideEffects()
								|| isa<TerminatorInst>(inst)
								|| isa<DbgInfoIntrinsic>(inst)
								|| isa<LandingPadInst>(inst)
								|| isa<StoreInst>(inst)
								|| isa<LoadInst>(inst)
								|| isa<AtomicRMWInst>(inst)
								|| isa<AtomicCmpXchgInst>(inst)) {
							(*i).second = true;
							is_iterating = true;
						}
						// check the use list for possible live instructions
						Value::use_iterator u = inst-> use_begin();
						for( ; u != inst->use_end(); ++u) {
							if (isa<Instruction>(*u) && inst_map.lookup((Instruction *)(*u))) {
								(*i).second = true;
								is_iterating = true;
							}
						}
					}
					// next (instruction, live) tuple in the map
					i++;
				}// end while (i != i_end)
			}// end while (is_iterating)

			// iterating over the instruction map to remove dead code
			DenseMap<Instruction *, bool>::iterator i = inst_map.begin();
			DenseMap<Instruction *, bool>::iterator i_end = inst_map.end();
			while (i != i_end) {
				if ((*i).second == false) {
					errs() << (*i).first->getName() << "\n";
					(*i).first->eraseFromParent();
					has_changed = true;
				}
				i++;
			}

			// iterating over the work list to remove dead code and do constant folding
			while (!WorkList.empty()) {
				Instruction *I = *WorkList.begin();
				WorkList.erase(WorkList.begin());
				if (!I->use_empty())
					if (Constant *C = ConstantFoldInstruction(I, TD, TLI)) {
						for (Value::use_iterator UI = I->use_begin(), UE = I->use_end(); UI != UE; ++UI)
							WorkList.insert(cast<Instruction>(*UI));
						I->replaceAllUsesWith(C);
						WorkList.erase(I);
						I->eraseFromParent();

					}
			}

			return has_changed;
		}// runOnFunction method closure
	};// deadCode class closure
}

char deadCode::ID = 0;
static RegisterPass<deadCode> X("dce-p3", "Dead Code Elimination", false, false);
