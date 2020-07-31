#include <bits/stdc++.h>
#define pet pair<int,string>
#define one first
#define two second
#define pb push_back
#define mp make_pair
using namespace std;

int err=0;


string bin(string s)
{
    stringstream s1(s);
    int n;
    s1 >> n;
    string ans;
    while(ans.size()<15)
    {
        ans+=char(n%2+'0');
        n/=2;
    }

    reverse(ans.begin(),ans.end());
    return ans;
}

string bin(int n)
{
    string ans;
    while(ans.size()<15)
    {
        ans+=char(n%2+'0');
        n/=2;
    }

    reverse(ans.begin(),ans.end());
    return ans;
}

bool integer(string s)
{
    for(int i=0;i<s.length();i++)
    {
        if(s[i]<'0' || s[i]>'9')
        return false;
    }
    return true;
}


vector<pet> cmnt(vector<pet> orig)
{
    vector<pet> ans;
    string s;
    int check=0;
    int use;
    int cmntline;

    int index=0;
    while(index<orig.size())
    {
        s=orig[index].two;
        index++;

        if(check==1)
        {
            use=s.find("*/");

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

        if(use<s.size())
        s=s.substr(0,use);

        use=s.find("/*");

        if(use<s.size())
        {
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

        use=s.find("*/");
        if(use<s.size())
        {
            err++;
            cerr << "Unpaired */ a line " << index << endl;
            return ans;
        }
        s.erase(remove(s.begin(), s.end(), ' '), s.end());
        s.erase(remove(s.begin(), s.end(), '\t'), s.end());
        if(s.size())
        {
            ans.push_back(mp(orig[index].one,s));
            //cout << s << endl;
        }
    
    }

    try
    {
        if(check!=0)
        throw cmntline;
    }

    catch(int line)
    {
        cerr << "No matching */ for /* at line " << line << endl;
        err++;
    }
    return ans;
}


map<string,int> process2(vector<pet> orig)
{
    map<string,int> m;
    m.insert(mp("SP",0));
    m.insert(mp("LCL",1));
    m.insert(mp("ARG",2));
    m.insert(mp("THIS",3));
    m.insert(mp("THAT",4));

    string s="R";

    for(int i=0;i<10;i++)
    {
        m.insert(mp(s+char(i+'0'),i));
    }

    s=s+'1';
    for(int i=0;i<6;i++)
    {
        m.insert(mp(s+char(i+'0'),10+i));
    }
    m.insert(mp("SCREEN",16384));
    m.insert(mp("KBD",24576));

    map<string,int>::iterator itr;

    string temp;
    int counteri=-1;
    
    int blah=-1;
    vector<int> yo;

    for(int i=0;i<orig.size();i++)
    {
        s=orig[i].two;
        if(s[0]=='(')
        {
            int find=s.find(')');
            if(find==s.size()-1)
            {
                counteri++;
            }

            if(find>=s.size())
            {
                err++;
                cout << "Matching ')' not found in line " << orig[i].one+1 << endl;
                return m;
            }

            temp=s.substr(1,find-1);
            itr=m.find(temp);
            if(itr!=m.end())
            {
                if(itr->second<0)
                {
                    yo[-(itr->second)-1]=0;
                    itr->second=i-counteri;
                }

                else
                {
                    err++;
                    cout << "Label ("<<s<<") repeated at lines " << itr->second+1 << " and " << orig[i].one+1  << endl;
                    return m;
                }
            }

            else
            m.insert(mp(temp,i-counteri));

            s=s.substr(find+1,s.length()-find-1);

            if(s.length()==0)
            continue;
        }

        if(s[0]=='@')
        {
            s=s.substr(1,s.length()-1);

            if(integer(s))
            continue;

            itr=m.find(s);

            if(itr==m.end())
            {
                m.insert(mp(s,blah));
                yo.push_back(1);
                blah--;
            }
        }
    }

    for(int i=1;i<yo.size();i++)
    {
        yo[i]+=yo[i-1];
    }

    for(itr=m.begin();itr!=m.end();itr++)
    {
        if(itr->second<0)
        {
            itr->second=15+yo[-(itr->second)-1];
        }
    }

    return m;
}


bool pass1(char* argv[],map<string,int>& m)
{
    ifstream in;
    in.open(argv[1]);

    ofstream out;
    out.open(argv[2]);

    string temp;
    vector<pet> orig;


    while(getline(in,temp))
    orig.push_back(make_pair(0,temp));

    orig=cmnt(orig);

    if(err!=0)
    {
        return false;
    }

    for(int i=0;i<orig.size();i++)
    {
        out << orig[i].two << endl;
    }

    out.close();
    in.close();

    m = process2(orig);
    return true;
}


void pass2(char* argv[],map<string,int> m)
{
    
    map<string,string> help;
    help.insert(mp("0","0101010"));
    help.insert(mp("1","0111111"));
    help.insert(mp("-1","0111010"));
    help.insert(mp("D","0001100"));
    help.insert(mp("A","0110000"));
    help.insert(mp("!D","0001101"));
    help.insert(mp("!A","0110001"));
    help.insert(mp("-D","0001111"));
    help.insert(mp("-A","0110011"));
    help.insert(mp("D+1","0011111"));
    help.insert(mp("1+D","0011111"));
    help.insert(mp("A+1","0110111"));
    help.insert(mp("1+A","0110111"));
    help.insert(mp("D-1","0001110"));
    help.insert(mp("-1+D","0001110"));
    help.insert(mp("A-1","0110010"));
    help.insert(mp("-1+A","0110010"));
    help.insert(mp("D+A","0000010"));
    help.insert(mp("A+D","0000010"));
    help.insert(mp("D-A","0010011"));
    help.insert(mp("A-D","0000111"));
    help.insert(mp("D&A","0000000"));
    help.insert(mp("A&D","0000000"));
    help.insert(mp("D|A","0010101"));
    help.insert(mp("A|D","0010101"));

    help.insert(mp("M","1110000"));
    help.insert(mp("!M","1110001"));
    help.insert(mp("-M","1110011"));
    help.insert(mp("M+1","1110111"));
    help.insert(mp("1+M","1110111"));
    help.insert(mp("M-1","1110010"));
    help.insert(mp("-1+M","1110010"));
    help.insert(mp("D+M","1000010"));
    help.insert(mp("M+D","1000010"));
    help.insert(mp("D-M","1010011"));
    help.insert(mp("M-D","1000111"));
    help.insert(mp("D&M","1000000"));
    help.insert(mp("M&D","1000000"));
    help.insert(mp("D|M","1010101"));
    help.insert(mp("M|D","1010101"));


    map <string,string> jmp;
    jmp.insert(mp("JMP","111"));
    jmp.insert(mp("JGT","001"));
    jmp.insert(mp("JEQ","010"));
    jmp.insert(mp("JGE","011"));
    jmp.insert(mp("JLT","100"));
    jmp.insert(mp("JNE","101"));
    jmp.insert(mp("JLE","110"));


    int hel;
    ifstream in;
    ofstream out;
    string s1;

    in.open(argv[2]);
    out.open(argv[3]);

    string s;

    while(getline(in,s))
    {
        if(s[0]=='(')
        {
            hel=s.find(')');
            if(hel<s.size()-1)
            {
                s=s.substr(hel+1,s.size()-1-hel);
            }

            else
            {
                continue;
            }
            
        }

        if(s[0]=='@')
        {
            //A inst
            out << 0;

            s=s.substr(1,s.length()-1);

            if(integer(s))
            {
                out << bin(s) << endl;
            }

            else
            out << bin(m.find(s)->two) << endl;
        }

        else
        {
            //C inst
            out << 111;

            hel=s.find('=');

            if(hel>=s.size())
            {
                hel=s.find(';');
                s1=s.substr(0,hel);

                out << help.find(s1)->two;
                out << "000";
                out << jmp[s.substr(hel+1,3)] << endl;
            }

            else
            {
                out << help[s.substr(hel+1,s.size()-1-hel)];
                s1="000";
                s=s.substr(0,hel);

                for(int i=0;i<s.size();i++)
                {
                    if(s[i]=='A')
                    s1[0]='1';

                    else if(s[i]=='M')
                    s1[2]='1';

                    else if(s[i]=='D')
                    {
                        s1[1]='1';
                    }
                }

                out << s1 << "000" << endl;
            }
            
        }
        
    }
    in.close();
    out.close();
}


int main(int argc,char* argv[])
{
    map<string,int> m;

    string s(argv[1]);

    string s1=s+".asm";
    string s2=s+".ir";
    string s3=s+".hack";

    char arr1[s1.size()+1];
    strcpy(arr1,s1.c_str());

    char arr2[s2.size()+1];
    strcpy(arr2,s2.c_str());

    char arr3[s3.size()+1];
    strcpy(arr3,s3.c_str());

    char* arr[4];
    arr[1]=arr1;
    arr[2]=arr2;
    arr[3]=arr3;

    pass1(arr,m);
    pass2(arr,m);
}