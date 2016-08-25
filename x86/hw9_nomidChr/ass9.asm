;  CS 218 - Assignment 9

;  Luis Ruiz 
;  Section - 1001
;  NSHE: 5001441817

;  Functions Template

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
	push r12

	mov r12, 0					;clear
	mov r12d, dword[len]		;get Length
	dec r12d 					;length - 1 

	mov dword [%2], 0			; make sure tempInt = 0
	mov rcx, r12				; set exp 2^expo
	mov rsi, %1					; get base address


	%%convertLoop:	
		mov r12,0				;clear
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
		jne  %%convertLoop	

	pop r12
	pop r9	
	pop rsi 
	pop rcx						;regain original value back 

%endmacro


; --------------------------------------------------------------------
;  Write assembly language functions.

;  * value returning function, readBinaryNum(), to read an ASCII
;    binary number from input, convert to integer, and return

;  * Void function, cocktailSort(), sorts the numbers into ascending
;    order (small to large).

;  * Void function, cubeStats(), finds the minimum, maximum, median, sum
;    of even numbers, and sum of odd numbers for a list of sorted numbers.

;  * Integer function, iMedian(), to compute and return the integer
;    average for a list of numbers.  Note, for an odd number of items,
;    the median value is defined as the middle value.  For an even number
;    of values, it is the integer average of the two middle values.

;  * Integer function, mStat(), to compute and return the integer
;    m-statistic.  Summation and division performed as integer values.
;    Due to the data sizes, the summation for the dividend (top)
;    must be performed as a quad-word.


;  Note, all data is signed!

; ********************************************************************************

section	.data

; -----
;  Define standard constants

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1

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

LF			equ	10
NULL		equ	0
ESC			equ	27

BUFFSIZE	equ	50
MINNUMBER	equ	1
MAXNUMBER	equ	1000

OUTOFRANGEMIN	equ	2
OUTOFRANGEMAX	equ	3
INPUTOVERFLOW	equ	4
ENDOFINPUT		equ	5

;------
;Length 
len 	dd 	0

; -----
;  Local variables for cocktailSort() void function (if any)

swapped		db	FALSE

; -----
;  Variables for cubeAreas() void function (if any)

ddSix 		dd 		6

; -----
;  Variables for cubeStats() void function (if any)

ddFour 		dd 		4	

; -----
;  Variables for integer iMedian() function (if any)


; -----
;  Variables for integer mStatistic() function (if any)
 
;-----------------------------
;Unitalized Data
section .bss 

binaryString resb 	BUFFSIZE+2		;total of 52
chr 		 resb	1


; **************************************************************************

section	.text

; -----------------------------------------------------------------------
;  Function to read an ASCII binary number from the user.
;	Note, the prompt and error messages are handled by
;	the calling routine.

; -----
;  HLL Call:
;	status = readBinaryNum(&numberRead);

;  Arguments Passed:
;	1) numberRead, addr - rdi

;  Returns:
;	number read (via reference)
;	status code (as above)

;  Return codes:
;	SUCCESS				Successful conversion
;	NOSUCCESS			Invalid input entered
;	OUTOFRANGEMIN		Input below minimum value
;	OUTOFRANGEMAX		Input above maximum value
;	INMPUTOPVERFLOW		User entered char count exceeds maximum len
;	ENDOFINPUT			End of the input

global readBinaryNum
readBinaryNum:

