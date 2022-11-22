%{
#include "header.h"
int yylex();
void yyerror(const char *s);
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <sstream>
#include <fstream>
#include <iostream>
#include <queue>
#include <stack>
#include <vector>
#include <cstdlib>
using namespace std;
vector<string> functionTable;
vector<string> identTable;
vector<string> tempTable;
vector<string> labelTable;
vector<string> digitsTable;
bool flag = false;
int identIndex = 0;
int assignIndex =0;
int numTemps = 0;
int numLabels = 0;
string code; 
void addFunc(string name){
	functionTable.push_back(name);
}
string make_temp(){
	string ret = "_temp"+ to_string(numTemps);
	tempTable.push_back(ret);
	numTemps++;
	return ret;
}
string make_label(){
	string ret = "_label"+ to_string(numLabels);
	labelTable.push_back(ret);
	numLabels++;
	return ret;
}

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
//THIS IS A TEST TO SEE IF I CAN PUSH INTO THIS GITHUB
%token <stringVal> IDENTIFIER
%token <integerVal> DIGITS


%%
//func test; bp var:it; ep bl el bb var=24+1; eb
Program:    {  }
    		| Program function { 
				
			 }
    ;

function:   FUNCTION ident SEMICOLON BEGINPARAMS declaration_loop ENDPARAMS BEGINLOCALS declaration_loop ENDLOCALS BEGINBODY statement_loop ENDBODY
            { code +="endfunc\n"; }
            ;

declaration_loop: { }
    			  | declaration_loop declaration SEMICOLON {  }
    			  ;

declaration:	 IDENTIFIER COLON INTEGER { 
					identTable.push_back($1);
					code +=". " + identTable[identIndex]+"\n";
					identIndex++;
 				 }
				 | IDENTIFIER COLON ARRAY L_SQUARE_BRACKET DIGITS R_SQUARE_BRACKET OF INTEGER { }
				;

statement_loop: statement SEMICOLON {  }
				| statement_loop statement SEMICOLON {  }
				;



statement:	  var ASSIGN expression {
				if(flag){
					code += "= "+identTable[identTable.size()-1]+", "+"_temp"+to_string(numTemps-1)+"\n";
					flag = false;
				}
 			}
		| IF bool_expr THEN statement_loop ENDIF { }
		| IF bool_expr THEN statement_loop ELSE statement_loop ENDIF {  }
		| WHILE bool_expr BEGINLOOP statement_loop ENDLOOP {  }
		| DO BEGINLOOP statement_loop ENDLOOP WHILE bool_expr {  }
		| READ var_loop {  }
		| WRITE var_loop { code += ".> "+identTable[identTable.size()-1]+"\n"; }
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
        	| expression ADD mult_expr { code += "+ _temp"+to_string(numTemps-1)+", "+ identTable[0]+", "+identTable[1]+"\n"; flag=true; }
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
		| DIGITS {
			if(assignIndex<identTable.size()-1){
					code += "= "+identTable[assignIndex]+", "+to_string($1)+"\n";
					assignIndex++;
			}
			if(assignIndex >= identTable.size()-1){
					code += ". "+make_temp()+"\n";
				
			}
				
		 }
		| SUB DIGITS {  }
		| L_PAREN expression R_PAREN {  }
		| SUB L_PAREN expression R_PAREN {  }
		| IDENTIFIER L_PAREN expression_loop R_PAREN {  }
		;

var_loop:	  var {  }
			  | var_loop COMMA var {  }
			  ;		
		


var:	  IDENTIFIER { 
		  
	 }



		| IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET {  }
		;
ident: IDENTIFIER{
			string temp;
			functionTable.push_back($1);
			code +="func ";
			code += functionTable[0] + "\n";
		}
%%

int main(int argc, char ** argv) {

  yyparse();

  ofstream file;
  file.open("code.mil");
  file << code;
  file.close();
}
void yyerror(const char *s){

}
