#include "deadLoad.h"

using namespace llvm;

namespace {
  struct deadLoad : public FunctionPass
  {
    
    deadLoad() : FunctionPass(ID) {}
    
    virtual bool runOnFunction(Function &F)
    {
      errs() << "deadLoad: ";
      errs() << F.getName() << '\n';

      for (Function::iterator b = F.begin(), be = F.end(); b != be; ++b)
      {
        errs() << "Basic block (name=" << b->getName() << ") has " << b->size() << " instructions.\n";

        deadLoad::isLastInstStore = false;
        deadLoad::lastStoreOp0 = NULL;
        deadLoad::lastStoreOp1 = NULL;

        for (BasicBlock::iterator i = b->begin(), ie = b->end(); i != ie; ++i)
        {

          // se a instrucao eh load
          if (isa<LoadInst>(i))
          {
            Value *v = i->getOperand(0);

            if (isLastInstStore && v->hasName())
            {
              if (deadLoad::lastStoreOp0 != NULL && deadLoad::lastStoreOp1 != NULL)
              {

                if (deadLoad::lastStoreOp1->getName() == v->getName())
                {
                  errs() << "USELESS LOAD\n";
                  errs() << "  LD_OP " << v->getName();
                  errs() << " == ST_OP " << deadLoad::lastStoreOp1->getName();
                  errs() << " replace with " << deadLoad::lastStoreOp0->getName();
                  errs() << *i << "\n";
                  errs() << "\n";

                  i->replaceAllUsesWith(deadLoad::lastStoreOp0);
                  Instruction &deadInst = *i;
                  i--;
                  deadInst.eraseFromParent();

                }
              }
            }
          }

          // verifica se a instrucao eh de store e seta as variaveis necessarias
          // para retirar um load desnecessario
          if (isa<StoreInst>(i))
          {
            deadLoad::isLastInstStore = true;
            deadLoad::lastStoreOp0 = i->getOperand(0);
            deadLoad::lastStoreOp1 = i->getOperand(1);
          }
          else
          {
            deadLoad::isLastInstStore = false;
          }
        }
      }

      return false;
    }
  }; // end-class deadLoad
}

char deadLoad::ID = 0;
static RegisterPass<deadLoad> X("deadLoad", "deadLoad Pass", false, false);
