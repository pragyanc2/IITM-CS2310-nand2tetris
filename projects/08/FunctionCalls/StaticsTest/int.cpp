#include <bits/stdc++.h>
#define pet pair<int,string>
#define one first
#define two second
#define mp make_pair
#define pb push_back
using namespace std;

int err=0;      //maintains error count

ofstream out;
vector<string> cmnt(vector<string> orig)
{
    vector<string> ans;
    string s;
    int check=0;    //used to check if multiline comment is applied
    int use;
    int cmntline;

    int index=0;
    while(index<orig.size())
    {
        s=orig[index];
        index++;

        if(check==1)
        {
            use=s.find("*/");

            //if multiline comment ends in this line use rest of the line 
            if(use<s.size())
            {
                s=s.substr(use+2,s.size()-use-2);
                check=0;
            }

            else
            {
                continue;
            }
        }


        use=s.find("//");

        //use part of line till comments appear

        if(use<s.size())
        s=s.substr(0,use);

        use=s.find("/*");

        if(use<s.size())
        {
            //if multiline comment ends in the line itself use rest of the line
            int use1=s.find("*/");

            if(use1>=s.size())
            {
                check=1;
                cmntline=index;
                s=s.substr(0,use);
            }

            else
            {
                s=s.substr(0,use)+s.substr(use1+2,s.size()-use-2);
            }
            
        }


        //check if erroneuos comment closer is present
        use=s.find("*/");
        if(use<s.size())
        {
            err++;
            cerr << "Unpaired */ a line " << index << endl;
            return ans;
        }

        //remove whitespaces from end of line
        while(s.back()==' ')
        s.pop_back();

        //remove tabs from the line
        s.erase(remove(s.begin(), s.end(), '\t'), s.end());
        if(s.size())
        {
            ans.push_back(s);
        }
    
    }

    //error if some unpaired multiline comment exists
    if(check!=0)
    {
        cerr << "No matching */ for /* at line " << cmntline << endl;
        err++; 
    }
    return ans;
}

//removes comments from .vm file and stores it in a vector of strings
vector<string> cmnt(int file_index,char** argv)
{
    ifstream in;
    
    string s(argv[file_index]);
    s=s+".vm";

    char arr[s.size()+1];
    strcpy(arr,s.c_str());

    //open filename.vm to read
    in.open(arr);
    string temp;
    vector<string> orig;

    //convert input file to vector of strings
    while(getline(in,temp))
    {
        orig.push_back(temp);
    }

    //commnents removed
    orig=cmnt(orig);
    in.close();

    return orig;
}

//assembly name for corresponding vm names
string name(string s2,string s3,string filename)
{
    if(s2=="argument")return "ARG";
    if(s2=="local")return "LCL";
    if(s2=="this")return "THIS";
    if(s2=="that")return "THAT";
    if(s2=="temp")return "5";
    if(s2=="pointer")return "3";
    if(s2=="constant")return s3;
    if(s2=="static")return filename+s3;

    err++;
    cout << "No Such Access Command: " << s2 << ' ' << s3 << endl;
    return "";
}

