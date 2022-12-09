%{
int yylex();
int yyerror(const char *s);
#include "header.h"

stringstream *everything;
void expression_code( CodeNode &DD,  CodeNode D2, CodeNode D3,string op);
string * new_temp();
string * new_label();
string  go_to(string *s);
string dec_label(string *s);
string dec_temp(string *s);
int count =0;
string gen_code(string *res, string op, string *val1, string *val2);
int tempi = 0;
int templ = 0;
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
%type <CodeNode> ident function declaration_loop declaration var2 dec_2 dec_3 statement statement_loop statement_else bool_expr Relation_Exp Relation_Exps comp expression expression_loop mult_expr term var var_loop

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
			  string tmp = *$2.place;
              *($$.code)  << "func " << *$2.place << "\n" << $5.code->str() << $8.code->str();
			  for(int i = 0; i < $5.vars->size(); ++i){
                    if((*$5.vars)[i].type == INT){
                        *($$.code) << "= " << *((*$5.vars)[i].place) << ", " << "$"<< to_string(i) << "\n";
                    }else{

                    }
                }
				*($$.code)<<$11.code->str();
				*($$.code)<<"endfunc\n";
             
            }
            ;

declaration_loop:  declaration SEMICOLON declaration_loop { 
					$$.code = $1.code;
                	$$.vars = $1.vars;
					for( int i = 0; i < $3.vars->size(); ++i){
						$$.vars->push_back((*$3.vars)[i]);
					}
                	*($$.code) << $3.code->str();
                	} 
    			|	{ 
					//cout<<"Entered dec epsilon\n";
						$$.code = new stringstream();
						$$.vars = new vector<Var>();
					}
    			;

declaration:	 IDENTIFIER dec_2 { 
					$$.code = $2.code;
                    $$.type = $2.type;
                    $$.length = $2.length;
                    $$.vars = $2.vars;
                    Var v = Var();
                    v.type = $2.type;
                    v.length = $2.length;
                    v.place = new string();
                    *v.place = $1;
                    $$.vars->push_back(v);
                    if($2.type == INT_ARR){
                        *($$.code) << ".[] " << $1 << ", " << $2.length << "\n";
                    }

                    else if($2.type == INT){
                        *($$.code) << ". " << $1 << "\n";
                       
                    }else{
                    }
					
                    
                }
				;
dec_2: 			COMMA IDENTIFIER dec_2{
					$$.code = $3.code;
					$$.type = $3.type;
					$$.length = $3.length;
					$$.vars = $3.vars;
					Var v = Var();
					v.type = $3.type;
					v.length = $3.length;
					v.place = new string();
					*v.place = $2;
					$$.vars->push_back(v);
					if($3.type == INT_ARR){
                        *($$.code) << ".[] " << $2 << ", " << $3.length << "\n";
                    }
                    else if($3.type == INT){
                        *($$.code) << ". " << $2 << "\n";
                    }else{
                        //printf("================ ERRRR\n");
                    }
				}
				| COLON dec_3 INTEGER{
					$$.code = $2.code;
					$$.type = $2.type;
                    $$.length = $2.length;
                    $$.vars = $2.vars;
				}
				;
dec_3:			ARRAY L_SQUARE_BRACKET DIGITS R_SQUARE_BRACKET OF {
					$$.code = new stringstream();
                    $$.vars = new vector<Var>();
                    $$.type = INT_ARR;
                    $$.length = $3;
				}
				|{
					$$.code = new stringstream();
                    $$.vars = new vector<Var>();
                    $$.type = INT;
                    $$.length = 0;
				}
				;

statement_loop: statement SEMICOLON statement_loop { 
					$$.code = $1.code;

				 }
				| 	/*statement_loop statement SEMICOLON*/ { 
					$$.code = new stringstream();
				 }
				;



