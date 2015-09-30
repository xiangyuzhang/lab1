%{
#include <strings.h>
#include <stdlib.h>
void yyerror(char *);
//#include "y.tab.h"
//extern YYSTYPE yylval;
int check;  
int fanouts;
int fanins;
char *figure_type;
char *net_name;
char *GATE_ASCI;
%}

%start A B C D E F G
NUMBER  [0-9]+
GATENAME [0-9a-zA-Z]+
GATETYPE  [a-zA-Z]+
SPACE  [ \t\n]+


character [a-zA-Z]+  
%%

[ \t\n]+            /*eat white space*/

"*".*               {                       
                         //yylval.string = strdup(yytext);
                         //printf("I am here in comments \n");
                         //return COMMENT;
                      }



{NUMBER}            {                                          //used to match gate_index;
                           
                           net_name = strdup(yytext);       
                            //yylval.number = atoi(yytext);
                           printf("\n \n %s\t",net_name);
                           //return NUMBER;
 
                        }

{GATETYPE}                    {
                             GATE_ASCI = strdup(yytext);
                             figure_type = strdup(yytext);
                             printf("%s ", GATE_ASCI);
                             //yylval.string = strdup(yytext);
                             check = find_gatetype(figure_type);
                             if(check == 0)
                             {
                              //printf("will go to input");
                              //return INPT;
                             }
                             else if(check == 1)
                             {
                              //printf("will go to fan");
                              //return FAN;
                             }
                             else if(check == 2)
                             {
                              //printf("will go to gate");
                              //return GATE;
                             }
                            
                            }


{GATENAME}             {                                      //  used to match 1gat, find 1gat
                              
                             GATE_ASCI = strdup(yytext);
                             printf("%s\t", GATE_ASCI);
                             //yylval.string = strdup(yytext);
                              //return GATENAME;
                            }






(">sa"[0-1])({SPACE}(">sa"[0-1]))?      {
                                      printf("%s\n", yytext);
                                      //yylval.string = strdup(yytext);
                                          }


{NUMBER}{SPACE}{NUMBER} {                                  //used to match the number of fan, but in string
                          //yylval.string = strdup(yytext);
                          GATE_ASCI = strdup(yytext);
                          printf("%s ", GATE_ASCI); 
                          //return NUMBER_OF_FAN;

                        }

%%

int find_gatetype(char *string_pass){
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


