package llvmast;

public  class LlvmIcmp extends LlvmInstruction
{
	public static final int eq = 1;
	public static final int ne = 2;
	public static final int ugt = 3;
	public static final int uge = 4;
	public static final int ult = 5;
	public static final int ule = 6;
	public static final int sgt = 7;
	public static final int sge = 8;
	public static final int slt = 9;
	public static final int sle = 10;
	
	public LlvmRegister lhs;
	public String conditionTag;
	public LlvmType type;
	public LlvmValue op1, op2;
    
    public LlvmIcmp(LlvmRegister lhs,  int conditionCode, LlvmType type, LlvmValue op1, LlvmValue op2)
    {
    	this.lhs = lhs;
    	this.type = type;
    	this.op1 = op1;
    	this.op2 = op2;
    	switch(conditionCode) {
    		case eq:
    			this.conditionTag = "eq";
    			break;
    		case ne:
    			this.conditionTag = "ne";
    			break;
    		case ugt:
    			this.conditionTag = "ugt";
    			break;
    		case uge:
    			this.conditionTag = "uge";
    			break;
    		case ult:
    			this.conditionTag = "ult";
    			break;
    		case ule:
    			this.conditionTag = "ule";
    			break;
    		case sgt:
    			this.conditionTag = "sgt";
    			break;
    		case sge:
    			this.conditionTag = "sge";
    			break;
    		case slt:
    			this.conditionTag = "slt";
    			break;
    		case sle:
    			this.conditionTag = "sle";
    			break;
    	}
    }

    public String toString()
    {
		return "  " + lhs + " = icmp " + conditionTag + " " + type + " " + op1 + ", " + op2;
    }
}