%{
  #include <stdlib.h>
  #include "calc.tab.h"
  #include "ast.h"
void yyerror(const char *);
%}

%%

[0-9]+   { yylval.intval = atoi(yytext); return INTEGER; }
[ \t]  { /* Ignore whitespace */ }
[*/()+\-|&<>] { return yytext[0]; }
"=="     { return EQ; }
"!="     { return NE; }
.        { yyerror("invalid character"); }
[\n]            { return RET; }

%%

int yywrap() {
  return 1;
}
