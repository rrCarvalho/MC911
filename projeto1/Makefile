

CFLAGS=-g
BISON=bison
FLEX=flex
 
parsernpl: parser.o flexer.o
	$(CC) -o parsernpl flexer.o parser.o
 
parser.c: parser.y
	$(BISON) -d parser.y  -o parser.c
 
flexer.c: flexer.l
	$(FLEX)  -o flexer.c flexer.l
 
clean:
	rm -f flexer.c flexer.o parser.c parser.o parser.h parsernpl *.html

