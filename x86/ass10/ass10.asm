;  Assignment #10
;  CS 218

;  Luis Ruiz 
;  Section -1001
;  NSHE: 5001441817

;  Support Functions.
;  Provided Template

; -----
;  Function getIterations()
;	Gets, checks, converts, and returns iteration
;	count from the command line.

;  Function drawChaos()
;	Calculates and plots Chaos algorithm

; ---------------------------------------------------------

; =====================================================================
;  Macro to convert ASCII/Binary value into an integer.
;  Reads <string>, convert to integer and place in <integer>
;  Assumes valid data, no error checking is performed.
;  Note, macro should preserve any registers that the macro alters.

;  Arguments:
;	%1 -> <string>, register -> string address
;	%2 -> <integer>, register -> result

;  Macro usgae
;	abin2int  <string>, <integer>

;  Example usage:
;	abin2int	rbx, tmpInteger

;  For example, to get address into a local register:
;		mov	rsi, %1

;  Note, the register used for the macro call (rbx in this example)
;  must not be altered before the address is copied into
;  another register (if desired).

%macro	abin2int	2
	
push rcx 					;save rcx original value coming in 
push r8
push r9
push rdx

	mov rdx, 0					;clear
	mov edx, dword[len]			;get Length
	dec edx 					;length - 1 

	mov dword [%2], 0			; make sure tempInt = 0
	mov rcx, rdx				; set exp 2^expo
	mov r8, %1					; get base address


	%%convertLoop:	
		mov rdx,0				;clear
		mov dl, byte [r8]		;its a byte so increment by 1
							 	;grab cSides[i] 
		mov r9d , 1			 	;reset to 1


		cmp dl, "1"				;r12b ==  '1'?
		jne %%notA1

		shl r9d, cl 			;2^cl
		add dword[%2], r9d		;add the shifted amount to tmpInteger

		%%notA1:

		inc r8					;increment i
		dec rcx					;decrement expo 

		cmp dl, NULL			;if NULL is reached exit
		jne  %%convertLoop	

	pop rdx
	pop r9	
	pop r8 
	pop rcx						;regain original value back 

%endmacro


; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; code for read
SYS_write	equ	1			; code for write
SYS_open	equ	2			; code for file open
SYS_close	equ	3			; code for file close
SYS_fork	equ	57			; code for fork
SYS_exit	equ	60			; code for terminate
SYS_creat	equ	85			; code for file open/create
SYS_time	equ	201			; code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS		equ	0
GL_POLYGON		equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Define program constants.

IT_MIN		equ	255
IT_MAX		equ	65535

; -----
;  Local variables for getArguments function.

;STR_LENGTH	equ	12

ddTwo		dd	2

errUsage	db	"Usage: chaos -it <binaryNumber> "
		db	LF, NULL
errBadCL	db	"Error, invalid or incomplete command line argument."
		db	LF, NULL
errITsp		db	"Error, iterations specifier incorrect."
		db	LF, NULL
errITvalue	db	"Error, invalid iterations value."
		db	LF, NULL
errITrange	db	"Error, iterations value must be between "
		db	"11111111 (2) and 1111111111111111 (2)."
		db	LF, NULL
segFault db "made it"
		 db LF,NULL 

; -----
;  Local variables for plotChaos funcction.

red			dd	0			; 0-255
green		dd	0			; 0-255
blue		dd	0			; 0-255

pi			dq	3.14159265358979	; constant
oneEighty	dq	180.0
tmp			dq	0.0

dStep		dq	120.0			; t step
scale		dq	500.0			; scale factor

initX		dq	0.0, 0.0, 0.0		; array of x values
initY		dq	0.0, 0.0, 0.0		; array of y values

x			dq	0.0
y			dq	0.0

seed		dq	987123
qThree		dq	3
fTwo		dq	2.0

A_VALUE		equ	9421			; must be prime
B_VALUE		equ	1

len 		dd  0				;length

;-------------------------------------------------------------

section  .text

; -----
; Open GL routines.

