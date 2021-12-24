%option noyywrap

%{

int isFirstTokenPrinted = 0;

typedef enum tokenCategory {
    NO_LEXEME, 
    IDENTIFIER, 
    NUM_INTEGER, 
    NUM_OCTAL, 
    NUM_HEXA, 
    STRING, 
    CHARACTER
}tokenCategory; 

void printToken(char* string, tokenCategory category, int* isFirstTokenPrinted);
void printError(int line, int column, char* message, int* isFirstTokenPrinted);

int line = 1;
int column = 1;

int commentStartLine; 
int commentStartColumn;

#define YY_USER_ACTION column += yyleng;

%}

%x N_LINE_COMMENT

%%

"void"                  {printToken("VOID", NO_LEXEME, &isFirstTokenPrinted);}
"int"                   {printToken("INT", NO_LEXEME, &isFirstTokenPrinted);}
"char"                  {printToken("CHAR", NO_LEXEME, &isFirstTokenPrinted);}
"return"                {printToken("RETURN", NO_LEXEME, &isFirstTokenPrinted);}
"switch"                {printToken("SWITCH", NO_LEXEME, &isFirstTokenPrinted);}
"case"                  {printToken("CASE", NO_LEXEME, &isFirstTokenPrinted);}
"default"               {printToken("DEFAULT", NO_LEXEME, &isFirstTokenPrinted);}
"do"                    {printToken("DO", NO_LEXEME, &isFirstTokenPrinted);}
"while"                 {printToken("WHILE", NO_LEXEME, &isFirstTokenPrinted);}
"for"                   {printToken("FOR", NO_LEXEME, &isFirstTokenPrinted);}
"if"                    {printToken("IF", NO_LEXEME, &isFirstTokenPrinted);}
"else"                  {printToken("ELSE", NO_LEXEME, &isFirstTokenPrinted);}
"typedef"               {printToken("TYPEDEF", NO_LEXEME, &isFirstTokenPrinted);}
"struct"                {printToken("STRUCT", NO_LEXEME, &isFirstTokenPrinted);}
[+]                     {printToken("PLUS", NO_LEXEME, &isFirstTokenPrinted);}
[-]                     {printToken("MINUS", NO_LEXEME, &isFirstTokenPrinted);}
[*]                     {printToken("MULTIPLY", NO_LEXEME, &isFirstTokenPrinted);}
[/]                     {printToken("DIV", NO_LEXEME, &isFirstTokenPrinted);}
[%]                     {printToken("REMAINDER", NO_LEXEME, &isFirstTokenPrinted);}
"++"                    {printToken("INC", NO_LEXEME, &isFirstTokenPrinted);}
"--"                    {printToken("DEC", NO_LEXEME, &isFirstTokenPrinted);}
[&]                     {printToken("BITWISE_AND", NO_LEXEME, &isFirstTokenPrinted);}
[|]                     {printToken("BITWISE_OR", NO_LEXEME, &isFirstTokenPrinted);}
[~]                     {printToken("BITWISE_NOT", NO_LEXEME, &isFirstTokenPrinted);}
[\^]                    {printToken("BITWISE_XOR", NO_LEXEME, &isFirstTokenPrinted);}
[!]                     {printToken("NOT", NO_LEXEME, &isFirstTokenPrinted);}
"&&"                    {printToken("LOGICAL_AND", NO_LEXEME, &isFirstTokenPrinted);}
"||"                    {printToken("LOGICAL_OR", NO_LEXEME, &isFirstTokenPrinted);}
"=="                    {printToken("EQUAL", NO_LEXEME, &isFirstTokenPrinted);}
"!="                    {printToken("NOT_EQUAL", NO_LEXEME, &isFirstTokenPrinted);}
[<]                     {printToken("LESS_THAN", NO_LEXEME, &isFirstTokenPrinted);}
[>]                     {printToken("GREATER_THAN", NO_LEXEME, &isFirstTokenPrinted);}
"<="                    {printToken("LESS_EQUAL", NO_LEXEME, &isFirstTokenPrinted);}
">="                    {printToken("GREATER_EQUAL", NO_LEXEME, &isFirstTokenPrinted);}
">>"                    {printToken("R_SHIFT", NO_LEXEME, &isFirstTokenPrinted);}
"<<"                    {printToken("L_SHIFT", NO_LEXEME, &isFirstTokenPrinted);}
[=]                     {printToken("ASSIGN", NO_LEXEME, &isFirstTokenPrinted);}
"+="                    {printToken("ADD_ASSIGN", NO_LEXEME, &isFirstTokenPrinted);}
"-="                    {printToken("MINUS_ASSIGN", NO_LEXEME, &isFirstTokenPrinted);}
[;]                     {printToken("SEMICOLON", NO_LEXEME, &isFirstTokenPrinted);}
[,]                     {printToken("COMMA", NO_LEXEME, &isFirstTokenPrinted);}
[:]                     {printToken("COLON", NO_LEXEME, &isFirstTokenPrinted);}
[(]                     {printToken("L_PAREN", NO_LEXEME, &isFirstTokenPrinted);}
[)]                     {printToken("R_PAREN", NO_LEXEME, &isFirstTokenPrinted);}
[{]                     {printToken("L_CURLY_BRACKET", NO_LEXEME, &isFirstTokenPrinted);}
[}]                     {printToken("R_CURLY_BRACKET", NO_LEXEME, &isFirstTokenPrinted);}
[[]                     {printToken("L_SQUARE_BRACKET", NO_LEXEME, &isFirstTokenPrinted);}
[]]                     {printToken("R_SQUARE_BRACKET", NO_LEXEME, &isFirstTokenPrinted);}
[?]                     {printToken("TERNARY_CONDITIONAL", NO_LEXEME, &isFirstTokenPrinted);}
[#]                     {printToken("NUMBER_SIGN", NO_LEXEME, &isFirstTokenPrinted);}
"->"                    {printToken("POINTER", NO_LEXEME, &isFirstTokenPrinted);}
"printf"                {printToken("PRINTF", NO_LEXEME, &isFirstTokenPrinted);}
"scanf"                 {printToken("SCANF", NO_LEXEME, &isFirstTokenPrinted);}
"define"                {printToken("DEFINE", NO_LEXEME, &isFirstTokenPrinted);}
"exit"                  {printToken("EXIT", NO_LEXEME, &isFirstTokenPrinted);}

[_a-zA-Z][_a-zA-Z0-9]*  {printToken(yytext, IDENTIFIER, &isFirstTokenPrinted);}
[0][1-7]+[0-7]*         {printToken(yytext, NUM_OCTAL, &isFirstTokenPrinted);}
[0][xX][0-9a-fA-F]+     {printToken(yytext, NUM_HEXA, &isFirstTokenPrinted);}
[0-9]+                  {printToken(yytext, NUM_INTEGER, &isFirstTokenPrinted);}

[ ]+                    {}
\/\/.*\n				{line++; column = 1;}
"/*"            		{BEGIN(N_LINE_COMMENT); commentStartLine = line; commentStartColumn = column-2;}
<N_LINE_COMMENT>[^*\n]+ {}
<N_LINE_COMMENT>\*[^/]  {}
<N_LINE_COMMENT>\n   	{line++; column = 1;}
<N_LINE_COMMENT><<EOF>> {printError(commentStartLine, commentStartColumn, "unterminated comment", &isFirstTokenPrinted); yyterminate();}
<N_LINE_COMMENT>"*/" 	{BEGIN(INITIAL);}

\"([^\\\"]|\\.)*\"      {
                        int len = strlen(yytext); 
						yytext[len-1] = '\0';
                        printToken(&yytext[1], STRING, &isFirstTokenPrinted);
                        }

