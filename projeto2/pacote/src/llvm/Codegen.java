/*****************************************************
Esta classe Codegen é a responsável por emitir LLVM-IR. 
Ela possui o mesmo método 'visit' sobrecarregado de
acordo com o tipo do parâmetro. Se o parâmentro for
do tipo 'While', o 'visit' emitirá código LLVM-IR que 
representa este comportamento. 
Alguns métodos 'visit' já estão prontos e, por isso,
a compilação do código abaixo já é possível.

class a{
    public static void main(String[] args){
    	System.out.println(1+2);
    }
}

O pacote 'llvmast' possui estruturas simples 
que auxiliam a geração de código em LLVM-IR. Quase todas 
as classes estão prontas; apenas as seguintes precisam ser 
implementadas: 

// llvmasm/LlvmBranch.java
// llvmasm/LlvmIcmp.java
// llvmasm/LlvmMinus.java
// llvmasm/LlvmTimes.java


Todas as assinaturas de métodos e construtores 
necessárias já estão lá. 


Observem todos os métodos e classes já implementados
e o manual do LLVM-IR (http://llvm.org/docs/LangRef.html) 
como guia no desenvolvimento deste projeto. 

****************************************************/
package llvm;

import semant.Env;
import syntaxtree.*;
import llvmast.*;

import java.util.*;

public class Codegen extends VisitorAdapter{
	private List<LlvmInstruction> assembler;
	private Codegen codeGenerator;

  	private SymTab symTab;
	private ClassNode classEnv; 	// Aponta para a classe atualmente em uso em symTab
	private MethodNode methodEnv; 	// Aponta para a metodo atualmente em uso em symTab


	public Codegen(){
		assembler = new LinkedList<LlvmInstruction>();
	}

	// Método de entrada do Codegen
	public String translate(Program p, Env env){	
		codeGenerator = new Codegen();

		// Preenchendo a Tabela de Símbolos
		// Quem quiser usar 'env', apenas comente essa linha
		//codeGenerator.symTab.FillTabSymbol(p);
		
		// Formato da String para o System.out.printlnijava "%d\n"
		codeGenerator.assembler.add(new LlvmConstantDeclaration("@.formatting.string", "private constant [4 x i8] c\"%d\\0A\\00\""));	

		// NOTA: sempre que X.accept(Y), então Y.visit(X);
		// NOTA: Logo, o comando abaixo irá chamar codeGenerator.visit(Program), linha 75
		p.accept(codeGenerator);

		// Link do printf
		List<LlvmType> pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		pts.add(LlvmPrimitiveType.DOTDOTDOT);
		codeGenerator.assembler.add(new LlvmExternalDeclaration("@printf", LlvmPrimitiveType.I32, pts)); 
		List<LlvmType> mallocpts = new LinkedList<LlvmType>();
		mallocpts.add(LlvmPrimitiveType.I32);
		codeGenerator.assembler.add(new LlvmExternalDeclaration("@malloc", new LlvmPointer(LlvmPrimitiveType.I8),mallocpts)); 


		String r = new String();
		for(LlvmInstruction instr : codeGenerator.assembler)
			r += instr+"\n";
		return r;
	}

	public LlvmValue visit(Program n){
		n.mainClass.accept(this);

		for (util.List<ClassDecl> c = n.classList; c != null; c = c.tail)
			c.head.accept(this);

		return null;
	}

	public LlvmValue visit(MainClass n){
		
		// definicao do main 
		assembler.add(new LlvmDefine("@main", LlvmPrimitiveType.I32, new LinkedList<LlvmValue>()));
		assembler.add(new LlvmLabel(new LlvmLabelValue("entry")));
		LlvmRegister R1 = new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I32));
		assembler.add(new LlvmAlloca(R1, LlvmPrimitiveType.I32, new LinkedList<LlvmValue>()));
		assembler.add(new LlvmStore(new LlvmIntegerLiteral(0), R1));

		// Statement é uma classe abstrata
		// Portanto, o accept chamado é da classe que implementa Statement, por exemplo,  a classe "Print". 
		n.stm.accept(this);  

		// Final do Main
		LlvmRegister R2 = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmLoad(R2,R1));
		assembler.add(new LlvmRet(R2));
		assembler.add(new LlvmCloseDefinition());
		return null;
	}
	
	public LlvmValue visit(Plus n){
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmPlus(lhs,LlvmPrimitiveType.I32,v1,v2));
		return lhs;
	}
	
	public LlvmValue visit(Print n){

		LlvmValue v =  n.exp.accept(this);

		// getelementptr:
		LlvmRegister lhs = new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I8));
		LlvmRegister src = new LlvmNamedValue("@.formatting.string",new LlvmPointer(new LlvmArray(4,LlvmPrimitiveType.I8)));
		List<LlvmValue> offsets = new LinkedList<LlvmValue>();
		offsets.add(new LlvmIntegerLiteral(0));
		offsets.add(new LlvmIntegerLiteral(0));
		List<LlvmType> pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		List<LlvmValue> args = new LinkedList<LlvmValue>();
		args.add(lhs);
		args.add(v);
		assembler.add(new LlvmGetElementPointer(lhs,src,offsets));

		pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		pts.add(LlvmPrimitiveType.DOTDOTDOT);
		
		// printf:
		assembler.add(new LlvmCall(new LlvmRegister(LlvmPrimitiveType.I32),
				LlvmPrimitiveType.I32,
				pts,				 
				"@printf",
				args
				));
		return null;
	}
	
	public LlvmValue visit(IntegerLiteral n){
		return new LlvmIntegerLiteral(n.value);
	};
	
	
	