push rsi ;prologue 
push rcx
push rdx
push rbx 
push r12
push r8

	mov r8,rdi 							;hold address &numRead 

	mov rbx, binaryString 				;grab the base Address
	mov r12,0							;i = 0
	mov dword[len], 0					;zero out the length

	;---------------------------------------------
	;read the charcters from the user(one at a time)

	leadingSpace:
		mov rcx, 0

		mov rax, SYS_read 		;system code for read 
		mov rdi, STDIN	 		;standard in 
		mov rsi, chr 			;address of chr 
		mov rdx, 1				;how many charcters to read 
		syscall 			

		mov rcx, 0				;clear
		mov cl, byte[chr]		;get charcters just to read 
		cmp cl, LF		        ;if lineFeed, input is done 
		je readDone

		cmp cl, 0x09			;if tab skip character
		je leadingSpace

		cmp cl, 0x20			;if space skip character
		je leadingSpace

		jmp firstChr 			;if non of the above conditions meet then grab the first charcter
			

	readCharacters:
		mov rax, 0				;clear 
		mov rcx, 0

		mov rax, SYS_read 		;system code for read 
		mov rdi, STDIN	 		;standard in 
		mov rsi, chr 			;address of chr 
		mov rdx, 1				;how many charcters to read 
		syscall 			

		mov rcx, 0				;clear
		mov cl, byte[chr]		;get charcters just to read 
		cmp cl ,LF		        ;if lineFeed, input is done 
		je readDone

		firstChr:

		inc r12 				;i++
		cmp r12, BUFFSIZE 		;if #chars >= BUFFSIZE
		jae readCharacters		; stop placing in buffer 

		mov byte[rbx], cl 	;binaryString[i] = chr 
		inc rbx				;incremnt my address

		jmp readCharacters

	readDone: 					;done reading

	;-------
	;Condition overFlow and or no charcters entered

	cmp r12, BUFFSIZE			;if less MAXNUMBER	
	jg overFlow 	 			;go to the 

	cmp r12,0
	je noInput 					;give end of Input

	mov byte[binaryString+r12],NULL ;PLACE NULL AT THE LAST CHARACTER
	
	mov dword[len], r12d 		;give length its value 

	;-----------------------------------------------------
	;this loop will check if the user input
	;is an ASCII binary number 

	;r12 contains the string length

	mov rcx, 0				;i = 0

	mov rbx, binaryString 	;get the base address of binaryString

	binaryCheck:
		mov rax, 0 				;clear
		mov al, byte[rbx+rcx] 	;binaryString[i]

		cmp al, 0x30			;if binaryString = '0'
		jl notBinary 			;then its not a '1' or '0'

		cmp al, 0x31   			;if binaryString = '1'
		ja notBinary			;then its not a '1' or '0'

		inc rcx

		cmp rcx,r12
		jb binaryCheck

	;------------------------------------------------------
	;Check if greater than min or max 
	;r12 contains the string length
	;r8 hold of the &integer to be returned 

	mov rbx, binaryString

	abin2int rbx, r8 				;call macro to convert ASCII binary into a integer
	mov rsi, 0						;clear
	mov esi, dword[r8]				;check value

	cmp esi, MINNUMBER 				;if less MINNUMBER
	jb  lessThanMin 				;go to the lessThanMin

	cmp esi, MAXNUMBER 				;if less MAXNUMBER
	ja  greaterThanMax 				;go to the greaterThanMax

	;----------------------------------
	;if all the excepetions are met 
	;SUCCESS is passed back 

	mov rax, SUCCESS
	jmp end

	;-----------------------------------	
	;Conditons

	overFlow:
	mov rax, INPUTOVERFLOW
	jmp end 

	notBinary:
	mov rax, NOSUCCESS  
	jmp end 

	lessThanMin:
	mov rax, OUTOFRANGEMIN
	jmp end

	greaterThanMax:
	mov rax, OUTOFRANGEMAX
	jmp end

	noInput:
	mov rax, ENDOFINPUT

end:	 					;will indicate the end of the function


pop r8
pop r12
pop rbx			;epilogue 
pop rdx 
pop rcx 
pop rsi 

ret

; **************************************************************************
;  Function to calculate cube areas
;	cubeAreas[i] = 6 ∗ sides[i]^2

; -----
;  Call:
;	cubeAreas(cSides, len, cAreas);

;  Arguments Passed:
;	1) cube sides array, addr
;	2) length, value
;	3) cube areas array, addr

;  Returns:
;	cAreas[] via reference

global cubeAreas
cubeAreas:

;cubeAreas = 6 *sides^2

	push rax			;prologue 
	push rcx 
	push r8

	mov r8, rdx 		;r8 = &cAreas (address)
	mov rdx, 0			;clear
	mov rax, 0			;clear  
	mov rcx, 0			;clear and i = 0

	getAreas:
		mov eax, dword[rdi+(rcx*4)]	;cSides[i]
		imul eax 					;sides^2
		imul dword [ddSix] 			;cubeAreas[i] = 6*sides^2 	

		mov dword[r8+(rcx*4)],eax	;cAreas[i] = cubeAreas[i]



		inc rcx 		; i += 1
		cmp ecx,esi 
		jb getAreas     ;do while (i < len)

	mov rdx,0			;clear
	mov rdx,r8			;place original back 

	pop r8
	pop rcx 			;epilogue 
	pop rax 	

ret

