package llvmast;
public class LlvmLabelValue extends LlvmValue{
    public String value;
    static int numberLabel = 0;
    
    public LlvmLabelValue(String value){
	type = LlvmPrimitiveType.LABEL;
	this.value = value+numberLabel;
    }
    
    public static void Labeladd(){
		numberLabel++;
	}

    public String toString(){
	return ""+ value;
    }
}