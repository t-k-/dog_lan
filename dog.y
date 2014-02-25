%{
#include <stdio.h>
%}

%error-verbose
%union { char somewhere[64]; }

%token GO 
%token <somewhere> WHERE 
%type <somewhere> expr 
%type <somewhere> atomic 
%token SEMICOLON 

%%
program: stmtlist;
stmtlist : | stmtlist stmt ;
stmt   : GO expr SEMICOLON {printf("dog goes to %s.\n", $2);};
expr   : atomic ;
atomic : WHERE ;
%%
int yyerror(char *msg)
{  fprintf(stderr,"Error: %s\n",msg);
   return 0;
}

int main(void)
{   yyparse();
    return 0;
}
