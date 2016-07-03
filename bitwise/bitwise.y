%{
#include <stdio.h>
#include <bitwise.h>
%}
%define parse.lac full
%define parse.error verbose
%union {
 char t;
 char *n;
}

%token BIN OCT HEX NOT OR XOR NAND AND EQUAL BINVAL OCTVAL HEXVAL IF ELSE SEMI LCUR RCUR
%token <n> IDENT 
%type <t> expr tipo
%left EQUAL
%left OR XOR
%left AND NAND
%nonassoc NOT

%% 

programa: decl bloqueInstr {printf("programa \n"); return(0);} 
        | grupoDecl bloqueInstr {printf("programa \n"); return(0);}  
        | bloqueInstr {printf("bloque de instrucciones \n"); return(0);}
        ;

grupoDecl: decl decl {printf("Grupo de declaraciones \n");} 
         | grupoDecl decl {printf("grupoDecl \n");}
         ;

decl: tipo IDENT SEMI {place = createSymbol ($2);
                       place -> type = $1;printf("decl \n");}
    ;

tipo: BIN {$$ = 'B';printf("tipo binario\n");}
    | OCT {$$ = 'O';printf("tipo octal\n");}
    | HEX {$$ = 'H';printf("tipo hexadecimal\n");}
    ;

bloqueInstr: LCUR grupoInstr RCUR {printf("bloqueInstr \n");}    
           | LCUR RCUR {printf("bloque de instrucciones vacio \n");}
           ;

grupoInstr: 
	  | grupoInstr Instr {printf("grupoInstr \n");}
          ;

Instr: InstrAsig     {} {printf("instr \n");}
     | decl          {} {printf("instr \n");}
     | InstrIf       {} {printf("instr \n");}
     | bloqueInstr   {} {printf("instr \n");}
     ;

InstrAsig: IDENT EQUAL expr SEMI {if(lookup($1)->type != $3){ yyerror("Tipo incompatible");};printf("InstrAsig \n");}
         ;

InstrIf: IF '(' expr ')' Instr ELSE Instr {printf(" \n");}
       ;

expr: expr OR expr       { if($1 != $3){ yyerror("Tipos incompatibles");} else { $$ = $1; };}
	| expr XOR expr  { if($1 != $3){ yyerror("Tipos incompatibles");} else { $$ = $1; };}
	| expr AND expr  { if($1 != $3){ yyerror("Tipos incompatibles");} else { $$ = $1; };}
	| expr NAND expr { if($1 != $3){ yyerror("Tipos incompatibles");} else { $$ = $1; };}
	| NOT expr       { $$ = $2;} 
	| '(' expr ')'   {$$ = $2;}
	| BINVAL {$$ = 'B';}
	| OCTVAL {$$ = 'O';}
	| HEXVAL {$$ = 'H';}
	| IDENT  {return lookup($1)->type;}
	;

%%
static unsigned
symhash(char *sym)
{
  unsigned int hash = 0;
  unsigned c;

  while(c = *sym++){
      hash = hash*9 ^ c;
 }
  return hash;
}

int nnew, nold;
int nprobe;
int repeated[NHASH];
char* d[1000];
int p = 0;

struct symbol *
createSymbol(char* sym)
{
  struct symbol *sp = &symtab[symhash(sym)%NHASH];
  int scount = NHASH;		/* how many have we looked at */
  while(--scount >= 0) {
    nprobe++;
    if(sp->name && !strcmp(sp->name, sym)) { nold++; yyerror("Symbol already defined"); return NULL; }

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

struct symbol *
lookup(char* sym){
  struct symbol *sp = &symtab[symhash(sym)%NHASH];
  int scount = NHASH;		/* how many have we looked at */
  while(--scount >= 0) {
    nprobe++;
    if(sp->name && !strcmp(sp->name, sym)) { nold++; return sp; }
    if(!sp->name) {		/* new entry */
      nnew++;
      yyerror("Symbol doesn't exist");
      return NULL;
    }

    if(++sp >= symtab+NHASH) sp = symtab; /* try the next entry */
  }
  fputs("symbol table overflow\n", stderr);
  abort(); /* tried them all, table is full */
  
}

main(int argc, char **argv){
yyparse();
printf("Expresion aceptada \n");
}

yyerror(char *s){
fprintf(stderr,"error: %s\n", s);
exit(0);
}
