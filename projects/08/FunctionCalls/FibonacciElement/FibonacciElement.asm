@256
D=A
@SP
M=D
@LCL
M=D
@ARG
M=D

// call Sys.init 0

@Sys.init1retadd
D=A
@SP
AM=M+1
A=A-1
M=D
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
@5
D=A
@0
D=A+D
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Sys.init
0;JMP
(Sys.init1retadd)



// function Sys.init 0

(Sys.init)
@0
D=A
(Sys.initloop)
@Sys.initloop_end
D;JEQ
@SP
AM=M+1
A=A-1
M=0
D=D-1
@Sys.initloop
0;JMP
(Sys.initloop_end)

// push constant 4

@4
D=A
@SP
A=M
M=D
@SP
M=M+1

// call Main.fibonacci 1

@Sys_Main.fibonacci1retadd
D=A
@SP
AM=M+1
A=A-1
M=D
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
@5
D=A
@1
D=A+D
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
(Sys_Main.fibonacci1retadd)

// label WHILE

(Sys_WHILE)

// goto WHILE

@Sys_WHILE
0;JMP

// function Main.fibonacci 0

(Main.fibonacci)
@0
D=A
(Main.fibonacciloop)
@Main.fibonacciloop_end
D;JEQ
@SP
AM=M+1
A=A-1
M=0
D=D-1
@Main.fibonacciloop
0;JMP
(Main.fibonacciloop_end)

// push argument 0

@0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push constant 2

@2
D=A
@SP
A=M
M=D
@SP
M=M+1

// lt

@SP
AM=M-1
D=M
A=A-1
D=M-D
M=-1
@IFLT3
D; JLT
@SP
A=M-1
M=0
(IFLT3)

// if-goto IF_TRUE

@SP
AM=M-1
D=M
@Main_IF_TRUE
D;JNE

// goto IF_FALSE

@Main_IF_FALSE
0;JMP

// label IF_TRUE

(Main_IF_TRUE)

// push argument 0

@0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// return

@LCL
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
D=A
@SP
M=D+1
@R13
AM=M-1
D=M
@THAT
M=D
@R13
AM=M-1
D=M
@THIS
M=D
@R13
AM=M-1
D=M
@ARG
M=D
@R13
AM=M-1
D=M
@LCL
M=D
@R14
A=M
0;JMP

// label IF_FALSE

(Main_IF_FALSE)

// push argument 0

@0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push constant 2

@2
D=A
@SP
A=M
M=D
@SP
M=M+1

// sub

@SP
AM=M-1
D=M
A=A-1
M=M-D

// call Main.fibonacci 1

@Main_Main.fibonacci1retadd
D=A
@SP
AM=M+1
A=A-1
M=D
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
@5
D=A
@1
D=A+D
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
(Main_Main.fibonacci1retadd)

// push argument 0

@0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push constant 1

@1
D=A
@SP
A=M
M=D
@SP
M=M+1

// sub

@SP
AM=M-1
D=M
A=A-1
M=M-D

// call Main.fibonacci 1

@Main_Main.fibonacci2retadd
D=A
@SP
AM=M+1
A=A-1
M=D
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
@5
D=A
@1
D=A+D
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
(Main_Main.fibonacci2retadd)

// add

@SP
AM=M-1
D=M
A=A-1
M=D+M

// return

@LCL
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
D=A
@SP
M=D+1
@R13
AM=M-1
D=M
@THAT
M=D
@R13
AM=M-1
D=M
@THIS
M=D
@R13
AM=M-1
D=M
@ARG
M=D
@R13
AM=M-1
D=M
@LCL
M=D
@R14
A=M
0;JMP

