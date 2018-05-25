O   [0-7]
D   [0-9]
NZ  [1-9]
L   [a-zA-Z_]
A   [a-zA-Z_0-9]
H   [a-fA-F0-9]
HP  (0[xX])
E   ([Ee][+-]?{D}+)
P   ([Pp][+-]?{D}+)
FS  (f|F|l|L)
IS  (((u|U)(l|L|ll|LL)?)|((l|L|ll|LL)(u|U)?))
CP  (u|U|L)
SP  (u8|u|U|L)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\n\f]

%{
#include <string.h>
#include "dog.tab.h"

#define COPY strcpy(yylval.token, yytext)
#define PRINT if (yytext[0] == '\n') printf("\n"); else printf("[%s]", yytext)
%}

%%

"//".*                                 { PRINT; COPY; return TOKEN; }
({SP}?\"([^"\\\n]|{ES})*\"{WS}*)+      { PRINT; COPY; return TOKEN; }

for_each                               { return _FOREACH; }

","                                    { PRINT; return ','; }
"("                                    { PRINT; return '('; }
")"                                    { PRINT; return ')'; }
"{"                                    { PRINT; return '{'; }
"}"                                    { PRINT; return '}'; }

"\n"                                   { PRINT; return '\n'; }
"\t"                                   { PRINT; return '\t'; }
[ ]+                                   { PRINT; return ' ';}
[^ \t\n,(){}]+                { PRINT; COPY; return TOKEN; }

%%
