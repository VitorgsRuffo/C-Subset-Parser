%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
extern int yylex();
extern char* yytext;
extern int line;
extern int column;
extern char* current_line;
void yyerror(char *s);

%}

/* declare tokens */
%token HASHTAG
%token DEFINE
%token IDENTIFIER
%token TIMES
%token L_CURLY_BRACKET
%token R_CURLY_BRACKET
%token L_SQUARE_BRACKET
%token R_SQUARE_BRACKET
%token ASSIGN
%token SEMICOLON
%token COMMA
%token L_PAREN
%token R_PAREN
%token INT
%token CHAR
%token VOID
%token DO
%token WHILE
%token IF
%token ELSE
%token FOR
%token PRINTF
%token STRING
%token SCANF
%token AMPERSAND
%token EXIT
%token RETURN
%token PLUS_ASSIGN
%token MINUS_ASSIGN
%token QUESTION
%token COLON
%token OR
%token AND
%token BITWISE_OR
%token BITWISE_XOR
%token EQUAL
%token NOT_EQUAL
%token LESS_THAN
%token LESS_EQUAL
%token GREATER_THAN
%token GREATER_EQUAL
%token L_SHIFT
%token R_SHIFT
%token MINUS
%token PLUS
%token DIV
%token MOD
%token INC
%token DEC
%token BITWISE_COMP
%token NOT
%token CHARACTER
%token NUM_INTEGER
%token NUM_HEXA
%token NUM_OCTAL
%token OTHER

%start Programa

%%

Programa: DecOuFunc DecOuFuncPrime {}
;

DecOuFunc: Declaracoes {} 
		 | Funcao 	   {}
;

DecOuFuncPrime: DecOuFunc DecOuFuncPrime {} 
		  | {} 
;


Declaracoes: HASHTAG DEFINE IDENTIFIER Expressao {}
		   | DeclaracaoVars {}
           | DeclaracaoProt {}
;

Funcao: Tipo VezesLoop IDENTIFIER Parametros L_CURLY_BRACKET FuncaoLoop Comandos R_CURLY_BRACKET {}
;

VezesLoop: TIMES VezesLoop {}
		 | {}
;

FuncaoLoop: DeclaracaoVars FuncaoLoop {} 
		  | {}
;

DeclaracaoVars: Tipo DeclaracaoVarsLoop SEMICOLON {}
;

DeclaracaoVarsLoop: VezesLoop IDENTIFIER ColcheteExpressaoLoop DeclaracaoVarsAtribuicao DeclaracaoVarsLoopPrime {}
;

ColcheteExpressaoLoop: L_SQUARE_BRACKET Expressao R_SQUARE_BRACKET ColcheteExpressaoLoop {} 
					 | {}
;

DeclaracaoVarsAtribuicao: ASSIGN ExpressaoAtribuicao {} 
						| {}
;

DeclaracaoVarsLoopPrime: COMMA DeclaracaoVarsLoop {}
				   | {}
;

DeclaracaoProt: Tipo VezesLoop IDENTIFIER Parametros SEMICOLON {}
;

Parametros: L_PAREN ParametrosOpLoop R_PAREN {}
;

ParametrosOpLoop: ParametrosLoop {} 
			    | {}
;

ParametrosLoop: Tipo VezesLoop IDENTIFIER ColcheteExpressaoLoop ParametrosLoopPrime {}
;

ParametrosLoopPrime: COMMA ParametrosLoop {}
			   | {}
;

Tipo: INT {} 
	| CHAR {} 
	| VOID {}
;

Bloco: L_CURLY_BRACKET Comandos R_CURLY_BRACKET {}
;

Comandos: ListaComandos ComandosPrime {}
;

ComandosPrime: ListaComandos ComandosPrime {} 
		 | {}
;

ListaComandos: DO Bloco WHILE L_PAREN Expressao R_PAREN SEMICOLON {}
			 | IF L_PAREN Expressao R_PAREN Bloco OpElse {}
			 | WHILE L_PAREN Expressao R_PAREN Bloco {}       
			 | FOR L_PAREN OpExpressao SEMICOLON OpExpressao SEMICOLON OpExpressao R_PAREN Bloco {} 
			 | PRINTF L_PAREN STRING OpVirgulaExpressao R_PAREN SEMICOLON {}
			 | SCANF L_PAREN STRING COMMA AMPERSAND IDENTIFIER R_PAREN SEMICOLON {}  
			 | EXIT L_PAREN Expressao R_PAREN SEMICOLON {} 
			 | RETURN OpExpressao SEMICOLON {} 
			 | Expressao SEMICOLON {}          
             | SEMICOLON {} 
			 | Bloco {}
;

OpElse: ELSE Bloco {} 
	  | {}
;

OpExpressao: Expressao {} 
		   | {}
;

OpVirgulaExpressao: COMMA Expressao {} 
				  | {}
;

Expressao: ExpressaoAtribuicao ExpressaoPrime {}
;

ExpressaoPrime: COMMA Expressao {} 
		  | {}
;

ExpressaoAtribuicao: ExpressaoCondicional {}
				   | ExpressaoUnaria AtribuicaoOperador ExpressaoAtribuicao {} 
