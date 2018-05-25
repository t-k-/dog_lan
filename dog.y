%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern int yylex (void);
extern int yyerror(const char *msg);

char *strcatdup(char*, char*);
%}

%error-verbose
%union { char token[512]; char *text; }

%token _FOREACH
%token <token> TOKEN
%token <token> NAME

%type <token> token
%type <text> tokens
%type <text> block
%type <text> namelist
%type <text> foreach

%destructor { printf("\n\n%s\n", $$); } <text>

%%
program
	: tokens { printf("# program #\n%s", $1); } ;

tokens
	: { $$ = strdup(""); }
	| tokens token { $$ = strcatdup($1, $2); free($1); }
	| tokens block { $$ = strcatdup($1, $2); free($1); free($2); }
	| tokens foreach { $$ = strcatdup($1, $2); free($1); free($2); }
	;

token
	: TOKEN  { strcpy($$, $1); }
	| NAME   { strcpy($$, $1); }
	| ','    { strcpy($$, ","); }
	| '('    { strcpy($$, "("); }
	| ')'    { strcpy($$, ")"); }
	| '\t'   { strcpy($$, "\t"); }
	| '\n'   { strcpy($$, "\n"); }
	;

block
	: '{' tokens '}' { $$ = strcatdup("[block] {", $2); free($2); }
	;

namelist
	: NAME { $$ = strdup($1); }
	| namelist ',' NAME { $$ = strcatdup($1, $3); free($1); }
	;

foreach
	: _FOREACH '(' namelist ')' { $$ = strcatdup("[foreach] (", $3); free($3); }
	;
%%
/*
*/

char *strcatdup(char *orig, char *cat)
{
	char *ret = malloc(strlen(orig) + strlen(cat) + 1 /* space */ + 1 /* NULL */);
	strcpy(ret, orig);
	strcat(ret, " ");
	strcat(ret, cat);
	return ret;
}

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
