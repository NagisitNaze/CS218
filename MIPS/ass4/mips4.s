#  CS 218, MIPS Assignment #4

#Luis Ruiz 
#Section 1001

#  Write an assembly language function to
#  calculate and display Collatz sequences.

#####################################################################
#  data segment

.data

# -----
#  Constants

TRUE = 1
FALSE = -1

N_MIN = 1
N_MAX = 715000001

# -----
#  Variables for main

hdr:			.ascii	"\nMIPS Assignment #4\n"
				.asciiz	"Collatz Conjecture Program\n"
collatzTitle:	.asciiz	"\nCollatz() Sequence:\n"
progDone:		.asciiz	"\nProgram Terminated.\n"
collSteps:		.asciiz	"\n\nCollatz() Steps: "

n:		.word	0
collatzCount:	.word	0


# -----
#  Local variables for readn() function.

pmt:		.ascii	"\n**********************************************"
			.asciiz	"\nInteger value for Collatz Conjecture:\n\n"
npmt:		.asciiz	"  Enter n (1 - 715,000,001): "

err1:		.ascii	"\nError, n value must be between 1 and 715,000,001 \n"
			.asciiz	"Please re-enter data.\n"

spc:		.asciiz	"   "
nline:		.asciiz	"\n"


# -----
#  Local variables for collatz function.

collNumber:	.asciiz	"\n   collatz() = "


# -----
#  Local variables for continue.

upmt:		.asciiz	"\nEnter another number (Y/y/N/n)? "
anerr:		.asciiz	"Error, must answer with (Y/y/N/n)."

ans:		.space	3


#####################################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Function to read and return N value.

computeCollatzSequence:

	sw	$zero, collatzCount		# re-set collatz counter.

	jal	readn
	sw	$v0, n

# -----
#  Compute Collatz Sequence.

	la	$a0, collatzTitle
	li	$v0, 4
	syscall

	lw	$a0, n
	jal	collatz

	sw	$v0, collatzCount		# save since $v0 must be reused.

# -----
#  Display counter for collatz() function.

	la	$a0, collSteps
	li	$v0, 4
	syscall

	lw	$a0, collatzCount
	li	$v0, 1
	syscall

# -----
#  See if user want to continue?

	jal	continue
	beq	$v0, TRUE, computeCollatzSequence

	li	$v0, 4
	la	$a0, progDone
	syscall

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall					# all done...
.end main


#####################################################################
#  Read N value.
#  Ensure that user enterd N value is >= N_MIN and N <= N_MAX.

# -----
#    Arguments:
#	none
#    Returns:
#	$v0 - user entered N value

.globl readn
.ent readn
readn:

#----
#prologue 
subu $sp, $sp, 4
sw $s0, 0($sp)

	#----

	checkLoop:

		#promt 
		la $a0, pmt
		li $v0, 4
		syscall

		#enter number promt
		la $a0, npmt
		li $v0, 4
		syscall

		#read number input 
		li $v0, 5
		syscall

		move $s0, $v0				#grab n 

		bge $s0, N_MIN, GEMIN 		#n >= 1
			b invalidNumber  		#if (n < 1)
		GEMIN:

		ble $s0,N_MAX, LTEMAX 		#n <= 715,000,001
			b invalidNumber 		#if(n > 715,000,001)
		LTEMAX:

		b validNumber 				

	invalidNumber:
		#print Error
		la $a0, err1
		li $v0, 4
		syscall

		b checkLoop					#go back and check if user 
									#entered a valid Number

	validNumber:
		move $v0, $s0 				#return n in $v0

	#----

#epilogue 
lw $s0, 0($sp)
addu $sp, $sp, 4
#----

jr $ra 

.end readn

#####################################################################
#  Function to compute Collatz sequence.

# -----
#  Collatz sequence definition:

#			1	if n = 1
#	collatz(n) =	n/2	if n is even
#			3n+1	if n is odd

# -----
#  Arguments:
#	$a0 - N value
#  Returns:
#	$v0 - count

#  Note, display's n on each call


.globl collatz
.ent   collatz
collatz:
#----
#prologue
subu $sp, $sp, 8
sw $ra, 0($sp)
sw $s0, 4($sp)

	#----


		move $s0, $a0

		bne $s0, 1, PRTLONE					#if( $a0 != 1) continue

			#print collatz Number 			#if($a0 == 1 ) enter
			la $a0, collNumber
			li $v0,4
			syscall

			#print number 
			move $a0, $s0
			li $v0, 1
			syscall

		PRTLONE:

		beq $s0, 1, endofCollatz			#base case

		#print collatz Number
		la $a0, collNumber
		li $v0,4
		syscall

		#print number 
		move $a0, $s0
		li $v0, 1
		syscall

		rem $t0, $s0, 2						# n%2 
		#rem will be used to check if even or odd

		beq $t0, 0, EvenN
			# n = 3n + 1 
			mul $s0, $s0, 3
			add $s0, $s0, 1
			b callCollatz
		EvenN:
			#n = n/2
			div $s0,$s0,2

		callCollatz:

		move $a0,$s0
		jal collatz


	endofCollatz:

		move $t1, $zero
		la $t0, collatzCount
		lw $t1, ($t0) 

		add $t1, $t1, 1 				#increment count 
		sw $t1, ($t0)

		move $v0,$t1 					#return count

	#----

#epilogue
lw $s0, 4($sp)
lw $ra, 0($sp)
addu $sp, $sp, 8
#---

jr $ra 

.end collatz
#####################################################################
#  Function to ask user if they want to continue.

# -----
#  Arguments:
#	none
#  Returns:
#	$v0 - TRUE/FALSE

.globl continue
.ent   continue
continue:

#-----
#prologue
subu $sp, $sp, 4
sw $s0, 0($sp)

	#----

		#print newline initially
		la $a0, nline
		li $v0,4
		syscall

		continueLoop:

			#promt 
			la $a0, upmt
			li $v0, 4
			syscall

			#read char 
			la $a0, ans
			li $a1, 3
			li $v0, 8
			syscall

			move $s0, $zero
			move $t0, $zero
			la $t0, ans
			lb $s0, ($t0)  				#grab char

			#Conditions
			beq $s0, 'n', noContinue
			beq $s0, 'N', noContinue
			beq $s0, 'Y', yesContiue
			beq $s0, 'y', yesContiue

			#else invalid Char 
			# print error message 

			la $a0, anerr
			li $v0, 4
			syscall

			b continueLoop

		yesContiue:
			li $v0, TRUE
			b endofContinue

		noContinue:
			li $v0, FALSE

		endofContinue:

	#----

#epilogue
lw $s0, 0($sp)
addu $sp, $sp, 4
#----

jr $ra 

.end continue

#####################################################################

