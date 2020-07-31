import re
import argparse
import sys
from tokens import *


cin = None
out = None
err = None
vm = None

#global varibale index has current index of token to be checked
index = 0
tokens = None
#ignoring the start and end tokens <tokens> and </tokens>

oplist = ['+','-','*','/','&amp;','|','&lt;','&gt;','=']
unaryop = ['-','~']
keywordConst = ['true','false','null','this']

class_vars = []
class_var_count = 0
static_count = 0
sub_vars = []
args_count = 0
tot_count = 0
local_count = 0
curr_class = None
subName = None
subType = None
labelNum = 0

#function to check next symbol and print it if correct else error
def checksymbol(char,spaces):
    string = nexttoken()
    if(string[0]!='<symbol>' or string[1]!=char):
        error('symbol')
    else:
        printit(spaces)

#function to write in vm file
def outvm(string):
    vm.write(string+'\n')

#check if token is a type
def typename(str):
    if(str=='int' or str=='boolean' or str=='char' or isIdentifier(str)):
        return True
    return False

#write to error file 
def error(token):
    str = token
    if(token[0]!='<'):
        str = '<'+token+'>'

    if(str!=nexttoken()[0]):
        err.write("ERROR: Expected "+str+" but "+nexttoken()[1])
    else:
        str = nexttoken()
        err.write("ERROR: "+str[1])

    sys.exit(0)

#get the next token
def nexttoken():
    if(index>=len(tokens)):
        err.write("ERROR: Reaches EOF\n")
        sys.exit(0)
    token = tokens[index]
    token = token[:len(token)-1]
    token = list(filter(None,re.split(r"(\<.*?\>)",token)))
    return token

#print required number of spaces in xml file
def printspaces(spaces):
    for i in range(spaces):
        out.write(' ')

#print token in xml file and move to next token
def printit(spaces):
    global index
    printspaces(spaces)
    out.write(tokens[index])
    index+=1

def acc(string,integer):
    return string+'.'+str(integer)

#find entry in variable table
def gettype(string):
    temp = [var for var in sub_vars if var[0]==string]
    if(len(temp)>0):
        if(len(temp)>1):
            err.write("Repeated declaration: "+string+'\n')
            sys.exit(0)

        else:
            return temp
    
    temp = [var for var in class_vars if var[0]==string]
    if(len(temp)>0):
        if(len(temp)>1):
            err.write("Repeated declaration: "+string+'\n')
            sys.exit(0)

    return temp

#declaration error
def declerror(string):
    err.write("Declaration error: {} undeclared.".format(string[1]))
    sys.exit(0)

    
