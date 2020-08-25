RUN:
	yacc -d plague.y
	lex plague.l
	gcc lex.yy.c y.tab.c bloomFilter.c murmur3.c -lm -o ../exe/plague