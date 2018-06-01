L   [a-zA-Z_]
A   [a-zA-Z_0-9]

SP  (u8|u|U|L)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\n\f]

%{
#include <string.h>
#include "dog.tab.h"

#define COPY strcpy(yylval.token, yytext)
#define PRINT // if (yytext[0] == '\n') printf("\n"); else printf("[%s]", yytext)
%}

%x comment

%%

 /* comments */
"//".*[\n]                             {}
"/*"                                   { BEGIN(comment); }
<comment>.                             {}
<comment>\n                            {}
<comment>"*/"                          { BEGIN(INITIAL); }

 /* special treatment for C */
"\\""\n"                               { COPY; return TOKEN; }
"#define"[ ]+{L}{A}*"("                { COPY; return TOKEN; }

 /* quoted string */
({SP}?\"([^"\\\n]|{ES})*\"{WS}*)+      { PRINT; COPY; return QUOTED; }

 /* keywords */
"foreach"                              { return _FOREACH; }

 /* names */
{L}{A}*                                { PRINT; COPY; return NAME; }

 /* seperator */
","                                    { PRINT; return ','; }
"("                                    { PRINT; return '('; }
")"                                    { PRINT; return ')'; }
"{"                                    { PRINT; return '{'; }
"}"                                    { PRINT; return '}'; }
"["                                    { PRINT; return '['; }
"]"                                    { PRINT; return ']'; }

 /* spaces */

"\n"                                   { PRINT; return '\n'; }
"\t"                                   { PRINT; return '\t'; }
[ ]+                                   { }

 /* tokens */
[^ \t\n,(){}\[\]]+                     { PRINT; COPY; return TOKEN; }

%%
