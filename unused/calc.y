%code requires {
  #include "ast.h" // Include the ast.h header 

}
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "calc.tab.h"

    extern void yyerror (char const *);
    extern int yylex(void);
%}

%union {
  int intval;
  Node *node;
}

%token <intval> INTEGER

%token RET

%nterm <node> eval expr mul_expr rel_expr unary_expr atomic_expr

%token <intval> LT GT EQ NE

%%

eval	: expr RET { printTree($$, 0, "ret"); $$ = $1; return 0; }
        | expr { printTree($$, 0, "parent" ); return 0; }
        ;

expr:
      mul_expr                    { $$ = $1; }
    | expr '+' mul_expr           { $$ = createNode("+", 0, $1, $3); }
    | expr '-' mul_expr           { $$ = createNode("-", 0, $1, $3); }
    ;

mul_expr:
        rel_expr                    { $$ = $1; }
    |  mul_expr '*' rel_expr       { $$ = createNode("*", 0, $1, $3); }
    | mul_expr '/' rel_expr       { $$ = createNode("/", 0, $1, $3); }
    ;

rel_expr:
        unary_expr                  { $$ = $1; }
    |  rel_expr LT unary_expr      { $$ = createNode("<", 0, $1, $3); }
    | rel_expr GT unary_expr      { $$ = createNode(">", 0, $1, $3);  }
    | rel_expr EQ unary_expr      { $$ = createNode("==", 0, $1, $3); }
    | rel_expr NE unary_expr      { $$ = createNode("!=", 0, $1, $3);  }
    ;

unary_expr:
        atomic_expr                 { $$ = $1; }
    |  '-' atomic_expr             { $$ = createNode("unary-", 0, $2, NULL); }
    ;

atomic_expr:
      '(' expr ')'                { $$ = $2; }
    | INTEGER                     { $$ = createNode("integer", $1, NULL, NULL); }
    ;

%%

void yyerror(const char *s) {
  fprintf(stderr, "Error: %s\n", s);
}

int main() {
  yyparse();

  return 0;
}
