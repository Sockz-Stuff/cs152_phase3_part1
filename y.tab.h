/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_HH_INCLUDED
# define YY_YY_Y_TAB_HH_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ADD = 258,
    SUB = 259,
    MULT = 260,
    DIV = 261,
    MOD = 262,
    LT = 263,
    GT = 264,
    LTE = 265,
    GTE = 266,
    EQUIV = 267,
    NOTEQ = 268,
    SEMICOLON = 269,
    COLON = 270,
    COMMA = 271,
    L_PAREN = 272,
    R_PAREN = 273,
    L_SQUARE_BRACKET = 274,
    R_SQUARE_BRACKET = 275,
    ASSIGN = 276,
    INTEGER = 277,
    ARRAY = 278,
    OF = 279,
    IF = 280,
    THEN = 281,
    ENDIF = 282,
    ELSE = 283,
    WHILE = 284,
    DO = 285,
    CONTINUE = 286,
    FUNCTION = 287,
    BEGINLOOP = 288,
    ENDLOOP = 289,
    BEGINPARAMS = 290,
    ENDPARAMS = 291,
    BEGINLOCALS = 292,
    ENDLOCALS = 293,
    BEGINBODY = 294,
    ENDBODY = 295,
    READ = 296,
    WRITE = 297,
    OR = 298,
    AND = 299,
    TRUE = 300,
    FALSE = 301,
    RETURN = 302,
    BREAK = 303,
    NOT = 304,
    IDENTIFIER = 305,
    DIGITS = 306
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 7 "phase2_v2.yy" /* yacc.c:1909  */

int integerVal;
char* stringVal;

#line 111 "y.tab.hh" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_HH_INCLUDED  */
