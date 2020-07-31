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



//function Sys.init 0

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

// push constant 4000

@4000
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 0

@0
D=A
@3
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 5000

@5000
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 1

@1
D=A
@3
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// call Sys.main 0

@Sys.main1retadd
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
@Sys.main
0;JMP
(Sys.main1retadd)

// pop temp 1

@1
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

// label LOOP

(NestedCall_LOOP)

// goto LOOP

@NestedCall_LOOP
0;JMP

// function Sys.main 5

(Sys.main)
@5
D=A
(Sys.mainloop)
@Sys.mainloop_end
D;JEQ
@SP
AM=M+1
A=A-1
M=0
D=D-1
@Sys.mainloop
0;JMP
(Sys.mainloop_end)

// push constant 4001

@4001
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 0

@0
D=A
@3
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 5001

@5001
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 1

@1
D=A
@3
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 200

@200
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop local 1

@1
D=A
@LCL
D=M+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 40

@40
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop local 2

@2
D=A
@LCL
D=M+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 6

@6
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop local 3

@3
D=A
@LCL
D=M+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 123

@123
D=A
@SP
A=M
M=D
@SP
M=M+1

// call Sys.add12 1

@Sys.add122retadd
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
@Sys.add12
0;JMP
(Sys.add122retadd)

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

// push local 2

@2
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push local 3

@3
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push local 4

@4
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

// add

@SP
AM=M-1
D=M
A=A-1
M=D+M

// add

@SP
AM=M-1
D=M
A=A-1
M=D+M

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

// function Sys.add12 0

(Sys.add12)
@0
D=A
(Sys.add12loop)
@Sys.add12loop_end
D;JEQ
@SP
AM=M+1
A=A-1
M=0
D=D-1
@Sys.add12loop
0;JMP
(Sys.add12loop_end)

// push constant 4002

@4002
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 0

@0
D=A
@3
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 5002

@5002
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 1

@1
D=A
@3
D=A+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

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

// push constant 12

@12
D=A
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

