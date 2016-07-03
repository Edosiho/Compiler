%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

float eval(char *c);
%}

%token INTCONST

%%
start : expr {printf("El infijo es: %s y su respuesta es: %f \n", $1,eval($1));}
      ;

expr : expr '+' term {char* temp = malloc(100);
			sprintf(temp, "%s%s+",$1,$3);
			$$ = temp;}
     |  expr '-' term {char* temp = malloc(100);
			sprintf(temp, "%s%s-",$1,$3);
			$$ = temp;}
     | term { $$ = $1;}
     ;
term : term '*' fact {char* temp = malloc(100);
			sprintf(temp, "%s%s*",$1,$3);
			$$ = temp;}
     | term '/' fact {char* temp = malloc(100);
			sprintf(temp, "%s%s/",$1,$3);
			$$ = temp;}
     | fact {$$ = $1;}
     ;
fact : '(' expr ')' {$$ = $2;}
     | INTCONST {char* temp = malloc(100);
		 sprintf(temp,"%d",$1);
		 $$ = temp;}
      ;
%%
main(int argc, char **argv)
{
yyparse();
printf("Expresion aceptada \n");
}

yyerror(char *s)
{
fprintf(stderr,"error: %s\n", s);
}
float eval (char * c){

	double stack[500];
	int top =-1;
	int i,op1,op2;
	for(i=0;i<strlen(c);i++){
		char tmp = c[i];
		if(isdigit(tmp)){
		 stack[++top] = tmp- 48;
		}
		else{
			op2 = stack[top--];
			op1 = stack[top--];
			switch (tmp){
				case '+' :
					stack[++top] = op1 +op2;
					break;
				case '-' :
					stack[++top] = op1 -op2;
					break;
				case '*' :
					stack[++top] = op1 *op2;
					break;
				case '/' :
					stack[++top] = op1 /op2;
					break;
				 default:
					break;

			}
		}
	}
	return stack[top];
}
