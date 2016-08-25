; *****************************************************************
;  Must include:
;	Lui Ruiz
;	assignmnet 5
;	CS 218 - 1001

; -----
;	Write a simple assembly language program to calculate the
;	information for a series of cubes; areas and volumes.
;	The information for the cubes are stored in an array.
;   Once the areas and volumes are computed, the program should
; 	find the minimum, maximum, middle value, sum, and average
;	for the areas and volumes.

; All data is treated as unsigned values

; *****************************************************************
;  Data Declarations

section	.data

; -----
;  Define constants

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
SYS_EXIT	equ	60			; call code for terminate

; -------------------------------------------------------------- 
;  Provided Data Set

sides	dw	 10,  14,  13,  37,  54 
		dw	 14,  29,  64,  67,  34 
		dw	 31,  13,  20,  61,  36 
		dw	 14,  53,  44,  19,  42 
		dw	 44,  52,  31,  42,  56 
		dw	 15,  24,  36,  75,  46 
		dw	 27,  41,  53,  62,  10 
		dw	 33,   4,  73,  31,  15 
		dw	  5,  11,  22,  33,  70 
		dw	 15,  23,  15,  63,  26 
		dw	 16,  13,  64,  53,  65 
		dw	 26,  12,  57,  67,  34 
		dw	 24,  33,  10,  61,  15 
		dw	 38,  73,  29,  17,  93 
		dw	 64,  73,  74,  23,  56 
		dw	  9,   8,   4,  10,  15 
		dw	 13,  23,  53,  67,  35 
		dw	 14,  34,  13,  71,  81 
		dw	 17,  14,  17,  25,  53 
		dw	 23,  73,  15,   6,  13 

length		dd	100 

caMin		dw	0 
caMid		dw	0 
caMax		dw	0 
caSum		dd	0 
caAve		dw	0 

cvMin		dd	0 
cvMid		dd	0 
cvMax		dd	0 
cvSum		dd	0 
cvAve		dd	0 

; -----
; Additional variables (if any)

dwSix		dw	6 
ddtest		dd 	0

; -------------------------------------------------------------- 
;  Uninitialized data 

section	.bss 

cubeAreas	resw	100 
cubeVolumes	resd	100 

; *****************************************************************
section .text 

global _start
_start:

;-----

	mov ecx, dword [length]				;set my counter 
	mov rsi, 0							;index = 0

	
	calculationLoop: 
		mov r8w, word [sides+(rsi*2)]	; r8d = sides[index],cubeArea
		movzx r9d, word [sides+(rsi*2)]	; r9d = sides[index],cubeVolume

		;cubeAreas[i] = 6 * sides[i]^2
		mov ax, r8w 						;ax(cubeArea(n))
		mul r8w								; ax = r8w^2
		mul word[dwSix]						; ax = 6 * r8w
		mov word[cubeAreas+(rsi*2)], ax 	; create Area array		

		mov eax,0							;clear 

		;cubeVolumes[i] = sides[i]^3
		mov eax, r9d						;eax(volumeArea(n))
		mul r9d								;r9d = r9d^2
		mul r9d 							;r9d = r9d^3
		mov dword[cubeVolumes+(rsi*4)],eax	;create Volume array

		inc rsi
		dec ecx
		cmp ecx,0
		jne calculationLoop

	;End of Calc Loop

	;---------
	;Find the min, max, and sum, for the total
	;area and volumes

	mov ecx, dword [length]				;reset my counter 
	mov rsi, 0							;index = 0

	mov r8w, word[cubeAreas]			;grab first elemnt of array
	mov word [caMin],r8w
	mov word [caMax],r8w

	mov r9d, dword [cubeVolumes]		;grab first elemnt of array
	mov dword [cvMin], r9d
	mov dword [cvMax], r9d
	mov dword [ddtest], r9d


	statsLoop:
		;------
		; Stats for the Area of Cube

		mov r8w, word [cubeAreas+(rsi*2)] 
		movzx r8d, r8w
		add dword[caSum], r8d

		cmp word [caMin], r8w
		jbe CA_notNewMin
		mov word [caMin], r8w			;then Min > r8w
		CA_notNewMin:

		cmp word [caMax], r8w
		jae CA_notNewMax
		mov word [caMax], r8w 			;then Min < r8w
		CA_notNewMax:

		;------
		;Stats for the Volume of Cube

		mov r9d, dword [cubeVolumes+(rsi*4)]
		add dword [cvSum], r9d

		cmp dword [cvMin], r9d
		jbe CV_notNewMin
		mov dword [cvMin], r9d
		CV_notNewMin:


		cmp dword [cvMax], r9d
		jae CV_notNewMax
		mov dword [cvMax], r9d
		CV_notNewMax:

		cmp rsi,49
		jne notMidValues

		;-------------------
		;Gathers the value of cubeAreas[49],[50]
		;and cubeVolumes and adds those 
		;respective to Area and Volumes
		add word [caMid],r8w
		add dword [cvMid],r9d
		inc rsi
		mov r8w, word [cubeAreas+(rsi*2)] 
		mov r9d, dword [cubeVolumes+(rsi*4)]
		add word [caMid],r8w
		add dword [cvMid],r9d
		dec rsi

		notMidValues:

		inc rsi

		dec ecx
		cmp ecx,0
		jne statsLoop
	
	;End of Stats Loop 

; *****************************************************************
;Find the Averages
	
	 mov rax, 0
	 mov rdx, 0
	
; Area Average

	mov eax, dword[caSum]
	mov edx,0
	idiv dword [length]
	mov word [caAve], ax


; Volume Average
	mov eax, dword[cvSum]
	mov edx,0
	div dword [length]
	mov dword [cvAve], eax

;Find the Mid
	shr word [caMid], 1				;The two sums divided by 2, Area
	shr dword [cvMid], 1			;The two sums divided by 2, Volume


; *****************************************************************
;	Done, terminate program.

last: 
	mov	eax, SYS_EXIT		; call code for exit (SYS_exit)
	mov	ebx, SUCCESS		; return SUCCESS (no error)
	syscall

; *****************************************************************