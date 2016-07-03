%{
#include "tcst.h"
%}


%union    {
        struct example typeexpr;
	double d;
	char *s;
        char t;
        }

%token <d> INTCONST DOUCONST
%token <s> IDENT
%token <t> DOUBLE INT
%type <typeexpr> expr
%type <typeexpr> term
%type <typeexpr> fact
%type <typeexpr> decll
%type <t> tipo

%%
start : decll expr {printf("El tipo del resultado es: %c\n",$2.type);}
      ;

decll : decll decl 
	| decl {}
	;
decl : tipo IDENT ';' {place=lookup($2); place->type=$1;}

tipo : DOUBLE {$$ ='D';} 
     | INT {$$ = 'I';}
     ;

expr : expr '+' term {if($1.type == $3.type) $$.type = $1.type;
			else yyerror("tipos incompatibles");}
     | term {$$.type = $1.type;}
     ;

term : term '*' fact {if($1.type == $3.type) $$.type = $1.type;
			else yyerror("tipos incompatibles");}
     | fact {$$.type = $1.type;}
     ;

fact : '(' expr ')' {$$.type = $2.type;}
     | INTCONST {$$.type = 'I';}
     | DOUCONST {$$.type = 'D';} 
     | IDENT {place=lookup($1); $$.type=place->type;}
     ;
%%

static unsigned
symhash(char *sym)
{
  unsigned int hash = 0;
  unsigned c;

  while(c = *sym++) hash = hash*9 ^ c;

  return hash;
}

int nnew, nold;
int nprobe;

struct symbol *
lookup(char* sym)
{
  struct symbol *sp = &symtab[symhash(sym)%NHASH];
  int scount = NHASH;		/* how many have we looked at */

  while(--scount >= 0) {
    nprobe++;
    if(sp->name && !strcmp(sp->name, sym)) { nold++; return sp; }

    if(!sp->name) {		/* new entry */
      nnew++;
      sp->name = strdup(sym);
      return sp;
    }

    if(++sp >= symtab+NHASH) sp = symtab; /* try the next entry */
  }
  fputs("symbol table overflow\n", stderr);
  abort(); /* tried them all, table is full */

}

main(int argc, char **argv)
{
yyparse();
printf("Expresion aceptada \n");
}

yyerror(char *s)
{
fprintf(stderr,"error: %s\n", s);
exit(0);
}

