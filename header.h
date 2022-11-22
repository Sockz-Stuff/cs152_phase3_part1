/* heading.h */
#ifndef _heading_h_
#define _heading_h_

#define YY_NO_UNPUT

#include <iostream>

/*data structures*/

#include <sstream>
#include <fstream>
#include <vector>
#include <stack>
#include <stdio.h>
#include <string>
#include <map>

using namespace std;

enum Type {INT,INT_ARR,FUNC};

    struct Var{
        
        string *place;
        string *value;
        string *offset;
        //vector
        Type type;
        int length;
        string *index;
    } ;

    struct Loop{
        string *begin;
        string *parent;
        string *end;
    };


    struct CodeNode{
       stringstream *code;
       //location
       string *place;
       string *value;
       string *offset;
       // branches
       string *op;
       string *begin;
       string *parent;
       string *end;
       // type
       //uint val;
       Type type;
       int length;
       string *index;
       // idents and vars
       vector<string> *ids;
       vector<Var> *vars; 
    };


#endif
