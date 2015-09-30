%{
#include <stdio.h>
#include <stdlib.h>	
#include <stdarg.h>
#include <string.h>
void yyerror(char *);
%}

	%union YYSTYPE {
		char *string;
		int number;
	}
	%token <number> NUMBER 
	%token <string> GATENAME 
	%token <string> FROM 
	%token <string> SA
	%token <string> INPT
	%token <string> FAN
	%token <string> GATE
	%token <string> NUMBER_OF_FAN



	%{
		void yyerror(char *);
		int yylex(void);
	%}

	%%
	program:
			program	clause 												{
																			printf("enter program!!\n");
																			}
			|
			;

	clause:
			gate
			|input
			|fan
			;
	

	gate:
			NUMBER GATENAME GATE NUMBER_OF_FAN SA NUMBER NUMBER	{
																			printf("Clause: %d %s %s %s %s %d %d\n", $1, $2, $3, $4, $5, $6, $7);
																			printf("This is the gate!\n");
																			printf("gateindex is: %d\n", $1);
																			printf("gatename is : %s\n", $2);
																			printf("gatetype is : %s\n", $3);
																			printf("fan info is : %s\n", $4);
																			printf("fault info is: %s\n", $5);	
																			printf("source gate info is: %d\n", $6);	
																			printf("source gate info is: %d\n", $7);
																			}												
	input:
			NUMBER GATENAME INPT NUMBER_OF_FAN SA						{
																			printf("Clause: %d %s %s %s %s\n", $1, $2, $3, $4, $5);
																			printf("This is the input!\n");
																			printf("gateindex is: %d\n", $1);
																			printf("gatename is : %s\n", $2);
																			printf("gatetype is : %s\n", $3);
																			printf("fan info is : %s\n", $4);
																			printf("fault info is: %s\n", $5);		
																			}
			;

	fan:
			NUMBER GATENAME FAN GATENAME SA					{
																			printf("Clause: %d %s %s %s\n", $1, $2, $3, $4);
																			printf("This is the fan!\n");
																			printf("gateindex is: %d\n", $1);
																			printf("gatename is : %s\n", $2);
																			printf("source gate name is : %s\n", $3);
																			printf("fault info is: %s\n", $4);		
																			}
			;

	%%



	void yyerror(char *s)
	{
		fprintf(stdout, "%s\n", s);
	}

	int main(void){
		yyparse();
		return 0;
	}