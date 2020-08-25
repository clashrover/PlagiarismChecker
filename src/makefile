RUN:
	yacc -d plague.y
	lex plague.l
	gcc lex.yy.c y.tab.c bloomFilter.c -lm -o ../exe/plague