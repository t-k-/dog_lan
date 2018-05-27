%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

extern FILE *yyin;
extern int yylex (void);
extern int yyerror(const char *msg);

char *tokcat(int, ...);

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
	: tokens { printf("%s", $1); free($1); } ;

tokens
	: { $$ = strdup(""); }
	| tokens token   { $$ = tokcat(2, $1, $2); free($1); }
	| tokens block   { $$ = tokcat(4, $1, "{", $2, "}"); free($1); free($2); }
	| tokens foreach { $$ = tokcat(4, $1, "{", $2, "}"); free($1); free($2); }
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
	: '{' tokens '}' { $$ = $2; }
	;

namelist
	: NAME { $$ = new_list_node($1); }
	| namelist ',' NAME {
		$$ = list_push_front(&($1), $3);
	}
	;

foreach
	: _FOREACH '(' namelist ')' block {
		$$ = strdup($5);

//		for (struct list_node *p = $3; p != NULL; p = p->next) {
//			printf("%s ", p->token);
//		}
//		printf("\n");

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

char *tokcat(int num, ...)
{
	va_list vali;
	int len = 1; /* NULL */

	va_start(vali, num);
	for (int i = 0; i < num; i++) {
		char *str = va_arg(vali, char*);
		len += strlen(str) + 1 /* space */;
	}
	va_end(vali);

	char *ret = malloc(len);
	ret[0] = '\0';

	va_start(vali, num);
	for (int i = 0; i < num; i++) {
		char *str = va_arg(vali, char*);
		int l = strlen(ret);
		if (l != 0 && ret[l - 1] != '\n')
			strcat(ret, " ");
		strcat(ret, str);
	}
	va_end(vali);

	return ret;
}

int yyerror(const char *msg)
{
	fprintf(stderr,"Error: %s\n",msg);
	return 0;
}

int main(int argc,char *argv[])
{
	FILE *fp;

	if(argc != 2) {
		printf("Please specify the input file.\n");
		return 1;
	} else {
		fp = fopen(argv[1], "r");
		if(!fp) {
			printf("couldn't open file for reading. \n");
			return 1;
		}
		yyin = fp;
	}
	
	yyparse();
	fclose(fp);
	return 0;
}
