/* 
   Angie Graci
   CSC 444
   Dr. Lea
   Fall 2014

   Phase 1 
   Part b: parser (vanilla)

   Parser for MiniJava 
   Bison Grammar File
*/

//================//
// C Declarations //
//================//

%{
#include <cstdio>
#include "minijava.tab.h"

// required components
extern "C" int yylex();
extern "C" FILE *yyin;
extern int base_yydebug;
extern int yylineno;
extern char *yytext;

// display errors
void yyerror(const char *s);
%}

//====================//
// Bison Declarations //
//====================//

// make more informative error messages
%error-verbose 

// definition of yystypes
%union {
  int ival;
  char *sval;
}

// define tokens
%token LCB
%token RCB
%token LP
%token RP
%token LSB
%token RSB
%token ASSIGNMENT
%token SEMICOLON
%token COMMA
%token LT
%token LAND
%token NOT
%token PLUS
%token MINUS
%token TIMES
%token DOT
%token CLASS
%token PUBLIC
%token STATIC
%token VOID
%token MAIN
%token STRING
%token EXTENDS
%token RETURN
%token INT
%token BOOLEAN
%token IF
%token ELSE
%token WHILE
%token SOUT
%token LENGTH
%token TRUE
%token FALSE
%token THIS
%token NEW
%token END
%token <ival> INTLIT
%token <sval> ID

// define associativity rules
%left LAND

//===============//
// Grammar Rules //
//===============//
%%
             Goal : MainClass Goal2
		  ;
            Goal2 : Goal2 ClassDeclaration /* (ClassDeclaration)* */ 
		  |
		  ;
        MainClass : CLASS Identifier LCB PUBLIC STATIC VOID MAIN LP STRING LSB RSB Identifier RP LCB Statement RCB RCB
		  ;
 ClassDeclaration : CLASS Identifier ExtendOption LCB Attributes Methods RCB
		  ;
     ExtendOption : EXTENDS Identifier /* (EXTENDS Identifier)? */
                  |
                  ;
       Attributes : Attributes VarDeclaration /* (VarDeclaration)* */
                  |
                  ; 
          Methods : MethodDeclaration Methods /* (MethodDeclaration)* */
                  | 
                  ;
   VarDeclaration : Type Identifier SEMICOLON
		  ;
MethodDeclaration : PUBLIC Type Identifier LP ParameterOptions RP LCB Attributes StatementList RETURN Expression SEMICOLON RCB
		  ;
  ParameterOptions: Type Identifier Parameters
                  | 
                  ;
       Parameters : COMMA Type Identifier Parameters /* (Type Identifier (COMMA Type Identifier)* )? */
                  | 
                  ;
    StatementList : Statement StatementList /* (Statement)* */ 
		  | 
		  ;
             Type : INT LSB RSB
                  | BOOLEAN
                  | INT
                  | Identifier
		  ;
        Statement : LCB StatementList RCB
                  | IF LP Expression RP Statement ELSE Statement
                  | WHILE LP Expression RP Statement
                  | SOUT LP Expression RP SEMICOLON
                  | Identifier ASSIGNMENT Expression SEMICOLON
                  | Identifier LSB Expression RSB ASSIGNMENT Expression SEMICOLON
		  ;
       Expression : Logical
                  ; 
          Logical : Relational Logical_P
                  ;
        Logical_P : LAND Relational Logical_P
                  |
	          ;
       Relational : Additive Relational_P
                  ;
     Relational_P : LT Additive Relational_P
                  |
	          ;
         Additive : Multiplicative Additive_P
                  ;
       Additive_P : PLUS Multiplicative Additive_P
                  | MINUS Multiplicative Additive_P
                  | 
                  ;
   Multiplicative : Negation Multiplicative_P
                  ;
 Multiplicative_P : TIMES Negation Multiplicative_P
                  | 
                  ;
         Negation : Negation_P Access
	          ;
       Negation_P : NOT Negation_P
                  |
	          ;
           Access : Literal Access_P 
                  ;
         Access_P : LSB Expression RSB Access_P
                  | DOT LENGTH Access_P
                  | DOT Identifier LP ArgumentsOption RP Access_P
                  |
                  ;
          Literal : TRUE
                  | FALSE
                  | THIS
                  | INTLIT
                  | Identifier
                  | NEW Identifier LP RP
	          | NEW INT LSB Expression RSB 
                  | LP Expression RP
                  ;
  ArgumentsOption : Expression Arguments
                  |
                  ;
        Arguments : COMMA Expression Arguments
                  | 
                  ;
       Identifier : ID 
		  ;
%%

//===================//
// Additional C Code //
//===================//

main(int argc, char** argv) {
  // check if user provided a file name
  if (argc < 2) {
    printf("No file specified!\n");
    return -1;
  }

  // open a minijava file
  FILE *myfile = fopen(argv[1], "r");

  // check that file is valid
  if (!myfile) {
    printf("Failed to open the file!\n");
    return -1;
  }

  // have lex read from file
  yyin = myfile;

  // lex it to the end!
  do {
    yyparse();
  } while (!feof(yyin));
}

// syntax error formatting
void yyerror(const char *s) {
  fprintf(stderr, "%d: %s.\n", yylineno, s);
}