; **************************************************************************
;  Function to implement cocktail sort to sort an integer array.
;	Note, sorts in desending order

; -----
;  HLL Call:
;	cocktailSort(list, len);

;  Arguments Passed:
;	1) list, addr
;	2) length, value

;  Returns:
;	sorted list (list passed by reference)

; -----
;  Cocktail Sort Algorithm:

;	bottom = 0
;	top = list_length - 1
;	swapped = true
;	while(swapped == true)			// if no elements have been
;						// swapped, then list is sorted
;	{
;		swapped = false
;		for(i = bottom; i < top; i = i + 1)
;		{
;		if(list[i] > list[i + 1])	// test iftwo elements are
;						// in the correct order
;		{
;		   swap(list[i], list[i + 1])	// let the two elements
;						// change places
;		   swapped = true
;		}
;	}
;						// decreases `top` because the
;						// element with the largest
;						// value in the
;					        // unsorted part of the list
;						// is now on the position top
;	top = top - 1;
;	for(i = top; i > bottom; i = i - 1)
;	{
;		if(list[i] < list[i - 1])
;		{
;		   swap(list[i], list[i - 1])
;		   swapped = true
;		}
;	}
; }


global	cocktailSort
cocktailSort:
;------
;Arguments:
;lst, address - rdi 
;len, value - esi

push rax 
push r12
push r14
push r15

	mov r10d, 0						;bottom = 0 (r10) initally

	mov r11d, esi 	
	dec r11d						;r11 = length - 1 (top)

	mov r12, TRUE					;swapped (r12) = true 

	whileLoop:

		cmp r12, TRUE				;while (swapped == true)
		jne endofWhile

		mov r12, FALSE				;(r12) swapped = FALSE

		mov rax, 0

		;************************************************
		;First for loop 

		mov eax, r10d  				;i = bottom (r13 = i) 

		forLoop1:

			cmp eax, r11d			;if i < top continue 
			jae endofFL1 			;else i >= top exit 

			mov r14d, dword[rdi+(rax*4)]	;lst[i]
			mov r15d, dword[rdi+(rax*4)+4]	;list[i+1]

			cmp r14d,r15d					;if lst[i] > lst[i+1],swap 
			jae leftValueisSmaller 			

			mov	dword [rdi+(rax*4)+4], r14d	 
			mov dword [rdi +(rax*4)], r15d
			mov r12 , TRUE					;(r12) swapped = TRUE

			leftValueisSmaller:


			inc eax							; i += 1
			jmp forLoop1

		endofFL1:

		;************************************************
		;Second for loop 	
		mov rax, 0

		dec r11d					;top = top - 1
		mov eax, r11d 				;i = top (r13 = i)
		

		forLoop2:

			cmp eax, r10d			;if i > bottom continue 
			jbe endofFL2 			;else i <= top exit 

			mov r14d, dword[rdi+(rax*4)]			;lst[i]
			mov r15d, dword[rdi+(rax*4)-4]			;list[i-1]

			cmp r14d,r15d 					;if lst[i] < lst[i+1],swap 
			jbe rightValueisSmaller 		

			mov dword[rdi+(rax*4)], r15d
			mov dword[rdi+(rax*4)-4], r14d

			mov r12, TRUE					;(r12) swapped = TRUE

			rightValueisSmaller:

			dec eax						; i -= 1
			jmp forLoop2

		endofFL2:

		;**************************
		;While loop content excluding forloops

		inc r10d  							;bottom += 1
		jmp whileLoop

	endofWhile:

pop r15
pop r14
pop r12
pop rax

ret 

; **************************************************************************
;  Function to find some statistical information of an integer array:
;	minimum, maximum, sum, average, and sum numbers
;	evenly divisible by 4
;  Note, you may assume the list is already sorted.

; -----
;  HLL Call:
;	cubeStats(list, len, min, max, sum, ave, fourSum);

;  Arguments Passed:
;	1) list, addr
;	2) length, value
;	3) minimum, addr
;	4) maximum, addr
;	5) sum, addr
;	6) average, addr
;	7) fourSum, addr

;  Returns:
;	minimum, maximum, sum, average, fourSum,
;	via pass-by-reference


global cubeStats
cubeStats:

