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

		codeGenerator.symTab = new SymTab();
		// Preenchendo a Tabela de Símbolos
		// Quem quiser usar 'env', apenas comente essa linha
		codeGenerator.symTab.FillTabSymbol(p);
		
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



/* ~~~ ClassDeclSimple ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(ClassDeclSimple n)
	{
		classEnv = symTab.classes.get("%class." + n.name.s);
		
		// formando a lista de tipos dos atributos
		/*List<LlvmType> typeList = new LinkedList<LlvmType>();
		for (util.List<VarDecl> v = n.varList; v != null; v = v.tail)
		{
			typeList.add(v.head.type.accept(this).type);
		}
		LlvmStructure structVarTypes = new LlvmStructure(typeList);*/

		// declarando a classe
		assembler.add(new LlvmConstantDeclaration("%class." + n.name.s,
				"type " + classEnv.classType));

		// percorrendo a lista de metodos
		for (util.List<syntaxtree.MethodDecl> m = n.methodList;
				m != null; m = m.tail)
		{
			m.head.accept(this);
		}

		return null;
	}



/* ~~~ ClassDeclExtends ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(ClassDeclExtends n)
	{
		return null;
	}



/* ~~~ VarDecl ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(VarDecl n)
	{
		return new LlvmRegister("%" + n.name.s,
				n.type.accept(this).type);
	}



/* ~~~ MethodDecl ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(MethodDecl n)
	{
		methodEnv = symTab.methods.get(
				"@__" + n.name.s + "_" + classEnv.nameClass);

		// definicao do metodo
		assembler.add(new LlvmDefine(methodEnv.name, methodEnv.retType,
				methodEnv.formals));

		// entrada do metodo
		LlvmLabelValue.Labelclear();
		assembler.add(new LlvmLabel(new LlvmLabelValue("entry")));

		// alocar params
		for (int i = 1; i < methodEnv.formals.size(); i++)
		{
			LlvmValue aR0 = methodEnv.formals.get(i);
			LlvmValue aR1 = new LlvmRegister(aR0 + "_addr", aR0.type);
			assembler.add(new LlvmAlloca(aR1, aR1.type,
					new LinkedList<LlvmValue>()));
			aR1.type = new LlvmPointer(aR1.type);
			assembler.add(new LlvmStore(aR0, aR1));
		}
		
		Iterator i = methodEnv.locals.iterator();
		while (i.hasNext())
		{
			LlvmValue vR0 = (LlvmValue)i.next();
			assembler.add(new LlvmAlloca(vR0, vR0.type,
					new LinkedList<LlvmValue>()));
		}

		// body
		for (util.List<syntaxtree.Statement> s = n.body; s != null;
				s = s.tail)
		{
			s.head.accept(this);
		}

		// retornando return
		LlvmValue ret0 = new LlvmRegister(methodEnv.retType);
		LlvmValue ret1 = new LlvmRegister(methodEnv.retType);
		ret0 = n.returnExp.accept(this);
		ret0.type = new LlvmPointer(ret0.type);
		assembler.add(new LlvmLoad(ret1, ret0));
		assembler.add(new LlvmRet(ret1));
		assembler.add(new LlvmCloseDefinition());

		return null;
	}



/* ~~~ Formal ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(Formal n)
	{
		return new LlvmRegister("%" + n.name.s,
				n.type.accept(this).type);
	}



/* ~~~ IntArrayType ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(IntArrayType n)
	{
		return new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I32));
	}



/* ~~~ BooleanType ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(BooleanType n)
	{
		return new LlvmRegister(LlvmPrimitiveType.I1);
	}



/* ~~~ IntergerType ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(IntegerType n)
	{
		return new LlvmRegister(LlvmPrimitiveType.I32);
	}



/* ~~~ IdentifierType ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(IdentifierType n)
	{
		return new LlvmRegister(new LlvmClassType("%class." + n.name));
	}



/* ~~~ Block ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(Block n)
	{
		for (util.List<Statement> s = n.body; s != null; s = s.tail)
		{
			s.head.accept(this);
		}

		return null;
	}



/* ~~~ If ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
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



/* ~~~ While ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
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



/* ~~~ Assign ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(Assign n)
	{
		LlvmValue exp = n.exp.accept(this);
		LlvmValue var = new LlvmRegister("%" + n.var.s, exp.type);
		var.type = new LlvmPointer(var.type);
		assembler.add(new LlvmStore(exp, var));

		return null;
	}



/* ~~~ ArrayAssign ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(ArrayAssign n)
	{
		return null;
	}



/* ~~~ And ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(And n)
	{
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I1);
		assembler.add(new LlvmLogic(res, LlvmLogic.and,
				LlvmPrimitiveType.I32, v1, v2));

		return res;
	}



/* ~~~ LessThan ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(LessThan n)
	{
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I1);
		assembler.add(new LlvmIcmp(res, LlvmIcmp.slt,
				LlvmPrimitiveType.I32, v1, v2));
		
		return res;
	}



/* ~~~ Equal ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(Equal n)
	{
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I1);
		assembler.add(new LlvmIcmp(res, LlvmIcmp.eq,
				LlvmPrimitiveType.I32, v1, v2));
		
		return res;
	}



/* ~~~ Minus ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(Minus n)
	{
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmMinus(res, LlvmPrimitiveType.I32, v1, v2));
		
		return res;
	}



/* ~~~ Times ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(Times n)
	{
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmTimes(res, LlvmPrimitiveType.I32, v1, v2));
		
		return res;
	}



/* ~~~ ArrayLookup ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(ArrayLookup n)
	{
		return null;
	}



/* ~~~ ArrayLength ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(ArrayLength n)
	{
		return null;
	}



/* ~~~ Call ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(Call n)
	{
		LlvmType retType = n.type.accept(this).type;
		LlvmType objType = n.object.type.accept(this).type;
		LlvmRegister ret = new LlvmRegister(retType);
		LlvmValue tmp = new LlvmRegister(objType);
		tmp = n.object.accept(this);
		
		List<LlvmValue> aList = new LinkedList<LlvmValue>();
		
		aList.add(tmp);
		for (util.List<syntaxtree.Exp> a = n.actuals; a != null;
				a = a.tail) 
		{
			aList.add(a.head.accept(this));
		}
		
		assembler.add(new LlvmCall(ret, retType,
				"@__" + n.method.s + "_"
				+ symTab.classes.get(objType.toString()).nameClass,
				aList));
		
		return ret;
	}



/* ~~~ True ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(True n)
	{
		return new LlvmBool(LlvmBool.TRUE);
	}



/* ~~~ False ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(False n)
	{
		return new LlvmBool(LlvmBool.FALSE);
	}



/* ~~~ IdentifierExp ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(IdentifierExp n)
	{
		return new LlvmRegister("%" + n.name.s,
				n.type.accept(this).type);
	}



/* ~~~ This ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(This n)
	{ 
		return new LlvmRegister("%this", 
				new LlvmPointer(n.type.accept(this).type));
	}



/* ~~~ NewArray ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(NewArray n)
	{
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmMalloc(res, res.type,
				n.size.accept(this)));
		
		return res;
	}



/* ~~~ NewObject ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(NewObject n)
	{
		
		LlvmValue res = new LlvmRegister(new LlvmPointer(
				new LlvmClassType("%class." + n.className.s)));
		assembler.add(new LlvmMalloc(res,
				symTab.classes.get("%class." + n.className.s).classType,
				"%class." + n.className.s));
		
		return res;
	}



/* ~~~ Not ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(Not n)
	{
		LlvmValue v1 = n.exp.accept(this);
		LlvmValue v2 = new LlvmIntegerLiteral(1);
		LlvmRegister res = new LlvmRegister(LlvmPrimitiveType.I1);
		assembler.add(new LlvmLogic(res, LlvmLogic.xor,
				LlvmPrimitiveType.I32, v1, v2));
		
		return res;
	}



/* ~~~ Identifier ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(Identifier n)
	{
		return null;
	}

}


/**********************************************************************************/
/* === Tabela de Símbolos ====
 *
 *
 */
