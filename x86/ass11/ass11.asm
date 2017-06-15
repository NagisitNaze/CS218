;  CS 218 - Assignment #11

;  Luis Ruiz 
;  Section -1001
;  NSHE: 5001441817

;  Functions Template

;************************************************************************
;Desciption 
;We are to implement a program that will open an HTML formated text 
;file read the text information, remove all HTML formating commands,
;and write the resulting text to another file 
; ***********************************************************************
;  Data declarations
;	Note, the error message strings should NOT be changed.
;	All other variables may changed or ignored...

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
SYS_lseek	equ	8			; system call code for file repositioning
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF			equ	10
SPACE		equ	" "
NULL		equ	0
ESC			equ	27
	
O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q

; -----
;  Define program specific constants.

BUFF_SIZE	equ	500000			; buffer size
;BUFF_SIZE	equ	5				; buffer size

; -----
;  Variables for getFiles() function.

eof			db	FALSE

usageMsg		db	"Usage: ./remover -i <inputFileName> "
				db	"-o <outputFileName>", LF, NULL
errIncomplete	db	"Error, incomplete command line arguments.", LF, NULL
errExtra		db	"Error, too many command line arguments.", LF, NULL
errInputSpec	db	"Error, invalid input file specifier.", LF, NULL
errOutputSpec	db	"Error, invalid output specifier.", LF, NULL
errInputFile	db	"Error, unable to open input file.", LF, NULL
errOutputFile	db	"Error, unable to open output file.", LF, NULL
message         db  "HI I MADE IT", LF, NULL

; -----
;  Variables for getBlock() function.

buffEnd		dq	BUFF_SIZE
curr		dq	BUFF_SIZE
wasEOF		db	FALSE
last 		db  FALSE

errFileRead	db	"Error, reading input file.", LF,
			db	"Program terminated.", LF, NULL

; -----
;  Variables for putBlock() function.

tmpChr		db	0
errWrite	db	"Error, writting to output file.", LF,
			db	"Program terminated.", LF, NULL

; -----
;  Variables for editLine() function.

isHTML		db	FALSE

; ------------------------------------------------------------------------
;  Unitialized data

section	.bss
buffer		resb	BUFF_SIZE


; ############################################################################

section	.text

; ***************************************************************
;  Routine to get file descriptors.
;	Must parse command line, check for errors,
;	attempt to open file, and, if files open
;	successfully, return descriptors.
;	Otherwise, display appropriate error message.

;  Command Line format:
;	./remover -i <inputFileName> -o <outputFileName>

; -----
;  HLL Call:
;	getFiles(argc, argv, &readFile, &writeFile)

; -----
;  Arguments:
;	argc, value
;	argv table, address
;	input file descriptor, address
;	output file descriptor, address
; -----
;  Returns:
;	TRUE (if worked) or FALSE (if error)
;	file decriptors, via reference
; -----


global getFiles
getFiles:

;rdi - (value) arguments count 
;rsi - (value) arguments variable
;rdx - (address) readFile
;rcx - (address) writeFile

push rbx 
push r12 
push r13
push r14

	;if(arc = 1)
		cmp rdi, 1
		je usageMessage

	;if(arc < 5)
		cmp rdi, 5
		jb incomplete

	;if(arc > 5)
		cmp rdi,5
		ja tooMany

	;if(argv[1] != "-i")

		mov r10, qword[rsi+8]				;argv[1]

		cmp byte[r10], '-'
		jne inputSpec  						;argv[1][0] != '-'

		inc r10
		cmp byte[r10], 'i'
		jne inputSpec  						;argv[1][1] != 'i'

		inc r10
		cmp byte[r10], NULL
		jne inputSpec  						;argv[1][2] != NULL

	;if(argv[3] != '-o')

		mov r10, qword[rsi+24] 				;argv[3]

		cmp byte[r10], '-'
		jne outSpec  						;argv[1][0] != '-'

		inc r10
		cmp byte[r10], 'o'
		jne outSpec  						;argv[1][1] != 'o'

		inc r10
		cmp byte[r10], NULL
		jne outSpec  						;argv[1][2] != NULL

	;--------------------------------
	;CALLEE SAVED  VALUES
	
		mov rbx, rdx 						;get copy &readFile
		mov r12, rcx 						;get copy &writeFile
		mov r13, qword[rsi+16]  			;get copy of file to be read 
		mov r14, qword[rsi+32] 				;get copy of file to write to 

	;--------------------------------

	;if(!infile.good())
	;------
	;Attempt to open file to be read.
	;Use system service for file open

	; Returns:
	;if error -> eax < 0
	;if success -> eax = file descriptor number

		mov rax, SYS_open  					;system call code to open file 
		mov rdi, r13						;rdi = file name string (NULL terminated)
		mov rsi, O_RDONLY           		;read only 
		syscall 							;call the kernel

		cmp rax,0							;if error opening rax < 0
		jl readingError

		mov qword[rbx], rax  				;file descriptor of file to read 

	;----
	;if(!outfile.good())	

	;Use system service for file open

	; Returns:
	;if error -> eax < 0
	;if success -> eax = file descriptor number

		mov rax, SYS_creat  			;system call code to open/create file
		mov rdi, r14 					;rdi = file name string (NULL terminated)
		mov rsi, S_IRUSR|S_IWUSR		;read/write to file 
		syscall

		cmp rax, 0 						;if error open rax < 0
		jl writingError

		mov qword[r12], rax 			;file descriptor of file to write to 

	;----------------------------------

	;If all conditions were false then 
	;return description file and return TRUE 
		 
		mov rax, TRUE 			 			;return TRUE 	
		jmp endGetFiles

