/* 
   Angie Graci
   CSC 444
   Dr. Lea
   Fall 2014

   Phase 1 
   Part b: lexer (vanilla)

   Scanner for MiniJava 
*/

%{
#define YY_DECL extern "C" int yylex()
#include "minijava.tab.h"
%}

DIGIT    [0-9]
ID       [a-zA-Z][a-zA-Z0-9_]*

%x MCOMMENT
%x SCOMMENT
%%

<INITIAL>"/*"                  BEGIN(MCOMMENT);     
<INITIAL>"//"                  BEGIN(SCOMMENT);     
<INITIAL>"{"                   { return LCB; }
<INITIAL>"}"                   { return RCB; }
<INITIAL>"("                   { return LP; }
<INITIAL>")"                   { return RP; }
<INITIAL>"["                   { return LSB; }
<INITIAL>"]"                   { return RSB; }
<INITIAL>"="                   { return ASSIGNMENT; }
<INITIAL>";"                   { return SEMICOLON; }
<INITIAL>","                   { return COMMA; }
<INITIAL>"<"                   { return LT; }
<INITIAL>"&&"                  { return LAND; }
<INITIAL>"!"                   { return NOT; }
<INITIAL>"+"                   { return PLUS; }
<INITIAL>"-"                   { return MINUS; }
<INITIAL>"*"                   { return TIMES; }
<INITIAL>"."                   { return DOT; }
<INITIAL>"class"               { return CLASS; }
<INITIAL>"public"              { return PUBLIC; }
<INITIAL>"static"              { return STATIC; }
<INITIAL>"void"                { return VOID; }
<INITIAL>"main"                { return MAIN; }
<INITIAL>"String"              { return STRING; }
<INITIAL>"extends"             { return EXTENDS; }
<INITIAL>"return"              { return RETURN; }
<INITIAL>"int"                 { return INT; }
<INITIAL>"boolean"             { return BOOLEAN; }
<INITIAL>"if"                  { return IF; }
<INITIAL>"else"                { return ELSE; }
<INITIAL>"while"               { return WHILE; }
<INITIAL>"System.out.println"  { return SOUT; }
<INITIAL>"length"              { return LENGTH; }
<INITIAL>"true"                { return TRUE; }
<INITIAL>"false"               { return FALSE; }
<INITIAL>"this"                { return THIS; }
<INITIAL>"new"                 { return NEW; }
<INITIAL>"\n"                  { yylineno++; }
<INITIAL><<EOF>>               { return END; }
<INITIAL>[ \t]+                /* eat up whitespace */
<INITIAL>{DIGIT}+              { yylval.ival = atoi(yytext); return INTLIT; }
<INITIAL>{ID}                  { yylval.sval = yytext; return ID; }
<INITIAL>.                     { printf("Error: unexpected token '%s'.\n", yytext); }

<MCOMMENT>"*/"                 BEGIN(INITIAL);
<MCOMMENT>"\n"                 { yylineno++; }
<MCOMMENT>.                    /* eat it! */

<SCOMMENT>"\n"                 { yylineno++; BEGIN(INITIAL); }
<SCOMMENT>.                    /* eat it! */

%%