//gives output to .asm file
void print(int file_index,char** argv)
{
    int callno=0;
    //orig contains all the lines after removing comments
    vector<string> orig=cmnt(file_index,argv);

    //if error found during removing comments do not proceed
    if(err>0)
    {
        return;
    }

    string str(argv[file_index]);

    string s;
    int help;

    string s1,s2,s3;
    for(int index=0;index<orig.size();index++)
    {
        s=orig[index];
        out << "// " << s << endl << endl;
        help=s.find(' ');

        //if no whitespace exists, i.e. if single string command
        if(help>=s.size())
        {
            if(s=="add")
            out << "@SP\n" << "AM=M-1\n" << "D=M\n" << "A=A-1\n" << "M=D+M\n";

            else if(s=="sub")
            out << "@SP\n" << "AM=M-1\n" << "D=M\n" << "A=A-1\n" << "M=M-D\n";

            else if(s=="and")
            out << "@SP\n" << "AM=M-1\n" << "D=M\n" << "A=A-1\n" << "M=M&D\n";

            else if(s=="or")
            out << "@SP\n" << "AM=M-1\n" << "D=M\n" << "A=A-1\n" << "M=M|D\n";

            else if(s=="not")
            out << "@SP\n" << "A=M-1\n" << "M=!M\n";

            else if(s=="neg")
            out << "@SP\n" << "A=M-1\n" << "M=-M\n";

            else if(s=="eq")
            out << "@SP\n" << "AM=M-1\n" << "D=M\n" << "A=A-1\n" << "D=M-D\n" << "M=-1\n" <<"@IFEQ" << index << endl << "D; JEQ\n" << "@SP\n" << "A=M-1\n" << "M=0\n" << "(IFEQ" << index << ")\n";

            else if(s=="gt")
            out << "@SP\n" << "AM=M-1\n" << "D=M\n" << "A=A-1\n" << "D=M-D\n" << "M=-1\n" <<"@IFGT" << index << endl << "D; JGT\n" << "@SP\n" << "A=M-1\n" << "M=0\n" << "(IFGT" << index << ")\n";
            
            else if(s=="lt")
            out << "@SP\n" << "AM=M-1\n" << "D=M\n" << "A=A-1\n" << "D=M-D\n" << "M=-1\n" <<"@IFLT" << index << endl << "D; JLT\n" << "@SP\n" << "A=M-1\n" << "M=0\n" << "(IFLT" << index << ")\n";

            else if(s=="return")
            {
                out << "@LCL\n" << "D=M\n" << "@R13\n" << "M=D\n";
                out << "@5\n" << "A=D-A\n" <<"D=M\n"<< "@R14\n" << "M=D\n";
                out << "@SP\n" <<"AM=M-1\n" << "D=M\n" << "@ARG\n" << "A=M\n"<< "M=D\n";
                out << "D=A\n" << "@SP\n" << "M=D+1\n";
                out << "@R13\n" << "AM=M-1\n" << "D=M\n" << "@THAT\n" << "M=D\n";
                out << "@R13\n" << "AM=M-1\n" << "D=M\n" << "@THIS\n" << "M=D\n";
                out << "@R13\n" << "AM=M-1\n" << "D=M\n" << "@ARG\n" << "M=D\n";
                out << "@R13\n" << "AM=M-1\n" << "D=M\n" << "@LCL\n" << "M=D\n";
                out << "@R14\n" << "A=M\n" << "0;JMP\n";
            }

            else
            {
                err++;
                cout << "Command not Found: " << s << endl;
                return;
            }
        }


        //else it is push or pop command
        else
        {
            s1=s.substr(0,help);
            s=s.substr(help+1,s.length()-help-1);

            help=s.find(' ');

            //if it is a two word command then it is program flow command
            if(help>=s.length())
            {
                s2=s;

                if(s1=="label")
                {
                    out  << '(' << str << '_' << s2 << ')' << endl;
                }

                else if(s1=="goto")
                {
                    out << "@" << str << '_' << s2 << endl;
                    out << "0;JMP\n";
                }

                else if(s1=="if-goto")
                {
                    out << "@SP\n" << "AM=M-1\n" << "D=M\n" << "@" << str << '_' << s2 << endl;
                    out << "D;JNE\n"; 
                }
                
                else
                {
                    //if none then error
                    err++;
                    cout << "Missing Parameter: " << s << endl;
                    return;
                }
            }


            else        
            {
                //if next character after space doesnot start another string
                if(!isalpha(s[0]))
                {
                    err++;
                    cout << "Improper spacing: " << s << endl;
                    return;
                }

                s2=s.substr(0,help);
                s=s.substr(help+1,s.length()-help-1);

                //if index parameter is not integer
                if(!isdigit(s[0]))
                {
                    err++;
                    cout << "Wanted Integer Parameter: " << s << endl;
                    return;
                }

            
                //s1 stores the command, s2 stores the location and s3 stores the index
                s3=s;
                string name1;

                //push command
                if(s1=="push")
                {
                    //asm name for the corresponding vm name of s2
                    name1=name(s2,s3,argv[1]);

                    //if unknown parameter passed as s2 then error
                    if(err>0)return;

                    if(s2=="static")
                    {
                        out << "@" << name1 << endl << "D=M\n" << "@SP\n" << "AM=M+1\n" << "A=A-1\n" << "M=D\n";
                        continue;
                    }

                    out << "@" << s3 <<endl;        //A register stores value of the index
                    
                    //Now in D register we store the value with which we need to update the location pointed by Stack Pointer
                    if(s2=="constant")
                    {
                        out << "D=A\n";             //For constant simply the index is the value      
                    }

                    else if(s2=="pointer" || s2=="temp")
                    {
                        out << "D=A\n"<< "@" << name1 << endl << "A=D+A\n" << "D=M\n";   //for pointer temp and static the location returned by name is the location used for storage        
                    }

                    else
                    {
                        out << "D=A\n"<< "@" << name1 << endl << "A=D+M\n" << "D=M\n";  //for others the location returned by name stores the address of the location used for storage
                    }

                    out << "@SP\n" << "A=M\n" << "M=D\n" << "@SP\n" << "M=M+1\n";       //location stack pointer is updated with value stored at D register and SP is incremented
                }

                //pop command
                else if(s1=="pop")
                {
                    name1=name(s2,s3,argv[1]);
                    //if unknown parameter passed as s2 then error
                    if(err>0)return;

                    //cannot pop constant value
                    if(s2=="constant")
                    {
                        cout << "Cannot pop into constant: " << s1 << ' ' << s2 << ' ' << s3 << endl;
                        err++;
                        return;
                    }

                    else 
                    {
                        if(s2=="static")
                        {
                            out << "@" << name1 << endl;
                            out << "D=A\n";
                        }

                        else
                        out << "@" << s3 << endl << "D=A\n" << "@" << name1 << endl;        //store value of index in D register and location given by name in A register

                        //in D register store the address of the location to be updated
                        if(s2=="pointer" || s2=="temp")
                        out << "D=A+D\n";                                                   

                        else if(s2!="static")
                        out << "D=M+D\n";
                        
                        /*use a temporary location(R13) to keep the address of location to be updated
                        decrement the stack pointer and store the value to be popped in D register
                        update the address stored in temporary location by value in D register*/
                        
                        out  << "@R13\n" << "M=D\n" << "@SP\n" << "AM=M-1\n" << "D=M\n" << "@R13\n" <<  "A=M\n" << "M=D\n";
                    }

                }

                //function command
                else if(s1=="function")
                {
                    out << "(" << s2 << ")\n";
                    out << "@" << s3 << endl << "D=A\n";
                    out << "(" << s2 << "loop)\n";
                    out << "@" << s2 << "loop_end\n";
                    out << "D;JEQ\n" << "@SP\n" << "AM=M+1\n" << "A=A-1\n" << "M=0\n" << "D=D-1\n";
                    out << "@" << s2 << "loop\n";
                    out << "0;JMP\n";
                    out << "(" << s2 << "loop_end)\n";
                }

                //function call
                else if(s1=="call")
                {
                    callno++;
                    out << "@" <<str << '_' << s2 << callno << "retadd\n" << "D=A\n" << "@SP\n" << "AM=M+1\n" << "A=A-1\n"<< "M=D\n";
                    out << "@LCL\n" << "D=M\n" << "@SP\n" << "AM=M+1\n" << "A=A-1\n" << "M=D\n";
                    out << "@ARG\n" << "D=M\n" << "@SP\n" << "AM=M+1\n" << "A=A-1\n" << "M=D\n";
                    out << "@THIS\n" << "D=M\n" << "@SP\n" << "AM=M+1\n" << "A=A-1\n" << "M=D\n";
                    out << "@THAT\n" << "D=M\n" << "@SP\n" << "AM=M+1\n" << "A=A-1\n" << "M=D\n";
                    out << "@5\n" << "D=A\n" << "@" << s3 << endl << "D=A+D\n" << "@SP\n" << "D=M-D\n" << "@ARG\n" << "M=D\n";
                    out << "@SP\n" << "D=M\n" << "@LCL\n" << "M=D\n";
                    out << "@" << s2 << endl << "0;JMP\n";
                    out << "(" <<str << '_' << s2 << callno << "retadd)\n";
                } 

                //if neither then error
                else
                {
                    err++;
                    cout << "Command not found: " << s1 << ' ' << s2 << ' ' << s3 << endl;
                    return;
                }
            }
        }
        
        out << endl;
    }
}

int main(int argc,char** argv)
{
    //cmnt(argc,argv);

    if(err>0)
    return 0;

    string str(argv[1]);
    str=str+".asm";

    char arr[str.size()+1];
    strcpy(arr,str.c_str());

    //open filename.asm to write
    out.open(arr);

    for(int i=2;i<argc;i++)
    print(i,argv);

    out.close();
}