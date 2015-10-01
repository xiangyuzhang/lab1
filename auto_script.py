__author__ = 'xiangyuzhang'
from subprocess import call
import os



cmmd = "yacc -d return.y"
call(cmmd, shell=True)
cmmd = "bison -d return.y"
call(cmmd, shell=True)
cmmd = "flex co-token.l"
call(cmmd, shell=True)
cmmd = "g++ -g -o coop lex.yy.c return.tab.c"
call(cmmd, shell=True)

os.remove("return.tab.c")
os.remove("return.tab.h")
os.remove("lex.yy.c")
os.remove("y.tab.c")
os.remove("y.tab.h")

