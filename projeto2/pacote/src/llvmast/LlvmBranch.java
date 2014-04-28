package llvmast;

public  class LlvmBranch extends LlvmInstruction
{
	private boolean conditional;
	
	public LlvmValue cond;
	public LlvmLabelValue label, brTrue, brFalse;
	

    public LlvmBranch(LlvmLabelValue label)
    {
    	this.conditional = false;
    	this.label = label;
    }
    
    public LlvmBranch(LlvmValue cond,  LlvmLabelValue brTrue, LlvmLabelValue brFalse)
    {
    	this.conditional = true;
    	this.cond = cond;
    	this.brTrue = brTrue;
    	this.brFalse = brFalse;
    }

    public String toString()
    {
    	if (conditional) {
    		return "  br i1 " + cond + ", label %" + brTrue + ", label %" + brFalse;
    	}
    	else {
    		return "  br label %" + label;
    	}
    }
}