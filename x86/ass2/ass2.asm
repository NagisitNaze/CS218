;-------------------------
;		Luis Ruiz
;		Assignment 2
;		CS 218 - 1001
;		5001441817 
;-------------------------
; *****************************************************************
; -----
; Write a simple assembly language program to compute the following formulas:
;	bAns1  =  bVar1 + bvar2
;	bAns2  =  bVar1 - bvar2
;	wAns1  =  wVar1 + wvar2
;	wAns2  =  wVar1 - wvar2
;	dAns1  =  dVar1 + dVar2
;	dAns2  =  dVar1 - dVar2
; *****************************************************************
;-----
;  Data Declarations

section .data 
; -----
;  Define Constants.

NULL			equ		0		; end of string

TRUE			equ		1 
FALSE			equ		0

EXIT_SUCESS 	equ		0		; Successful operation 
SYS_EXIT		equ 	60 		; call code for termination

;----

bVar1			db		31
bVar2			db		13
bAns1			db		0
bAns2			db		0
wVar1			dw		3924
wVar2			dw		1943
wAns1			dw		0
wAns2			dw		0
dVar1			dd		174632105
dVar2			dd		124789360
dVar3			dd		-56237
dAns1			dd		0
dAns2			dd		0
flt1			dd		-14.25
flt2			dd		7.125
threePi			dd		9.42477
qVar1			dq		123169427153
myClass			db		"CS 218", NULL
edName			db		"Ed Jorgensen", NULL
myName			db		"Luis Ruiz", NULL

; *****************************************************************

section	.text
global _start
_start:

; -----
;	bAns1  =  bVar1 + bVar2
;	bAns2  =  bVar1 - bVar2

;	bAns1  =  bVar1 + bVar2
	mov al, byte [bVar1]
	add al, byte [bVar2]
	mov byte [bAns1], al 

;	bAns2  =  bVar1 - bVar2
	mov al, byte [bVar1]
	sub al, byte [bVar2]
	mov byte [bAns2], al 

; -----
;	wAns1  =  wVar1 + wVar2
;	wAns2  =  wVar1 - wVar2

;	wAns1  =  wVar1 + wVar2
	mov ax, word [wVar1]
	add ax, word [wVar2]
	mov word [wAns1], ax

;	wAns2  =  wVar1 - wVar2
	mov ax, word [wVar1]
	sub ax, word [wVar2]
	mov word [wAns2], ax 

; -----
;	dAns1  =  dVar1 + dVar2
;	dAns2  =  dVar1 - dVar2

;	dAns1  =  dVar1 + dVar2
	mov eax, dword [dVar1]
	add eax, dword [dVar2]
	mov dword [dAns1], eax

;	dAns2  =  dVar1 - dVar2
	mov eax, dword [dVar1]
	sub eax, dword [dVar2]
	mov dword [dAns2], eax 

; *****************************************************************
;	Done, terminate program.

last:
	mov eax, SYS_EXIT 		;call code for exit
	mov ebx, EXIT_SUCESS 	; exit program with success
	syscall