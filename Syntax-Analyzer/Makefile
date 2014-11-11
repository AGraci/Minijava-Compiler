all: minijava

minijava.tab.c minijava.tab.h: minijava.y
	bison -d minijava.y

lex.yy.c: minijava.l minijava.tab.h
	flex minijava.l

minijava: lex.yy.c minijava.tab.c minijava.tab.h
	g++ minijava.tab.c lex.yy.c -lfl -o minijava

