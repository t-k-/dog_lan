%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylex (void);
extern int yyerror(const char *msg);
%}

%error-verbose
%union { char token[1024]; }

%token _FOREACH
%token <token> TOKEN
%token <token> NAME

%%
program
	: statements;

statements
	:
	| statements statement
	;

statement
	: TOKEN { printf("%s ", $1); }
	| NAME { printf("%s ", $1); }
	| _FOREACH '(' NAME ',' NAME ',' NAME ')' block
		{
			printf("[for each (%s)(%s)(%s)]", $3, $5, $7);
		}
	| block {}
	| ','  { printf(", "); }
	| '('  { printf("( "); }
	| ')'  { printf(") "); }
	| '\n' { printf("\n"); }
	| '\t' { printf("\t"); }
	;

block
	: '{' statements '}'  { printf("[block]"); }
	;
%%

int yyerror(const char *msg)
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
