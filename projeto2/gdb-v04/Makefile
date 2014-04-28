#
# pacote v03
# 
# Como compilar:
# $ make compile
#
# Como executar o compilador:
# $ make run INPUT=test/teste.java OUTPUT=teste.s
#
# Como gerar bytecode:
# $ make bytecode INPUT=teste.s OUTPUT=teste.bc
#
# Como executar o bytecode:
# $ lli teste.bc
#

SOURCES = $(wildcard src/**/*.java)
OBJECTS = $(addprefix obj/, $(notdir $(SOURCES:.java=.o)))
CLASSES = $(SOURCES:.java=.class)

all: $(OBJECTS)
	gcj -classpath src:lib/projeto2.jar obj/*.o -o minijava --main=main.Main -L./lib -Wl,-rpath,./lib/ -lprojeto2 -Xlinker --allow-multiple-definition 2>&1 

obj/%.o : src/**/%.java
	gcj -classpath src:lib/projeto2.jar -g -c $< -o obj/$(notdir $@)


jar2so: $(CLASSES)
	gcj -classpath src:lib/projeto2.jar -fPIC -fjni -c lib/projeto2.jar -o lib/projeto2.o
	gcj -shared -fPIC -o lib/libprojeto2.o lib/projeto2.o  -o lib/libprojeto2.so

%.class : %.java
	javac -cp src:lib/projeto2.jar $<



clean:
	rm -f src/llvm/*.class src/llvmast/*.class
	rm -f src/llvm/*.o src/llvmast/*.o
	rm -f obj/*.o




