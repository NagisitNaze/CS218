; Luis Ruiz 
; CS 218 - 1001
; Assignment #12 template

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
;save regs
	push	rax
	push	rcx
	push	rbx
	push	rdx
	push	rdi
	

;main code
	mov	eax,%1
	mov	rcx,0
	mov	ebx,2

%%divideLoop:
;pushes reminders into stack
	mov	edx,0
	div	ebx
	
	push rdx
	inc	rcx

	cmp eax,0
	jne	%%divideLoop

;----
;Convert Remainders

	lea	rbx,byte[%2]
	mov	rdi,0
	mov	edx,32
	sub	edx,ecx
	cmp	edx,0
	je	%%restoreLoop

%%fillzero:
	mov	al,"0"
	mov	byte[rbx+rdi],al;
	inc 	rdi
	dec	edx
	cmp	edx,0
	jne	%%fillzero

%%restoreLoop:
;retrieves values stored in stack
	pop	rax
	add	al,"0"
	
	mov	byte[rbx+rdi], al
	inc	rdi
	loop %%restoreLoop

	mov	byte[rbx+rdi], NULL

;restore regs
	pop	rdi
	pop	rdx
	pop	rbx
	pop	rcx
	pop	rax

%endmacro

; ***************************************************************

section	.data

; -----
;  Define standard constants.

LF			equ	10			; line feed
NULL		equ	0			; end of string
ESC			equ	27			; escape key

TRUE		equ	1
FALSE		equ	-1

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

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

SYS_NPROCESSORS	equ	0x53			; system call code for number of processors


; -----
;  Message strings

;LIMIT		equ	0x70000000
LIMIT 		equ 0x64

header		db	LF, "*******************************************", LF
			db	ESC, "[1m", "Program Start", ESC, "[0m", LF, LF, NULL

msgFinal	db	"Final Counter Value should be: ", NULL
msgDoneMain	db	"Sequential Counter -> Final Value: ", NULL
msgDoneThread	db	"Parrellel Counter -> Final Value: ", NULL

msgProgDone	db	LF, "Completed.", LF, NULL

SeqMsgStart	db	LF, "--------------------------------------", LF	
			db	"Compute Formula -> Sequential", LF, NULL
ParMsgStart	db	LF, "--------------------------------------", LF
			db	"Compute Formula -> Parrellel", LF, NULL

errUsage	db	"Usage: ast12 <-sq|-pt>", LF, NULL
errCount    db  "Error, too many command line arguments.", LF, NULL
errSpec		db	"Error, invalid argument.", LF, NULL

coreCount	db	"CPU Cores: "
cores		db	"?", LF, NULL

; -----
;  Constants and global variable

A		equ	2
B		equ	2
C		equ	1

myValue		dd	0


; -----
;  Thread data structures

pthreadID0	dd	0, 0, 0, 0, 0
pthreadID1	dd	0, 0, 0, 0, 0


; -----
;  Local variables for compute functions.

msgMain		db	" ...Main starting...", LF, NULL
msgThread0	db	" ...Thread 0 starting...", LF, NULL
msgThread1	db	" ...Thread 1 starting...", LF, NULL


; -----
;  Local variables for printMessageValue

newLine		db	LF, LF, NULL

section	.bss
tmpString	resb	32


; ***************************************************************

section	.text

extern	pthread_create, pthread_join
extern  sysconf

global main
main:

; -----
;  Check arguments...

; argument count(value) - rdi 
; arguments vector (address) - rsi 

;-----
;if(argc == 1)
cmp rdi, 1
je prtUseMsg

;-----
;if(argc != 2)
cmp rdi, 2
jne printErrCount

mov rbx, 0					;clear
mov rbx, qword[rsi+8]		;argv[1]

;-----
;if(argv[1] != "-sp" || argv != "-pt")

cmp dword[rbx],0x0071732d 		;"-sq",NULL
je validSpec
	cmp dword[rbx], 0x0074702d 	;"-pt",NULL
	je validSpec
	jmp prtErrMsg
validSpec:

; -----
;  Get the number of cores and display to the screen.
;	Not needed for anything, but kinda interesting...

	mov	rdi, SYS_NPROCESSORS
	call	sysconf

	add	al, "0"
	mov	byte [cores], al

; -----
;  Initial actions:
;	Display start message
;	Display final value in ternary (for reference)
;	Display message for sequential, non-threaded start message

	mov	rdi, header
	call	printString

	mov	rdi, coreCount
	call	printString

	mov	rdi, msgFinal
	mov	rsi, LIMIT
	call	printSummary

; ----
;  Got to appropriate section...

	cmp dword[rbx],0x0071732d			;if(argv[1] == "-sq",NULL)
	je doSequential 					;goto doSequential

	cmp dword[rbx], 0x0074702d 			;if(argv[1] == "-pt",NULL)
	je doParrallel 						;goto doParrallel

; ***************************************************************
;  Compute formula - sequential, non-threaded
;	display start message
;	start thread 0
;	wait for thread 0 completion
;	start thread 1
;	wait for thread 1 completion
;	display final result

doSequential:
	mov	dword [myValue], 0			; initialize counter to 0

	mov	rdi, SeqMsgStart	
	call	printString

; -----
;  Create new thread 0
;	pthread_create(&pthreadID0, NULL, &threadFunction0, NULL);

	mov	rdi, pthreadID0
	mov	rsi, NULL
	mov	rdx, threadFunction0
	mov	rcx, NULL
	call	pthread_create

;  Wait for thread to complete.
;	pthread_join (pthreadID0, NULL);

	mov rdi, msgThread0
	call printString

	mov	rdi, qword [pthreadID0]
	mov	rsi, NULL
	call	pthread_join

