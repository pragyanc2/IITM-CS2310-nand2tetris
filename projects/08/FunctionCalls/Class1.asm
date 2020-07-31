// function Class1.set 0

(Class1.set)
@0
D=A
(Class1.setloop)
@Class1.setloop_end
D;JEQ
@SP
AM=M+1
A=A-1
M=0
D=D-1
@Class1.setloop
0;JMP
(Class1.setloop_end)

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

// pop static 0

@Class10
D=A
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

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

// pop static 1

@Class11
D=A
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 0

@0
D=A
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

// function Class1.get 0

(Class1.get)
@0
D=A
(Class1.getloop)
@Class1.getloop_end
D;JEQ
@SP
AM=M+1
A=A-1
M=0
D=D-1
@Class1.getloop
0;JMP
(Class1.getloop_end)

// push static 0

@Class10
D=M
@SP
AM=M+1
A=A-1
M=D
// push static 1

@Class11
D=M
@SP
AM=M+1
A=A-1
M=D
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