/* ******************************************************************
 *   Nossos visitors
 * ****************************************************************** */
	
	public LlvmValue visit(ClassDeclSimple n)
	{
		List<LlvmType> typeList = new LinkedList<LlvmType>();
		for (util.List<VarDecl> v = n.varList; v != null; v = v.tail) {
			typeList.add(v.head.type.accept(this).type);
		}
		
		LlvmStructure structVarTypes = new LlvmStructure(typeList);
		
		assembler.add(new LlvmConstantDeclaration("%class." + n.name.s,
				"type " + structVarTypes));
		
		for (util.List<syntaxtree.MethodDecl> m = n.methodList;
				m != null; m = m.tail) {
			m.head.accept(this);
		}
		
		return null;
	}
	public LlvmValue visit(ClassDeclExtends n){return null;}
	
	public LlvmValue visit(VarDecl n)
	{
		return new LlvmRegister("%" + n.name.s, n.type.accept(this).type);
	}
	
	public LlvmValue visit(MethodDecl n)
	{
		// cria uma lista com os params
		List<LlvmValue> args = new LinkedList<LlvmValue>();
		args.add(new LlvmRegister("%this",
				new LlvmPointer(new LlvmClassType("%class."))));
		for (util.List<syntaxtree.Formal> f = n.formals;
				f != null; f = f.tail) {
			args.add(f.head.accept(this));
		}
		
		// tipo de retorno do metodo
		LlvmType retType = n.returnType.accept(this).type;
		
		// definicao do metodo
		assembler.add(new LlvmDefine("@__" + n.name.s + "_",
				retType, args));
		
		// entrada do metodo
		LlvmLabelValue.Labelclear();
		assembler.add(new LlvmLabel(new LlvmLabelValue("entry")));
		
		
		// alocando return
		LlvmRegister R1 = new LlvmRegister(new LlvmPointer(retType));
		assembler.add(new LlvmAlloca(R1, retType,
				new LinkedList<LlvmValue>()));
		assembler.add(new LlvmStore(new LlvmIntegerLiteral(0), R1));
		
		
		// alocar params
		for (int i = 1; i < args.size(); i++)
		{
			LlvmValue aReg = args.get(i);
			
			LlvmValue aR1 = new LlvmRegister(aReg + "_addr", aReg.type);
			assembler.add(new LlvmAlloca(aR1, aR1.type,
					new LinkedList<LlvmValue>()));
	
			aR1.type = new LlvmPointer(aR1.type);
			assembler.add(new LlvmStore(aReg, aR1));
		}
		
		
		// declaracao das vars locais
		for (util.List<syntaxtree.VarDecl> v = n.locals; v != null;
				v = v.tail)
		{
			LlvmValue vReg = v.head.accept(this);
			assembler.add(new LlvmAlloca(vReg, vReg.type,
					new LinkedList<LlvmValue>()));
		}

		// body
		for (util.List<syntaxtree.Statement> s = n.body; s != null;
				s = s.tail)
		{
			s.head.accept(this);
		}
		
		// retornando return
		LlvmRegister R2 = new LlvmRegister(retType);
		assembler.add(new LlvmLoad(R2,R1));
		assembler.add(new LlvmRet(R2));
		assembler.add(new LlvmCloseDefinition());
		
		return null;
	}
	
	public LlvmValue visit(Formal n)
	{
		return new LlvmRegister("%" + n.name.s, n.type.accept(this).type);
	}
	
	public LlvmValue visit(IntArrayType n)
	{
		return new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I32));
	}
	
	public LlvmValue visit(BooleanType n)
	{
		return new LlvmRegister(LlvmPrimitiveType.I1);
	}
	
	public LlvmValue visit(IntegerType n)
	{
		return new LlvmRegister(LlvmPrimitiveType.I32);
	}
	
	public LlvmValue visit(IdentifierType n)
	{
		switch (n.name)
		{
		case "i1":
			return new LlvmRegister(LlvmPrimitiveType.I1);
		case "i8":
			return new LlvmRegister(LlvmPrimitiveType.I8);
		case "i32":
			return new LlvmRegister(LlvmPrimitiveType.I32);
		case "void":
			return new LlvmRegister(LlvmPrimitiveType.VOID);
		case "label":
			return new LlvmRegister(LlvmPrimitiveType.LABEL);
		case "...":
			return new LlvmRegister(LlvmPrimitiveType.DOTDOTDOT);
		}

		return null;
	}
	
	public LlvmValue visit(Block n)
	{
		for (util.List<Statement> s = n.body; s != null; s = s.tail) {
			s.head.accept(this);
		}
		
		return null;
	}
	
	public LlvmValue visit(If n)
	{
		// labels necessarios
		LlvmLabelValue ifThen = new LlvmLabelValue("IfThen");
		LlvmLabelValue ifElse = new LlvmLabelValue("IfElse");
		LlvmLabelValue ifEnd = new LlvmLabelValue("IfEnd");
		
		// teste if
		LlvmValue cond = n.condition.accept(this);
		assembler.add(new LlvmBranch(cond, ifThen, ifElse));
		
		//bloco then
		LlvmLabelValue.Labeladd();
		assembler.add(new LlvmLabel(ifThen));
		n.thenClause.accept(this);
		assembler.add(new LlvmBranch(ifEnd));
		
		// bloco else
		if (n.elseClause != null) { 
			assembler.add(new LlvmLabel(ifElse));
			n.elseClause.accept(this);
			assembler.add(new LlvmBranch(ifEnd));
		}
		
		// fim do if
		assembler.add(new LlvmLabel(ifEnd));
		
		return null;
	}
	
	public LlvmValue visit(While n)
	{
		// labels necessarios
		LlvmLabelValue whileTest = new LlvmLabelValue("WhileTest");
		LlvmLabelValue whileStart = new LlvmLabelValue("WhileStart");
		LlvmLabelValue whileEnd = new LlvmLabelValue("WhileEnd");

		// teste while
		LlvmLabelValue.Labeladd();
		assembler.add(new LlvmBranch(whileTest));
		assembler.add(new LlvmLabel(whileTest));
		LlvmValue cond = n.condition.accept(this);
		assembler.add(new LlvmBranch(cond, whileStart, whileEnd));
		
		// bloco do
		assembler.add(new LlvmLabel(whileStart));
		n.body.accept(this);
		assembler.add(new LlvmBranch(whileTest));
		
		// fim do while
		assembler.add(new LlvmLabel(whileEnd));
		
		return null;
	}
	public LlvmValue visit(Assign n)
	{
		LlvmValue exp = n.exp.accept(this);
		LlvmRegister var = new LlvmRegister("%" + n.var.s, exp.type);
		var.type = new LlvmPointer(var.type);
		assembler.add(new LlvmStore(exp, var));
		
		return null;
	}
	
	public LlvmValue visit(ArrayAssign n)
	{
		return null;
	}
	
	public LlvmValue visit(And n)
	{
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I1);
		assembler.add(new LlvmLogic(res, LlvmLogic.and, LlvmPrimitiveType.I32, v1, v2));
		
		return res;
	}
	
	public LlvmValue visit(LessThan n)
	{
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I1);
		assembler.add(new LlvmIcmp(res, LlvmIcmp.slt, LlvmPrimitiveType.I32, v1, v2));
		return res;
	}
	
	public LlvmValue visit(Equal n)
	{
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I1);
		assembler.add(new LlvmIcmp(res, LlvmIcmp.eq, LlvmPrimitiveType.I32, v1, v2));
		return res;
	}
	
	public LlvmValue visit(Minus n)
	{
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmMinus(lhs, LlvmPrimitiveType.I32, v1, v2));
		return lhs;
	}
	
	public LlvmValue visit(Times n)
	{
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmTimes(lhs, LlvmPrimitiveType.I32, v1, v2));
		return lhs;
	}
	
	public LlvmValue visit(ArrayLookup n){return null;}
	public LlvmValue visit(ArrayLength n){return null;}
	public LlvmValue visit(Call n){return null;}
	
	public LlvmValue visit(True n)
	{
		return new LlvmBool(LlvmBool.TRUE);
	}
	
	public LlvmValue visit(False n)
	{
		return new LlvmBool(LlvmBool.FALSE);
	}
	
	public LlvmValue visit(IdentifierExp n)
	{
		return new LlvmRegister("%" + n.name.s,
				n.type.accept(this).type);
	}
	
	public LlvmValue visit(This n){return null;}
	public LlvmValue visit(NewArray n){return null;}
	public LlvmValue visit(NewObject n){return null;}
	
	public LlvmValue visit(Not n)
	{
		LlvmValue v1 = n.exp.accept(this);
		LlvmValue v2 = new LlvmIntegerLiteral(1);
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I1);
		assembler.add(new LlvmLogic(res, LlvmLogic.xor, LlvmPrimitiveType.I32, v1, v2));
		return res;
	}
	
	public LlvmValue visit(Identifier n){return null;}
}


