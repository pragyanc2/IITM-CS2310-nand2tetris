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

// push constant 6

@6
D=A
@SP
A=M
M=D
@SP
M=M+1

// push constant 8

@8
D=A
@SP
A=M
M=D
@SP
M=M+1

// call Class1.set 2

@Sys_Class1.set1retadd
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
@2
D=A+D
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Class1.set
0;JMP
(Sys_Class1.set1retadd)

// pop temp 0

@0
D=A
@5
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 23

@23
D=A
@SP
A=M
M=D
@SP
M=M+1

// push constant 15

@15
D=A
@SP
A=M
M=D
@SP
M=M+1

// call Class2.set 2

@Sys_Class2.set2retadd
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
@2
D=A+D
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Class2.set
0;JMP
(Sys_Class2.set2retadd)

// pop temp 0

@0
D=A
@5
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// call Class1.get 0

@Sys_Class1.get3retadd
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
@Class1.get
0;JMP
(Sys_Class1.get3retadd)

// call Class2.get 0

@Sys_Class2.get4retadd
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
@Class2.get
0;JMP
(Sys_Class2.get4retadd)

// label WHILE

(Sys_WHILE)

// goto WHILE

@Sys_WHILE
0;JMP

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

// function Class2.set 0

(Class2.set)
@0
D=A
(Class2.setloop)
@Class2.setloop_end
D;JEQ
@SP
AM=M+1
A=A-1
M=0
D=D-1
@Class2.setloop
0;JMP
(Class2.setloop_end)

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

@Class20
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

@Class21
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

// function Class2.get 0

(Class2.get)
@0
D=A
(Class2.getloop)
@Class2.getloop_end
D;JEQ
@SP
AM=M+1
A=A-1
M=0
D=D-1
@Class2.getloop
0;JMP
(Class2.getloop_end)

// push static 0

@Class20
D=M
@SP
AM=M+1
A=A-1
M=D
// push static 1

@Class21
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

