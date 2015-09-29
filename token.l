%{
#include <strings.h>
extern YYSTYPE yylval;
#include <stdlib.h>
void yyerror(char *);
#include "y.tab.h"
int check;  
int fanouts;
int fanins;
char *figure_type;
char *net_name;
char *GATE_ASCI;
%}

%start A
NUMBER  [0-9]+
GATENAME [0-9a-zA-Z]+
GATETYPE  [a-zA-Z]+
SPACE  [ \t\n]+


character [a-zA-Z]+  
%%

[ \t\n]+            /*eat white space*/

"*".*\n               {
                         
                         yylval.string = strdup(yytext);
                         /*printf("I am here in comments \n");*/
                         BEGIN A;
                         //return COMMENT;
                      }



<A>{NUMBER}            {                                          //used to match gate_index;
                           
                           net_name = strdup(yytext);       
                            yylval.number = atoi(yytext);
                           printf("%s",net_name);
                           BEGIN B;
                           return NUMBER;
 
                        }


<B>([0-9]+)gat             {                                      //  used to match 1gat, find 1gat
                              
                               GATE_ASCI = strdup(yytext);
                             printf("%s", GATE_ASCI);
                             yylval.string = strdup(yytext);
                             BEGIN C;
                              return GATENAME;
                            }

<B>([0-9]+)fan             {                                        //  used to match 14fan
                              
                             GATE_ASCI = strdup(yytext);
                             printf("%s", GATE_ASCI);
                             yylval.string = strdup(yytext);
                             BEGIN D;
                            return FANNAME;
                            }

<C>"inpt"                    {
                             GATE_ASCI = strdup(yytext);
                             figure_type = strdup(yytext);
                             printf("%s", GATE_ASCI);
                             yylval.string = strdup(yytext);
                             BEGIN E;
                            return INPT;
                            }

<C>{GATETYPE}                 {
                              GATE_ASCI = strdup(yytext);
                              figure_type = strdup(yytext);
                             printf("%s", GATE_ASCI);
                             yylval.string = strdup(yytext);
                             BEGIN E;
                            return GATETYPE;
                            }

<D>{GATENAME}                 {
                             GATE_ASCI = strdup(yytext);
                             printf("%s", GATE_ASCI);
                             yylval.string = strdup(yytext);
                             BEGIN F;
                            return SOURCE_GATE_TYPE;
                            }


<F>(">sa"[0-1])+               {
                                      printf("%s", yytext);
                                      yylval.string = strdup(yytext);
                                      check = find_gatetype(figure_type);
                                      if(check == 1)
                                      {
                                        BEGIN A;
                                      }
                                      else if(check == 2)
                                      {
                                        BEGIN G;
                                      }
                                      else
                                      {
                                        BEGIN A;
                                      }
                                      return SA;

                                }
<E>{NUMBER}{SPACE}{NUMBER} {                                  //used to match the number of fan, but in string
                          yylval.string = strdup(yytext);
                          BEGIN F;
                          return NUMBER_OF_FAN;

                        }

<G>{NUMBER}{SPACE}{NUMBER} {                                  //used to find the source, but in string
                          yylval.string = strdup(yytext);
                          BEGIN A;
                          return SOURCE_OF_GATE;

                        }
%%

int find_gatetype(char *string_pass){
  char *string_cmp = "from";

  if(strcmp(string_pass, "inpt") == 0) {
   /* printf("I am here  in FROM FUNCTION \n"); */
   return 0;
  }
   else if(strcmp(string_pass, "from") == 0)
   {
    return 1;
   }
  else
  {
    return 2;
  }
}


int main(int argc, char *argv[]){
//int argc;
//char **argv;

         if (argc > 1) {
                FILE *file;
                file = fopen(argv[1], "r");
                if (!file) {
                        fprintf(stderr,"could not open %s\n",argv[1]);
                } else {

                 printf("reading\n");
                 yyin = file;
                }   
                 yylex();     
              
              /*  fclose(file);*/
      }

 }


int yywrap(void)
{
  return 1;
}


