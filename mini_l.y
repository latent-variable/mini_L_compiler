/*mini_l.y*/
%{
  #include <iostream>
  #include <stdio.h>
  #include <string>
  #include <string.h>
  using namespace std;


  void yyerror(const char *msg);
  int yylex(void);
  extern int currLine;
  extern int currPos;
  FILE *yy_in;
%}

%union{
    int   int_val;
    char* id_val;
}

%error-verbose
%start Program


%token FUNCTION
%token BEGIN_PARAMS
%token END_PARAMS
%token BEGIN_LOCALS
%token END_LOCALS
%token BEGIN_BODY
%token END_BODY
%token INTEGER
%token ARRAY
%token OF
%token IF
%token THEN
%token ENDIF
%token ELSE
%token WHILE
%token DO
%token BEGINLOOP
%token ENDLOOP
%token CONTINUE
%token READ
%token WRITE
%token AND
%token OR
%token NOT
%token TRUE
%token FALSE
%token RETURN

%token <int_val> NUMBER
%token <id_val> ID

%token SUB
%token ADD
%token MULT
%token DIV
%token MOD
%token EQ
%token NEQ
%token LT
%token GT
%token LTE
%token GTE

%token SEMICOLON
%token COLON
%token COMMA
%token L_PAREN
%token R_PAREN
%token L_SQUARE_BRACKET
%token R_SQUARE_BRACKET
%token ASSIGN

%%  //end of symbols specification

Program      :  Functions                                         {cout <<"Program -> Functions\n";}
             ;

Functions    :  function Functions                               {cout << "Funtions -> function -> Funtions\n ";}
             | /*  */                                             {cout << "Funtions -> Epsilon\n";}
             ;

function     :   FUNCTION ID SEMICOLON BEGIN_PARAMS Declarations END_PARAMS
                 BEGIN_LOCALS Declarations END_LOCALS
                 BEGIN_BODY Statements END_BODY                   {cout <<"function -> FUNCTION-> ID->"<<$2<<" SEMICOLON->BEGIN_PARAMS->Declarations->END_PARAMS->BEGIN_LOCALS -> Declarations->END_LOCALS->BEGIN_BODY -> Statements-> END_BODY\n";}
            ;

Declarations : Declaration SEMICOLON Declarations                {cout << "Declarations -> Declaration -> SEMICOLON -> Declarations->\n";}
             | /* */                                             {cout << "Declarations->Epsilon->\n";}
             ;

Declaration : Identifiers COLON INTEGER                           {cout << "Declaration -> Identifiers->COLON->INTEGER\n";}
            | Identifiers COLON ARRAY L_SQUARE_BRACKET
             NUMBER R_SQUARE_BRACKET OF INTEGER                 {cout << "Declaration -> Identifiers->COLON-> ARRAY_> L_SQUARE_BRACKET-> NUMBER->"<<$5<<"-> R_SQUARE_BRACKET -> OF->INTEGER\n";}
            ;
Identifiers : ID COMMA Identifiers                               {cout <<"Identifiers ->ID->"<<$1<<"-> COMMA -> Identifiers->\n";}
            | ID                                                 {cout <<"Identifiers ->ID->"<<$1<<"\n";}
            ;

Statement   : Vars ASSIGN Expressions                            {cout << "Statement-> VAR -> ASSIGN -> Expressions\n";}
            | IF Bool-exps THEN Statements ENDIF                 {cout <<"Statement->IF -> Bool-Exp->THEN->Statements-> ENDIF\n";}
            | IF Bool-exps THEN Statements ELSE Statements ENDIF {cout <<"Statement->IF -> Bool-Exp->THEN->Statements->ELSE ->Statements-> ENDIF\n";}
            | WHILE Bool-exps BEGINLOOP Statements ENDLOOP       {cout <<"Statement->WHILE Bool-Exp->BEGINLOOP->Statements->ENDLOOP\n";}
            | DO BEGINLOOP Statements ENDLOOP WHILE Bool-exps    {cout <<"Statement->DO->BEGINLOOP->Statements->ENDLOOP->WHILE->Bool-exp\n";}
            | READ Vars                                          {cout <<"Statement->READ->Vars\n";}
            | WRITE Vars                                         {cout <<"Statement->WRITE->Vars\n";}
            | CONTINUE                                           {cout <<"Statement->CONTINUE\n";}
            | RETURN Expressions                                 {cout <<"Statement->RETURN->Expressions\n";}
            ;

