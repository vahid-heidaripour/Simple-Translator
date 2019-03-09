%{
#include <ctype.h>
#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef char *yystype;
#define YYSTYPE yystype

void		 yyerror(const char *);
int		 yylex(void);

extern FILE	*yyin;
extern FILE	*yyout;

%}

%token VARS
%token IFPOS THEN ELSE END
%token SKIP
%token COMMA
%token ID NUM
%token ASSIGN

%%

start			: Program					{ fprintf(yyout, "%s", $1); }
			;

Program 		: Declaration Statements			{ asprintf(&$$, "%s%s", $2, $1); free($1); free($2); }
			;
Declaration      	: VARS Vars					{ asprintf(&$$, "%s%s", $1, $2); free($1); free($2); }
			;
Vars			: ID COMMA Vars					{ asprintf(&$$, "%s%s%s", $1, $2, $3); free($1); free($2); free($3); }
			| ID						{ $$ = $1; }
			;
Statements		: Statement					{ $$ = $1; }
			| Statement COMMA Statements			{ asprintf(&$$, "%s%s%s", $1, $2, $3); free($1); free($2); free($3); }
			;
Statement		: SKIP						{ $$ = $1; }
			| Assignment					{ $$ = $1; }
			| Conditional					{ $$ = $1; }
			;
Assignment		: ID ASSIGN ID					{ asprintf(&$$, "%s%s%s", $1, $2, $3); free($1); free($2); free($3); }
			| ID ASSIGN NUM					{ asprintf(&$$, "%s%s%s", $1, $2, $3); free($1); free($2); free($3); }
			;
Conditional		: IFPOS ID THEN Statements ELSE Statements END  {
										char *ifpos = "ifpos";
										char *ws1 = $1;
										char *ws1_end = strstr($1, ifpos);
										char *ws2 = ws1_end + strlen(ifpos);
										*ws1_end = 0;
										asprintf(&$$, "%sifneg%s%s%s%s%s%s%s", ws1, ws2, $2, $3, $6, $5, $4, $7);
										free($1); free($2); free($3); free($4); free($5); free($6); free($7);
									}
			;

%%

#include "lex.c"

void yyerror(const char *s)
{
	printf("%d : %s %s\n", yylineno, s, yytext);
}

int main(int argc, const char *const *argv)
{
	if (argc != 2)
		errx(1, "usage: %s inputfile", argv[0]);

        yyout = fopen("output", "w");
	yyin = fopen(argv[1], "r");

        if(!yyparse())
        	printf("\nParsing complete\n");
        else
        	printf("\nParsing failed\n");

        fclose(yyin);
        fclose(yyout);

        return 0;
}

