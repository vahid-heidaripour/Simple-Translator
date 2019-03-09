
%%

[ \t\n]*vars[ \t\n]*            { yylval = strdup(yytext); return VARS; }
[ \t\n]*skip[ \t\n]*            { yylval = strdup(yytext); return SKIP; }
[ \t\n]*ifneg[ \t\n]*           { yylval = strdup(yytext); return IFNEG;}
[ \t\n]*then[ \t\n]*            { yylval = strdup(yytext); return THEN; }
[ \t\n]*else[ \t\n]*            { yylval = strdup(yytext); return ELSE; }
[ \t\n]*end[ \t\n]*             { yylval = strdup(yytext); return END;  }
[ \t\n]*":="[ \t\n]*            { yylval = strdup(yytext); return ASSIGN;}
[ \t\n]*","[ \t\n]*             { yylval = strdup(yytext); return COMMA; }
\n                              { yylineno = yylineno + 1; }
[ \t\n]*[a-zA-Z]+[ \t\n]*       { yylval = strdup(yytext); return ID;   }
[ \t\n]*-?[0-9]+[ \t\n]*        { yylval = strdup(yytext); return NUM;  }
[ \t\n]*[^ \t\n][ \t\n]*        { yylval = strdup(yytext); return *yytext; }

%%

