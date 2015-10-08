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

struct EdgeNode   
{
	int vtxNO;		//指向下一个点
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
	EdgeNode *first;		//指向下一个线	
	EdgeNode *second;
	EdgeNode *third;	
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
Gate_class next_gate_is[2];

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
																			//printf("enter program!!\n");
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
			graph->vertexList = &gates[n];				//pointer:vertexList points to the address:start of set of nodes
			graph->vertexes = n;			// number of vertexes is n
			graph->edges = 0;
			for (int i = 0; i < n; i++)
			{

				stringstream ss;
				//ss << gates[i].Gate_name;
				//cout << gates[i].Gate_name << endl;
				graph->vertexList[i].Gate_name = gates[i].Gate_name;
				graph->vertexList[i].Gate_type = gates[i].Gate_type;
				graph->vertexList[i].Gate_index = gates[i].Gate_index;
				graph->vertexList[i].Source_gate_name = gates[i].Source_gate_name;
				graph->vertexList[i].Fault = gates[i].Fault;
				graph->vertexList[i].Source_gate_index[0] = gates[i].Source_gate_index[0];
				graph->vertexList[i].Source_gate_index[1] = gates[i].Source_gate_index[1];
				graph->vertexList[i].path = -1;
				graph->vertexList[i].visited = false;
				graph->vertexList[i].first = NULL;    //what is first??? 
				graph->vertexList[i].second = NULL; 
				graph->vertexList[i].third = NULL; 
				graph->vertexList[i].indegree = 0;
			}
		}
	}

	void PrintGraph(Graph *graph)
	{
		if (graph == NULL)
			return;

		//考虑到一点多边，所以我的输出风格需要变化
		for(int i = 0; i <= gate_counter-1; i++)
		{
			EdgeNode *p1 = graph->vertexList[i].first;
			EdgeNode *p2 = graph->vertexList[i].second;
			EdgeNode *p3 = graph->vertexList[i].third;
			if (p1 != NULL)
			{
				cout << "gate index = " << gates[i].Gate_name << " , to " << graph->vertexList[p1->vtxNO].Gate_name << endl;
			}
			if (p2 != NULL)
			{
				cout << "gate index = " << gates[i].Gate_name << " , to " << graph->vertexList[p2->vtxNO].Gate_name << endl;
			}
			if (p3 != NULL)
			{
				cout << "gate index = " << gates[i].Gate_name << " , to " << graph->vertexList[p3->vtxNO].Gate_name << endl;
			}
		}

		/*这部分是原文
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
		*/
		cout << "\n";
	}

	void AddEdge(Graph *graph, int v1, int v2)   //here, the v1 and v2 is the index of a gate, rather a gate_index!!! v1是source
	{
		if (graph == NULL) return;
		//if (v1 < 0 || v1 > graph->vertexes - 1) return;   //here it will consider whether the vertex is already existed, I need to change!!!
		//if (v2 < 0 || v2 > graph->vertexes - 1) return;
		if (v1 == v2) return; //no loop is allowed  
		EdgeNode *p1 = graph->vertexList[v1].first;
		EdgeNode *p2 = graph->vertexList[v1].second;
		EdgeNode *p3 = graph->vertexList[v1].third;

		//貌似我们允许线的多次连接，所以我做了下面的修改
		if (p1 == NULL)//is the first vertex's prvious is unknown
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
		else if (p2 == NULL)
		{
			graph->vertexList[v1].second = new EdgeNode;  
			graph->vertexList[v1].second->next = NULL;
			graph->vertexList[v1].second->vtxNO = v2;
			//graph->vertexList[v1].first->weight = weight;
			graph->edges++;
			graph->vertexList[v2].indegree++;
			return;			
		}
		else if (p3 == NULL)
		{
			graph->vertexList[v1].third = new EdgeNode;  
			graph->vertexList[v1].third->next = NULL;
			graph->vertexList[v1].third->vtxNO = v2;
			//graph->vertexList[v1].first->weight = weight;
			graph->edges++;
			graph->vertexList[v2].indegree++;
			return;			
		}
		/*
		//下面的注释是原文
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
		*/
	}
	//这里是排序算法
		void Swap(Gate_class *array, int x, int y)
	{
	    Gate_class temp = array[x];
	    array[x] = array[y];
	    array[y] = temp;
	}
		void InsertSort(Gate_class *array, int size)
	{
	    for(int i = 1; i < size; i++)
	    {
	        for(int j = i; j > 0; j--)
	        {
	            if(array[j].Gate_index < array[j - 1].Gate_index)
	            {
	                Swap(array, j, j-1);
	            }
	        }
	    }
	}

	void BFS(Graph *graph)
	{
	if(graph == NULL)
		return;
	cout << "BFS\n";

	for (int i = 0; i < graph->vertexes; i++)  //double check all the gates are unvisited
		graph->vertexList[i].visited = false;

	
	queue<int> QVertex;

	for (int i = 0; i < graph->vertexes; i++)  //标记目前没有便利过的gate为visited，并且输出名字
	{
		//cout<<"get in for"<<endl;
		if (!graph->vertexList[i].visited)  
		{
			//cout<<"get in if"<<endl;
			QVertex.push(i);
			//cout<<"i am here" << graph->vertexList[i].Gate_type;
			cout << graph->vertexList[i].Gate_name << " " << graph->vertexList[i].Gate_type << " ";
			graph->vertexList[i].visited = true;
			//cout<<"this is the current size of queue:" << QVertex.size() << endl;
		}
		if(QVertex.size() >> 0)
		{
			//cout<<"get in while"<<endl;
			int vtxNO = QVertex.front();
			QVertex.pop();
			EdgeNode *p1 = graph->vertexList[vtxNO].first;  //找到放入元素出边
			EdgeNode *p2 = graph->vertexList[vtxNO].second;
			EdgeNode *p3 = graph->vertexList[vtxNO].third;
			//cout<<"this is the current size of queue:" << QVertex.size() << endl;
			
			if(p1 != NULL)
			{
				if (!graph->vertexList[p1->vtxNO].visited)
				{	
					//cout << graph->vertexList[i].Gate_name << " " << graph->vertexList[i].Gate_type << " ";
					cout << graph->vertexList[p1->vtxNO].Gate_index << " " << endl;
					graph->vertexList[p1->vtxNO].visited = true;
					QVertex.push(p1->vtxNO);
				}
				p1 = p1->next;
			}

			if(p2 != NULL)
			{
				if (!graph->vertexList[p2->vtxNO].visited)
				{
										
					cout << graph->vertexList[p2->vtxNO].Gate_index << " " << endl;

					graph->vertexList[p2->vtxNO].visited = true;
					QVertex.push(p2->vtxNO);
				}
				p2 = p2->next;
			}

			if(p3 != NULL)
			{
				if (!graph->vertexList[p3->vtxNO].visited)
				{
										
					cout << graph->vertexList[p3->vtxNO].Gate_index << " " << endl;

					graph->vertexList[p3->vtxNO].visited = true;
					QVertex.push(p3->vtxNO);
				}
				p3 = p3->next;
			}

			//cout<<"get out loop"<<endl;

		}
	}

	cout << "\n";
	}
	void Get_next_gate(Graph *graph, Gate_class gate)
	{
		int index = 0;
		if(gate.first != NULL)
		{
		 	next_gate_is[index] = graph->vertexList[gate.first->vtxNO];
			if(next_gate_is[index].Gate_type == "from")
			{
				next_gate_is[index] = graph->vertexList[next_gate_is[index].first->vtxNO];
				index++;
			}


		}

		if(gate.second != NULL)
		{
		 	next_gate_is[index] = graph->vertexList[gate.second->vtxNO];
			if(next_gate_is[index].Gate_type == "from")
			{
				next_gate_is[index] = graph->vertexList[next_gate_is[index].second->vtxNO];
				index++;
			}

		}

		if(gate.third != NULL)
		{
		 	next_gate_is[index] = graph->vertexList[gate.second->vtxNO];
			if(next_gate_is[index].Gate_type == "from")
			{
				next_gate_is[index] = graph->vertexList[next_gate_is[index].second->vtxNO];
				index++;
			}

		}

	}

	void Add_PO(Graph *graph)  //遍历整个图，寻找哪里需要加上新的PO  -------->没有完成好
	{
		cout<<"here";
		Gate_class temp1;
		cout<<"here";
		int start_index = 20001;
		cout<<"here";
		for(int x = 0; x <= graph->vertexes-1; x++)
		{
			cout<<"here";
			temp1 = graph->vertexList[x];
			cout<<"This is: " << temp1.Gate_name << " " << "to " << graph->vertexList[temp1.first->vtxNO].Gate_name;
			if(temp1.first== NULL)   //意思就是，这个gate没有出边
			{
				//现在需要在原来的gates【】里面加上新的node，然后重新生成图，之后加上边
				//加上新的gates
				cout << " Here" <<endl;
				gates[gate_counter].Gate_index = start_index;
				gates[gate_counter].Gate_type = "PO";
				gates[gate_counter].Gate_name = "PO";
				gate_counter++;
				//重新生成图
			}

		}
//		BuildGraph(graph, gate_counter);
//		//加上边
//		AddEdge(graph, i, start_index);
	}
	void Generate_result(Graph *graph, int size)
	{
		int temp1;
		string temp2;
		int  PO_index = 20001;
		ofstream out("out.txt");
		for(int i = 0; i<= graph->vertexes-1; i++)
		{
			if(graph->vertexList[i].Gate_type == "from")
			{
				continue;
			}
			else
			{
				//这里输出index
				out << graph->vertexList[i].Gate_index << " ";
				//这里输出种类
				if(graph->vertexList[i].Gate_type == "inpt")
				{
					out << "PI" << " ";
				}
				
				else if((graph->vertexList[i].Gate_type != "inpt")&&(graph->vertexList[i].Gate_type != "from"))
				{
					temp2 = graph->vertexList[i].Gate_type;
					if(temp2 == "nand")		out << "NAND" << " ";
					if(temp2 == "nor")		out << "NOR" << " ";
					if(temp2 == "or")		out << "OR" << " ";
					if(temp2 == "xor")		out << "XOR" << " ";	
					if(temp2 == "and")		out << "AND" << " ";				

				}
				
				//这里输出下一个gate的index
				if(graph->vertexList[i].third != NULL)
				{
				temp1 = graph->vertexList[i].third->vtxNO;    //need change
				//cout << graph->vertexList[temp1].Gate_index << " ";
				if(graph->vertexList[temp1].Gate_type == "from")
				{
					temp1 = graph->vertexList[temp1].first->vtxNO;
				}
				out << graph->vertexList[temp1].Gate_index << " ";
				}


				if(graph->vertexList[i].second != NULL)
				{
				temp1 = graph->vertexList[i].second->vtxNO;    //need change
				if(graph->vertexList[temp1].Gate_type == "from")
				{
					temp1 = graph->vertexList[temp1].first->vtxNO;
				}
				out << graph->vertexList[temp1].Gate_index << " ";
				//cout << graph->vertexList[temp1].Gate_index << " ";
				}


				if(graph->vertexList[i].first != NULL)
				{
				temp1 = graph->vertexList[i].first->vtxNO;    //need change
				if(graph->vertexList[temp1].Gate_type == "from")
				{
					temp1 = graph->vertexList[temp1].first->vtxNO;
				}			
				out << graph->vertexList[temp1].Gate_index << " ";
				//cout << graph->vertexList[temp1].Gate_index << " ";
				}

				if((graph->vertexList[i].first == NULL)&&(graph->vertexList[i].second == NULL)&&(graph->vertexList[i].third == NULL))
				{
					out << PO_index;
					PO_index++ ;
				}
			    out<<";"<<endl;
			}
		}

		for(int i = PO_index-1; i>= 20001; i--)
		{
			out << "PO" << " " << i << " ;" <<endl;
		}
	}

	void Fault_generation(Graph *graph, int size)
	{
		bool fault_list[2] = {-1, -1};
		int s;

	
		for(int i = 0; i<=size-1; i++)
		{
			cout<<graph->vertexList[i].Gate_index<<" "<<graph->vertexList[i].Fault;
			if(graph->vertexList[i].Fault.find("sa0") != std::string::npos)
			{
				//fault_list[0] = '0';
				//s = 0;
				cout<< "found sa0 ";
			}

			if(graph->vertexList[i].Fault.find("sa1") != std::string::npos)
			{
				//fault_list[1] = '1';
				//s = 1;
				cout << "found sa1";
			}
//			for(int j = 0; j<=s; j++)
//			{
//				cout<<" "<<fault_list[j];
//			}

			cout << endl;
		s = -1;
		}

	}
	int main(void){

		yyparse();
		cout <<"Data collect successfully!" <<endl;
		//cout << "this is the total number of gate: " << gate_counter<<endl;
		/*for(int j = 0; j<= gate_counter-1; j++)
		{
			cout<<gates[j].Gate_index << " " << gates[j].Gate_name << " " << gates[j].Gate_type << " " <<endl; 
		}*/
		Graph *graph = NULL;
		int start_index = 20001;
		InsertSort(gates, gate_counter);
		cout << "Data is cleaned up!" << endl;
		BuildGraph(graph, gate_counter);


		cout << "Graph is built!" << endl;
		cout << "after build graph" << endl;
		cout << "Vertex: " << graph->vertexes << "\n";
		cout << "Edge: " << graph->edges << "\n";
		//PrintGraph(graph);
		//now I need to carefully arrange edges


		for(int i = 0; i <= gate_counter-1; i++)
		{
			if(gates[i].Gate_type == "from")
			{	//cout << "find a fan with index: " << gates[i].Gate_index << endl;
				for(int j = 0; j <= gate_counter-1; j++)
				{
					if(gates[j].Gate_name == gates[i].Source_gate_name)
					{	//cout << "find its origin " << gates[j].Gate_index << endl;
						AddEdge(graph, j, i);
						//cout << "edge between: " << gates[j].Gate_name << " and " << gates[i].Gate_name << " Connected!" << endl; 
					}
				}

			}

			else if(gates[i].Gate_type != "inpt")  //现在找到了gate
			{
				//cout << "the gate is: " << gates[i].Gate_name << " with source index: " << gates[i].Source_gate_index[0] << " and " << gates[i].Source_gate_index[1] << endl;
				for (int j = 0; j <= gate_counter-1; j++)
				{
					if(gates[j].Gate_index == gates[i].Source_gate_index[0])
					{
						AddEdge(graph, j, i);
					}
					if(gates[j].Gate_index == gates[i].Source_gate_index[1])
					{
						AddEdge(graph, j, i);
					}
				}
			}
		}
		cout <<"Edgeds are added" << endl;

		cout<<"here";
		//Add_PO(graph);
		cout << "PO is added" <<endl;
		//cout<<"Here is the gates name, index and type:"<<endl;
		//for(int i = 0; i<=gate_counter-1; i++)
		//{
		//	cout<<graph->vertexList[i].Gate_name<<" ";
		//	cout<<graph->vertexList[i].Gate_index<<" ";
		//	cout<<graph->vertexList[i].Gate_type<<endl;
		//}
		cout << "Vertex: " << graph->vertexes << "\n";
		cout << "Edge: " << graph->edges << "\n";
		/*
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
		*/
		PrintGraph(graph);


		//BFS(graph);
		Generate_result(graph, gate_counter);
	//	Fault_generation(graph, gate_counter);
		return 0;
	}