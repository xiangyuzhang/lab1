%{
#include <string>
#include <iostream>
extern "C" 
void yyerror(char *);
//#include "y.tab.h"
//extern YYSTYPE yylval;
using namespace std;

int check;  
int fanouts;
int fanins;
string figure_type;
string net_name;
string GATE_ASCI;
string GATE_TYPE;
int Is_gate;;
string string_cmp_inpt = "inpt";
string string_cmp_from = "from";


%}

%start A B C D E F G H I
NUMBER  [0-9]+
GATENAME [0-9a-zA-Z]+
GATETYPE  [a-zA-Z]+
SPACE [ \t\n]+ 
%%



"*".*               {                       
                         //yylval.string = strdup(yytext);
                         
                         //return COMMENT;
                          BEGIN A;
                      }

<I>(">sa"[0-1])({SPACE}(">sa"[0-1]))?      {
                                      cout << yytext << " ";
                                      //yylval.string = strdup(yytext);
                                      //return SA;
                                      if((GATE_TYPE != "inpt") && (GATE_TYPE != "from"))
                                      {
                                        BEGIN H;
                                      }
                                      else
                                      {
                                        BEGIN A;
                                      }
                                          }

<D>{NUMBER}{SPACE}{NUMBER} {                                  //used to match the number of fan, but in string
                          //yylval.string = strdup(yytext);
                          GATE_ASCI = strdup(yytext);
                          cout  << GATE_ASCI << " "; 
                          BEGIN I;
                          //return FAN_INFO_INPT;
                        }
<H>.*               {
                                //yylval.string = strdup(yytext);
                                 cout  << yytext<<" ";
                                //return SOURCE;
                                BEGIN A;
                              }


<A>{NUMBER}           {                                          //used to match gate_index;
                           
                           net_name = strdup(yytext);       
                            //yylval.number = atoi(yytext);

                           cout << "\n"  << yytext << " ";
                           BEGIN B;
                           //return NUMBER;
 
                        }


<B>{GATENAME}             {                                      //  used to match 1gat, find 1gat
                              
                             GATE_ASCI = strdup(yytext);
                             cout  << GATE_ASCI << " ";
                             //yylval.string = strdup(yytext);
                             BEGIN C;
                             // return GATENAME;
                            }

<C>{GATETYPE}                    {
                             GATE_TYPE = strdup(yytext);
                             figure_type = strdup(yytext);
                             cout  << GATE_TYPE << " ";
                             
                             //yylval.string = strdup(yytext);
                             
                             if(yytext == string_cmp_from)
                             {
                              BEGIN E;
                              //return FAN;
                             }
                             else if(yytext == string_cmp_inpt)
                             {
                              BEGIN D;
                              //return INPT;
                             }
                             else 
                             {
                              //Is_gate = 1;
                              //cout << Is_gate;
                              BEGIN D;
                              //return GATE;
                             }
                            
                             }
                            
                         

<E>{GATENAME}             {
                             GATE_ASCI = strdup(yytext);
                             cout  << GATE_ASCI << " ";
                             //yylval.string = strdup(yytext);
                             BEGIN I;
                             // return GATENAME;

                            }





                    
[ \t\n]+            /*eat white space*/

%%

/*int find_gatetype(char *string_pass){
  char *string_cmp_inpt = "inpt";
  char *string_cmp_from = "from";
  if(strcmp(string_pass, string_cmp_inpt) == 0) {
   return 0;
  }
   else if(strcmp(string_pass, string_cmp_from) == 0)
   {
    return 1;
   }
  else
  {
    return 2;
  }
}*/



int main()
{

  yylex(); /* 进行Lex分析 */

  return 0;
}
int yywrap()
{
return 1;
}