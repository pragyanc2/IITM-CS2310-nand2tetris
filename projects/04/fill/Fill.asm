@KBD
D=M
@white
D; JEQ
@black
0;JMP

(white)
	@SCREEN
	D=A
	@i
	M=D
	
(whiteloop)
	@i
	D=M
	@KBD
	D=D-A
	@whiteend
	D;JGE
	@i
	A=M
	M=0
	@i
	M=M+1
	@whiteloop
	0;JMP
	
(whiteend)
	@KBD
	D=M
	@whiteend
	D; JEQ

(black)
	@SCREEN
	D=A
	@i
	M=D
	
(blackloop)
	@i
	D=M
	@KBD
	D=D-A
	@blackend
	D;JGE
	@i
	A=M
	M=-1
	@i
	M=M+1
	@blackloop
	0;JMP
(blackend)
	@KBD
	D=M
	@blackend
	D;JNE

	@white
	0;JMP