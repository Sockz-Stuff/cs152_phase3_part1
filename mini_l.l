
%{
#include "y.tab.h"
int row = 1; 
int col = 1;
%}

DIGIT       [0-9]
IDENTIFIER  [a-zA-Z0-9_]*[a-zA-Z0-9]*


%%

"-"		{ col += yyleng; return SUB; }
"+"		{ col += yyleng; return ADD; }
"*"		{ col += yyleng; return MULT; }
"/"		{ col += yyleng; return DIV; }
"%"		{ col += yyleng; return MOD; }

"=="	{ col += yyleng; return EQUIV; }
"!="	{ col += yyleng; return NOTEQ; }
"<"		{ col += yyleng; return LT; }
">"		{ col += yyleng; return GT; }
"<="	{ col += yyleng; return LTE; }
">="	{ col += yyleng; return GTE; }

";"		{ col += yyleng; return SEMICOLON; }
":"		{ col += yyleng; return COLON; }
","		{ col += yyleng; return COMMA; }
"("		{ col += yyleng; return L_PAREN; }
")"		{ col += yyleng; return R_PAREN; }
"["		{ col += yyleng; return L_SQUARE_BRACKET; }
"]"		{ col += yyleng; return R_SQUARE_BRACKET; }
"="		{ col += yyleng; return ASSIGN; }

it		{ col += yyleng; return INTEGER; }
arr		{ col += yyleng; return ARRAY; }
of		{ col += yyleng; return OF; }
if		{ col += yyleng; return IF; }
then	{ col += yyleng; return THEN; }
fi		{ col += yyleng; return ENDIF; }
elif	{ col += yyleng; return ELSE; }

while	{ col += yyleng; return WHILE; }
do		{ col += yyleng; return DO; }
begin_l	{ col += yyleng; return BEGINLOOP; }
end_l	{ col += yyleng; return ENDLOOP; }

func	    { col += yyleng; return FUNCTION; }
bp	        { col += yyleng; return BEGINPARAMS; }
ep	        { col += yyleng; return ENDPARAMS; }
bl	        { col += yyleng; return BEGINLOCALS; }
el	        { col += yyleng; return ENDLOCALS; }
bb	        { col += yyleng; return BEGINBODY; }
eb		    { col += yyleng; return ENDBODY; }
continue	{ col += yyleng; return CONTINUE; }
read		{ col += yyleng; return READ; }
write		{ col += yyleng; return WRITE; }
and		    { col += yyleng; return AND; }
or		    { col += yyleng; return OR; }
!		    { col += yyleng; return NOT; }
True		{ col += yyleng; return TRUE; }
False		{ col += yyleng; return FALSE; }
RETURN		{ col += yyleng; return RETURN; }

{DIGIT}+	{ col += yyleng; yylval.integerVal = atoi(yytext); return DIGITS; }
{IDENTIFIER}	{ col += yyleng; yylval.stringVal = strdup(yytext); return IDENTIFIER; }

[ \t]+		{col += yyleng;}
"\n"		{row++; col = 1;}
.		{printf("Error at (line %d, column %d): mystery symbol %d \"%s\"\n", row, col, atoi(yytext), yytext); exit(0);}

%%

