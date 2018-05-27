%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

extern FILE *yyin;
extern int yylex (void);
extern int yyerror(const char *msg);

char *tokcat(int, ...);
char *tok_cat(int, ...);

struct list_node {
	struct list_node *next;
	char token[512];
};

struct list_node *list_new(char*);
struct list_node *list_push_front(struct list_node **, char*);
char *list_token(struct list_node*, int);
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

%destructor { printf("\n token \n"); } <token>
%destructor { printf("\n list \n"); } <list>
%destructor { printf("\n text \n"); } <text>

%%
program
	: tokens { printf("%s", $1); free($1); } ;

tokens
	: { $$ = strdup(""); }
	| tokens token   { $$ = tok_cat(2, $1, $2); free($1); }
	| tokens block   { $$ = tok_cat(4, $1, "{", $2, "}"); free($1); free($2); }
	| tokens foreach { $$ = tok_cat(4, $1, "{", $2, "}"); free($1); free($2); }
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
	: NAME { $$ = list_new($1); }
	| namelist ',' NAME {
		$$ = list_push_front(&($1), $3);
	}
	;

foreach
	: _FOREACH '(' namelist ')' block {
		char *tok1 = list_token($3, 3);
		char *tok2 = list_token($3, 2);
		char *tok3 = list_token($3, 1);
		$$ = tokcat(16,
			"struct ", tok2, "_iterator ", tok1, " = ",
			tok2, "_mk_iterator(", tok3, "); ",
			"do {",
			$5,
			"} while (list_next(", tok3, ", &", tok1, "));"
		);

		list_free($3);
	}
	;
%%
/*
*/

struct list_node *list_push_front(struct list_node **head, char *token)
{
	struct list_node *p = *head;
	*head = list_new(token);
	(*head)->next = p;
	return *head;
}

struct list_node *list_new(char *token)
{
	struct list_node *ret = malloc(sizeof(struct list_node));
	ret->next = NULL;
	strcpy(ret->token, token);

	return ret;
}

char *list_token(struct list_node *head, int index)
{
	char *tok = NULL;
	for (int i = 0; i < index && head; i++, head = head->next)
		tok = head->token;
	return tok;
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

static char *_tokcat(int space, int num, va_list vali)
{
	int len = 1; /* NULL */

	va_list vali_copy;
	va_copy(vali_copy, vali);

	for (int i = 0; i < num; i++) {
		char *str = va_arg(vali, char*);
		len += strlen(str) + 1 /* space */;
	}

	char *ret = malloc(len);
	ret[0] = '\0';

	for (int i = 0; i < num; i++) {
		char *str = va_arg(vali_copy, char*);
		int l = strlen(ret);
		if (space && l != 0 && ret[l - 1] != '\n')
			strcat(ret, " ");
		strcat(ret, str);
	}
	va_end(vali_copy);

	return ret;
}

char *tok_cat(int num, ...)
{
	va_list vali;
	va_start(vali, num);
	_tokcat(1, num, vali);
	va_end(vali);
}

char *tokcat(int num, ...)
{
	va_list vali;
	va_start(vali, num);
	_tokcat(0, num, vali);
	va_end(vali);
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
