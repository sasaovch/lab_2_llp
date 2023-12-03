%code requires {
  #include "../ast.h"
}

%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "parser.h"

  extern void yyerror (char const *);
  extern int yylex(void);

  extern FILE *yyin;
%}

%union {
  int integer;
  int boolean;
  double real;
  char *string;
  Node *node;
}

%token
    QUERY_TOKEN
    MUTATION_TOKEN
    BOOLEAN_TOKEN
    NULL_VALUE_TOKEN
    FIELD_TOKEN
    VARIABLE_TOKEN
    NUMBER_TOKEN
    STRING_TOKEN
    PARENTHESIS_TOKEN
    COLON_TOKEN
    EQUAL_TOKEN
    BRAKET_OPEN_TOKEN
    BRAKET_CLOSE_TOKEN
    CURLY_BRACE_OPEN_TOKEN
    CURLY_BRACE_CLOSE_TOKEN
    COMMA_TOKEN
    DOT_TOKEN
    EQUAL_OPERATOR_TOKEN
    LOWER_OPERATOR_TOKEN
    GREATER_OPERATOR_TOKEN
    GREATER_EQUAL_TOKEN
    LOWER_EQUAL_TOKEN
    NOT_EQUAL_TOKEN
    NOT_TOKEN
    OR_TOKEN
    AND_TOKEN
    INTEGER_TOKEN
    DOUBLE_TOKEN
    IDENTIFIER_TOKEN
    PLUS_OPERATION_TOKEN
    MINUS_OPERATION_TOKEN
    MULTIPLY_OPERATION_TOKEN
    DIVIDE_OPERATION_TOKEN
    RET_TOKEN
    DOUBLE_DOT_TOKEN
    QOUTE_TOKEN
    SQUARE_BRAKET_OPEN_TOKEN
    SQUARE_BRAKET_CLOSE_TOKEN

%type <string> IDENTIFIER_TOKEN
%type <real> DOUBLE_TOKEN
%type <string> FIELD_TOKEN VARIABLE_TOKEN
%type <integer> INTEGER_TOKEN
%type <boolean> BOOLEAN_TOKEN

%nterm <node> start 
      operation_definitions 
      operation_definition 
      query 
      mutation 
      argument 
      expr 
      mul_expr 
      rel_expr 
      atomic_expr
      selection_set_opt
      selection_set
      selection_list
      selection
      arguments_opt
      argument_list
      arguments
      name
      value
      variable
      json_input
      json_value
      json_object
      json_elements
      json_element
      json_array
      json_values

%%


json_input:
    json_value                                             { $$ = createNode_V(JSON, $1, NULL); }

json_value:
    json_object  { $$ = $1; }
  | value { $$ = createNode_V(JSON_OBJECT, $1, NULL); }
  | json_array  { $$ = $1; }
  ;

json_object:
    CURLY_BRACE_OPEN_TOKEN CURLY_BRACE_CLOSE_TOKEN { $$ = NULL; }
  | CURLY_BRACE_OPEN_TOKEN json_elements CURLY_BRACE_CLOSE_TOKEN { $$ = createNode_V(JSON_OBJECT, $2, NULL); }
  ;

json_elements:
    json_element { $$ = $1; }
  | json_elements COMMA_TOKEN json_element { $$ = createNode_V(JSON_ELEMENTS, $1, $3); }
  ;

json_element:
    QUERY_TOKEN name QUERY_TOKEN json_value { $$ = createNode_V(JSON_ELEMENT, $2, $4); }
  ;

json_array:
    SQUARE_BRAKET_OPEN_TOKEN SQUARE_BRAKET_CLOSE_TOKEN { $$ = NULL; }
  | SQUARE_BRAKET_OPEN_TOKEN json_values SQUARE_BRAKET_CLOSE_TOKEN { $$ = createNode_V(JSON_ARRAY, $2, NULL); }
  ;

json_values:
    json_value { $$ = $1; }
  | json_values COMMA_TOKEN json_value { $$ = createNode_V(VALUES, $1, $3); }


value:
    rel_expr                                               { $$ = createNode_V(MATH_VALUE, $1, NULL); }
  | name                                                   { $$ = createNode_V(VAR_VALUE, $1, NULL); }
  | QOUTE_TOKEN name QOUTE_TOKEN                           { $$ = createNode_V(VALUE, $2, NULL); }

rel_expr:
      expr                                                 { $$ = $1; }
    | rel_expr LOWER_OPERATOR_TOKEN expr                   { $$ = createNode_V(LOWER_EQUAL, $1, $3); }
    | rel_expr GREATER_OPERATOR_TOKEN expr                 { $$ = createNode_V(GREATER_EQUAL, $1, $3); }
    | rel_expr EQUAL_OPERATOR_TOKEN expr                   { $$ = createNode_V(EQUAL_OPERATOR, $1, $3); }
    | rel_expr NOT_EQUAL_TOKEN expr                        { $$ = createNode_V(NOT_EQUAL, $1, $3); }
    ;

expr:
      mul_expr                                             { $$ = $1; }
    | expr PLUS_OPERATION_TOKEN mul_expr                   { $$ = createNode_V(PLUS_OPERATION, $1, $3); }
    | expr MINUS_OPERATION_TOKEN mul_expr                  { $$ = createNode_V(MULTIPLY_OPERATION, $1, $3); }
    ;

mul_expr:
      atomic_expr                                          { $$ = $1; }
    | mul_expr MULTIPLY_OPERATION_TOKEN atomic_expr        { $$ = createNode_V(MULTIPLY_OPERATION, $1, $3); }
    | mul_expr DIVIDE_OPERATION_TOKEN atomic_expr          { $$ = createNode_V(DIVIDE_OPERATION, $1, $3); }
    ;

atomic_expr:
      BRAKET_OPEN_TOKEN expr BRAKET_CLOSE_TOKEN            { $$ = $2; }
    | DOUBLE_TOKEN                                         { $$ = createNode_D(DOUBLE, $1, NULL, NULL); }
    | INTEGER_TOKEN                                        { $$ = createNode_I(INTEGER, $1, NULL, NULL); }
    ;

name: 
    FIELD_TOKEN { $$ = createNode_S(FIELD, $1, NULL, NULL); }
  
variable:
    VARIABLE_TOKEN { $$ = createNode_S(VARIABLE, $1, NULL, NULL); }

%%

void yyerror(const char *s) {
  fprintf(stderr, "error: %s\n", s);
}


int main(int argc, char *argv[]) {
  --argc;
  ++argv;
  if (argc == 0) {
    printf("Usage: ./parser <file.graphql>\n");
    return 1;
  }
  
  FILE *file = fopen(argv[0], "r");
  if (file == NULL) {
    printf("Unable to open file: %s\n", argv[0]);
    return 1;
  }
  yyin = file;
  if (yyparse()) {
    printf("Parsing failed\n");
  }
}