push rbp 			;prologue 
mov rbp, rsp		;rbp points to itself 
push rax 
push rbx 
push r15


	;Get Min and Max 
	mov rax,0				;clear
	mov r15,0				;clear
	mov r15d, dword [rdi]	;cAreas[0] = Max
	mov dword[rcx],r15d 	;get Max

	movsxd rax, esi 				;rax and since it length its unsigned
	dec rax 						;length-1
	mov r15d, dword[rdi+(rax*4)]	;cAreas[length-1]=Min
	mov dword[rdx], r15d			;get Min

	;Get Sum and sum of fourSum

	mov rcx,0			;i = 0
	mov rbx,0			;forSum = 0
	mov dword[r8],0		;sum = 0

	statsLoop:	
		mov rdx,0					;clear
		mov rax,0					;clear

		mov eax, dword[rdi+(rcx*4)]	;cAreas[i]
		add dword[r8], eax			;regular Sum 

		;check if divsible by 4
		cdq 						;edx:eax
		idiv dword [ddFour] 		;edx:eax/4

		cmp edx,0	
		jne notDivBy4

		mov eax, dword[rdi+(rcx*4)]	;cAreas[i]
		add ebx, eax				;get fourSum

		notDivBy4:


		inc rcx 					; i += 1
		cmp ecx,esi 
		jb statsLoop    		 	;do while (i < len)

	mov rax,0					;clear
	mov rax , qword[rbp+16]		;get forSum Address

	mov dword[rax],0			;fourSum = 0
	mov dword[rax],ebx 			;place value in forSUm

	;Get Int Ave of Sum 
	mov rax, 0 						;clear
	mov eax, dword[r8]				;get Sum 
	cdq 							;edx:eax 
	idiv esi 						;edx:eax / length
	mov dword [r9], eax 			;grab result = ave 

pop r15
pop rbx 
pop rax 
pop rbp 	;epilogue  	

ret

; **************************************************************************
;  Function to calculate the integer median of an integer array.
;	Note, for an odd number of items, the median value is defined as
;	the middle value.  For an even number of values, it is the integer
;	average of the two middle values.

; -----
;  HLL Call:
;	med = iMedian(list, len);

;  Arguments Passed:
;	1) list, addr - 8
;	2) length, value - 12

;  Returns:
;	integer median - value (in eax)

global iMedian
iMedian:

push rbx 
push rdx
push r8

	mov rax, 0
	mov rdx, 0
	mov r8,2

	movsxd rax, esi 	; get length 
	div r8				;rdx:rax/2 unsigned division 

	mov r8,0			;clear

	cmp rdx, 0
	je evenList

	;odd list 
	mov r8d, dword[rdi+(rax*4)]
	mov rax,0				;clear
	mov eax, r8d			;leave value in A reg and return 
	jmp medDone

	evenList:
	add r8d, dword[rdi+(rax*4)]		;cAreas[(length/2)]
	add r8d, dword[rdi+(rax*4)-4]	;cAreas[(length/2)-1]
	sar r8d,1					;r8/2(signed)
	mov rax,0					;clear
	mov eax,r8d 				;place value to be return 

	medDone:

pop r8
pop rdx
pop rbx

ret

; **************************************************************************
;  Function to calculate the integer m-statictic of an integer array.
;	Formula for mStat is:
;		mStat = sum [ (list[i] - median)^2 ]
;	Must use iMedian() function to find median.

; -----
;  HLL Call:
;	var = mStatistic(list, len);

;  Arguments Passed:
;	1) list, addr
;	2) length, value

;  Returns:
;	mStat - value (in rax)

global mStatistic
mStatistic:

	push rcx 
	push rdx 
	push rbx 

		mov rax, 0		;clear 
		mov rcx, 0		;clear 
		mov r10, 0		;clear
		movsxd r11, esi	;place length-1 in reg64
						;use r11 because rdx will be needed
						;for arithmetic operation

		mStatLoop:	

			mov r10, 0					;clear
			call iMedian 				;eax now has a value 
			cdqe 						;eax->rax 

			mov r10d,dword[rdi+(rcx*4)]	;cAreas[i]

			sub r10, rax 				;cAreas[i]-rax
			mov rax, r10 				;get the mStat value 
			imul rax 					;(cAreas[i]-rax)^2


			add rbx, rax				;get sum 

			inc rcx 
			cmp rcx, r11 				
			jb mStatLoop 	 			;do while i < length-1 

			mov rax, rbx 
			;when i exit value remain in rax 

	pop rbx 
	pop rdx 
	pop rcx 


ret

; ***************************************************************************