statement:	  var ASSIGN expression {
				$$.code = $1.code;
				*($$.code) << $3.code->str();
				if($1.type == INT && $3.type == INT){
					*($$.code)<<"= "<< *$1.place<<", "<< *$3.place <<" \n";
				}
				else if($1.type == INT && $3.type == INT_ARR){
                    *($$.code) << gen_code($1.place, "=[]", $3.place, $3.index);
                }
                else if($1.type == INT_ARR && $3.type == INT && $1.value != NULL){
                    *($$.code) << gen_code($1.value, "[]=", $1.index, $3.place);
                }
                else if($1.type == INT_ARR && $3.type == INT_ARR){
                    string *tmp = new_temp();
                    *($$.code) << dec_temp(tmp) << gen_code(tmp, "=[]", $3.place, $3.index);
                    *($$.code) << gen_code($1.value, "[]=", $1.index, tmp);
                }
                else{
                        yyerror("Error: expression is null.");
				}			
 			}
		| IF bool_expr THEN statement_loop statement_else ENDIF {
			$$.code = new stringstream();
            $$.begin = new_label();
            $$.end = new_label();
            *($$.code) << $2.code->str() << "?:= " << *$$.begin << ", " <<  *$2.place << "\n";
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
                *($$.code) << ".< " << *$2.place << "\n"; 
            }
            else{
                *($$.code) << ".[]< " << *$2.place << ", " << $2.index << "\n"; 
            }
            *($$.code) << $2.code->str();
		 }
		| WRITE var_loop { 
			$$.code = $2.code;
            if($2.type == INT){
                *($$.code) << ".> " << *$2.place << "\n"; 
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
					$$.begin = new_label();
				}
				;
bool_expr:	  Relation_Exps { 
					$$.code = $1.code;
					*($$.code) << $1.code->str();
					if($1.op != NULL){
						$$.place = new_temp();
						*($$.code)  << dec_temp($$.place);
					}

 				}
        | bool_expr OR Relation_Exps {  }
        ;

Relation_Exps:	  		Relation_Exp { 
							$$.code = $1.code; 	//copy relation expression code over
							$$.place = $1.place;		// copy the temp name where it will jump
 						}
        			  | Relation_Exps AND Relation_Exp {  }
                      ;

Relation_Exp:	  expression comp expression {
						$$.code = $1.code;
						*($$.code) << $2.code->str();
                    	*($$.code) << $3.code->str();
                    	$$.place = new_temp();
                    	*($$.code)<< dec_temp($$.place) << gen_code($$.place, *$2.op, $1.place, $3.place);
  				   }
				  | NOT expression comp expression {  }
				  | TRUE {  }
				  | FALSE {  }
				  | L_PAREN bool_expr R_PAREN {  }
				  ;

comp:	  LT { 
			$$.code = new stringstream();
			$$.op = new string ();
			*$$.op = "<";
 		 }
		| GT { 
			$$.code = new stringstream();
			$$.op = new string ();
			*$$.op = ">";
		 }
		| LTE { 
			$$.code = new stringstream();
			$$.op = new string ();
			*$$.op = "<=";
		 }
		| GTE { 
			$$.code = new stringstream();
			$$.op = new string ();
			*$$.op = ">=";
		 }
		| NOTEQ { 
			$$.code = new stringstream();
			$$.op = new string ();
			*$$.op = "!=";
		 }
		| EQUIV { 
			$$.code = new stringstream();
			$$.op = new string ();
			*$$.op = "==";
		 }
		;

expression: mult_expr { 
			$$.code = $1.code;
			$$.place = $1.place;
			$$.op = $1.op;
			$$.type = INT;
 			}
        	| expression ADD mult_expr {
				
		
			$$.code = $3.code;
			*($$.code) << $3.code -> str();
			if($3.op == NULL){
				$$.place = $3.place;
				$$.op = new string();
				*$$.op = '+';
			}
			else{
				$$.place = new_temp();
				$$.op = new string();
				*$$.op = '+';
			}
			
			 

			 }
        	| expression SUB mult_expr {  }
        ;

expression_loop:    expression { 
						
				$$.code = $1.code;

 					}
    				| expression_loop COMMA expression { 
					
	
					$$.code = $3.code;
					$$.op = new string();
					$$.place = new_temp();
					*$$.op = ',';

					}
    				;

mult_expr:	  term  { 
					$$.code = $1.code;
					$$.place = $1.place;
 				}
        	  | mult_expr MULT term { }
			  | mult_expr DIV term {  }
			  | mult_expr MOD term {  }
        ;


term:	var { 
			$$.code = $1.code;
			$$.place = $1.place;
			$$.index = $1.index;
 		}
		| SUB var {  }
		| DIGITS {
			$$.code = new stringstream();
			$$.place = new string();
			*$$.place  = to_string($1);
				
		 }
		| SUB DIGITS {  }
		| L_PAREN expression R_PAREN { 
			$$.code = $2.code;
			$$.place = $2.place; 
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
				$$.place = new string();
				*$$.place = $1;
			}
			else{
			}
	 	  }


		 ;
var2:   {
			$$.code = new stringstream();
			$$.index = NULL;
			$$.place = NULL;
			$$.type = INT;
		}
		| L_SQUARE_BRACKET expression R_SQUARE_BRACKET{
			$$.code = $2.code;
			$$.place = NULL;
			$$.index = $2.place;
			$$.type = INT_ARR;
		}
		;
ident: IDENTIFIER{

            string tmp = $1;
            Var mf = Var();
            mf.type = FUNC;
            $$.place = new string();
            *$$.place = tmp;
		}
%%
void expression_code( CodeNode &DD, CodeNode D2, CodeNode D3, string op){
    DD.code = D2.code;
    *(DD.code) << D3.code->str();
    if(D3.op == NULL){
        DD.place = D2.place;
        DD.op = new string();
        *DD.op = op;
    }
    else{
        //cout << "IN ELSE" << endl;
        DD.place = new_temp();
        DD.op = new string();
        *DD.op = op;

        *(DD.code) << dec_temp(DD.place)<< gen_code(DD.place , *D3.op, D2.place, D3.place);
    } 
}
string go_to(string *s){
    return ":= "+ *s + "\n"; 
}
string dec_label(string *s){
    return ": " +*s + "\n"; 
}
string dec_temp(string *s){
    return ". " +*s + "\n"; 
}
string * new_temp(){
    string * t = new string();
    ostringstream conv;
    conv << tempi;
    *t = "_temp"+ conv.str();
    tempi++;
    return t;
}
string * new_label(){
    string * t = new string();
    ostringstream conv;
    conv << templ;
    *t = "_label"+ conv.str();
    templ++;
    return t;
}

string gen_code(string *res, string op, string *val1, string *val2){
    if(op == "!"){
        return op + " " + *res + ", " + *val1 + "\n";
    }
    else{
        return op + " " + *res + ", " + *val1 + ", "+ *val2 +"\n";
    }
}

int yyerror(const char *s)
{
    extern int row;
    extern int col;
    printf(">>> Line %d, position %d: %s\n",row,col,s);
    return -1;
}

int main(int argc, char ** argv) {

  yyparse();

  ofstream file;
  file.open("code.mil");
  file << everything->str();
  file.close();
}

