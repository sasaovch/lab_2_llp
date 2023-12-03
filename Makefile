CC        = gcc
CFLAGS    = -Wall -g
#include libm.a
INC_LIB   = -lfl

TARGET    = graphql

SRC_DIR = ./
OBJ_DIR = ./build/

SRC_FILES = $(wildcard $(SRC_DIR)*.c)
OBJ_FILES = $(patsubst $(SRC_DIR)%.c, $(OBJ_DIR)%.o, $(SRC_FILES))

.PHONY: all
all : $(TARGET)

$(TARGET) : $(OBJ_FILES) FLEX BISON
	$(CC) $(OBJ_FILES) -o $(TARGET) $(INC_LIB) $(OBJ_DIR)parser.c $(OBJ_DIR)lexer.c

$(OBJ_DIR)%.o : $(SRC_DIR)%.c $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR) :
	mkdir $(OBJ_DIR)

FLEX :
	flex -o $(OBJ_DIR)lexer.c $(SRC_DIR)graphql.l

BISON :
	bison -t -o $(OBJ_DIR)parser.c --header=$(OBJ_DIR)parser.h $(SRC_DIR)graphql.y -Wcounterexamples -Wother -Wconflicts-sr

.PHONY: clean
clean :
	rm -r $(TARGET) $(OBJ_DIR)