extern glutInit, glutInitDisplayMode, glutInitWindowSize
extern glutInitWindowPosition
extern glutCreateWindow, glutMainLoop
extern glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern glutSwapBuffers
extern gluPerspective
extern glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern glClear, glLoadIdentity, glMatrixMode, glViewport
extern glTranslatef, glRotatef, glBegin, glEnd, glVertex3f, glColor3f
extern glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d
extern glutPostRedisplay

; -----
;  c math library funcitons

extern	cos, sin


; ******************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:
	push	rbx
	push	rsi
	push	rdi
	push	rdx

; -----
;  Count characters in string.

	mov	rbx, rdi			; str addr
	mov	rdx, 0
strCountLoop:
	cmp	byte [rbx], NULL
	je	strCountDone
	inc	rbx
	inc	rdx
	jmp	strCountLoop
strCountDone:

	cmp	rdx, 0
	je	prtDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; EDX=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

prtDone:
	pop	rdx
	pop	rdi
	pop	rsi
	pop	rbx
	ret

; ******************************************************************
;  Function getIterations()
;	Performs error checking, converts ASCII/binary to integer.
;	Command line format (fixed order):
;	  "-sp <binaryNumber> -dc <binaryNumber> -bk <binaryNumber>"

; -----
;  Arguments:
;	1) ARGC, double-word, value (rdi)
;	2) ARGV, double-word, address (rsi)
;	3) iterations count, double-word, address (rdx)


global getIterations
getIterations:
;value argc - rdi
;address argv -rsi 
;address of iterations(length) - rdx 

push rbx
push rcx
push r8
push r12
push r13
	

		;-----------
		;if argc == 1
		cmp rdi, 1
		je usageMsg

		;---------------
		;if arc != 3
		cmp rdi, 3
		jne lackofArg

		;-----------
		;if argv[1] != "-it"
		;rsi = argv (starting address of argument vector)

		mov r12, qword[rsi+8]		;& argv[1]
		mov rbx, 0					;i = 0

		specifierLoop:
			mov rcx, 0					;clear
			mov cl, byte[r12+rbx]		;argv[1][i] 

			cmp rbx, 0					;1st char
			jne not1st
				cmp cl, '-'				;if (argv[1][0] != '-')
				jne specifierWrong
			not1st:

			cmp rbx, 1					;2nd char
			jne not2nd
				cmp cl, 'i'				;if (argv[1][1] != '-')
				jne specifierWrong
			not2nd:

			cmp rbx, 2					;3 char 
			jne not3rd 				
				cmp cl, 't'				
				jne specifierWrong 		;if (argv[1][2] != 't')
			not3rd:	  

			cmp rbx, 3   				;4char must be NULL
			jne not4th	
				cmp cl, NULL
				jne specifierWrong
			not4th:

			inc rbx 
			cmp cl, NULL
			jne specifierLoop

		;-------------
		;check if argv[2] contains a valid binary String
		;rsi = argv (starting address of argument vector)

		mov r13, qword[rsi+16]				;& argv[2]
		mov rbx, 0							;i = 0

		binaryCheck:
			mov rax, 0 				;clear
			mov al, byte[r13+rbx] 	;binaryString[i]

			inc rbx 				;i++

			cmp al, NULL 			;while (argv[2][i] != NULL)
			je endofBinaryCheck

			cmp al, 0x30			;if binaryString = '0'
			jl notBinary 			;then its not a '1' or '0'

			cmp al, 0x31   			;if binaryString = '1'
			ja notBinary			;then its not a '1' or '0'

			jmp binaryCheck

		endofBinaryCheck:

		;convert BinarySting to int 
		mov dword[len],0			;clear length
		mov dword[len], ebx  		;get Length

		push rdi 		 			;following the calling convention
		push rsi 

		mov  rdi, r13					
		mov  rsi, rdx 

		abin2int rdi, rsi 		    ;macro binaryString to int 

		pop rsi 
		pop rdi 

		cmp dword[rdx], IT_MIN 			;tempInt < IT_MIN	
		jb outOfRange 			

		cmp dword[rdx],IT_MAX			;tempInt > IT_MAX
		ja outOfRange

		;---------
		;if all exceptions are FALSE, then it was entered 
		;correct 

		;iterations already contains a value

		mov rax, TRUE
		jmp checkDone				

	;------------
	;Conditons

	usageMsg:
		lea rdi, [errUsage] 		;1st arg
		call printString 
		mov rax, FALSE	
		jmp checkDone	

	lackofArg:
		lea rdi, [errBadCL] 	   	;1st arg
		call printString 
		mov rax, FALSE	
		jmp checkDone

	specifierWrong:
		lea rdi, [errITsp]          ;1st arg
		call printString 
		mov rax, FALSE	
		jmp checkDone 

	notBinary:
		lea rdi, [errITvalue]       ;1st arg
		call printString 
		mov rax, FALSE	
		jmp checkDone 

	outOfRange:
		lea rdi, [errITrange]       ;1st arg
		call printString 
		mov rax, FALSE	

	checkDone:						;will inidcate the end of the function

