;  CS 218 - Assignment 8

;  Luis Ruiz 
;  Section - 1001
;  NSHE: 5001441817

;  Procedures Template.

; --------------------------------------------------------------------
;  Write assembly language procedures/functions.

;  * void function, cocktailSort(), sorts the numbers into descending
;    order (large to small).  Uses the cocktail sort algorithm from
;    assignment #7 (modified to sort in descending order).

;  * void function, cubeAreas(), to find the area of each cube for a
;    series of cubes (in an array).

;  * void function, cubeStats(), finds the minimum, maximum, median, sum,
;    average, and sum numbers evenly divisible by 4 for a list of
;    sorted numbers.

;  * integer function, iMedian(), to compute and return the integer
;    average for a list of numbers.  Note, for an odd number of items,
;    the median value is defined as the middle value.  For an even number
;    of values, it is the integer average of the two middle values.

;  * integer function, mStatistic(), to compute and return the integer
;    m-statistic.  Summation and division performed as integer values.
;    Due to the data sizes, the summation for the dividend (top)
;    must be performed as a quad-word.

;  Note, all data is signed!

; ********************************************************************************

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation

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
NULL		equ	0
ESC		equ	27

; -----
;  Variables for cocktailSort() void function (if any)

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



; **************************************************************************

section	.text

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
		jl getAreas     ;do while (i < len)

	mov rdx,0			;clear
	mov rdx,r8			;place original back 

	pop r8
	pop rcx 			;epilogue 
	pop rax 	

ret


ret

; **************************************************************************
;  Function to implement bubble sort to srot an integer array.
;	Note, sorts in desending order

; -----
;  HLL Call:
;	cockatilSort(list, len);

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
			jge leftValueisSmaller 			

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
			mov r15d, dword[rdi+(rax*4)-4]		;list[i-1]

			cmp r14d,r15d 					;if lst[i] < lst[i+1],swap 
			jle rightValueisSmaller 		

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
;	minimum, median, maximum, sum, average, sum of numbers
;       evenly divisible by 4
;  Note, Assumes the list is already sorted.

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
;	minimum, maximum, sum, average, and threeSum,
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
;	Formula for m-statistic is:
;		mStat = sum [ (list[i] - median)^2 ]
;	Must use iMedian() function to find median.

; -----
;  HLL Call:
;	mStat = mStatistic(list, len);

;  Arguments Passed:
;	1) list, addr 		- rdi 
;	2) length, value 	- esi 

;  Returns:
;	m-statistic - value (in rax)

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
			jl mStatLoop 	 			;do while i < length-1 

			mov rax, rbx 
			;when i exit value remain in rax 

	pop rbx 
	pop rdx 
	pop rcx 


ret

; ***************************************************************************

