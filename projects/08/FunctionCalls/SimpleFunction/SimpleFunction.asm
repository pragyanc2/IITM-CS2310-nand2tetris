// function SimpleFunction.test 2

(SimpleFunction.test)
@2
D=A
(SimpleFunction.testloop)
@SimpleFunction.testloop_end
D;JEQ
@SP
AM=M+1
A=A-1
M=0
D=D-1
@SimpleFunction.testloop
0;JMP
(SimpleFunction.testloop_end)

// push local 0

@0
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push local 1

@1
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// add

@SP
AM=M-1
D=M
A=A-1
M=D+M

// not

@SP
A=M-1
M=!M

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

// add

@SP
AM=M-1
D=M
A=A-1
M=D+M

// push argument 1

@1
D=A
@ARG
A=D+M
D=M
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