Statements  : Statement SEMICOLON Statements                     {cout <<"Statements->Statement->SEMICOLON->Statements\n";}
            | Statement SEMICOLON                                {cout <<"Statements->Epsilon\n";}
            ;

Bool-exps   : Relation-And-Exprs                                 {cout <<"Bool-exps -> Relation-And-Exprs\n";}
            | Relation-And-Exprs OR Bool-exps                    {cout <<"Bool-exps->Relation-And-Exprs-> OR->Bool-exps\n";}
            ;

Relation-And-Exprs  : Relation-Exprs                             {cout<<"Relation-And-Exprs\n";}
                    | Relation-Exprs AND Relation-And-Exprs      {cout<<"Relation-And-Exprs ->Relation-Exprs_>AND->Relation-And-Exprs\n";}
                    ;

Relation-Exprs  : Exprs                                          {cout<<"Relation-Exprs->Exprs\n";}
                | NOT Exprs                                      {cout<<"Relation-Exprs->NOT->Exprs\n";}
                ;

Exprs           : Expressions Comps Expressions                  {cout<<"Exprs->Expressions->Comps->Expressions\n";}
                | TRUE                                           {cout<<"Exprs->TRUE\n";}
                | FALSE                                          {cout<<"Exprs->FALSE\n";}
                | L_PAREN Bool-exps R_PAREN                      {cout<<"Exprs->L_PAREN-> Bool-exps->R_PAREN\n";}
                ;

Comps           : EQ                                             {cout<<"Comps->EQ\n";}
                | NEQ                                            {cout<<"Comps->NEQ\n";}
                | LT                                             {cout<<"Comps->LT\n";}
                | GT                                             {cout<<"Comps->GT\n";}
                | LTE                                            {cout<<"Comps->LTE\n";}
                | GTE                                            {cout<<"Comps->GTE\n";}
                ;

Expressions     : Multiplication-Exprs                           {cout<<"Expressions->Multiplication-Exprs\n";}
                | Multiplication-Exprs ADD  Expressions          {cout<<"Expressions->Multiplication-Exprs->ADD->Expressions\n";}
                | Multiplication-Exprs SUB  Expressions          {cout<<"Expressions->SUB->Expressions\n";}
                ;

Multiplication-Exprs : Terms                                     {cout<<"Multiplication-Exprs->Terms\n";}
                     | Terms MULT Terms                          {cout<<"Multiplication-Exprs->Terms->MULT->Terms\n";}
                     | Terms DIV Terms                           {cout<<"Multiplication-Exprs->Terms->DIV->Terms\n";}
                     | Terms MOD Terms                           {cout<<"Multiplication-Exprs->Terms->MOD->Terms\n";}
                     ;

Terms      : Term                                                {cout<<"Terms->Term\n";}
           | SUB Term                                          {cout<<"Terms->SUB->Term\n";}
           | ID L_PAREN List R_PAREN                            {cout<<"Terms->Identifier->L_PAREN->Lists->R_PAREN\n";}
           ;

List       : Expressions                                         {cout<<"List->Expressions\n";}
           | Expressions COMMA List                              {cout<<"List->Expressions->COMMA->List";}
           | /*   */                                             {cout<<"List->Epselon\n";}
           ;


Term       : Var                                                 {cout<<"Term->Var\n";}
           | NUMBER                                              {cout<<"Term->NUMBER->"<< $1 <<endl;}
           | L_PAREN Expressions R_PAREN                         {cout<<"Term->L_PAREN->Expressions->R_PAREN\n";}
           ;

Vars       : Var COMMA Vars                                     {cout<<"Vars->Var->COMMA->Vars\n";}
           | Var                                                {cout<<"Vars->Var\n";}
           ;

Var : ID                                                         {cout<<"Var->ID->"<<$1<<"\n";}
    | ID L_SQUARE_BRACKET Expressions R_SQUARE_BRACKET           {cout<<"ID->"<<$1<<"->L_SQUARE_BRACKET->Expressions->R_SQUARE_BRACKET\n";}
    ;

%%

int main(int argc, char **argv){
  if (argc > 1 ){
    yy_in = fopen(argv[1], "r");
    if (yy_in == NULL){
      cout<<"syntax: " << argv[0] <<endl;
    }
  }
  yyparse();  //calls yylex() for tokens.
  return 0;
}

void yyerror(const char *msg){
  cout << "** Line "<< currLine <<", position "<<currPos <<": "<< msg << endl;
}
