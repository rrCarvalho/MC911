#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/ValueSymbolTable.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;
namespace {
  struct deadcode : public FunctionPass {
    static char ID;
    deadcode() : FunctionPass(ID) {}
    virtual bool runOnFunction(Function &F) {
      bool hasChanged = false;
      std::map<StringRef, Value *> map;
      ValueSymbolTable::iterator i = F.getValueSymbolTable().begin();
      ValueSymbolTable::iterator i_end = F.getValueSymbolTable().end();
      while (i != i_end) {
        map.insert(std::pair<StringRef, Value *>((*i).first(), (*i).second());
        i++;
      }
      int c = 0;
      while (!map.empty()) {
        Value *v = (*map.begin()).second;
        map.erase(map.begin());
        if (isa<Instruction>(v) && v->use_empty()) {
          Instruction *I = (Instruction *)v;
          if (!I->mayHaveSideEffects())
          {
            for (int i = 0; i < I->getNumOperands(); i++) {
              map.insert(std::pair<StringRef, Value *>(I->getOperand(i)->getName(), I->getOperand(i)));
            }
            I->eraseFromParent();
            c++;
            hasChanged = true;
          }
        }
      }
      errs() << c << " changed" << std::endl;
      return hasChanged;
    }//runOnFunction method closure
  };//deadcode class closure
}
char deadcode::ID = 0;
static RegisterPass<deadcode> X("deadcode", "deadcode elimination", false, false);
