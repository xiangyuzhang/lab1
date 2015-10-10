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

struct Gate_class					//here I declare the gate class
{
	int Gate_index;
	string Gate_name;
	string Gate_type;
	string Source_gate_name;
	int Fault_list[2] = {-1,-1};
	int Source_gate_index[20] = {-1,-1,-1,-1,-1,  -1,-1,-1,-1,-1,  -1,-1,-1,-1,-1,  -1,-1,-1,-1,-1};	
	bool visited;  
	int distance;  
	int path;  
	int indegree;   
	int Fan_out_number = 0;
	int Fan_in_number = 0;
}; 
int gate_counter = -1;
Gate_class gates[12000];
int tempupdater = 0;
%}

%union {
int val;
char *name;
}
%token <name> NETNAME
%token <val> FANINNET 
%token <name> GATETYPE 
%token <val> NETNO 
%token <val> FANOUT
%token <val> FANIN 
%token <val> FAULT
%token <name> FROMNAME



	%{
		void yyerror(char *);
		int yylex(void);
	%}

	%%
	netlist:
	| netlist line_item
	;
	line_item:   netname | faninnet | gatetype | netno | fanout | fanin | fault | fromname 
	 	;
	netname: NETNAME 					{gates[gate_counter].Gate_name = $1;}	
	faninnet: FANINNET 					{gates[gate_counter].Source_gate_index[tempupdater] = $1;
											tempupdater++;}
	gatetype: GATETYPE 					{gates[gate_counter].Gate_type = $1;}
	netno: NETNO 						{
											gate_counter++;
											gates[gate_counter].Gate_index = $1;
											tempupdater =0;
										}	
	fanout: FANOUT 						{gates[gate_counter].Fan_out_number = $1;}
	fanin: FANIN 						{gates[gate_counter].Fan_in_number = $1;}
	fault: FAULT 						{
										 if ($1 == 0){gates[gate_counter].Fault_list[0] = 1;}
										 if ($1 == 1){gates[gate_counter].Fault_list[1] = 1;}
										 }
	fromname : FROMNAME 				{gates[gate_counter].Source_gate_name = $1;}

	%%



	void yyerror(char *s)
	{
		fprintf(stdout, "%s\n", s);
	};
	int main(void){
		yyparse();
		for(int i = 0; i<=gate_counter; i++)
		{
			cout << gates[i].Gate_index << " " << gates[i].Gate_name << " " << gates[i].Gate_type << " ";
			if(gates[i].Gate_type == "from")
			{
				cout << gates[i].Source_gate_name << " " ;
					if(gates[i].Fault_list[0] == 1)
					{
						cout << ">SA0" << " ";
					}
					if(gates[i].Fault_list[1] == 1)
					{
						cout << ">SA1" << " ";
					}
					cout << endl;
			}

			else if(gates[i].Gate_type == "inpt")
			{
				cout << gates[i].Fan_out_number << " " << gates[i].Fan_in_number << " ";
				if(gates[i].Fault_list[0] == 1)
				{
					cout << ">SA0" << " ";
				}
				if(gates[i].Fault_list[1] == 1)
				{
					cout << ">SA1" << " ";
				}
				cout << endl;
			}
			else
			{
				cout << gates[i].Fan_out_number << " " << gates[i].Fan_in_number << " ";
				if(gates[i].Fault_list[0] == 1)
				{
					cout << ">SA0" << " ";
				}
				if(gates[i].Fault_list[1] == 1)
				{
					cout << ">SA1" << " ";
				}	
				cout << endl;
				for(int j = 0; j <= gates[i].Fan_in_number-1; j++)
				{
					cout << gates[i].Source_gate_index[j] << " ";
				}
				
				cout << endl;
			}
		}
		return 0;

	}