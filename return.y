%{
#include <stdio.h>
#include <stdlib.h>	
#include <stdarg.h>
#include <string.h>
#include <iostream>
#include <climits>
#include <sstream>
#include <queue>
#include <vector>
#include <cctype>
#include <fstream>
extern "C" 
using namespace std;
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
	%token <string> FAN_INFO
	%token <string> SOURCE
	%token <string> SOURCE_GATENAME



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

			NUMBER GATENAME GATE FAN_INFO SA  SOURCE						{
																			printf("Clause: %d %s %s %s %s %s \n", $1, $2, $3, $4, $5, $6);
																			//printf("This is the gate!\n");
																			//printf("gateindex is: %d\n", $1);
																			//printf("gatename is : %s\n", $2);
																			//printf("gatetype is : %s\n", $3);
																			//printf("fan info is : %s\n", $4);
																			//printf("fault info is: %s\n", $5);	
																			//printf("source gate info is: %s\n", $6);	
																			
																			//gates[gate_counter].Gate_index = $1;
																			//gates[gate_counter].Gate_name = $2;
																			//gates[gate_counter].Gate_type = $3;
																			//gates[gate_counter].Fault = $5;
																			//gates[gate_counter].Source_gate_string = $6;
																		
																			//gate_counter++;	
																		}
												
			;																											
	input:
			NUMBER GATENAME INPT FAN_INFO SA							{
																			printf("Clause: %d %s %s %s %s\n", $1, $2, $3, $4, $5);
																			//printf("This is the input!\n");
																			//printf("gateindex is: %d\n", $1);
																			//printf("gatename is : %s\n", $2);
																			//printf("gatetype is : %s\n", $3);
																			//printf("fan info is : %s\n", $4);
																			//printf("fault info is: %s\n", $5);
																			//gates[gate_counter].Gate_index = $1;	
																			//gates[gate_counter].Gate_name = $2;
																			//gates[gate_counter].Gate_type = $3;
																			//gates[gate_counter].Fault = $5;
																			//gate_counter++;	
																		}
			;

	fan:
			NUMBER GATENAME FAN SOURCE_GATENAME SA									{
																			printf("Clause: %d %s %s %s\n", $1, $2, $3, $4);
																			//printf("This is the fan!\n");
																			//printf("gateindex is: %d\n", $1);
																			//printf("gatename is : %s\n", $2);
																			//printf("from is : %s\n", $3);
																			//printf("source gate is: %s\n", $4);	
																			//printf("fault info is: %s\n", $5);
																			//gates[gate_counter].Gate_index = $1;	
																			//gates[gate_counter].Gate_name = $2;
																			//gates[gate_counter].Gate_type = $3;
																			//gates[gate_counter].Source_gate_name = $4;
																			//gates[gate_counter].Fault = $5;
																			//gate_counter++;		
																		}
			;

	%%



	void yyerror(char *s)
	{
		fprintf(stdout, "%s\n", s);
	};
	int main(void){
		yyparse();
		return 0;
	}