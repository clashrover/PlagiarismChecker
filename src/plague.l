%{
#include "y.tab.h"      //generated by yacc
%}
%%


[^\n ]+            			{yylval.txt=strdup(yytext);return word;}
[ ]+[\n]*									{return ' ';}
[\n]+[ ]*									{return '\n';}
<<EOF>>                             { static int once = 0; return once++ ? 0 : '\n' ;}  
 

%%

int yywrap (void) {return 1;}