/**********************************************************************************/
/* === Tabela de Símbolos ==== 
 * 
 * 
 */
/**********************************************************************************/

class SymTab extends VisitorAdapter
{
    public Map<String, ClassNode> classes;
    public Map<String, MethodNode> methods;
    private ClassNode classEnv;    //aponta para a classe em uso

    public LlvmValue FillTabSymbol(Program n)
    {
		n.accept(this);
		
		return null;
	}
    
	public LlvmValue visit(Program n)
	{
		n.mainClass.accept(this);
	
		for (util.List<ClassDecl> c = n.classList; c != null; c = c.tail)
			c.head.accept(this);
	
		return null;
	}
	
	public LlvmValue visit(MainClass n)
	{
		classes.put(n.className.s, new ClassNode(n.className.s, null, null));
		
		return null;
	}
	
	public LlvmValue visit(ClassDeclSimple n)
	{
		List<LlvmType> typeList = new LinkedList<LlvmType>();
		// Constroi TypeList com os tipos das variáveis da Classe (vai formar a Struct da classe)
		for (util.List<VarDecl> v = n.varList; v != null; v = v.tail) {
			typeList.add(v.head.type.accept(this).type);
		}
		
		List<LlvmValue> varList = null;
		// Constroi VarList com as Variáveis da Classe
		
	
		classes.put(n.name.s, new ClassNode(n.name.s, new LlvmStructure(typeList), varList));
		
	    // Percorre n.methodList visitando cada método
		
		return null;
	}