def compileterm(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    


    printspaces(spaces)
    out.write('<term>\n')
    spaces+=2

    string = nexttoken()

    #unaryop
    if(string[1] in unaryop):
        oper = string[1]
        printit(spaces)
        compileterm(spaces)
        if(string[1]=='-'):
            outvm("neg")
        else:
            outvm("not")

    #integerConstant
    elif string[0]=='<integerConstant>':
        printit(spaces)
        outvm("push constant "+string[1])

    #expression
    elif(string[1]=='('):
        printit(spaces)
        compileexpression(spaces)
        checksymbol(')',spaces)

    #keywordConstant
    elif string[0]=='<keyword>':
        printit(spaces)
        if(string[1]=='this'):
            outvm("push pointer 0")
        else:
            outvm("push constant 0")
            if string[1]=='true':
                outvm("not") 
            elif(string[1] not in['false','null']):
                error('keyword')   
    
    #stringConstant
    elif string[0]=='<stringConstant>':
        printit(spaces)
        str1 = string[1]
        str1 = str1[1:len(str1)-1]
        outvm("push constant "+str(len(str1)))
        outvm("call String.new 1")
        for i in range(len(str1)):
            outvm("push constant "+str(ord(str1[i])))
            outvm("call String.appendChar 2")

    #identifier (maybe method function or varName)
    elif string[0] == '<identifier>':
        printit(spaces)
        temp = gettype(string[1])
        if len(temp)>1:
            err.write("Repeated declaration: {}".format(string[1]))
            sys.exit(0)

        if len(temp)!=0 and temp[0][1]=='this' and subType=='function':
            err.write("ERROR: Using field variable {} in function {} in {}".format(string[1],subName,curr_class))
            sys.exit(0)

        #normal variable
        if not(nexttoken()[1] in ['.','[','(']):
            if len(temp)==0:
                declerror(string)
            outvm("push "+temp[0][1]+' '+str(temp[0][3]))

        #Array 
        elif (nexttoken()[1]=='['):
            printit(spaces)
            compileexpression(spaces)
            checksymbol(']',spaces)
            outvm("push "+temp[0][1]+ ' '+str(temp[0][3]))
            outvm("add")
            outvm("pop pointer 1")
            outvm("push that 0")

        #subroutine
        else:
            id1 = string[1]
            id2 = None
            if nexttoken()[1]=='.':
                #dot 
                printit(spaces)
                if(nexttoken()[0]!='<identifier>'):
                    error('identifier')

                #function or method name
                id2 = nexttoken()[1]
                printit(spaces)
    
                if(len(temp)!=0):
                    outvm("push "+temp[0][1]+' '+str(temp[0][3]))
            else:
                outvm("push pointer 0")
            checksymbol('(',spaces)
            np = compileexpressionlist(spaces)
            checksymbol(')',spaces)

            if(id2 is None):
                outvm("call "+curr_class+'.'+id1+' '+str(np+1))

            else:
                if len(temp)==0:
                    outvm("call "+acc(id1,id2)+' '+str(np))
                else:
                    outvm("call "+acc(temp[0][2],id2)+' '+str(np+1))
        
    else:
        error('term')
    printspaces(spaces-2)
    out.write('</term>\n')    

def compileexpression(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    

    printspaces(spaces)
    out.write('<expression>\n')
    spaces+=2

    #first term
    compileterm(spaces)

    string = nexttoken()

    op = {}
    op['+'] = 'add'
    op['-'] = 'sub'
    op['&amp;'] = 'and'
    op['|'] = 'or'
    op['&gt;'] = 'gt'
    op['&lt;'] = 'lt'
    op['='] = 'eq'
    op['*'] = 'call Math.multiply 2'
    op['/'] = 'call Math.divide 2'

    while(string[1] in oplist):
        oper = string[1]
        printit(spaces)
        compileterm(spaces)
        string = nexttoken()
        outvm(op[oper])

    printspaces(spaces-2)
    out.write('</expression>\n')

def compileexpressionlist(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    
    
    printspaces(spaces)
    out.write('<expressionList>\n')
    string  = nexttoken()

    spaces+=2

    #empty expressionlist
    if(string[1]==')'):
        printspaces(spaces-2)
        out.write('</expressionList>\n')
        return 0
    
    #first expression
    compileexpression(spaces)
    exprs=1

    string = nexttoken()

    while(string[1]==','):
        printit(spaces)
        compileexpression(spaces)
        string = nexttoken()
        exprs+=1

    printspaces(spaces-2)
    out.write('</expressionList>\n')
    return exprs

def compilelet(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    

    printspaces(spaces)
    out.write('<letStatement>\n')
    spaces+=2

    #let keyword
    printit(spaces)

    string = nexttoken()

    #varname
    if(string[0]!='<identifier>'):
        error('identifier')

    varname = string[1]
    printit(spaces)
    temp = gettype(varname)

    if(len(temp)==0):
        declerror(string)

    string = nexttoken()
    
    #if indexed
    if(string[1]=='['):
        printit(spaces)
        compileexpression(spaces)
        string = nexttoken()
        checksymbol(']',spaces)
        string = nexttoken()

        outvm("push "+temp[0][1]+" "+str(temp[0][3]))
        outvm("add")
        checksymbol('=',spaces)
        compileexpression(spaces)
        outvm("pop temp 0")
        checksymbol(';',spaces)

        outvm("pop pointer 1")
        outvm("push temp 0")
        outvm("pop that 0")

    else:
        checksymbol('=',spaces)
        compileexpression(spaces)
        checksymbol(';',spaces)
        outvm("pop "+temp[0][1]+" "+str(temp[0][3]))

    spaces-=2
    printspaces(spaces)
    out.write('</letStatement>\n')

def compileif(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    

    
    printspaces(spaces)
    out.write('<ifStatement>\n')

    spaces+=2

    tlabelnum=labelNum
    labelNum+=2

    #if
    printit(spaces)

    #lbracket
    string = nexttoken()
    checksymbol('(',spaces)

    #expression
    compileexpression(spaces)
    string = nexttoken()

    #rbracket
    checksymbol(')',spaces)

    #lbracket
    string = nexttoken()
    checksymbol('{',spaces)

    outvm("not")
    outvm("if-goto "+acc(curr_class,tlabelnum))

    #statements
    compilestatements(spaces)

    string = nexttoken()

    #rbracket
    checksymbol('}',spaces)

    string = nexttoken()

    #else statement
    if(string[0]=='<keyword>' and string[1]=='else'):

        outvm("goto "+acc(curr_class,tlabelnum+1))
        outvm("label "+acc(curr_class,tlabelnum))
        printit(spaces)
        #lbracket
        string = nexttoken()
        checksymbol('{',spaces)

        #statements
        compilestatements(spaces)

        string = nexttoken()

        #rbracket
        checksymbol('}',spaces)
        outvm("label "+acc(curr_class,tlabelnum+1))

    else:
        outvm("label "+acc(curr_class,tlabelnum))

    spaces-=2
    printspaces(spaces)
    out.write('</ifStatement>\n')

def compilewhile(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    


    printspaces(spaces)
    out.write("<whileStatement>\n")
    spaces+=2

    tlabelnum = labelNum
    labelNum+=2

    #while
    printit(spaces)

    #lbracket
    string = nexttoken()
    checksymbol('(',spaces)

    outvm("label "+acc(curr_class,tlabelnum))

    #expression
    compileexpression(spaces)
    string = nexttoken()

    #rbracket
    checksymbol(')',spaces)

    outvm("not")
    outvm("if-goto "+acc(curr_class,tlabelnum+1))

    #lbracket
    string = nexttoken()
    checksymbol('{',spaces)

    #statements
    compilestatements(spaces)

    string = nexttoken()

    #rbracket
    checksymbol('}',spaces)
    outvm("goto "+acc(curr_class,tlabelnum))
    outvm("label "+acc(curr_class,tlabelnum+1))

    spaces-=2

    printspaces(spaces)
    out.write("</whileStatement>\n")

def compiledo(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    

    printspaces(spaces)
    out.write('<doStatement>\n')

    spaces+=2

    #do keyword
    printit(spaces)

    string = nexttoken()
    if(string[0]!='<identifier>'):
        error('identifier')

    else:
        printit(spaces)

    id1 = string[1]
    id2 = None
    temp = []
    string2 = nexttoken()
    if(string2[0]=='<symbol>' and string2[1]=='.'):
        checksymbol('.',spaces)
        if(nexttoken()[0]!='<identifier>'):
            error('identifier')
        
        id2 = nexttoken()[1]
        printit(spaces)

        temp = gettype(id1)
        if(len(temp)!=0):
            outvm("push "+temp[0][1]+' '+str(temp[0][3])) 

    else:
        outvm("push pointer 0")

    checksymbol('(',spaces)
    np = compileexpressionlist(spaces)
    checksymbol(')',spaces)
    checksymbol(';',spaces)    

    if(id2 is None):
        outvm("call "+curr_class+'.'+id1+' '+str(np+1))
        outvm("pop temp 0")

    else:
        if len(temp)==0:
            outvm("call "+acc(id1,id2)+' '+str(np))
        else:
            outvm("call "+acc(temp[0][2],id2)+' '+str(np+1))
        outvm("pop temp 0")


    spaces-=2
    printspaces(spaces)
    out.write('</doStatement>\n')

def compilereturn(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    
    printspaces(spaces)

    out.write('<returnStatement>\n')
    spaces+=2

    #keyword return
    printit(spaces)

    string = nexttoken()
    if(string[1]!=';'):
        compileexpression(spaces)

    else:
        outvm("push constant 0")

    string = nexttoken()

    checksymbol(';',spaces)
    outvm("return")
    
    spaces-=2
    printspaces(spaces)
    out.write('</returnStatement>\n')

def compilestatements(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    
    printspaces(spaces)

    out.write('<statements>\n')

    spaces+=2
    statementList = ['let','if','while','do','return']

    string = nexttoken()

    while(string[0]=='<keyword>' and string[1] in statementList):
        if(string[1]=='let'):
            compilelet(spaces)
        elif(string[1]=='if'):
            compileif(spaces)
        elif(string[1]=='while'):
            compilewhile(spaces)
        elif(string[1]=='do'):
            compiledo(spaces)
        else:
            compilereturn(spaces)

        string = nexttoken()

    spaces-=2
    printspaces(spaces)
    out.write('</statements>\n')

def compilevardec(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    
    printspaces(spaces)
    out.write("<varDec>\n")

    spaces+=2

    curr_kind = 'local'

    #var
    printit(spaces)

    #type
    string  = nexttoken()
    if(not typename(string[1])):
        error('type')

    curr_type = string[1]
    printit(spaces)

    #name
    string  = nexttoken()
    if(string[0]!='<identifier>'):
        error('identifier')

    curr_name = string[1]
    sub_vars.append((curr_name,curr_kind,curr_type,local_count))
    tot_count+=1
    local_count+=1
    printit(spaces)

    #names
    string = nexttoken()

    if(string[0]!='<symbol>'):
        error('symbol')

    while(string[0]=='<symbol>'):
        if(string[1]!=','):
            break
            
        else:
            printit(spaces)

        string = nexttoken()
        if(string[0]!='<identifier>'):
            error('identifier')

        curr_name = string[1]
        sub_vars.append((curr_name,curr_kind,curr_type,local_count))
        tot_count+=1
        local_count+=1

        printit(spaces)
        string = nexttoken()


    #print semicolon
    checksymbol(';',spaces)

    spaces-=2

    printspaces(spaces)
    out.write("</varDec>\n")

def compilesubroutinebody(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    

    printspaces(spaces)

    out.write('<subroutineBody>\n')
    spaces+=2
    
    # { bracket
    string = nexttoken()
    checksymbol('{',spaces)

    string = nexttoken()

    #variable declarations
    while(string[1]=='var'):
        compilevardec(spaces)
        string = nexttoken()

    #dump in vm
    outvm("function "+curr_class+'.'+subName+' '+str(local_count))

    if(subType == 'constructor'):
        outvm("push constant "+str(class_var_count-static_count))
        outvm("call Memory.alloc 1")
        outvm("pop pointer 0")

    elif(subType == 'method'):
        outvm("push argument 0")
        outvm("pop pointer 0")

    #statements
    compilestatements(spaces)

    #check for }
    string = nexttoken()
    checksymbol('}',spaces)

    spaces-=2
    printspaces(spaces)
    out.write('</subroutineBody>\n')

def compileparameterlist(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    
    string = nexttoken()

    #if empty declaration
    if(string[1]==')'):
        printspaces(spaces)
        out.write('<parameterList>\n')
        printspaces(spaces)
        out.write('</parameterList>\n')
        return

    printspaces(spaces)
    out.write('<parameterList>\n')


    #first parameter type
    if(not typename(string[1])):
        error('type')

    spaces+=2

    curr_type = string[1]
    curr_kind = 'argument'

    printit(spaces)
    string = nexttoken()

    #first parameter name
    if(string[0]!='<identifier>'):
        error('identifier')

    sub_vars.append((string[1],curr_kind,curr_type,tot_count))
    args_count+=1
    tot_count+=1

    printit(spaces)


    string = nexttoken()

    while(string[0]=='<symbol>'):
        #comma
        if(string[1]!=','):
            break
    
        else:    
            printit(spaces)

        #parameter type
        string = nexttoken()
        if(not typename(string[1])):
            error('type')

        curr_type = string[1]
        printit(spaces)

        #parameter name
        string = nexttoken()
        if(string[0]!='<identifier>'):
            error('identifier')

        sub_vars.append((string[1],curr_kind,curr_type,args_count))
        args_count+=1
        tot_count+=1
        printit(spaces)

        string = nexttoken()

    spaces-=2
    printspaces(spaces)
    out.write('</parameterList>\n')

def compilesubroutinedec(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum    


    printspaces(spaces)
    out.write('<subroutineDec>\n')

    spaces+=2
    #keyword
    subType = nexttoken()[1]
    printit(spaces)

    #type
    strings = nexttoken()

    if(not typename(strings[1]) and strings[1]!='void'):
        error('type')

    printit(spaces)

    #subroutine name
    strings = nexttoken()
    if(strings[0]!='<identifier>'):
        error('identifier')
    subName = strings[1]
    printit(spaces)

    #for method
    if(subType == 'method'):
        sub_vars.append(('this','argument',curr_class,0))
        args_count +=1
        tot_count+=1

    #lbracket
    strings = nexttoken()
    checksymbol('(',spaces)

    #parameterlist
    compileparameterlist(spaces)

    #rbracket
    strings = nexttoken()
    checksymbol(')',spaces)

    #subroutinebody
    compilesubroutinebody(spaces)
    spaces-=2

    printspaces(spaces)
    out.write('</subroutineDec>\n')

def compileclassvardec(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNums_vars,class_var_count
    printspaces(spaces)
    out.write('<classVarDec>\n')

    spaces+=2

    #static or field
    curr_kind =  nexttoken()[1]
    if(curr_kind == 'field'):
        curr_kind = 'this'
    printit(spaces)

    string = nexttoken()

    if(not typename(string[1])):
        error('type')
    
    #variable type
    curr_type = string[1]

    printit(spaces)
    string = nexttoken()

    if(string[0]!='<identifier>'):
        error('identifier')
    

    #first variable name in current classvardec
    if(curr_kind == 'static'):
        class_vars.append((string[1],curr_kind,curr_type,static_count))
        static_count+=1

    else:
        class_vars.append((string[1],curr_kind,curr_type,class_var_count-static_count))

    class_var_count+=1

    printit(spaces)
    strings = nexttoken()

    #next token should be ; or ,
    if(strings[0]!='<symbol>'):
        error('symbol')

    #while we get ',' keep taking input
    while(strings[0]=='<symbol>'):
        if(strings[1]!=','):
            break
            
        else:
            printit(spaces)

        strings= nexttoken()

        #name of variable
        if(strings[0]!='<identifier>'):
            error('identifier')

        #append all variables in current declaration
        if(curr_kind=='static'):
            class_vars.append((strings[1],curr_kind,curr_type,static_count))
            static_count+=1

        else:
            class_vars.append((strings[1],curr_kind,curr_type,class_var_count-static_count))
    
        class_var_count+=1
        printit(spaces)
        strings = nexttoken()

    #print semicolon
    checksymbol(';',spaces)

    printspaces(spaces)
    out.write('</classVarDec>\n')

def compileclass(spaces):
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum   
    printspaces(spaces)
    strings  = nexttoken()
    #check keyword class
    if(strings[0]!='<keyword>' or strings[1]!='class'):
        error('keyword')

    printspaces(spaces)
    out.write('<class>\n')

    printit(spaces+2)

    #check identifier class name
    strings = nexttoken()

    if(strings[0]!='<identifier>'):
        error('identifier')

    curr_class = strings[1]

    printit(spaces+2)

    #check for {
    
    strings = nexttoken()

    checksymbol('{',spaces+2)

    #classvardec*
    strings = nexttoken()
    if(strings[0]!='<keyword>'):
        error('keyword')

    while(strings[1]=='static' or strings[1]=='field'):
        compileclassvardec(spaces+2)
        strings = nexttoken()

    strings = nexttoken()

    #subroutinedec*
    while(strings[1]=='constructor' or strings[1]=='function' or strings[1]=='method'):
        args_count =0
        local_count = 0
        tot_count = 0
        sub_vars.clear()
        compilesubroutinedec(spaces+2)
        strings = nexttoken()
    strings = nexttoken()

    checksymbol('}',spaces+2)

    printspaces(spaces)
    out.write('</class>\n')


def compile_func(file_name):
    global out,err,vm,tokens,index
    global class_vars,index,class_var_count,static_count,sub_vars,args_count,tot_count,local_count,curr_class,subName,subType,labelNum
    out = open(file_name+'.xml',"w")
    err = open(file_name+'.err',"w")
    vm = open(file_name+'.vm',"w")
    
    #Initializing the global variables
    index = 0
    class_vars = []
    class_var_count = 0
    static_count = 0
    sub_vars = []
    args_count = 0
    tot_count = 0
    local_count = 0
    curr_class = None
    subName = None
    subType = None
    labelNum = 0

    token_func(file_name)
    cin = open(file_name+'.tok',"r")
    tokens = cin.readlines()
    cin.close()

    #removing the <tokens> and </tokens> tags
    tokens = tokens[1:len(tokens)-1]

    compileclass(0)
    cin.close()
    out.close()
    err.close()
    vm.close()
    

if __name__ == "__main__":
    compile_func('Main')