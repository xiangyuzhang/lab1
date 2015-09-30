// circuit.y.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"


%{
#include <stdio.h>
#include <iostream>
#include <climits>
#inlcude <sstream>
#include <queue>
#include <vector>
#include <stdlib.h>	
#include <stdarg.h>
#include <string.h>
using namespace std
void yyerror(char *)

const bool UNDIGRAPH = 1
% }

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
% }

%%
program:
program	clause{
	printf("enter program!!\n");
}
|
;

clause:
gate
| input
| fan
;


gate:
NUMBER GATENAME GATE NUMBER_OF_FAN SA NUMBER NUMBER{
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
NUMBER GATENAME INPT NUMBER_OF_FAN SA{
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
NUMBER GATENAME FAN GATENAME SA{
	printf("Clause: %d %s %s %s\n", $1, $2, $3, $4);
printf("This is the fan!\n");
printf("gateindex is: %d\n", $1);
printf("gatename is : %s\n", $2);
printf("from is : %s\n", $3);
printf("source gate is: %s\n", $4);
printf("fault info is: %s\n", $5);
}
;

%%

class Gate
{
	int Gate_index;
	char *Gate_name;
	char *Source_gate;
	char *Dest_gate;
	char *Fault;
	vector<int> Source_index;
	vector<int> Dest_index;
}

struct Graph
{
	string *vertexLabel; //the number of the labels is equal to vertexes  
	Gate 
	int edges;
	int **AdjMat;
	bool *visited;  //only for DFS,BFS,Dijkstra  
	int *distance;   //only for Dijkstra  
	int *path;  //only for Dijkstra  
};

void BuildGraph(Graph *&graph, int n)
{
	if (graph == NULL)
	{
		graph = new Graph;
		graph->vertexes = n;
		graph->edges = 0;
		graph->AdjMat = new int *[n];
		graph->vertexLabel = new string[n];
		graph->visited = new bool[n];
		graph->distance = new int[n];
		graph->path = new int[n];
		for (int i = 0; i < graph->vertexes; i++)
		{
			stringstream ss;
			ss << "v" << i + 1;
			ss >> graph->vertexLabel[i];
			graph->visited[i] = false;
			graph->distance[i] = INT_MAX;
			graph->path[i] = -1;
			graph->AdjMat[i] = new int[n];

			if (UNDIGRAPH)
				memset(graph->AdjMat[i], 0, n * sizeof(int));
			else
				for (int j = 0; j < graph->vertexes; j++)
				{
					if (i == j)
						graph->AdjMat[i][j] = 0;
					else
						graph->AdjMat[i][j] = INT_MAX;
				}
		}
	}
}

void MakeEmpty(Graph *&graph)
{
	if (graph == NULL)
		return;

	delete[]graph->vertexLabel;
	delete[]graph->visited;
	delete[]graph->distance;
	delete[]graph->path;
	for (int i = 0; i < graph->vertexes; i++)
	{
		delete[]graph->AdjMat[i];
	}
	delete[]graph->AdjMat;
	delete graph;
}

void AddEdge(Graph *graph, int v1, int v2, int weight)
{
	if (graph == NULL) return;
	if (v1 < 0 || v1 > graph->vertexes - 1) return;
	if (v2 < 0 || v2 > graph->vertexes - 1) return;
	if (v1 == v2) return; //no loop is allowed  

	if (UNDIGRAPH)
	{
		if (graph->AdjMat[v1][v2] == 0)//not exist,edges plus 1    
			graph->edges++;
		graph->AdjMat[v1][v2] = graph->AdjMat[v2][v1] = weight;
	}

	else
	{
		if (graph->AdjMat[v1][v2] == 0 || graph->AdjMat[v1][v2] == INT_MAX)//not exist,edges plus 1  
			graph->edges++;
		graph->AdjMat[v1][v2] = weight;
	}
}

void RemoveEdge(Graph *graph, int v1, int v2)
{
	if (graph == NULL) return;
	if (v1 < 0 || v1 > graph->vertexes - 1) return;
	if (v2 < 0 || v2 > graph->vertexes - 1) return;
	if (v1 == v2) return; //no loop is allowed  

	if (UNDIGRAPH)
	{
		if (graph->AdjMat[v1][v2] == 0)//not exists,return    
			return;
		graph->AdjMat[v1][v2] = graph->AdjMat[v2][v1] = 0;
		graph->edges--;
	}

	else
	{
		if (graph->AdjMat[v1][v2] == 0 || graph->AdjMat[v1][v2] == INT_MAX)//not exists,return  
			return;
		graph->AdjMat[v1][v2] = INT_MAX;
		graph->edges--;
	}
}

void yyerror(char *s)
{
	fprintf(stdout, "%s\n", s);
}

int main(void) {
	yyparse();
	return 0;
}