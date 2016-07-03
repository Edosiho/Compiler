%{
#include "tcst.h"
#include "tcst.tab.h"
%}

%%
[0-9]+	{return(INTCONST);}
[0-9]+\.[0-9]+	{return(DOUCONST);}
"double" {yylval.t = 'D'; return(DOUBLE);}
"int"	{yylval.t = 'I'; return(INT);}
[a-z]+ 	{yylval.s = strdup(yytext); return(IDENT);}
[+*();]	{return(yytext[0]);}
\n	{return(0);}
. 	{ }
%%