[\n]                    {line++; column = 1;}

'\\[abfnrtv0\'\"\?\\]'  {
						yytext[3] = '\0';
                        printToken(&yytext[1], CHARACTER, &isFirstTokenPrinted);
                        }

'[ -~]'                 {
						yytext[2] = '\0';
                        printToken(&yytext[1], CHARACTER, &isFirstTokenPrinted);
                        }

.					    {printError(line, column-1, yytext, &isFirstTokenPrinted);}

%%

int main(int argc, char **argv)
{

	yylex();
	return 0;
}

void printToken(char* string, tokenCategory category, int* isFirstTokenPrinted){
    if(!*isFirstTokenPrinted)
        *isFirstTokenPrinted = 1;
    else
        printf("\n");

    switch(category){
        case NO_LEXEME: 
            printf("%s", string); 
            break;
        case IDENTIFIER:
            printf("IDENTIFIER(%s)", string);
            break;
        case NUM_INTEGER:
            printf("NUM_INTEGER(%s)", string);
            break;
        case NUM_OCTAL:
            printf("NUM_OCTAL(%s)", string);
            break;
        case NUM_HEXA:
            printf("NUM_HEXA(%s)", string);
            break;
        case STRING:            
            printf("STRING(%s)", string);
            break;
        case CHARACTER:
            printf("CHARACTER(%s)", string);
            break;
    }
}

void printError(int line, int column, char* message, int* isFirstTokenPrinted){
    if(!*isFirstTokenPrinted)
        *isFirstTokenPrinted = 1;
    else
        printf("\n");
    printf("error:lexical:%d:%d: %s", line, column, message);
}