; -----
;  Create new thread 1
;	pthread_create(&pthreadID1, NULL, &threadFunction1, NULL);

	
	mov rdi, msgThread1
	call printString

	mov	rdi, pthreadID1
	mov	rsi, NULL
	mov	rdx, threadFunction1
	mov	rcx, NULL
	call	pthread_create

;  Wait for thread to complete.
;	pthread_join (pthreadID1, NULL);

	mov	rdi, qword [pthreadID1]
	mov	rsi, NULL
	call	pthread_join

; -----
;  Display final result for sequential, non-threaded result.

	mov	rdi, msgDoneMain
	mov	esi, dword [myValue]
	call	printSummary

	jmp	progDone

; ***************************************************************
;  Compute formula - parrallel, threaded
;  Display message for threaded start

	doParrallel:

		mov	dword [myValue], 0			; initialize counter to 0

		mov	rdi, ParMsgStart
		call	printString

; 	-----
;  	Create new thread 0
;	pthread_create(&pthreadID0, NULL, &threadFunction0, NULL);
	
		mov rdi, msgThread0
		call printString

		mov	rdi, pthreadID0
		mov	rsi, NULL
		mov	rdx, threadFunction0
		mov	rcx, NULL
		call	pthread_create
		
; 	-----
; 	 Create new thread 1
;	pthread_create(&pthreadID1, NULL, &threadFunction1, NULL);

		
		mov rdi, msgThread1
		call printString

		mov	rdi, pthreadID1
		mov	rsi, NULL
		mov	rdx, threadFunction1
		mov	rcx, NULL
		call	pthread_create

;  Wait for thread to complete.
;	pthread_join (pthreadID0, NULL);

		mov	rdi, qword [pthreadID0]
		mov	rsi, NULL
		call	pthread_join


; 	 Wait for thread to complete.
;	 pthread_join (pthreadID1, NULL);

		mov	rdi, qword [pthreadID1]
		mov	rsi, NULL
		call	pthread_join

; -----
;  Display final result for sequential, non-threaded result.

		mov	rdi, msgDoneThread
		mov	esi, dword [myValue]
		call	printSummary

		jmp	progDone


; ================================================================
;  Error handling

prtUseMsg:
	mov	rdi, errUsage
	call printString
	jmp progDone

prtErrMsg:
	mov	rdi, errSpec
	call printString
	jmp progDone

printErrCount:
	mov rdi, errCount 
	call printString
	jmp	progDone


; **********
;  Program done, display final 'done' message
;	and terminate.

progDone:
	mov	rdi, msgProgDone
	call	printString

	mov	rax, SYS_exit			; system call for exit
	mov	rdi, SUCCESS			; return code SUCCESS
	syscall

; ===================================================================
;  Thread function #0
;	Accesses a global variable 'myValue'
;	Computes -> myValue = A * myValue / B + C

; -----
;  Arguments:
;	N/A (global variable accessed)
;  Returns:
;	N/A (global variable accessed)


global threadFunction0
threadFunction0:

	mov rcx, LIMIT 
	shr rcx, 1 							;divide LIMIT/2

	incLoop0:
		mov rax , 0
		mov eax, dword[myValue] 			;grab myValue
		mov rbx, A  						;grab A 
											
		mul ebx 							;myValue*A
		mov rbx, B 							;grab B

		div ebx 							;(myValue*A)/B
		mov rbx, C							;grab C

		add eax, ebx  
		mov dword[myValue], eax             ;((myValue*A)/B) + C

		loop incLoop0

ret

; ******************************************************************
;  Thread function #1
;	Accesses a global variable 'myValue'
;	Computes -> myValue = A * myValue / B + C
;	Loops LIMIT/2 times

; -----
;  Arguments:
;	N/A (global variable accessed)
;  Returns:
;	N/A (global variable accessed)

global threadFunction1
threadFunction1:

	mov rcx, LIMIT 
	shr rcx, 1 							;divide LIMIT/2

	incLoop1:
		mov rax , 0
		mov eax, dword[myValue] 			;grab myValue
		mov rbx, A  						;grab A 
											
		mul ebx 							;myValue*A
		mov rbx, B 							;grab B

		div ebx 							;(myValue*A)/B
		mov rbx, C							;grab C

		add eax, ebx  
		mov dword[myValue], eax             ;((myValue*A)/B) + C

		loop incLoop1

ret
; ******************************************************************
;  Display message and binary value in specified format.
;	format: <messageString> <value> <newLine>

;  Basic steps:
;	- print message string (via passed address)
;	- convert value into ASCII/Octal string
;	- print ASCII/Octal string
;	- print newLine (for nice formatting)

; -----
;  Arguments:
;	1) message, address
;	2) value, value
; -----
;  Returns:
;	N/A

global	printSummary
printSummary:
	push rbx

	mov	ebx, esi

	call printString			; rdi already set

	int2abin ebx , tmpString

	mov	rdi, tmpString
	call	printString

	mov	rdi, newLine
	call	printString

	pop	rbx
	ret

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

; -----
; Count characters to write.

	mov	rdx, 0
strCountLoop:
	cmp	byte [rdi+rdx], NULL
	je	strCountLoopDone
	inc	rdx
	jmp	strCountLoop
strCountLoopDone:
	cmp	rdx, 0
	je	printStringDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write		; system code for write()
	mov	rsi, rdi		; address of characters to write
	mov	rdi, STDOUT		; file descriptor for standard in
						; rdx=count to write, set above
	syscall				; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret

; ******************************************************************

