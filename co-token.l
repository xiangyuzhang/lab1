%{
#include <string>
#include <iostream>
extern "C" 
void yyerror(char *);
#include "y.tab.h"
extern YYSTYPE yylval;
int check;  
int fanouts;
int fanins;
char *figure_type;
char *net_name;
char *GATE_ASCI;
int Is_gate;;
char *string_cmp_inpt = "inpt";
char *string_cmp_from = "from";

using namespace std;
%}

%start A B C D E F G
NUMBER  [0-9]+
GATENAME [0-9a-zA-Z]+
GATETYPE  [a-zA-Z]+
SPACE  [ \t\n]+


character [a-zA-Z]+  
%%

<H>[{SPACE}{NUMBER}]+       {
                                yylval.string = strdup(yytext);
                                BEGIN A;
                                return SOURCE;
                              }

[ \t\n]+            /*eat white space*/

"*".*               {                       
                         yylval.string = strdup(yytext);
                         //printf("I am here in comments \n");
                         //return COMMENT;

                      }



{NUMBER}           {                                          //used to match gate_index;
                           
                           net_name = strdup(yytext);       
                            yylval.number = atoi(yytext);
                           //printf("%s\t",net_name);
                           BEGIN B;
                           return NUMBER;
 
                        }

<C>{GATETYPE}                    {
                             GATE_ASCI = strdup(yytext);
                             figure_type = strdup(yytext);
                             //printf("gate type is: %s", GATE_ASCI);
                             //check = find_gatetype(yytext);
                             yylval.string = strdup(yytext);
                             //printf(" this is check: %d ", check);
                             if(strcmp(yytext, string_cmp_from) == 0)
                             {
                              BEGIN B;
                              return FAN;
                             }
                             else if(strcmp(yytext, string_cmp_inpt) == 0)
                             {
                              BEGIN D;
                              return INPT;
                             }
                             else 
                             {
                              Is_gate = 1;
                              BEGIN D;
                              return GATE;
                             }
                            
                             }
                            
                            

<B>{GATENAME}             {                                      //  used to match 1gat, find 1gat
                              
                             GATE_ASCI = strdup(yytext);
                             //printf("%s\t", GATE_ASCI);
                             yylval.string = strdup(yytext);
                             BEGIN C;
                              return GATENAME;
                            }






(">sa"[0-1])({SPACE}(">sa"[0-1]))?      {
                                      //printf("%s\n", yytext);
                                      yylval.string = strdup(yytext);
                                      return SA;
                                          }


<D>{NUMBER}{SPACE}{NUMBER} {                                  //used to match the number of fan, but in string
                          yylval.string = strdup(yytext);
                          GATE_ASCI = strdup(yytext);
                          //printf("%s ", GATE_ASCI); 
                          if(Is_gate == 1)
                          {
                            BEGIN H;
                          }
                          else
                          {
                            BEGIN A;                           
                          }
                          return NUMBER_OF_FAN;

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





int yywrap(void)
{
  return 1;
}


