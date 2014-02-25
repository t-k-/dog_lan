%{
#include <string.h>
#include "dog.tab.h"
%}

%%

[\t ]	;
\n      ;
GO      {return GO;}
dog\.   {return DOG;}
;       {return SEMICOLON;}
[a-z]+  {strcpy(yylval.somewhere, yytext);  return WHERE;}

%%
