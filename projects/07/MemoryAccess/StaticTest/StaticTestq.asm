// push constant 111

@111
D=A
@SP
A=M
M=D
@SP
M=M+1

// push constant 333

@333
D=A
@SP
A=M
M=D
@SP
M=M+1

// push constant 888

@888
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop static 8

@8
D=A
@StaticTest8
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// pop static 3

@3
D=A
@StaticTest3
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// pop static 1

@1
D=A
@StaticTest1
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push static 3

@3
D=A
@StaticTest3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push static 1

@1
D=A
@StaticTest1
A=D+A
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

// push static 8

@8
D=A
@StaticTest8
A=D+A
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

