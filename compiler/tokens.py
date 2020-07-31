#File used for tokenization and creation of .tok file

import re
import argparse
import sys

symbolList = ['(',')','{','}','[',']','.',',',';','+','-','*','/','&','|','<','>','=','~']
keywords = ['class','constructor','function','method','field','static','var','int','char','boolean','void','true','false','null','this','let','do','if','else','while','return']

filename = None
err = None

def removeComments(string):
    string = re.sub(re.compile("//.*?\n" ) ,"" ,string)
    string = re.sub(re.compile("/\*.*?\*/",re.DOTALL ) ,"" ,string)
    return string

def splitString(string):    
    nstr = re.split(r"(\".*?\")",string)
    lists = []
    for str in nstr:
        lists.append([str] if (len(str)>0 and str[0]=='"') else re.split(r"\ |\t|\n|(\".*?\"|\(|\)|\{|\}|\[|\]|\.|\,|\;|\+|\-|\*|\/|\&|\||\<|\>|\=|\~)", str))

    lists = [token for sublist in lists for token in sublist]
    # a = list(filter(None,(re.split(r"\ |\t|\n|(\".*?\"|\(|\)|\{|\}|\[|\]|\.|\,|\;|\+|\-|\*|\/|\&|\||\<|\>|\=|\~)", string))))
    tokens = list(filter(None,lists))
    return tokens

def getInput():

    txt = None
    if(filename is None):
        txt = open(args.file+".jack")
    
    else:
        txt = open(filename+".jack")
    s = txt.read()
    s = s+'\n'
    return s

def isKeyword(token):
    return token in keywords

def isSymbol(token):
    return token in symbolList

def isInteger(token):
    return token.isdigit() and (len(token)<5 or (len(token)==5 and token <= "32767"))

def isIdentifier(token):
    return token.isidentifier()

def isString(token):
    return token[0]==r'"' and token[len(token)-1] == r'"'

def tokenize(tokens):
    out = open(filename+'.tok',"w")
    err = open(filename+'.err','w')
    out.write('<tokens>\n')
    for token in tokens:
        if isKeyword(token):
            token = '<keyword>'+token+'</keyword>'
        elif isSymbol(token):
            if(token == '<'):
                token=('<symbol>'+'&lt;'+'</symbol>')
            elif(token =='>'):
                token=('<symbol>'+'&gt;'+'</symbol>')
            elif token == '&':
                token=('<symbol>'+'&amp;'+'</symbol>')
            else:
                token=('<symbol>'+token+'</symbol>')
        elif isInteger(token):
            token=('<integerConstant>'+token+'</integerConstant>')
        elif isString(token):
            token=('<stringConstant>'+token+'</stringConstant>')
        elif isIdentifier(token):
            token=('<identifier>'+token+'</identifier>')
        else:
            if(err is not None):
                err.write("ERROR: Lexical Error {}".format(token))
            else:
                print("ERROR: Unidentified token: ",token)
            out.close()
            sys.exit(0)

        out.write(token)
        out.write('\n')
    out.write(r'</tokens>')
    out.close()

def token_func(file_name):
    global filename
    filename = file_name
    s = getInput()
    s = removeComments(s)
    tokens = splitString(s)
    # print(tokens)
    tokenize(tokens)

if __name__ == "__main__":
    token_func('Main')
    

