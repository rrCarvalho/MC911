package llvmast;

public  class LlvmLogic extends LlvmInstruction
{
	public static final int and	= 0;
	public static final int or	= 1;
	public static final int xor	= 2;
	
	public LlvmRegister res;
	public String tag;
	public LlvmType type;
	public LlvmValue op1, op2;
    
    public LlvmLogic(LlvmRegister lhs,  int code, LlvmType type, LlvmValue op1, LlvmValue op2)
    {
    	this.res = lhs;
    	this.type = type;
    	this.op1 = op1;
    	this.op2 = op2;
    	switch(code) {
    		case and:
    			this.tag = "and";
    			break;
    		case or:
    			this.tag = "or";
    			break;
    		case xor:
    			this.tag = "xor";
    			break;
    	}
    }

    public String toString()
    {
		return "  " + res + " = " + tag + " " + type + " " + op1 + ", " + op2;
    }
}