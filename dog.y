%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
%}

%error-verbose
%union { char somewhere[64]; }

%token DOG GO 
%token <somewhere> WHERE 
%type <somewhere> expr 
%type <somewhere> atomic 
%token SEMICOLON 

%%
program: stmtlist;
stmtlist : | stmtlist stmt ;
stmt   : DOG GO expr SEMICOLON {printf("dog goes %s.\n", $3);};
expr   : atomic ;
atomic : WHERE ;
%%

int yyerror(char *msg)
{  fprintf(stderr,"Error: %s\n",msg);
   return 0;
}

int main(int argc,char *argv[])
{   
	FILE *fp;

	if(argc != 2) {
		printf("Please specify the input file.\n");
		return 1;
	} else { 
		fp = fopen(argv[1],"r");

		if(!fp)
		{
			printf("couldn't open file for reading. \n");
			return 1;
		}

		yyin=fp;
	}
	
	yyparse();
	fclose(fp);

	return 0;
}
