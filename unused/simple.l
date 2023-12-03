%{
#include <stdio.h>
#include <stdlib.h>
extern FILE* yyin;

void init_flex(FILE* infile) {
  yyrestart(infile);
}
%}
%%

[/][/].*\n      ; // comment
[a-f0-9]+		{
					yylval.integer = yytext;
					return INT;
				}
[0-9]+\.[0-9]+  { 
					yylval.num = strtod(yytext, NULL);
                  	return NUM;
                }
[ \t\r]         ; // whitespace
[\n]            { return RET; }
.				{ return *yytext; }

%%
