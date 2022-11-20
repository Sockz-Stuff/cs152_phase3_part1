%{
int yylex();
void yyerror(const char *s);
#include <stdio.h>
#include <string>

//from slides
struct CodeNode {

	std::string code; //code associated with this node
	std::string name; //register for the node

};

%}

%union{
int integerVal;
char* stringVal;

}
%token ADD SUB MULT DIV MOD 
%token LT GT LTE GTE EQUIV NOTEQ
%token SEMICOLON COLON COMMA
%token L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET
%token ASSIGN
%token INTEGER ARRAY
%token OF IF THEN ENDIF ELSE WHILE DO CONTINUE
%token FUNCTION BEGINLOOP ENDLOOP BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY
%token READ WRITE
%token OR AND TRUE FALSE RETURN BREAK NOT

%left L_PAREN R_PAREN
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left LT GT LTE GTE EQUIV NOTEQ
%left ADD SUB
%left MULT DIV MOD
%left OR
%left AND
%right NOT
%right ASSIGN

%type<val> var  

%token <stringVal> IDENTIFIER
%token <integerVal> DIGITS


%%

Program:    {  }
    		| Program function {  }
    ;

function:   FUNCTION IDENTIFIER SEMICOLON BEGINPARAMS declaration_loop ENDPARAMS BEGINLOCALS declaration_loop ENDLOCALS BEGINBODY statement_loop ENDBODY
            {  }
            ;

declaration_loop: { }
    			  | declaration_loop declaration SEMICOLON {  }
    			  ;

declaration:	 IDENTIFIER COLON INTEGER {  }
				 | IDENTIFIER COLON ARRAY L_SQUARE_BRACKET DIGITS R_SQUARE_BRACKET OF INTEGER { }
				;

statement_loop: statement SEMICOLON {  }
				| statement_loop statement SEMICOLON {  }
				;



statement:	  var ASSIGN expression { }
		| IF bool_expr THEN statement_loop ENDIF { }
		| IF bool_expr THEN statement_loop ELSE statement_loop ENDIF {  }
		| WHILE bool_expr BEGINLOOP statement_loop ENDLOOP {  }
		| DO BEGINLOOP statement_loop ENDLOOP WHILE bool_expr {  }
		| READ var_loop {  }
		| WRITE var_loop {  }
		| CONTINUE {  }
		| RETURN expression {  }
		;

bool_expr:	  Relation_Exps {  }
        | bool_expr OR Relation_Exps {  }
        ;

Relation_Exps:	  		Relation_Exp {  }
        			  | Relation_Exps AND Relation_Exp { ; }
                      ;

Relation_Exp:	  expression comp expression {  }
				  | NOT expression comp expression {  }
				  | TRUE {  }
				  | FALSE {  }
				  | L_PAREN bool_expr R_PAREN {  }
				  ;

comp:	  LT {  }
		| GT {  }
		| LTE {  }
		| GTE {  }
		| NOTEQ {  }
		| EQUIV {  }
		;

expression: mult_expr {  }
        	| expression ADD mult_expr {  }
        	| expression SUB mult_expr {  }
        ;

expression_loop:    expression {  }
    				| expression_loop COMMA expression { }
    				;

mult_expr:	  term  {  }
        	  | mult_expr MULT term {  }
			  | mult_expr DIV term {  }
			  | mult_expr MOD term { }
        ;


term:	var {  }
		| SUB var {  }
		| DIGITS {  }
		| SUB DIGITS {  }
		| L_PAREN expression R_PAREN {  }
		| SUB L_PAREN expression R_PAREN {  }
		| IDENTIFIER L_PAREN expression_loop R_PAREN {  }
		;

var_loop:	  var {  }
			  | var_loop COMMA var {  }
			  ;		
		


var:	  IDENTIFIER { 
		
		CodeNode *node = new CodeNode;
		node -> code = "";
		node -> name = $1;
		
		std::string error;
		if(!find(node -> name, it, error)){
			yyerror(error.c_str());
		}

		$$ = node;
	 }



		| IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET {  }
		;

%%

int main(int argc, char ** argv) {

  yyparse();
}
void yyerror(const char *s){

}
