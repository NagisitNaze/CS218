;  CS 218, Assignment #6

;  Luis Ruiz 
;  Section - 1001
;  NSHE: 5001441817

;  Write a simple assembly language program to calculate
;  the cube areas for a series of cubes.

;  The cube side lengths are provided as binary values
;  represented as ASCII characters (0's and 1's) and must
;  be converted into integer in order to perform the
;  calculations.

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
	push rsi
	push r9

	mov dword [%2], 0			; make sure tempInt = 0
	mov rcx, 31					; set exp 2^expo
	mov rsi, %1					; get base address


	%%convertLoop:
		mov r12b, byte [rsi]	;its a byte so increment by 1
							 	;grab cSides[i] 
		mov r9d , 1			 	;reset to 1


		cmp r12b, "1"			;r12b ==  '1'?
		jne %%notA1

		shl r9d, cl 			;2^cl
		add dword[%2], r9d		;add the shifted amount to tmpInteger

		%%notA1:

		inc rsi					;increment i
		dec rcx					;decrement expo 

		cmp r12b, NULL			;if NULL is reached exit
		jne %%convertLoop	

	pop r9	
	pop rsi 
	pop rcx						;regain original value back 

%endmacro

; =====================================================================
;  Macro to convert integer to hex value in ASCII format.
;  Reads <integer>, converts to ASCII/binary string including
;	NULL into <string>
;  Note, macro should preserve any registers that the macro alters.

;  Arguments:
;	%1 -> <integer>, value
;	%2 -> <string>, string address

;  Macro usgae
;	int2abin    <integer-value>, <string-address>

;  Example usage:
;	int2abin	dword [cubeAreas+rsi*4], tempString

;  For example, to get value into a local register:
;		mov	eax, %1

%macro	int2abin	2

	push rax				;push original values on to stack
	push rbx 
	push rcx 
	push rdx 

	mov rax, 0				;clear the reg's
	mov rbx, 0	
	mov rcx, 0
	mov rdx, 0

	mov ebx, 2
	mov eax, %1

	;----
	%%divideLoop:
		mov rdx, 0			;unsigned division
		div ebx 			;edx:eax/2

		cmp edx,0
		jne %%notZero

		mov edx, 0x30		;push "0" onto stack
		push rdx  
		%%notZero:

		cmp edx,1
		jne %%notOne

		mov edx, 0x31		;push "1" onto stack
		push rdx  
		%%notOne:


		inc rcx 			;number elements pushed on to stack

		cmp eax,0
		jne %%divideLoop	;while (result > 0)

	;end of divide loop

;--------------------
	mov r15, 32				;length of string
	mov rbx, 0

	%%zeroOutString:	

		mov byte[%2+rbx], "0"	;initial place a zero in the index 
								;location

		inc rbx
		dec r15
		cmp r15,0
		jne %%zeroOutString
	;end of create string

	mov byte[%2+rbx], 0		;Place NULL at the end 

	dec rcx			;index = index -1 
					;index starts at 0
		
	%%overWriteLoop:        	;recall number of pused items
		pop rax 				; was stored in rcx
		mov byte[%2+rcx], al

		dec rcx 
		cmp rcx,-1
		jne %%overWriteLoop

	; end of Write Loop 

	;------------
	;loop push values on stack to later be popped
	
	mov rbx, %2		;32 characters excluding NULL
	mov rcx , 32
	;-----------
	;had to push and pop because 
	; everything was outputing flipped 

	%%pushLoop:
		movzx rax ,byte[rbx]
		push rax 

		inc rbx
		loop %%pushLoop
	;end of push loop 

	mov rbx, %2
	mov rcx, 32

	%%popLoop:
		pop rax 
		mov byte[rbx],al 

		inc rbx 
		loop %%popLoop
	;end of pop Loop 

;--------
	; Place original values in reg's 

	pop rdx
	pop rcx
	pop rbx 
	pop rax 

;--------

%endmacro

; =====================================================================
;  Simple macro to display a string to the console.
;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

;  Macro usage:
;	printString  <stringAddr>

;  Arguments:
;	%1 -> <stringAddr>, string address

