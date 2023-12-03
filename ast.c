#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "ast.h"

const char *astNodeTypeToString[] = {
    "QUERY",
    "MUTATION",
    "BOOLEAN",
    "NULL_VALUE",
    "FIELD",
    "VARIABLE",
    "NUMBER",
    "STRING",
    "PARENTHESIS",
    "COLON",
    "EQUAL",
    "BRAKET_OPEN",
    "BRAKET_CLOSE",
    "CURLY_BRACE_OPEN",
    "CURLY_BRACE_CLOSE",
    "COMMA",
    "DOT",
    "EQUAL_OPERATOR",
    "LOWER_OPERATOR",
    "GREATER_OPERATOR",
    "GREATER_EQUAL",
    "LOWER_EQUAL",
    "NOT_EQUAL",
    "NOT",
    "OR",
    "AND",
    "INTEGER",
    "DOUBLE",
    "IDENTIFIER",
    "PLUS_OPERATION",
    "MINUS_OPERATION",
    "MULTIPLY_OPERATION",
    "DIVIDE_OPERATION",
    "RET",
    "DOUBLE_DOT",
    "QOUTE",
    "ARGUMENT",
    "FILTER",
    "SELECTION",
    "OPERATION",
    "VALUE",
    "MATH_VALUE",
    "VAR_VALUE",
    "NAME_DEFINITION",
    "VARIABLE_DEFINITION",
    "SELECTION_SET",
    "TYPE",
    "JSON",
    "JSON_OBJECT",
    "JSON_ELEMENT",
    "JSON_ARRAY",
    "VALUES",
    "JSON_ELEMENTS"
};

Node *createNode_V(AstNodeType type, Node *left, Node *right) {
  printf("Need to create node: %s\n", astNodeTypeToString[type]);
  Node *newNode = (Node *) malloc(sizeof(Node));
  newNode->type = type;
  newNode->left = left;
  newNode->right = right;
  return newNode;
}

Node *createNode_I(AstNodeType type, int val, Node *left, Node *right) {
  Node *newNode = (Node *) malloc(sizeof(Node));
  newNode->type = type;
  newNode->value.int_val = val;
  newNode->left = left;
  newNode->right = right;
  return newNode;
}

Node *createNode_D(AstNodeType type, double val, Node *left, Node *right) {
  Node *newNode = (Node *) malloc(sizeof(Node));
  newNode->type = type;
  newNode->value.double_val = val;
  newNode->left = left;
  newNode->right = right;
  return newNode;
}

Node *createNode_B(AstNodeType type, bool val, Node *left, Node *right) {
  Node *newNode = (Node *) malloc(sizeof(Node));
  newNode->type = type;
  newNode->value.bool_val = val;
  newNode->left = left;
  newNode->right = right;
  return newNode;
}

char* copyStr(const char* src) {
    char* dest = malloc(strlen(src));
    strcpy(dest, src);
    return dest;
}

Node *createNode_S(AstNodeType type, char *val, Node *left, Node *right) {
  Node *newNode = (Node *) malloc(sizeof(Node));
  newNode->type = type;
  newNode->value.str_val = copyStr(val);;
  newNode->left = left;
  newNode->right = right;
  return newNode;
}

const char *getAstNodeTypeName(AstNodeType type) {
    if (type < AST_NODE_TYPE_COUNT) {
        return astNodeTypeToString[type];
    } else {
        return "UNKNOWN";
    }
}

void printTree(Node *node, int depth) {

    if (node == NULL) {
        return;
    }

    printf("|-");
    for (int i = 0; i < depth; ++i) {
        printf("|-");
    }
    printf(" ");
    printf("%s ", getAstNodeTypeName(node->type));
    switch (node->type) {
        case DOUBLE:
            printf(": %f", node->value.double_val);
            break;
        case INTEGER:
            printf(": %d", node->value.int_val);
            break;
        case STRING:
            printf(": \"%s\"", node->value.str_val);
            break;
        case FIELD:
            printf(": \"%s\"", node->value.str_val);
            break;
        case VARIABLE:
            printf(": \"%s\"", node->value.str_val);
            break;
        case BOOLEAN:
            printf(": %s", node->value.bool_val ? "true" : "false");
        default:
            break;
    }

    printf("\n");
    
    printTree(node->left, depth + 1);
    printTree(node->right, depth + 1);
}