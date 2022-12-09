%{
#define YY_NO_UNPUT

#include <iostream>
#include <vector>
#include <stack>
#include <map>
#include <sstream>
#include <fstream>
#include <stdio.h>
#include <string>

using namespace std;
enum Type {INT,INT_ARR,FUNC};

    struct Variable{
        string *name;
        string *value;
        Type type;
        int length;
        string *index;
    } ;

    struct CodeNode{
	   vector<Variable> *variable_vector; 
       stringstream *code;
       string *name;
       string *value;
       string *oper;
       string *begin;
       string *end;
       Type type;
       int length;
       string *index;
    };

int yylex();
int yyerror(const char *s);
stringstream *everything;
string * create_temp();

string * create_label();
string  go_to(string *s){
	return ":= "+ *s + "\n"; 
}
string dec_label(string *s){
	return ": " +*s + "\n"; 
}
string dec_temp(string *s){
	return ". " +*s + "\n"; 
}
int temp_count = 0;
int lable_count = 0;
%}

%union{
int integerVal;
char* stringVal;
struct {
    stringstream* code;
}start;
//from pp slides
struct CodeNode CodeNode;
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
%token IDENTIFIER DIGITS

%left L_PAREN R_PAREN
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left LT GT LTE GTE EQUIV NOTEQ
%left ADD SUB
%left MULT DIV MOD
%left OR
%left AND
%right NOT
%right ASSIGN

%type <stringVal> IDENTIFIER
%type <integerVal> DIGITS
%type <start> Program
%type <CodeNode> ident function declaration_loop declaration var2 declaration_comma declaration_arr statement statement_loop statement_else bool_expr Relation_Exp Relation_Exps comp expression expression_loop mult_expr term var var_loop

%%
//func test; bp var:it; ep bl el bb var=24; eb
Program:     function Program{ 
                //printf("entered program");
                $$.code = $1.code;
                *($$.code) << $2.code->str();
                everything = $$.code;
            }
    		|  { 
				$$.code = new stringstream();
			 }
    ;

function:   FUNCTION ident SEMICOLON BEGINPARAMS declaration_loop ENDPARAMS BEGINLOCALS declaration_loop ENDLOCALS BEGINBODY statement_loop ENDBODY
            { 
              $$.code = new stringstream();
			  string tmp = *$2.name;
              *($$.code)  << "func " << *$2.name << "\n" << $5.code->str() << $8.code->str();
			  for(int i = 0; i < $5.variable_vector->size(); ++i){
                    if((*$5.variable_vector)[i].type == INT){
                        *($$.code) << "= " << *((*$5.variable_vector)[i].name) << ", " << "$"<< to_string(i) << "\n";
                    }
                }
				*($$.code)<<$11.code->str();
				*($$.code)<<"endfunc\n";
             
            }
            ;

declaration_loop:  declaration SEMICOLON declaration_loop { 
					$$.code = $1.code;
                	$$.variable_vector = $1.variable_vector;
					for( int i = 0; i < $3.variable_vector->size(); ++i){
						$$.variable_vector->push_back((*$3.variable_vector)[i]);
					}
                	*($$.code) << $3.code->str();
                	} 
    			|	{ 
						$$.code = new stringstream();
						$$.variable_vector = new vector<Variable>();
					}
    			;

declaration:	 IDENTIFIER declaration_comma { 
					$$.code = $2.code;
                    $$.type = $2.type;
                    $$.length = $2.length;
                    $$.variable_vector = $2.variable_vector;
                    Variable temp = Variable();
                    temp.type = $2.type;
                    temp.length = $2.length;
                    temp.name = new string();
                    *temp.name = $1;
                    $$.variable_vector->push_back(temp);
                    if($2.type == INT_ARR){
                        *($$.code) << ".[] " << $1 << ", " << $2.length << "\n";
                    }

                    else if($2.type == INT){
                        *($$.code) << ". " << $1 << "\n";
                       
                    }
                }
				;
declaration_comma: 	COMMA IDENTIFIER declaration_comma{
					$$.code = $3.code;
					$$.type = $3.type;
					$$.length = $3.length;
					$$.variable_vector = $3.variable_vector;
					Variable temp = Variable();
					temp.type = $3.type;
					temp.length = $3.length;
					temp.name = new string();
					*temp.name = $2;
					$$.variable_vector->push_back(temp);
					if($3.type == INT_ARR){
                        *($$.code) << ".[] " << $2 << ", " << $3.length << "\n";
                    }
                    else if($3.type == INT){
                        *($$.code) << ". " << $2 << "\n";
                    }
				}
				| COLON declaration_arr INTEGER{
					$$.code = $2.code;
					$$.type = $2.type;
                    $$.length = $2.length;
                    $$.variable_vector = $2.variable_vector;
				}
				;
declaration_arr:	ARRAY L_SQUARE_BRACKET DIGITS R_SQUARE_BRACKET OF {
					$$.code = new stringstream();
                    $$.variable_vector = new vector<Variable>();
                    $$.type = INT_ARR;
                    $$.length = $3;
				}
				|{
					$$.code = new stringstream();
                    $$.variable_vector = new vector<Variable>();
                    $$.type = INT;
                    $$.length = 0;
				}
				;

statement_loop: statement SEMICOLON statement_loop { 
					$$.code = $1.code;
					*($$.code) << $3.code->str();

				 }
				| 	/*statement_loop statement SEMICOLON*/ { 
					$$.code = new stringstream();
				 }
				;



statement:	  var ASSIGN expression {
				$$.code = $1.code;
				*($$.code) << $3.code->str();
				if($1.type == INT && $3.type == INT){
					*($$.code)<<"= "<< *$1.name<<", "<< *$3.name <<" \n";
				}
				else if($1.type == INT && $3.type == INT_ARR){
                    *($$.code) << "=[]" << " "<< *$1.name << ", "<< *$3.name << ", "<< *$3.index << "\n";
                }
                else if($1.type == INT_ARR && $3.type == INT && $1.value != NULL){
                    *($$.code) << "[]=" << " "<< *$1.name << ", "<< *$1.index << ", "<< *$3.name << "\n";
                }
                else if($1.type == INT_ARR && $3.type == INT_ARR){
                    string *tmp = create_temp();
                    *($$.code) << dec_temp(tmp) << "=[]" << " "<< tmp << ", "<< *$3.name << ", "<< *$3.index << "\n";
                    *($$.code) << "[]=" << " "<< *$1.value << "," << *$1.index << ", "<< tmp << "\n";
                }		
 			}
		| IF bool_expr THEN statement_loop statement_else ENDIF {
			$$.code = new stringstream();
            $$.begin = create_label();
            $$.end = create_label();
            *($$.code) << $2.code->str() << "?:= " << *$$.begin << ", " <<  *$2.name << "\n";
            if($5.begin != NULL){                       
                *($$.code) << go_to($5.begin); 
                *($$.code) << dec_label($$.begin)  << $4.code->str() << go_to($$.end);
                *($$.code) << dec_label($5.begin) << $5.code->str();
            }
			else{
                *($$.code) << go_to($$.end)<< dec_label($$.begin)  << $4.code->str();
            }
            *($$.code) << dec_label($$.end);
		 }	
		| WHILE bool_expr BEGINLOOP statement_loop ENDLOOP {  }
		| DO BEGINLOOP statement_loop ENDLOOP WHILE bool_expr {  }
		| READ var_loop { 
			$$.code = $2.code;
            if($2.type == INT){
                *($$.code) << ".< " << *$2.name << "\n"; 
            }
            else{
                *($$.code) << ".[]< " << *$2.name << ", " << $2.index << "\n"; 
            }
            *($$.code) << $2.code->str();
		 }
		| WRITE var_loop { 
			$$.code = $2.code;
            if($2.type == INT){
                *($$.code) << ".> " << *$2.name << "\n"; 
            }
            else{
                *($$.code) << ".[]> " << *$2.value << ", " << *$2.index << "\n"; 
            }
            *($$.code) << $2.code->str();
		 }
		| CONTINUE {  }
		| RETURN expression {  }
		;
statement_else: {
					$$.code = new stringstream();
					$$.begin = NULL;

				}
				| ELSE statement_loop{
					$$.code = $2.code;
					$$.begin = create_label();
				}
				;
bool_expr:	  Relation_Exps { 
					$$.code = $1.code;
					*($$.code) << $1.code->str();
					if($1.oper != NULL){
						$$.name = create_temp();
						*($$.code)  << dec_temp($$.name);
					}

 				}
        | bool_expr OR Relation_Exps {  }
        ;

Relation_Exps:	  		Relation_Exp { 
							$$.code = $1.code; 	
							$$.name = $1.name;		
 						}
        			  | Relation_Exps AND Relation_Exp {  }
                      ;

Relation_Exp:	  expression comp expression {
						$$.code = $1.code;
						*($$.code) << $2.code->str();
                    	*($$.code) << $3.code->str();
                    	$$.name = create_temp();
                    	*($$.code)<< dec_temp($$.name) << *$2.oper << " " << *$$.name << ", "<< *$1.name << ", "<< *$3.name << "\n";
  				   }
				  | NOT expression comp expression {  }
				  | TRUE {  }
				  | FALSE {  }
				  | L_PAREN bool_expr R_PAREN {  }
				  ;

comp:	  LT { 
			$$.code = new stringstream();
			$$.oper = new string ();
			*$$.oper = "<";
 		 }
		| GT { 
			$$.code = new stringstream();
			$$.oper = new string ();
			*$$.oper = ">";
		 }
		| LTE { 
			$$.code = new stringstream();
			$$.oper = new string ();
			*$$.oper = "<=";
		 }
		| GTE { 
			$$.code = new stringstream();
			$$.oper = new string ();
			*$$.oper = ">=";
		 }
		| NOTEQ { 
			$$.code = new stringstream();
			$$.oper = new string ();
			*$$.oper = "!=";
		 }
		| EQUIV { 
			$$.code = new stringstream();
			$$.oper = new string ();
			*$$.oper = "==";
		 }
		;

expression: mult_expr { 
			$$.code = $1.code;
			$$.name = $1.name;
			$$.oper = $1.oper;
			$$.type = INT;
 			}
        	| expression ADD mult_expr {
				
		
			$$.code = $3.code;
			*($$.code) << $3.code -> str();
			if($3.oper == NULL){
				$$.name = $3.name;
				$$.oper = new string();
				*$$.oper = '+';
			}
			else{
				$$.name = create_temp();
				$$.oper = new string();
				*$$.oper = '+';
			}
			
			 

			 }
        	| expression SUB mult_expr { 
			$$.code = $3.code;
			*($$.code) << $3.code -> str();
			if($3.oper == NULL){
				$$.name = $3.name;
				$$.oper = new string();
				*$$.oper = '-';
			}
			else{
				$$.name = create_temp();
				$$.oper = new string();
				*$$.oper = '-';
			}
			  }
        ;

expression_loop:    expression { 
						$$.code = $1.code;
 					}
    				| expression_loop COMMA expression { 
						$$.code = $3.code;
						$$.oper = new string();
						$$.name = create_temp();
						*$$.oper = ',';
					}
    				;

mult_expr:	  term  { 
					$$.code = $1.code;
					$$.name = $1.name;
 				}
        	  | mult_expr MULT term {}
			  | mult_expr DIV term {}
			  | mult_expr MOD term {}
        ;


term:	var { 
			$$.code = $1.code;
			$$.name = $1.name;
			$$.index = $1.index;
 		}
		| SUB var {}
		| DIGITS {
			$$.code = new stringstream();
			$$.name = new string();
			*$$.name  = to_string($1);
				
		 }
		| SUB DIGITS {  }
		| L_PAREN expression R_PAREN { 
			$$.code = $2.code;
			$$.name = $2.name; 
		}
		| SUB L_PAREN expression R_PAREN {  }
		| IDENTIFIER L_PAREN expression_loop R_PAREN {  }
		;

var_loop:	  var { }
			  | var_loop COMMA var {  }
			  ;		
		


var:	  IDENTIFIER var2 { 
			$$.code = $2.code;
			$$.type = $2.type;
			string tmp = $1;
			if($2.index == NULL){
				$$.name = new string();
				*$$.name = $1;
			}
	 	  }


		 ;
var2:   {
			$$.code = new stringstream();
			$$.index = NULL;
			$$.name = NULL;
			$$.type = INT;
		}
		| L_SQUARE_BRACKET expression R_SQUARE_BRACKET{
			$$.code = $2.code;
			$$.name = NULL;
			$$.index = $2.name;
			$$.type = INT_ARR;
		}
		;
ident: IDENTIFIER{

            string tmp = $1;
            Variable temp = Variable();
            temp.type = FUNC;
            $$.name = new string();
            *$$.name = tmp;
		}
%%
string * create_temp(){
	string * t = new string();
    *t = "_label"+ temp_count;
    temp_count++;
    return t;
}
string * create_label(){
	string * t = new string();
    *t = "_label"+ lable_count;
    lable_count++;
    return t;
}


int yyerror(const char *s)
{
    extern int row;
    extern int col;
    printf(" Line %d, position %d: %s\n",row,col,s);
    return -1;
}

int main(int argc, char ** argv) {

  yyparse();

  ofstream file;
  file.open("code.mil");
  file << everything->str();
  file.close();
}
