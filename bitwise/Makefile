all: bitwise

bitwise: lex.yy.c bitwise.tab.c
	gcc -g -o bitwise bitwise.tab.c lex.yy.c -lfl -ly -I.

lex.yy.c: bitwise.l
	flex bitwise.l

bitwise.tab.c: bitwise.y
	bison -d bitwise.y
