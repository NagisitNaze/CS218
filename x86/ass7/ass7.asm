;  CS 218, Assignment #7

;  Luis Ruiz 
;  Section - 1001
;  NSHE: 5001441817

; Write a simple assembly language program to sort a list of integer
; numbers into ascending (small to large) order.  Additionally, find the
; minimum, median, maximum, sum, and average of the list.  You should
; find the minimum and maximum after the list is sorted (i.e.,
; min=list[len-1] and max=list[0])

; =====================================================================

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

LF			equ	10
SPACE		equ	" "
NULL		equ	0
ESC			equ	27

; -----
;  Provided Data

lst	dd	123,  42, 146,  76, 120,  56, 164,  65, 155,  57
	dd	111, 188,  33,  05,  27, 101, 115, 108,  13, 115
	dd	 17,  26, 129, 117, 107, 105, 109,  30, 150,  14
	dd	147, 123,  45,  40,  65,  11,  54,  28,  13,  22
	dd	 69,  26,  71, 147,  28,  27,  90, 177,  75,  14
	dd	181,  25,  15,  22,  17,  11,  10, 129,  12, 134
	dd	 61,  34, 151,  32,  12,  29, 114,  22,  13, 131
	dd	127,  64,  40, 172,  24, 125,  16,  62,   8,  92
	dd	111, 183, 133,  50,   2,  19,  15,  18, 113,  15
	dd	 29, 126,  62,  17, 127,  77,  89,  79,  75,  14
	dd	114,  25,  84,  43,  76, 134,  26, 100,  56,  63
	dd	 24,  16,  17, 183,  12,  81, 320,  67,  59, 190
	dd	193, 132, 146, 186, 191, 186, 134, 125,  15,  76
	dd	 67, 183,   7, 114,  15,  11,  24, 128, 113, 112
	dd	 24,  16,  17, 183,  12, 121, 320,  40,  19,  90
	dd	135, 126, 122, 117, 127,  27,  19, 127, 125, 184
	dd	 97,  74, 190,   3,  24, 125, 116, 126,   4,  29
	dd	104, 124, 112, 143, 176,  34, 126, 112, 156, 103
	dd	 69,  26,  71, 147,  28,  27,  39, 177,  75,  14
	dd	153, 172, 146, 176, 170, 156, 164, 165, 155, 156
	dd	 94,  25,  84,  43,  76,  34,  26,  13,  56,  63
	dd	147, 153, 143, 140, 165, 191, 154, 168, 143, 162
	dd	 11,  83, 133,  50,  25,  21,  15,  88,  13,  15
	dd	169, 146, 162, 147, 157, 167, 169, 177, 175, 144
	dd	 27,  64,  30, 172,  24,  25,  16,  62,  28,  92
	dd	181, 155, 145, 132, 167, 185, 150, 149, 182,  34
	dd	 81,  25,  15,   9,  17,  25,  37, 129,  12, 134
	dd	177, 164, 160, 172, 184, 175, 166,  62, 158,  72
	dd	 61,  83, 133, 150, 135,  31, 185, 178, 197, 185
	dd	147, 123,  45,  40,  66,  11,  54,  28,  13,  22
	dd	 49,   6, 162, 167, 167, 177, 169, 177, 175, 164
	dd	161, 122, 151,  32,  70,  29,  14,  22,  13, 131
	dd	 84, 179, 117, 183, 190, 100, 112, 123, 122, 131
	dd	123,  42, 146,  76,  20,  56,  64,  66, 155,  57
	dd	 39, 126,  62,  41, 127,  77, 199,  79, 175,  14

len	dd	350

min	dd	0
med	dd	0
max	dd	0
sum	dd	0
avg	dd	0

; **************************************************************

section .text 

global _start
_start: 

;-----
; cocktailSort(list, listLength)
	mov esi, dword [len] 		; 2nd arg, value of length
	mov rdi, lst				; 1st arg, address of list

	call cocktailSort

;*************************
;Find the min, max, and sum, of the given list 

;Recall rdi contains the address of the first element in the array lst

mov rsi, 0						;clear rsi 
mov rsi, qword[len]				;get the length as a quad
mov rax, 0						;clear
mov rbx, 0						;i = 0
dec rsi 						;get length-1

;----------------------
;get min and max 
mov r8d, dword[rdi]				;get first element in the list
mov dword[min], r8d				;get Min
mov r8d, dword [rdi+(rsi*4)]	;get the last element in list
mov dword[max], r8d				;get Max

;---------------
;get the sum 
sumLoop: 
	mov eax, dword[rdi+(rbx*4)]	;lst[i]
	add dword[sum], eax			;get the sum 

	inc rbx						;i +=1
	cmp ebx, dword[len] 
	jb sumLoop 

;----
;Average
mov eax,dword[sum]
mov rdx, 0			;edx:eax
div dword[len]		;edx:eax/length
mov dword[avg], eax 	

;Mid
mov rax, 0			;clear
movsxd rax, dword[len]	;length is unsigned so zero is extended
mov rdx,0			;rdx:rax
mov rbx,2
div rbx				;rdx:rax / 2

cmp rdx,0
je evenList

;oddList
mov r9d,0						;clear

mov r9d, dword[lst+(rax*4)]		;grab the middle value
mov dword[med], r9d
jmp medDone

evenList:

mov rdx,0
mov edx, dword [lst+(rax*4)]		;length/2
add dword[med], edx
dec rax 							;(length/2)-1
mov edx, dword [lst+(rax*4)]
add dword[med], edx
shr dword[med], 1					;sum of two median /2

medDone:

; ------------------------
;  Done, terminate program.

last: 
mov rax, SYS_exit
mov rbx, SUCCESS
syscall
;end of main 

; ***************************************************************

;HLL call:
;cocktailSort(lst, len)
;-----

global cocktailSort
cocktailSort: 
;------
;Arguments:
;lst, address - rdi 
;len, value - rsi

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
			jle leftValueisSmaller 			

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
			jge rightValueisSmaller 		

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


ret 

