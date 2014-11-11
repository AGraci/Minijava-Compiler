/* Angie Graci
   CSC 444
   Dr. Lea
   Fall 2014

   Phase 1 
   Part a: lexer (vanilla)
   Scanner for MiniJava */

%{
#define YY_DECL extern "C" int yylex()
%}

DIGIT    [0-9]
ID       [a-zA-Z][a-zA-Z0-9_]*

%x MCOMMENT
%x SCOMMENT
%%

<INITIAL>"/*"                  BEGIN(MCOMMENT);     
<INITIAL>"//"                  BEGIN(SCOMMENT);     
<INITIAL>"{"                   { printf("LCB\n"); }
<INITIAL>"}"                   { printf("RCB\n"); }
<INITIAL>"("                   { printf("LP\n"); }
<INITIAL>")"                   { printf("RP\n"); }
<INITIAL>"["                   { printf("LSB\n"); }
<INITIAL>"]"                   { printf("RSB\n"); }
<INITIAL>"="                   { printf("ASSIGNMENT\n"); }
<INITIAL>";"                   { printf("SEMICOLON\n"); }
<INITIAL>","                   { printf("COMMA\n"); }
<INITIAL>"<"                   { printf("LT\n"); }
<INITIAL>"&&"                  { printf("LAND\n"); }
<INITIAL>"!"                   { printf("NOT\n"); }
<INITIAL>"+"                   { printf("PLUS\n"); }
<INITIAL>"-"                   { printf("MINUS\n"); }
<INITIAL>"*"                   { printf("TIMES\n"); }
<INITIAL>"."                   { printf("DOT\n"); }
<INITIAL>"class"               { printf("CLASS\n"); }
<INITIAL>"public"              { printf("PUBLIC\n"); }
<INITIAL>"static"              { printf("STATIC\n"); }
<INITIAL>"void"                { printf("VOID\n"); }
<INITIAL>"main"                { printf("MAIN\n"); }
<INITIAL>"String"              { printf("STRING\n"); }
<INITIAL>"extends"             { printf("EXTENDS\n"); }
<INITIAL>"return"              { printf("RETURN\n"); }
<INITIAL>"int"                 { printf("INT\n"); }
<INITIAL>"boolean"             { printf("BOOLEAN\n"); }
<INITIAL>"if"                  { printf("IF\n"); }
<INITIAL>"else"                { printf("ELSE\n"); }
<INITIAL>"while"               { printf("WHILE\n"); }
<INITIAL>"System.out.println"  { printf("SOUT\n"); }
<INITIAL>"length"              { printf("LENGTH\n"); }
<INITIAL>"true"                { printf("TRUE\n"); }
<INITIAL>"false"               { printf("FALSE\n"); }
<INITIAL>"this"                { printf("THIS\n"); }
<INITIAL>"new"                 { printf("NEW\n"); }
<INITIAL>"\n"                  { yylineno++; }
<INITIAL>[ \t]+                /* eat up whitespace */
<INITIAL><<EOF>>              { printf("EOF\n"); return 0; }
<INITIAL>{DIGIT}+              { printf( "INTEGER: %d\n", atoi( yytext ) ); }
<INITIAL>{ID}                  { printf( "IDENTIFIER: %s\n", yytext ); }
<INITIAL>.                     { printf("Error: unexpected token '%s'.\n", yytext);}

<MCOMMENT>"*/"                 BEGIN(INITIAL);
<MCOMMENT>"\n"                 { yylineno++; }
<MCOMMENT><<EOF>>              { printf("EOF\n"); return 1; }
<MCOMMENT>.                    /* eat it! */

<SCOMMENT>"\n"                 { yylineno++; BEGIN(INITIAL); }
<SCOMMENT><<EOF>>              { printf("EOF\n"); return 0; }
<SCOMMENT>.                    /* eat it! */

%%

main() {
  // open a minijava file
  FILE *myfile = fopen("sample.java", "r");

  // check that file is valid
  if (!myfile) {
    printf("Failed to open the file!\n");
    return -1;
  }

  // have lex read from file
  yyin = myfile;

  // lex it!
  yylex();
}
