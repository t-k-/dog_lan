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
%}

%%

"\n"                                   { return '\n'; }
"\t"                                   { return '\t'; }
"/*"                                   { COPY; return TOKEN; }
"*/"                                   { COPY; return TOKEN; }
"//".*                                 { COPY; return TOKEN; }
"#".*                                  { COPY; return TOKEN; }

for_each                                { return _FOREACH; }

{L}{A}*                                { COPY; return NAME; }
{HP}{H}+{IS}?                          { COPY; return TOKEN; }
{NZ}{D}*{IS}?                          { COPY; return TOKEN; }
"0"{O}*{IS}?                           { COPY; return TOKEN; }
{CP}?"'"([^'\\\n]|{ES})+"'"            { COPY; return TOKEN; }

{D}+{E}{FS}?                           { COPY; return TOKEN; }
{D}*"."{D}+{E}?{FS}?                   { COPY; return TOKEN; }
{D}+"."{E}?{FS}?                       { COPY; return TOKEN; }
{HP}{H}+{P}{FS}?                       { COPY; return TOKEN; }
{HP}{H}*"."{H}+{P}{FS}?                { COPY; return TOKEN; }
{HP}{H}+"."{P}{FS}?                    { COPY; return TOKEN; }

({SP}?\"([^"\\\n]|{ES})*\"{WS}*)+      { COPY; return TOKEN; }

","                    { return ','; }
"("                    { return '('; }
")"                    { return ')'; }
"{"                    { return '{'; }
"}"                    { return '}'; }

"..."                  { COPY; return TOKEN; }
">>="                  { COPY; return TOKEN; }
"<<="                  { COPY; return TOKEN; }
"+="                   { COPY; return TOKEN; }
"-="                   { COPY; return TOKEN; }
"*="                   { COPY; return TOKEN; }
"/="                   { COPY; return TOKEN; }
"%="                   { COPY; return TOKEN; }
"&="                   { COPY; return TOKEN; }
"^="                   { COPY; return TOKEN; }
"|="                   { COPY; return TOKEN; }
">>"                   { COPY; return TOKEN; }
"<<"                   { COPY; return TOKEN; }
"++"                   { COPY; return TOKEN; }
"--"                   { COPY; return TOKEN; }
"->"                   { COPY; return TOKEN; }
"&&"                   { COPY; return TOKEN; }
"||"                   { COPY; return TOKEN; }
"<="                   { COPY; return TOKEN; }
">="                   { COPY; return TOKEN; }
"=="                   { COPY; return TOKEN; }
"!="                   { COPY; return TOKEN; }
";"                    { COPY; return TOKEN; }
":"                    { COPY; return TOKEN; }
"="                    { COPY; return TOKEN; }
"["                    { COPY; return TOKEN; }
"]"                    { COPY; return TOKEN; }
"."                    { COPY; return TOKEN; }
"&"                    { COPY; return TOKEN; }
"!"                    { COPY; return TOKEN; }
"~"                    { COPY; return TOKEN; }
"-"                    { COPY; return TOKEN; }
"+"                    { COPY; return TOKEN; }
"*"                    { COPY; return TOKEN; }
"/"                    { COPY; return TOKEN; }
"%"                    { COPY; return TOKEN; }
"<"                    { COPY; return TOKEN; }
">"                    { COPY; return TOKEN; }
"^"                    { COPY; return TOKEN; }
"|"                    { COPY; return TOKEN; }
"?"                    { COPY; return TOKEN; }
.                      { /* escape */ }

%%
