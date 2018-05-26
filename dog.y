%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern int yylex (void);
extern int yyerror(const char *msg);

char *strcatdup(char*, char*);

struct list_node {
	struct list_node *next;
	char token[512];
};

struct list_node *new_list_node(char*);
struct list_node *list_push_front(struct list_node **, char*);
void list_free(struct list_node*);
%}

%error-verbose
%union {
	char token[512];
	char *text;
	struct list_node *list;
}

%token _FOREACH
%token <token> TOKEN
%token <token> NAME

%type <token> token
%type <text> tokens
%type <text> block
%type <list> namelist
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
	: NAME { $$ = new_list_node($1); }
	| namelist ',' NAME {
		$$ = list_push_front(&($1), $3);
	}
	;

foreach
	: _FOREACH '(' namelist ')' block {
		$$ = strcatdup("[foreach] ", $5);

		for (struct list_node *p = $3; p != NULL; p = p->next) {
			printf("%s ", p->token);
		}
		printf("\n");

		list_free($3);
	}
	;
%%
/*
*/

struct list_node *list_push_front(struct list_node **head, char *token)
{
	struct list_node *p = *head;
	*head = new_list_node(token);
	(*head)->next = p;
	return *head;
}

struct list_node *new_list_node(char *token)
{
	struct list_node *ret = malloc(sizeof(struct list_node));
	ret->next = NULL;
	strcpy(ret->token, token);

	return ret;
}

void list_free(struct list_node *head)
{
	struct list_node *next;
	while (head) {
		next = head->next;
		free(head);
		head = next;
	}
}

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
