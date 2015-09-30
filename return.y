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
	%token <string> GATETYPE
	%token <string> FANNAME 
	%token <string> FROM 
	%token <string> TYPE 
	%token <string> SA
	%token <string> INPT
	%token <string> NUMBER_OF_FAN
	%token <string> SOURCE_OF_GATE
	%token <string> SOURCE_GATE_TYPE

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
			input
			|gate
			|fan
			;
													
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
	gate:
			NUMBER GATENAME GATETYPE NUMBER_OF_FAN SA SOURCE_OF_GATE	{
																			printf("Clause: %d %s %s %s %s %s\n", $1, $2, $3, $4, $5, $6);
																			printf("This is the gate!\n");
																			printf("gateindex is: %d\n", $1);
																			printf("gatename is : %s\n", $2);
																			printf("gatetype is : %s\n", $3);
																			printf("fan info is : %s\n", $4);
																			printf("fault info is: %s\n", $5);	
																			printf("source gate info is: %s\n", $6);	
																			}
			;
	fan:
			NUMBER GATENAME SOURCE_GATE_TYPE SA						{
																			printf("Clause: %d %s %s %s\n", $1, $2, $3, $4);
																			printf("This is the fan!\n");
																			printf("gateindex is: %d\n", $1);
																			printf("gatename is : %s\n", $2);
																			printf("source gate type is : %s\n", $3);
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