%macro	printString	1
	push	rax			; save altered registers
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	lea	rdi, [%1]		; get address
	mov	rdx, 0			; character count
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	lea	rsi, [%1]		; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; =====================================================================
;  Initialized variables.

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1			; unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

NUMS_PER_LINE	equ	2


; -----
;  Assignment #6 Provided Data

STRLENGTH	equ	32

cSides	db	"00000000000000000000000010101001", NULL
		db	"00000000000000000000000001010101", NULL
		db	"00000000000000000000000101011001", NULL
		db	"00000000000000000000000000101010", NULL
		db	"00000000000000000000010101101011", NULL
		db	"00000000000000000001010100101101", NULL
		db	"00000000000000000000000101101101", NULL
		db	"00000000000000000000101011111000", NULL
		db	"00000000000000000000111100111001", NULL
		db	"00000000000000000001001111001101", NULL
		db	"00000000000000000001110001111101", NULL
		db	"00000000000000000000101111100000", NULL
		db	"00000000000000000000110011111001", NULL
		db	"00000000000000000011101001000101", NULL
		db	"00000000000000000000011101011101", NULL
		db	"00000000000000000010110011111000", NULL
		db	"00000000000000000001110101111101", NULL
		db	"00000000000000000001010001111101", NULL
		db	"00000000000000000011110001111101", NULL
		db	"00000000000000000001010001101101", NULL
		db	"00000000000000000001100001111101", NULL

aLength		db	"00000000000000000000000000010101", NULL
length		dd	0

cubeAreasSum	dd	0
cubeAreasAve	dd	0
cubeAreasMin	dd	0
cubeAreasMax	dd	0

; -----
;  Misc. variables for main.

hdr		db	LF, "-----------------------------------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #6", ESC, "[0m", LF
		db	"Cube Area Information", LF, LF
		db	"Cube Sides's:", LF, NULL
shdr		db	LF, "Cube Area's Sum:   ", NULL
avhdr		db	LF, "Cube Areas's Ave:  ", NULL
minhdr		db	LF, "Cube Areas's Min:  ", NULL
maxhdr		db	LF, "Cube Areas's Max:  ", NULL

tmpInteger	dd	0
newLine		db	LF, NULL
spaces		db	"   ", NULL

; =====================================================================
;  Uninitialized variables

section	.bss

cubeAreas	resd	21
tempString	resb	32

; **************************************************************

section	.text
global	_start
_start:

; -----
;  Display assignment initial headers.

	mov	edx, 0
	printString	hdr

; -----
;  Convert integer length, in ASCII binaary format


;	YOUR CODE GOES HERE
;		Convert ASCII binary format length to inetger (no macro)
;		Do not use macro here...

	push rcx 						;save rcx original value coming in 
	push rsi

	mov dword [length], 0			; make sure tempInt = 0
	mov rcx, 31						; set exp 2^expo
	mov rsi, aLength				; get base address


	getLength:
		mov r12b, byte [rsi]	;its a byte so increment by 1
							 	;grab cSides[i] 
		mov r9d , 1			 	;reset to 1


		cmp r12b, "1"			;r12b ==  '1'?
		jne nA1

		shl r9d, cl 			;2^cl
		add dword[length], r9d	;add the shifted amount to tmpInteger

		nA1:					;if the character is 0 jump here

		inc rsi					;increment i
		dec rcx					;decrement expo 

		cmp r12b, NULL			;if NULL is reached exit
		jne getLength	

		
	pop rsi 
	pop rcx						;regain original value back 
	

; -----
;  Convert cube sides from ASCII/binary to integer

	mov	ecx, dword [length]
	mov	rdi, 0					; index for cube areas
	mov	rbx, cSides
cvtLoop:
	abin2int	rbx, tmpInteger

	mov	eax, dword [tmpInteger]
	mul	eax
	mov	r10, 6
	mul	r10d
	mov	dword [cubeAreas+rdi*4], eax
	add	ebx, (STRLENGTH+1)

	inc	rdi
	dec	ecx
	cmp	ecx, 0
	jne	cvtLoop

; -----
;  Display each the cube area (two per line).

	mov	ecx, dword [length]
	mov	rsi, 0
printLoop:
	int2abin	dword [cubeAreas+rsi*4], tempString
	printString	tempString
	printString	spaces

	test	rsi, 1				; even/odd check
	je	skipNewline
	printString	newLine
