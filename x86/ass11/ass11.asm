;  CS 218 - Assignment #11
;  Functions Template

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

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

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
;BUFF_SIZE	equ	2			; buffer size

; -----
;  Variables for getFiles() function.

eof		db	FALSE

usageMsg	db	"Usage: ./remover -i <inputFileName> "
		db	"-o <outputFileName>", LF, NULL
errIncomplete	db	"Error, incomplete command line arguments.", LF, NULL
errExtra	db	"Error, too many command line arguments.", LF, NULL
errInputSpec	db	"Error, invalid input file specifier.", LF, NULL
errOutputSpec	db	"Error, invalid output specifier.", LF, NULL
errInputFile	db	"Error, unable to open input file.", LF, NULL
errOutputFile	db	"Error, unable to open output file.", LF, NULL

; -----
;  Variables for getBlock() function.

buffMax		dq	BUFF_SIZE
curr		dq	BUFF_SIZE
wasEOF		db	FALSE

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


;	YOUR CODE GOES HERE



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

; -----
;  Arguments passed:
;	input file descriptor, value
;	address for block buffer, address
;	requested block size, value
; -----
;  Returns
;	actual block size
; -----


;	YOUR CODE GOES HERE



; ***************************************************************
;  Function to write a block of text to the file.
;	Note, buffering not required here.
;	The block size is passed.

; -----
;  Arguments passed:
;	value of file descriptor, output file
;	address for block buffer
;	number of characters in the block
; -----
;  Returns
;	nothing
; -----


;	YOUR CODE GOES HERE



; ***************************************************************
;  Edit line by removing all html formatting commands.
;	The HTML formatting is considered all characters between
;	the "<" and ">" symbols (inclusive).
;	Counts and reurns the edited block size
;		The edited block will be <= original block size

; -----
;  Arguments passed:
;	input block buffer, address
;	actual input block size, value
;	output block buffer, address
; -----
;  Returns
;	block size of edited block
; -----


;	YOUR CODE GOES HERE



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

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of char to write
	mov	rdi, STDOUT			; file descriptor for std in
						; rdx=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret

; ***************************************************************

