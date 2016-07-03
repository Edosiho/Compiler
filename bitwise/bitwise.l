%{
#include "bitwise.tab.h"
#include "bitwise.h"
%}

%%
"bin"  {return(BIN);}
"oct"  {return(OCT);}
"hex"  {return(HEX);}
"if"   {return(IF);}
"else" {return(ELSE);}

[!]  {return(NOT);}
[|]  {return(OR);}
[+]  {return(XOR);}
[&]  {return(AND);}
[*]  {return(NAND);}
[=]  {return(EQUAL);}
[;]  {return (SEMI);}

[()] {return yytext[0];}
[{]  {return (LCUR);}
[}]  {return (RCUR);}

.|\n {}

[0-1]{6} {return(BINVAL);}
[8]+[Xx]+[0-7]{2} {return(OCTVAL);}
[0]+[Xx]+[0-3][aA-fF0-9] {return(HEXVAL);}
[a-zA-Z][a-zA-Z_]* {yylval.n = strdup(yytext); return (IDENT);}

<<EOF>>  {return 0;}
%%


