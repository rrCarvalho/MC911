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
		
		// tipo array
		assembler.add(new LlvmConstantDeclaration("%struct.array",
				"type { i32, i32 * }"));
		
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
		classEnv = symTab.classes.get("%class." + n.name.s + " *");

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
		
		// alocar locals
		Iterator<LlvmValue> i = methodEnv.locals.iterator();
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
		ret0 = n.returnExp.accept(this);
		assembler.add(new LlvmRet(ret0));
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
		return new LlvmRegister(new LlvmPointer(
				new LlvmClassType("%struct.array")));
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
		return new LlvmRegister(new LlvmPointer(
				new LlvmClassType("%class." + n.name)));
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
		
		String varName = "%" + n.var.s;
		if (methodEnv.formalsNames.contains(n.var.s))
		{
			varName += "_addr";
		}
		
		LlvmValue var = new LlvmRegister(varName,
				new LlvmPointer(exp.type));
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
		LlvmType retType = n.type.accept(this).type;
		LlvmValue ret = new LlvmRegister(retType);
		LlvmValue array = n.array.accept(this);
		
		List<LlvmValue> offsets = new LinkedList<LlvmValue>();
		offsets.add(new LlvmNamedValue(n.index.toString(), 
				LlvmPrimitiveType.I32));
		
		LlvmValue elem = new LlvmRegister(new LlvmPointer(retType));
		assembler.add(new LlvmGetElementPointer(elem, array, offsets));
		
		assembler.add(new LlvmLoad(ret, elem));
		
		return ret;
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
		
		List<LlvmValue> aList = new LinkedList<LlvmValue>();
		aList.add(n.object.accept(this));
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
		LlvmType vType = n.type.accept(this).type;
		
		LlvmValue ret = new LlvmRegister(vType);
		
		String varName = "%" + n.name.s;
		if (methodEnv.formalsNames.contains(n.name.s))
		{
			varName += "_addr";
		}
		
		LlvmValue var = new LlvmRegister(varName,  
				new LlvmPointer(vType));
			
		assembler.add(new LlvmLoad(ret, var));
		
		return ret;
	}