	public LlvmValue visit(ClassDeclExtends n){return null;}
	public LlvmValue visit(VarDecl n){return null;}
	public LlvmValue visit(Formal n){return null;}
	public LlvmValue visit(MethodDecl n){return null;}
	public LlvmValue visit(IdentifierType n)
	{
		switch (n.name)
		{
		case "i1":
			return new LlvmRegister(LlvmPrimitiveType.I1);
		case "i8":
			return new LlvmRegister(LlvmPrimitiveType.I8);
		case "i32":
			return new LlvmRegister(LlvmPrimitiveType.I32);
		case "void":
			return new LlvmRegister(LlvmPrimitiveType.VOID);
		case "label":
			return new LlvmRegister(LlvmPrimitiveType.LABEL);
		case "...":
			return new LlvmRegister(LlvmPrimitiveType.DOTDOTDOT);
		}

		return null;
	}
	
	public LlvmValue visit(IntArrayType n)
	{
		return new LlvmRegister(new LlvmArray(0, LlvmPrimitiveType.I32));
	}
	
	public LlvmValue visit(BooleanType n)
	{
		return new LlvmRegister(LlvmPrimitiveType.I1);
	}
	
	public LlvmValue visit(IntegerType n)
	{
		return new LlvmRegister(LlvmPrimitiveType.I32);
	}
}

class ClassNode extends LlvmType
{
	public String nameClass;
	public LlvmStructure classType;
	public List<LlvmValue> varList;
	
	ClassNode (String nameClass, LlvmStructure classType, List<LlvmValue> varList)
	{
		this.nameClass = nameClass;
		this.classType = classType;
		this.varList = varList;
	}
}

class MethodNode 
{
	public String name;
	public LlvmType retType;
	public List<LlvmValue> formals;
	public List<LlvmValue> locals;
	
	MethodNode (String name, LlvmType retType, List<LlvmValue> formals,	List<LlvmValue> locals)
	{
		this.name = name;
		this.retType = retType;
		this.formals = formals;
		this.locals = locals;
	}
}