;-----------------------------------------
;Conditon 

	usageMessage:
		mov rdi, usageMsg 
		call printString
		mov rax, FALSE
		jmp endGetFiles

	incomplete:
		mov rdi, errIncomplete
		call printString
		mov rax, FALSE	
		jmp endGetFiles

	tooMany:
		mov rdi, errExtra
		call printString
		mov rax, FALSE	
		jmp endGetFiles

	inputSpec:
		mov rdi, errInputSpec
		call printString
		mov rax, FALSE	
		jmp endGetFiles

	outSpec:
		mov rdi, errOutputSpec
		call printString
		mov rax, FALSE	
		jmp endGetFiles

	readingError:
		mov rdi, errInputFile
		call printString
		mov rax, FALSE
		jmp endGetFiles

	writingError:
		mov rdi, errOutputFile
		call printString
		mov rax,FALSE	

endGetFiles:

pop r14
pop r13
pop r12
pop rbx 

ret 

; ***************************************************************
;  Get a block of text from file and return.

;  The block size is passed (and may vary).
;  Function terminates the block with a NULL.

;  This routine handles the I/O buffer manipulation.
;    1) if buffer is empty, get more chars from file
;    2) return block and update buffer pointers

;  When done reading input, returns actual number of
;  characters in the block.  The actual number may be
;  less than requested on final read operation.

;-----
; Psuedo Code of the Algorithm 
; i = 0
; GrabNext:
; 		if(curr >= buffEnd)
;		{
; 			if(eof)
;			{
;           	set rax to i 
; 				jmp to endofGB 
;         	}
;			read file (syscall)
; 			if(rax < 0)
;			{
;           	set rax to 0
; 				output readFile error  
; 				jmp to endofGB 
;         	}
; 			if(rax == 0)
;			{
;           	set rax to 0 
; 				jmp to endofGB 
;         	}   
; 			if(rax < BUFFSIZE)
;			{
;           	buffEnd = rax (readCharacters) 
; 				eof = TRUE  
;         	}
;			curr reset      
;		}
;		tempChr = buff[curr]
; 		curr++
;		block[i] = tempChr
; 		i++
;		if(i < BLOCKSIZE-1)
;          jmp GrabNext

;		block[i] = NULL
; 		set rax to i

global getBlock
getBlock:
;getBlock(readFile, block,requesteBlockSize);
; -----
;  Arguments passed:
;	input file descriptor, value (rdi)
;	address for block buffer, address (rsi)
;	requested block size, value (edx)
; -----
;  Returns
;	actual block size (rax)
; -----

	push rbx 
	push r12
	push r13
	push r14

		mov r14, 0			;clear
		;--------------------------------------
		;CALLEE SAVED  VALUES
		mov r12, rdi 					;file descriptor of readFile
		mov r13, rsi 					;block[]
		mov r14, rdx 					;blockSize		
		;--------------------------------------

		;-------
		;if(last)
		cmp byte[last], TRUE
		jne notLast 
			mov byte[last], FALSE
			mov rax,0 					;return 0
			jmp getBlockEnd
		notLast:

		mov rbx, 0						;i = 0

		GetNext:
			;--------
			;if(curr>=buffEnd)
			mov r10, qword[curr]
			cmp r10, qword[buffEnd]  			
			jb currNotGBuff

				;--------
				;if(eof)
				cmp byte[eof],TRUE		 						
				jne notEOF
					mov byte[r13+rbx],r11b
					mov byte[eof], FALSE
					mov byte[last],TRUE
					mov rax, rbx 			;return i 
					jmp getBlockEnd
				notEOF:

				;--------
				;readFile(syscall)	
				mov rax, SYS_read 		;system code to read a file 
				mov rdi, r12 			;File Descriptor
				mov rsi, buffer			;Address of where to place characters read 
				mov rdx, BUFF_SIZE		;characters to be Read(BUFFSIZE)
				syscall
				
				;--------
				;if(rax < 0)
				cmp rax, 0
				jge successfullyRead
					mov rdi, errFileRead
					call printString 	 	;display errorMessage
					mov rax, 0 				;return 0
					jmp getBlockEnd 		
				successfullyRead:

				;--------
				;if(rax == 0)
				cmp rax,0
				jne charactersRead
					mov rax,0 				;return 0
					jmp getBlockEnd
				charactersRead:

				;--------
				;if(rax < BUFFSIZE)
				cmp rax, BUFF_SIZE
				jge buffSizeRead
					mov qword[buffEnd], rax 	;buffEnd = characters Read
					mov byte[eof],TRUE
				buffSizeRead:

				mov qword[curr], 0  			;curr = 0

			currNotGBuff: 						;end of if(curr >= buffEnd)
			;-------

			mov r11, 0							;clear

			mov r10, qword[curr]				;get curr 
			mov r11b, byte[buffer+r10] 			;tempChr = buff[curr]			
			inc qword[curr] 					;curr++

			mov byte[r13+rbx],r11b 				;block[i]= tempChr
			inc rbx 							;i++

			cmp rbx,r14							;if(i < blocksize)
			jb GetNext

			mov byte[r13+rbx],r11b
			mov rax, rbx  						;return i 

		;end of GetNext 		

	getBlockEnd:							;end of getBlock

	pop r14
	pop r13
	pop r12
	pop rbx 