pop r13
pop r12
pop r8
pop rcx 
pop rbx 


ret 

; ******************************************************************
;  Function to draw chaos algorithm.

;  Chaos point calculation algorithm:
;	seed = 7 * 100th of seconds (from current time)
;	for  i := 1 to iterations do
;		s = rand(seed)
;		n = s mod 3
;		x = x + ( (init_x(n) - x) / 2 )
;		y = y + ( (init_y(n) - y) / 2 )
;		color = n
;		plot (x, y, color)
;		seed = s
;	end_for

; -----
;  Global variables (form main) accessed.

common	drawColor	1:4			; draw color
common	degree		1:4			; initial degrees
common	iterations	1:4			; iteration count

; -----

global drawChaos
drawChaos:
	push	r12				; save registers

; -----
; Prepare for drawing
	; glClear(GL_COLOR_BUFFER_BIT);

	mov	rdi, GL_COLOR_BUFFER_BIT
	call	glClear

; -----
;  Plot initial points.

	; glBegin();
	mov	rdi, GL_POINTS
	call	glBegin

; -----
;  Calculate initial points.

;  initX[i]

	mov r12,0						;i = 0
	calcLoop:
		;----------------
		;intitX[i]

		cvtsi2sd xmm0, r12d 			;xmm0 = 0.0, 32bit -> 64 bit floating point 
		mulsd xmm0, qword[dStep]		;i*dStep

		movsd xmm1, qword[pi]			;xmm1 = 3.14... 
		divsd xmm1, qword[oneEighty] 	;pi/180.0
		cvtsi2sd xmm2, dword[degree]  	;convert int degree to 64 bit floating point
		mulsd xmm1,xmm2	  				;(degree*(pi/180))
		addsd xmm0, xmm1                ;xmm0 = ((degree*(pi/180))+(i*dStep))

		call sin 						

		mulsd xmm0, qword[scale] 			;xmm0 = sin(((degree*(pi/180))+(i*dStep)))*scale
		movsd qword[initX+(r12*8)], xmm0    ;store initX[i]

		;----------------
		;intitY[i]

		cvtsi2sd xmm0, r12d 			;xmm0 = 0.0, 32bit -> 64 bit floating point 
		mulsd xmm0, qword[dStep]		;i*dStep

		movsd xmm1, qword[pi]			;xmm1 = 3.14... 
		divsd xmm1, qword[oneEighty] 	;pi/180.0
		cvtsi2sd xmm2, dword[degree]  	;convert int degree to 64 bit 
		mulsd xmm1,xmm2	  				;(degree*(pi/180))
		addsd xmm0, xmm1                ;xmm0 = ((degree*(pi/180))+(i*dStep))

		call cos 						

		mulsd xmm0, qword[scale] 			;xmm0 = cos(((degree*(pi/180))+(i*dStep)))*scale
		movsd qword[initY+(r12*8)], xmm0    ;store initY[i]

		;--------------
		;increment i and condition

		inc r12
		cmp r12, 3
		jl calcLoop

; -----
;  Main plot loop.
;	generate random number
;	get n (random number % 3)
;	calculate next (x,y) point
;	set color (as per algorithm)
;	plot (x,y)




; -----
;  Flush buffr to display, exit rotuine...

	call	glEnd
	call	glFlush

	pop	r12
	ret

; ******************************************************************

