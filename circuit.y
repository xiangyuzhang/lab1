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

struct EdgeNode   
{
	int vtxNO;
	int weight;
	EdgeNode *next;   
};

struct Gate_class					//here I declare the gate class
{
	int Gate_index;
	string Gate_name;
	string Gate_type;
	string Source_gate_name;
	string Fault;
	int Source_gate_index[2] = {-1,-1};
	EdgeNode *first;				
	bool visited;  
	int distance;  
	int path;  
	int indegree;   
}; 

Gate_class gates[12000];

struct Graph
{
	Gate_class *vertexList;//the size of this array is equal to vertexes, point to a address:start of vertex array    
	int vertexes;  //number of vertexes
	int edges;
};



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

	void BuildGraph(Graph *&graph, int n)
	{
		if (graph == NULL)
		{
			graph = new Graph;			//graph is a pointer, pointed for the start of the memory
			graph->vertexList = &gates[n];				//pointer:verterList points to the address:start of set of nodes
			graph->vertexes = n;			// number of vertexes is n
			graph->edges = 0;
			for (int i = 0; i < n; i++)
			{
				stringstream ss;
				//ss << gates[i].Gate_name;
				cout << gates[i].Gate_name << endl;
				graph->vertexList[i].Gate_name = gates[i].Gate_name;
				graph->vertexList[i].path = -1;
				graph->vertexList[i].visited = false;
				graph->vertexList[i].first = NULL;    //what is first??? 
				graph->vertexList[i].indegree = 0;
			}
		}
	}

	void PrintGraph(Graph *graph)
	{
		if (graph == NULL)
			return;
		cout << "Vertex: " << graph->vertexes << "\n";
		cout << "Edge: " << graph->edges << "\n";

		for (int i = 0; i < graph->vertexes; i++)
		{
			cout << i + 1 << ": " << graph->vertexList[i].Gate_name << "->";
			EdgeNode *p = graph->vertexList[i].first;
			while (p != NULL)
			{
				cout << graph->vertexList[p->vtxNO].Gate_name << "->";
				p = p->next;
			}
			cout << "\n";
		}
		cout << "\n";
	}

	void AddEdge(Graph *graph, int v1, int v2)   //here, the v1 and v2 is the index of a gate, rather a gate_index!!!
	{
		if (graph == NULL) return;
		if (v1 < 0 || v1 > graph->vertexes - 1) return;   //here it will consider whether the vertex is already existed, I need to change!!!
		if (v2 < 0 || v2 > graph->vertexes - 1) return;
		if (v1 == v2) return; //no loop is allowed  

		EdgeNode *p = graph->vertexList[v1].first;
		if (p == NULL)//is the first vertex's prvious is unknown
		{
			//can not be p = new EdgeNode;    
			graph->vertexList[v1].first = new EdgeNode;  
			graph->vertexList[v1].first->next = NULL;
			graph->vertexList[v1].first->vtxNO = v2;
			//graph->vertexList[v1].first->weight = weight;
			graph->edges++;
			graph->vertexList[v2].indegree++;
			return;
		}

		while (p->next != NULL)//move to the last node    
		{
			if (p->vtxNO == v2)//already exits. checking all nodes but the last one    
				return;

			p = p->next;
		}

		if (p->vtxNO == v2)//already exits. checking the first or the last node    
			return;

		EdgeNode *node = new EdgeNode;
		node->next = NULL;
		node->vtxNO = v2;
		//node->weight = weight;
		p->next = node;//last node's next is the new node    

		graph->edges++;
		graph->vertexList[v2].indegree++;
	}
	int main(void){

		yyparse();
		//cout << "this is the total number of gate: " << gate_counter<<endl;
		/*for(int j = 0; j<= gate_counter-1; j++)
		{
			cout<<gates[j].Gate_index << " " << gates[j].Gate_name << " " << gates[j].Gate_type << " " <<endl; 
		}*/
		Graph *graph = NULL;
		BuildGraph(graph, gate_counter);

		PrintGraph(graph);

		AddEdge(graph, 0, 1);
		AddEdge(graph, 0, 2);
		AddEdge(graph, 0, 3);
		AddEdge(graph, 1, 3);
		AddEdge(graph, 1, 4);
		AddEdge(graph, 2, 5);
		AddEdge(graph, 3, 2);
		AddEdge(graph, 3, 5);
		AddEdge(graph, 3, 6);
		AddEdge(graph, 4, 3);
		AddEdge(graph, 4, 6);
		AddEdge(graph, 6, 5);
		PrintGraph(graph);

		return 0;
	}