/**********************************************************************************/

class SymTab extends VisitorAdapter
{
    public HashMap<String, ClassNode> classes;
    public HashMap<String, MethodNode> methods;
    private ClassNode classEnv;    //aponta para a classe em uso

    
    
    public LlvmValue FillTabSymbol(Program n)
    {
    	this.classes = new HashMap<String, ClassNode>();
    	this.methods = new HashMap<String, MethodNode>();
    	
		n.accept(this);
		
		for (Map.Entry<String, ClassNode> e : classes.entrySet())
		{
			System.out.println("classes: " + e.getKey() + " / " + e.getValue().nameClass
					+ " " + e.getValue().classType);
		}
		
		for (Map.Entry<String, MethodNode> e : methods.entrySet())
		{
			System.out.println("methods: " + e.getKey() + " / " + e.getValue().name
					+ " " + e.getValue().retType);
		}
		

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
		List<LlvmValue> varList = new LinkedList<LlvmValue>();
		// Constroi TypeList com os tipos das variáveis da Classe (vai formar a Struct da classe)
		// Constroi VarList com as Variáveis da Classe
		for (util.List<VarDecl> v = n.varList; v != null; v = v.tail) {
			LlvmValue var = v.head.accept(this);
			typeList.add(var.type);
			varList.add(var);
			
		}

		classes.put("%class." + n.name.s, new ClassNode(n.name.s,
				new LlvmStructure(typeList), varList));
		classEnv = classes.get("%class." + n.name.s);

	    // Percorre n.methodList visitando cada método
		for (util.List<syntaxtree.MethodDecl> m = n.methodList;
				m != null; m = m.tail)
		{
			m.head.accept(this);
		}

		return null;
	}

	
	
	public LlvmValue visit(ClassDeclExtends n)
	{
		return null;
	}
	
	
	
	public LlvmValue visit(VarDecl n)
	{
		return new LlvmRegister("%" + n.name.s,
				n.type.accept(this).type);
	}
	
	
	
	public LlvmValue visit(Formal n)
	{
		return new LlvmRegister("%" + n.name.s,
				n.type.accept(this).type);
	}
	
	
	
	public LlvmValue visit(MethodDecl n)
	{
		LlvmType retType = n.returnType.accept(this).type;
		List<LlvmValue> aList = new LinkedList<LlvmValue>();
		List<LlvmValue> vList = new LinkedList<LlvmValue>();
		
		aList.add(new LlvmRegister("%this",
				new LlvmPointer(new LlvmClassType("%class." 
				+ classEnv.nameClass))));
		for (util.List<syntaxtree.Formal> f = n.formals;
				f != null; f = f.tail) 
		{
			aList.add(f.head.accept(this));
		}
			
		for (util.List<syntaxtree.VarDecl> l = n.locals; l != null;
					l = l.tail)
		{
			vList.add(l.head.accept(this));
		}
		
		methods.put("@__" + n.name.s + "_" + classEnv.nameClass,
				new MethodNode(
				"@__" + n.name.s + "_" + classEnv.nameClass, retType,
				aList, vList));
		
		return null;
	}
	
	
	
	public LlvmValue visit(IdentifierType n)
	{
		return new LlvmRegister(new LlvmPointer(
				new LlvmClassType("%class." + n.name)));
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