/* ~~~ This ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(This n)
	{ 
		return new LlvmRegister("%this", n.type.accept(this).type);
	}



/* ~~~ NewArray ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(NewArray n)
	{
		List<LlvmValue> offsets;
		
		LlvmValue arrayStruct = new LlvmRegister(new LlvmPointer(
				new LlvmClassType("%struct.array")));
		
		// tipos contidos na struct.array
		List<LlvmType> arrayStructTypes = new LinkedList<LlvmType>();
		arrayStructTypes.add(LlvmPrimitiveType.I32);
		arrayStructTypes.add(new LlvmPointer(LlvmPrimitiveType.I32));
		
		// malloc struct.array
		LlvmType arrayStructStruct = new LlvmStructure(arrayStructTypes);
		assembler.add(new LlvmMalloc(arrayStruct, arrayStructStruct,
				"%struct.array"));
		
		// malloc do array
		LlvmValue arrayArray = new LlvmRegister(new LlvmPointer(
				LlvmPrimitiveType.I32));
		assembler.add(new LlvmMalloc(arrayArray, LlvmPrimitiveType.I32,
				n.size.accept(this)));
		
		// apontando arrayArray para i32* de struct.array
		LlvmValue arrayStructArray = new LlvmRegister(new LlvmPointer(
				new LlvmPointer(LlvmPrimitiveType.I32)));
		offsets = new LinkedList<LlvmValue>();
		offsets.add(new LlvmIntegerLiteral(0));
		offsets.add(new LlvmIntegerLiteral(1));
		assembler.add(new LlvmGetElementPointer(arrayStructArray,
				arrayStruct, offsets));
		assembler.add(new LlvmStore(arrayArray, arrayStructArray));
		
		return arrayStruct;
	}



/* ~~~ NewObject ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	public LlvmValue visit(NewObject n)
	{
		LlvmValue res = new LlvmRegister(new LlvmPointer(
				new LlvmClassType("%class." + n.className.s)));
		assembler.add(new LlvmMalloc(res, symTab.classes.get(
				"%class." + n.className.s + " *").classType,
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
    private String varName; // nome da variavel corrente
    private List<String> arrayNames; // arrays da classe corrente

    
    
    public LlvmValue FillTabSymbol(Program n)
    {
    	this.classes = new HashMap<String, ClassNode>();
    	this.methods = new HashMap<String, MethodNode>();
    	
		n.accept(this);
		
		for (Map.Entry<String, ClassNode> e : classes.entrySet())
		{
			System.out.println("classes: " + e.getKey() + " / " + e.getValue().nameClass
					+ " " + e.getValue().classType);
			System.out.println(e.getValue().arrayNames.size());
			Iterator<String> i = e.getValue().arrayNames.iterator();
			while (i.hasNext())
			{
				System.out.println(i.next());
			}
			
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
		List<String> varNames = new LinkedList<String>();
		List<String> arrayNames = new LinkedList<String>();
		
		classes.put(n.className.s, new ClassNode(n.className.s, null, null, varNames, arrayNames));
		
		return null;
	}

	
	
	public LlvmValue visit(ClassDeclSimple n)
	{	
		List<LlvmType> typeList = new LinkedList<LlvmType>();
		List<LlvmValue> varList = new LinkedList<LlvmValue>();
		List<String> varNames = new LinkedList<String>();
		
		// nova lista de arrays
		arrayNames = new LinkedList<String>();
		
		// Constroi TypeList com os tipos das variáveis da Classe (vai formar a Struct da classe)
		// Constroi VarList com as Variáveis da Classe
		for (util.List<VarDecl> v = n.varList; v != null; v = v.tail)
		{
			LlvmValue var = v.head.accept(this);
			typeList.add(var.type);
			varList.add(var);
			varNames.add(v.head.name.s);
		}

		// preenche a classe
		classes.put("%class." + n.name.s + " *", new ClassNode(n.name.s,
				new LlvmStructure(typeList), varList, varNames,	null));
		
		// apontador para a classe corrente
		classEnv = classes.get("%class." + n.name.s + " *");

	    // Percorre n.methodList visitando cada método
		for (util.List<syntaxtree.MethodDecl> m = n.methodList;
				m != null; m = m.tail)
		{
			m.head.accept(this);
		}
		
		// setando a lista de arrays
		classEnv.arrayNames = arrayNames;

		return null;
	}

	
	
	public LlvmValue visit(ClassDeclExtends n)
	{
		return null;
	}
	
	
	
	public LlvmValue visit(VarDecl n)
	{
		// seta o nome da variavel corrente
		varName = n.name.s;
		return new LlvmRegister("%" + n.name.s,
				n.type.accept(this).type);
	}
	
	
	
	public LlvmValue visit(Formal n)
	{
		// seta o nome da variavel corrente
		varName = n.name.s;
		return new LlvmRegister("%" + n.name.s,
				n.type.accept(this).type);
	}
	
	
	
	public LlvmValue visit(MethodDecl n)
	{
		LlvmType retType = n.returnType.accept(this).type;
		
		List<LlvmValue> aList = new LinkedList<LlvmValue>();
		List<LlvmValue> vList = new LinkedList<LlvmValue>();
		
		List<String> aNames = new LinkedList<String>();
		List<String> vNames = new LinkedList<String>();
		
		// lista de argumentos
		aList.add(new LlvmRegister("%this",
				new LlvmPointer(new LlvmClassType("%class." 
				+ classEnv.nameClass))));
		for (util.List<syntaxtree.Formal> f = n.formals;
				f != null; f = f.tail) 
		{
			aList.add(f.head.accept(this));
			aNames.add(f.head.name.s);
		}
			
		// lista de vars locais
		for (util.List<syntaxtree.VarDecl> l = n.locals; l != null;
					l = l.tail)
		{
			vList.add(l.head.accept(this));
			vNames.add(l.head.name.s);
		}
		
		// preenche metodo
		methods.put("@__" + n.name.s + "_" + classEnv.nameClass,
				new MethodNode(
						"@__" + n.name.s + "_" + classEnv.nameClass,
						classEnv.nameClass, retType, aList, vList,
						aNames, vNames));
		
		return null;
	}
	
	
	
	public LlvmValue visit(IdentifierType n)
	{
		return new LlvmRegister(new LlvmPointer(
				new LlvmClassType("%class." + n.name)));
	}

	
	
	public LlvmValue visit(IntArrayType n)
	{
		// adiciona a array corrente na lista de arrays da classe
		arrayNames.add(varName);
		return new LlvmRegister(new LlvmPointer(
				new LlvmClassType("%struct.array")));
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
	public List<String> varNames;
	public List<String> arrayNames;

	ClassNode (String nameClass, LlvmStructure classType,
			List<LlvmValue> varList, List<String> varNames,
			List<String> arrayNames)
	{
		this.nameClass = nameClass;
		this.classType = classType;
		this.varList = varList;
		this.varNames = varNames;
		this.arrayNames = arrayNames;
	}
}



class MethodNode
{
	public String name;
	public String className;
	public LlvmType retType;
	public List<LlvmValue> formals;
	public List<LlvmValue> locals;
	public List<String> formalsNames;
	public List<String> localsNames;

	MethodNode (String name, String className, LlvmType retType,
			List<LlvmValue> formals, List<LlvmValue> locals,
			List<String> formalsNames, List<String> localsNames)
	{
		this.name = name;
		this.className = className;
		this.retType = retType;
		this.formals = formals;
		this.locals = locals;
		this.formalsNames = formalsNames;
		this.localsNames = localsNames;
	}
}




