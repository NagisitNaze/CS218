; *****************************************************************
;  Must include:
;	Lui Ruiz
;	assignmnet 4
;	CS 218 - 1001

; -----
;	Write a simple assembly language program to find the 
;	minimum, middle value, maximum, sum, and integer 
;	average of a list of numbers. 

;   Additionally, the program should also find the sum, count, and
;	integer average for the positive numbers. The program should also 
;	find the sum, count, and integer average for the numbers that 
;	are evenly divisible by 6. 

; *****************************************************************
;  Data Declarations

section .data 
;-------
;Define Constants

SUCCESS				equ 	0 	; Successful operation
SYS_EXIT			equ 	60 	; call code for terminate

;-----------------
; Assignment 4 Data Decleration 

;---- 
; double-word data 

lst			dd	 1246,  1116,  1542,  1240,  1677
			dd	 1635,  2426,  1820,  1246, -2333
			dd	 2317, -1115,  2726,  2140,  2565
			dd	 2871,  1614,  2418,  2513,  1422
			dd	-2119,  1215, -1525, -1712,  1441
			dd	-3622,  -731, -1729,  1615,  1724
			dd	 1217, -1224,  1580,  1147,  2324
			dd	 1425,  1816,  1262, -2718,  2192
  			dd	-1432,  1235,  2764, -1615,  1310
			dd	 1765,  1954,  -967,  1515,  3556
			dd	 1342,  7321,  1556,  2727,  1227
			dd	-1927,  1382,  1465,  3955,  1435
			dd	-1225, -2419, -2534, -1345,  2467
			dd	 1315,  1961,  1335,  2856,  2553
  			dd	-1032,  1835,  1464,  1915, -1810
			dd	 1465,  1554, -1267,  1615,  1656
			dd	 2192, -1825,  1925,  2312,  1725
			dd	-2517,  1498, -1677,  1475,  2034
			dd	 1223,  1883, -1173,  1350,  1415
			dd	  335,  1125,  1118,  1713,  3025

len				dd	100
	
lstMin			dd	0
lstMid			dd	0
lstMax			dd	0
lstSum			dd	0
lstAve			dd	0

posCnt			dd	0
posSum			dd	0
posAve			dd	0

sevenCnt		dd	0
sevenSum		dd	0
sevenAve		dd	0


; *****************************************************************

section .text 

global _start
_start:

;-----
; General loop that will be used 

	mov ecx, dword[len]				;grab length of list
	mov rsi, 0 						;index = 0


	mov r8d, dword [lst]			
	mov dword[lstMin],r8d			;Grab the first element in the
	mov dword[lstMax],r8d			;In the array 


generalLoop:
	mov eax, dword [lst+(rsi*4)]	;list[index], grabs one element at a time
	;SUM of entire List
	add dword [lstSum], eax			;Sum = Sum + list[index], this sum includes
									;the values in the list

	;Grab the Min from Entire List
	cmp dword[lstMin],eax
	jg getMin						;list[index] < r8d (current Min)
	endOfMin:

	;Grab the Max from Entire List
	cmp dword[lstMax],eax
	jl getMax 						;list[index] > r9d (current Max)
	endOfMax:

	;Grabs the Value in the middle of the List
	cmp rsi, 49						
	je middleValue 	
	cmp rsi,50
	je middleValue				
	endOfMiddle:

	;Check if the Value is positive
	cmp eax,0
	jg positive						;list[index] > 0
	endOfPostive:

	;Check if the Value is Divisible by 6
	mov r15d, eax 					;retain the value of list[index]
	mov r10d,7						;store 7 in r10d 
	cdq 							;lis[index]=eax -> edx:eax					
	idiv r10d
	cmp edx,0						;if edx = Remain is equal to 0
	je 	DivBy6 						;if div by 6 jump to label
	endOfdivBy6:		

	inc rsi 						;rsi += 1
	dec ecx							;ecx-= 1, this will be done
	cmp ecx,0						;until ecx == 0
	jne generalLoop 				;ecx != 0 continue

;End of Loop 

;****************************************************************
;Solving for the averages
	
	;Solve for the Average of the List
	mov r15d, dword [len]
	mov eax, dword [lstSum]
	cdq							;eax -> edx:eax
	idiv r15d					;(edx:eax)/length of list
	mov dword[lstAve], eax

	;Solve for the Average of the Pos List
	mov r15d, dword [posCnt]
	mov eax, dword [posSum]
	cdq 						;eax -> edx:eax
	idiv r15d					;(edx:eax)/length of postive List
	mov dword [posAve], eax

	;Average from divisible by 6
	mov r15d, dword [sevenCnt]
	mov eax, dword [sevenSum]
	cdq 						;eax -> edx:eax
	idiv r15d					;(edx:eax)/length of  div by 6 List
	mov dword [sevenAve], eax

	;Take Average
	shr dword [lstMid], 1

	jmp last 					;go straight to terminate program
;****************************************************************
;Conditional Statements that will be used within the loop 

getMin:
	mov dword [lstMin], eax 	;Min = current Min
	jmp endOfMin

getMax: 
	mov dword [lstMax], eax		;Max = current Max
	jmp endOfMax

middleValue:
	add dword[lstMid], eax
	jmp endOfMiddle

positive:
	inc dword [posCnt]
	add dword [posSum], eax
	jmp endOfPostive

DivBy6:
	inc dword [sevenCnt]
	add dword [sevenSum], r15d	;recall r15d holds the original
	jmp endOfdivBy6

; *****************************************************************
;	Done, terminate program.

last: 
	mov	eax, SYS_EXIT		; call code for exit (SYS_exit)
	mov	ebx, SUCCESS		; return SUCCESS (no error)
	syscall

; *****************************************************************
 