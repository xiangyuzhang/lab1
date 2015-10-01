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
extern "C" 
using namespace std;
void yyerror(char *);

struct Gate_class					//here I declare the gate class
{
	int Gate_index;
	string Gate_name;
	string Gate_type;
	string Source_gate_name;
	string Fault;
	int Source_gate_index[2] = {-1,-1};

}; 
vector <Gate_class> gates(12000);

int gate_counter = 0;
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
			NUMBER GATENAME GATE NUMBER_OF_FAN SA NUMBER NUMBER			{
																			//printf("Clause: %d %s %s %s %s %d %d\n", $1, $2, $3, $4, $5, $6, $7);
																			//printf("This is the gate!\n");
																			//printf("gateindex is: %d\n", $1);
																			//printf("gatename is : %s\n", $2);
																			//printf("gatetype is : %s\n", $3);
																			//printf("fan info is : %s\n", $4);
																			//printf("fault info is: %s\n", $5);	
																			//printf("source gate info is: %d\n", $6);	
																			//printf("source gate info is: %d\n", $7);
																			gates[gate_counter].Gate_index = $1;
																			gates[gate_counter].Gate_name = $2;
																			gates[gate_counter].Gate_type = $3;
																			gates[gate_counter].Fault = $5;
																			gates[gate_counter].Source_gate_index[0] = $6;
																			gates[gate_counter].Source_gate_index[1] = $7;
																			gate_counter++;
																			}	
			;																											
	input:
			NUMBER GATENAME INPT NUMBER_OF_FAN SA						{
																			//printf("Clause: %d %s %s %s %s\n", $1, $2, $3, $4, $5);
																			//printf("This is the input!\n");
																			//printf("gateindex is: %d\n", $1);
																			//printf("gatename is : %s\n", $2);
																			//printf("gatetype is : %s\n", $3);
																			//printf("fan info is : %s\n", $4);
																			//printf("fault info is: %s\n", $5);
																			gates[gate_counter].Gate_index = $1;	
																			gates[gate_counter].Gate_name = $2;
																			gates[gate_counter].Gate_type = $3;
																			gates[gate_counter].Fault = $5;
																			gate_counter++;	
																			}
			;

	fan:
			NUMBER GATENAME FAN GATENAME SA								{
																			//printf("Clause: %d %s %s %s\n", $1, $2, $3, $4);
																			//printf("This is the fan!\n");
																			//printf("gateindex is: %d\n", $1);
																			//printf("gatename is : %s\n", $2);
																			//printf("from is : %s\n", $3);
																			//printf("source gate is: %s\n", $4);	
																			//printf("fault info is: %s\n", $5);
																			gates[gate_counter].Gate_index = $1;	
																			gates[gate_counter].Gate_name = $2;
																			gates[gate_counter].Gate_type = $3;
																			gates[gate_counter].Source_gate_name = $4;
																			gates[gate_counter].Fault = $5;
																			gate_counter++;		
																			}
			;

	%%



	void yyerror(char *s)
	{
		fprintf(stdout, "%s\n", s);
	};



	int main(void){

		yyparse();
		cout << "this is the total number of gate: " << gate_counter<<endl;
		for(int i; i<= gate_counter-1; i++)
		{
			cout<<gates[i].Gate_index << " " << gates[i].Gate_name << " " << gates[i].Gate_type << " " <<endl; 
		}
		return 0;
	}