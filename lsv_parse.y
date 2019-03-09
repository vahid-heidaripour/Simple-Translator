%{
#include <ctype.h>
#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef char *yystype;
#define YYSTYPE yystype

void             yyerror(const char *);
int              yylex(void);

extern FILE     *yyin;
%}

%token VARS
%token IFNEG THEN ELSE END
%token SKIP
%token COMMA
%token ID NUM
%token ASSIGN

%%

start                   : Program                                      
                        ;

Program                 : Statements Declaration                        
                        ;
Declaration             : VARS Vars                                     
                        ;
Vars                    : ID COMMA Vars                                 
                        | ID                                            
                        ;
Statements              : Statement                                     
                        | Statement COMMA Statements                    
                        ;
Statement               : SKIP                                          
                        | Assignment                                    
                        | Conditional                                   
                        ;
Assignment              : ID ASSIGN ID                                  
                        | ID ASSIGN NUM                                 
                        ;
Conditional             : IFNEG ID THEN Statements ELSE Statements END 
	                ;

%%

#include "lsv_lex.c"

void yyerror(const char *s)
{
        printf("%d : %s %s\n", yylineno, s, yytext);
}

int main(int argc, const char *const *argv)
{
        if (argc != 2)
                errx(1, "usage: %s inputfile", argv[0]);

        yyin = fopen(argv[1], "r");

        if(!yyparse())
                printf("\nParsing complete\n");
        else
                printf("\nParsing failed\n");

        fclose(yyin);

        return 0;
}

