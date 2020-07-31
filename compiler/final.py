import compileEngine
import sys

if __name__ == "__main__":    
    cmds = sys.argv
    times = int(cmds[1])

    for i in range(2,times+2):
        str1 = str(cmds[i])
        str1 = str1[:len(str1)-5]
        compileEngine.compile_func(str1)