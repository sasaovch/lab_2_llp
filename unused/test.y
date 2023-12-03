%{
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int nodeType;
    char* tokenText;
    struct Node* child;
    struct Node* sibling;
} Node;

#define YYSTYPE struct Node *

int yylex(void);
void yyerror(const char *s);

extern FILE *yyin;
%}

%union {
  int integer;
  double real;
  char *string;
  Node *node;
}

%token<node> FIELD VARIABLE
%token<string> STRING
%token<integer> INTEGER
%token<real> REAL

%nterm <node> start 
      operation_definitions 
      operation_definition 
      query 
      mutation 
      eval 
      field_set 
      object
      objects
      opt_name 
      field 
      arguments 
      expr 
      mul_expr 
      rel_expr 
      unary_expr 
      atomic_expr

%right ';'
%right '='

%%

start:
operation_definitions
;

operation_definitions:
  operation_definition operation_definitions
  | 
;

operation_definition:
  query
  | mutation
;

query:
  "query" opt_name '{' field_set '}' {
    $$ = $4;
  }
;

mutation:
  "mutation" opt_name '{' field_set '}' {
    $$ = $4;
  }
;

opt_name: 
  /* empty */ { $$ = NULL; }
  | FIELD { 
    $$ = malloc(sizeof(Node));
    $$->nodeType = 0;
    $$->tokenText = $1->tokenText;
    $$->child = NULL;
    $$->sibling = NULL;
  }
;

field_set:
  field field_set {
    $$ = $1;
    $$->sibling = $2;
  }
  | /* empty */ { $$ = NULL; }
;

field:
  FIELD '(' arguments ')' '{' field_set '}' {
    $$ = $1;
    $$->child = $6;
  }
  | FIELD '(' arguments ')' {
    $$ = $1;
  }
  | FIELD '{' field_set '}' {
    $$ = $1;
    $$->child = $3;
  }
  | FIELD {
    $$ = $1;
  }
;

arguments:
  FIELD ':' FIELD arguments {
    $$ = $1;
    $$->child = $3;
    $$->sibling = $4;
  }
  |
;

%%

void yyerror(const char *s) {
  fprintf(stderr, "error: %s\n", s);
}

Node *parse_file(FILE *file) {
  yyin = file;
  if (yyparse()) {
    printf("Parsing failed\n");
  }
}

int main(int argc, char *argv[]) {
  --argc;
  ++argv;
  if (argc == 0) {
    printf("Usage: ./parser <file.graphql>\n");
    return 1;
  }
  
  FILE *f = fopen(argv[0], "r");
  if (f == NULL) {
    printf("Unable to open file: %s\n", argv[0]);
    return 1;
  }
  
  Node *root = parse_file(f);
  // ...
}