ret 

; ***************************************************************
;  Function to write a block of text to the file.
;	Note, buffering not required here.
;	The block size is passed.

; -----
;  Arguments passed:
;	value of file descriptor, output file (rdi)
;	address for block buffer (rsi)
;	number of characters in the block (rdx)
; -----
;  Returns
;	nothing
; -----

global putBlock
putBlock:
	
	mov rax, SYS_write
	syscall

	cmp rax, 0	
	jg noErrorWriting 
		mov rdi, errWrite
		call printString
	noErrorWriting:
	
ret 

; ***************************************************************
;  Edit line by removing all html formatting commands.
;	The HTML formatting is considered all characters between
;	the "<" and ">" symbols (inclusive).
;	Counts and reurns the edited block size
;		The edited block will be <= original block size

; -----
;  Arguments passed:
;	input block buffer, address (rdi)
;	actual input block size, value (rsi)
;	output block buffer, address (rdx)
; -----
;  Returns
;	block size of edited block
; -----

;Algorithm
;---------

;i=0
;count=0

;start:
;while(i < blockSize)
;{
;	chr = block[i]
;	if(chr == '<')
;		isHTML = TRUE
;	if(isHTML)
;	{
;		while(isHTML)
;		{
;			chr = block[i]
;			if(chr == '>')
;				isHTML=FALSE
;			i++
;			if(i<blockSize)
;				goto end
;		}
;	goto start 
;	}
; 	newBlock[count] = chr
; 	count++
;	i++
;}

global editBlock
editBlock:
	
	push rbx 
	push r12
	push r13
	 	
	 	mov r12, 0				;i = 0
	 	mov rbx, 0 				;count = 0
	 	mov r13, rsi 			;blocksize

	 	editLoop: 				

	 		cmp r12,r13 						;while(i<blockSize)
	 		jae endofEdit

	 		mov r10,0							;clear 
	 		mov r10b,byte[rdi+r12] 				;chr = block[i]

	 		cmp r10b,'<' 						;if(chr == '<')
	 		jne validChar
	 			mov byte[isHTML], TRUE
	 		validChar

	 		cmp byte[isHTML],FALSE	            ;if(isHTML)
	 		je continue

	 			ignoreChars:  					

	 				cmp byte[isHTML],FALSE				;while(isHTML)
	 				je stopIgnore

	 				mov r10,0							;clear 
	 				mov r10b,byte[rdi+r12] 				;chr = block[i]

	 				cmp r10b, '>' 						;if(chr = '>')
	 				jne notEndHTML 
	 					mov byte[isHTML], FALSE	 
	 				notEndHTML:

	 				inc r12 							;i++

	 				cmp r12,r13 						;if(i < blocksize)
	 				jae endofEdit

	 				jmp ignoreChars

	 			stopIgnore:

	 			jmp editLoop

	 		continue:

	 		mov byte[rdx+rbx], r10b 
	 		inc r12
	 		inc rbx

	 		jmp editLoop

	 	endofEdit:	

	 	mov byte[rdx+rbx],NULL 		;NULL terminate
	 	mov rax, rbx 				;return newBlocksize 

	pop r13
	pop r12
	pop rbx 

ret 

; ***************************************************************
;  Generic procedure to display a string to the screen.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

; -----
;  HLL Call:
;	printString(stringAddr);

;  Arguments:
;	address, string
;  Returns:
;	nothing

global	printString
printString:

; -----
;  Count characters to write.

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

	mov	rax, SYS_write	; system code for write()
	mov	rsi, rdi		; address of char to write
	mov	rdi, STDOUT		; file descriptor for std in
						; rdx=count to write, set above
	syscall				; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret

; ***************************************************************