;

AtribuicaoOperador: ASSIGN {} 
			      | PLUS_ASSIGN {} 
				  | MINUS_ASSIGN {}
;

ExpressaoCondicional: ExpressaoOrLogico ExpressaoCondicionalPrime {}
;

ExpressaoCondicionalPrime: QUESTION Expressao COLON ExpressaoCondicional {} 
					 | {} 
;

ExpressaoOrLogico: ExpressaoAndLogico ExpressaoOrLogicoPrime {}
;
ExpressaoOrLogicoPrime: OR ExpressaoOrLogico {}
				  | {}
;

ExpressaoAndLogico: ExpressaoOr ExpressaoAndLogicoPrime {}
;

ExpressaoAndLogicoPrime: AND ExpressaoAndLogico {} 
			       | {}
;

ExpressaoOr: ExpressaoXor ExpressaoOrPrime {}
;

ExpressaoOrPrime: BITWISE_OR ExpressaoOr 
			| {}
;

ExpressaoXor: ExpressaoAnd ExpressaoXorPrime {}
;

ExpressaoXorPrime: BITWISE_XOR ExpressaoXor {}
		     | {}
;

ExpressaoAnd: ExpressaoIgualdade ExpressaoAndPrime {}
;

ExpressaoAndPrime: AMPERSAND ExpressaoAnd {}
			 | {}
;



ExpressaoIgualdade: ExpressaoRelacional ExpressaoIgualdadePrime {}
;
ExpressaoIgualdadePrime: IgualdadeOperador ExpressaoIgualdade {}
			       | {}
;
IgualdadeOperador: EQUAL {} 
				 | NOT_EQUAL {}
;


ExpressaoRelacional: ExpressaoShift ExpressaoRelacionalPrime {}
;
ExpressaoRelacionalPrime: RelacionalOperador ExpressaoRelacional {} 
				    | {}
;
RelacionalOperador: LESS_THAN {}
				  | LESS_EQUAL {} 
				  | GREATER_THAN {} 
				  | GREATER_EQUAL {}
;


ExpressaoShift: ExpressaoAditiva ExpressaoShiftPrime {}
;
ExpressaoShiftPrime: ShiftOperador ExpressaoShift {}
			   | {}
;
ShiftOperador: L_SHIFT {} 
			 | R_SHIFT {}
;


ExpressaoAditiva: ExpressaoMultiplicativa ExpressaoAditivaPrime {}
;
ExpressaoAditivaPrime: AdicaoOperador ExpressaoAditiva {} 
				 | {}
;
AdicaoOperador: MINUS {}
			  | PLUS {}
;


ExpressaoMultiplicativa: ExpressaoCast ExpressaoMultiplicativaPrime {}
;
ExpressaoMultiplicativaPrime: MultOperador ExpressaoMultiplicativa {}
					    | {}
;
MultOperador: TIMES {}
			| DIV {} 
			| MOD {}
;


ExpressaoCast: ExpressaoUnaria {} 
			 | L_PAREN Tipo VezesLoop R_PAREN ExpressaoCast {}
;

ExpressaoUnaria: ExpressaoPosFixa {} 
			   | INC ExpressaoUnaria {} 
			   | DEC ExpressaoUnaria {} 
			   | UnarioOperador ExpressaoCast {}
;

UnarioOperador: AMPERSAND {} 
			  | TIMES {} 
			  | PLUS {} 
			  | MINUS {} 
			  | BITWISE_COMP {} 
			  | NOT {}
;

ExpressaoPosFixa: ExpressaoPrimaria {} 
			    | ExpressaoPosFixa ExpressaoPosFixaPrime {}
;

ExpressaoPosFixaPrime: L_SQUARE_BRACKET Expressao R_SQUARE_BRACKET {} 
			     | INC {}
				 | DEC {}
				 | L_PAREN OpExpressaoAtribuicaoLoop R_PAREN {}
;

OpExpressaoAtribuicaoLoop: ExpressaoAtribuicaoLoop {} 
					     | {}
;

ExpressaoAtribuicaoLoop: ExpressaoAtribuicao ExpressaoAtribuicaoLoopPrime {}
;

ExpressaoAtribuicaoLoopPrime: COMMA ExpressaoAtribuicaoLoop {}
					    | {}
;

ExpressaoPrimaria: IDENTIFIER {} 
				 | Numero {} 
				 | CHARACTER {} 
				 | STRING {} 
				 | L_PAREN Expressao R_PAREN {}
;

Numero: NUM_INTEGER {} 
	  | NUM_HEXA {} 
	  | NUM_OCTAL {}
;

%%

void yyerror(char *s){
	int columnError = column-((int)strlen(yytext));
	printf("error:syntax:%d:%d: %s\n", line, columnError, yytext);
	printf("%s", current_line);
	int i;
	for(i = 0; i < columnError-1; i++)
		printf(" ");
	printf("^");
	exit(0);
}

int main(int argc, char **argv){
    yyparse();
	printf("SUCCESSFUL COMPILATION.");
    return 0;
}