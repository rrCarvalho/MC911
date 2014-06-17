#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/InstIterator.h"

namespace llvm {
  struct deadLoad : public FunctionPass
  {
  private:
    bool isLastInstStore;
    Value *lastStoreOp0;
    Value *lastStoreOp1;
  public:
    static char ID;
    deadLoad() : FunctionPass(ID) {}
    virtual bool runOnFunction(Function &F);
  };
}
