%{
#include "infij.tab.c"
%}

%%
[0-9]+	{yylval = atoi(yytext); return(INTCONST);}
\n	{return(0);}
[+*()-/]	{return(yytext[0]);}
. 	{}
%%
