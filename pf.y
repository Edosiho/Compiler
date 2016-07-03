%{
#include <stdio.h>
%}

%union{
	char *s;
}

%token <s> INTCONST
%type <s> start expr term fact

%%
start : expr {printf("El resultado es : %d \n",$1);}
      ;

expr : expr '+' term {printf("%s %s %s",$1,$3,"+");}
     | expr 