skipNewline:
	inc	rsi

	dec	ecx
	cmp	ecx, 0
	jne	printLoop
	printString	newLine

; -----
;  Find sum, min, max and compute average.


;	YOUR CODE GOES HERE
;		find cube stats

	mov ecx, dword [length]				;reset my counter 
	mov rsi, 0							;index = 0

	mov r8d, dword[cubeAreas]			;grab first elemnt of array
	mov dword [cubeAreasMin],r8d
	mov dword [cubeAreasMax],r8d

statsLoop:

	mov r8d , dword[cubeAreas+rsi*4]
	add dword [cubeAreasSum], r8d		; get the sum

	cmp dword [cubeAreasMin], r8d		
	jbe notNewMin
	mov dword [cubeAreasMin], r8d		;then Min > r8d
	notNewMin:

	cmp dword [cubeAreasMax], r8d		
	jae notNewMax
	mov dword [cubeAreasMax], r8d		;then Max < r8d
	notNewMax:

	inc rsi								;increment i 

	dec ecx
	cmp ecx,0
	jne statsLoop

;-------
;Average 
	
	mov rax, 0
	mov eax, dword [cubeAreasSum] 			
	mov rdx , 0						;unsigned division
	div dword [length]				;divide by length
	mov dword [cubeAreasAve], eax

; -----
;  Convert sum to ASCII/binary for printing.

	printString	shdr

;	YOUR CODE GOES HERE
;		Convert the integer sum to ASCII/Binary (no macro)
;		Do not use macro here...

	push rax				;push original values on to stack
	push rbx 
	push rcx 
	push rdx 

	mov rax, 0				;clear the reg's
	mov rbx, 0	
	mov rcx, 0
	mov rdx, 0

	mov ebx, 2
	mov eax, dword [cubeAreasSum]

	;----
	;Dived by 2 unitl result is 0
	;Push all remainders on to stack
	divBy2Loop:
		mov rdx, 0			;unsigned division
		div ebx 			;edx:eax/2

		cmp edx,0
		jne not0

		mov edx, 0x30		;push "0" onto stack
		push rdx  
		not0:

		cmp edx,1
		jne not1

		mov edx, 0x31		;push "1" onto stack
		push rdx  
		not1:


		inc rcx 			;number elements pushed on to stack

		cmp eax,0
		jne divBy2Loop		;while (result > 0)

	;end of divide loop

	;--------------------
	;Make the string all zeros and the last character, NULL

	mov r15, 32				;length of string
	mov rbx, 0

	clearOutString:	

		mov byte[tempString+rbx], "0"	

		inc rbx
		dec r15
		cmp r15,0
		jne clearOutString
	;end of create string

	mov byte[tempString+rbx], 0		;Place NULL at the end 

	;------
	;Pop all pushed characters
	;and place in appropriate location, with 
	;respect to index

	dec rcx			;index = index -1 
					;index starts at 0

	popandPlace:        					;recall number of pused items
		pop rax 				; was stored in rcx
		mov byte[tempString+rcx], al

		dec rcx 
		cmp rcx,-1
		jne popandPlace

	; end of Write Loop 
	;---------
	;Had to push and pop because 
	;everything being outputted was flipped

	mov rbx, tempString		;32 characters excluding NULL
	mov rcx , 32

	loopPush:
		movzx rax ,byte[rbx]
		push rax 

		inc rbx
		loop loopPush
	;end of push loop 

	mov rbx, tempString
	mov rcx, 32

	loopPop:
		pop rax 
		mov byte[rbx],al 

		inc rbx 
		loop loopPop
	;end of pop Loop 

;--------
	; Place original values in reg's 

	pop rdx
	pop rcx
	pop rbx 
	pop rax 

	printString tempString




; -----
;  Convert average, min, and max integers to ASCII/binary for printing.

	printString	avhdr
	int2abin	dword [cubeAreasAve], tempString
	printString	tempString

	printString	minhdr
	int2abin	dword [cubeAreasMin], tempString
	printString	tempString

	printString	maxhdr
	int2abin	dword [cubeAreasMax], tempString
	printString	tempString

	printString	newLine
	printString	newLine


; *****************************************************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, SUCCESS
	syscall

