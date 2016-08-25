#  CS 218, MIPS Assignment #3
#  Provided template

#  MIPS assembly language program to check for
#  a magic square.


###########################################################
#  data segment

.data

hdr:		.asciiz	"\nProgram to check a Magic Square. \n\n"

# -----
#  Possible Magic Square #1

msq1:	.word	2, 7, 6
		.word	9, 5, 1
		.word	4, 3, 8

ord1:	.word	3

# -----
#  Possible Magic Square #2

msq2:	.word	16,  3,  2, 13
		.word	 5, 10, 11,  8
		.word	 9,  6,  7, 12
		.word	 4, 15, 14,  1

ord2:	.word	4

# -----
#  Possible Magic Square #3

msq3:	.word	16,  3,  2, 13
		.word	 5, 10, 11,  8
		.word	 9,  5,  7, 12
		.word	 4, 15, 14,  1

ord3:	.word	4

# -----
#  Possible Magic Square #4

msq4:	.word	21,  2,  8, 14, 15
		.word	13, 19, 20,  1,  7
		.word	 0,  6, 12, 18, 24
		.word	17, 23,  4,  5, 11
		.word	 9, 10, 16, 22,  3

ord4:	.word	5

# -----
#  Possible Magic Square #5

msq5:	.word	64, 12, 23, 61, 60, 35, 17, 57
		.word	19, 55, 54, 12, 13, 51, 55, 16
		.word	17, 47, 46, 21, 20, 43, 42, 24
		.word	41, 26, 27, 37, 36, 31, 30, 33
		.word	32, 34, 35, 29, 28, 38, 39, 25
		.word	40, 23, 22, 44, 45, 19, 18, 48
		.word	49, 15, 14, 52, 53, 11, 10, 56
		.word	18, 58, 59, 46, 24, 62, 63, 11

ord5:	.word	8

# -----
#  Possible Magic Square #6

msq6:	.word	 9,  6,  3, 16
		.word	 4, 15, 10,  5
		.word	 14, 1,  8, 11
		.word	 7, 12, 13, 1

ord6:	.word	4

# -----
#  Possible Magic Square #7

msq7:	.word	64,  2,  3, 61, 60,  6,  7, 57
		.word	 9, 55, 54, 12, 13, 51, 50, 16
		.word	17, 47, 46, 20, 21, 43, 42, 24
		.word	40, 26, 27, 37, 36, 30, 31, 33
		.word	32, 34, 35, 29, 28, 38, 39, 25
		.word	41, 23, 22, 44, 45, 19, 18, 48
		.word	49, 15, 14, 52, 53, 11, 10, 56
		.word	 8, 58, 59,  5,  4, 62, 63,  1

ord7:	.word	8


# -----
#  Local variables for print header routine.

ds_hdr:	.ascii	"\n-----------------------------------------------------"
		.asciiz	"\nPossible Magic Square #"

nlines:	.asciiz	"\n\n"


# -----
#  Local variables for check magic square.

TRUE = 1
FALSE = 0

rw_msg:		.asciiz	"    Row  #"
cl_msg:		.asciiz	"    Col  #"
d_msg:		.asciiz	"    Diag #"

no_msg:		.asciiz	"\nNOT a Magic Square.\n"
is_msg:		.asciiz	"\nIS a Magic Square.\n"


# -----
#  Local variables for prt_sum routine.

sm_msg:		.asciiz	"   Sum: "


# -----
#  Local variables for prt_matrix function.

newLine:	.asciiz	"\n"
tab: 		.asciiz "\t"

blnks1:		.asciiz	" "
blnks2:		.asciiz	" "
blnks3:		.asciiz	"  "
blnks4:		.asciiz	"   "
blnks5:		.asciiz	"    "
blnks6:		.asciiz	"     "


###########################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display main program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Set data set counter.

	li	$s0, 0

# -----
#  Check Magic Square #1

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq1
	lw	$a1, ord1
	jal	prtSquare

	la	$a0, msq1
	lw	$a1, ord1
	jal	chkMagicSqr

# -----
#  Check Magic Square #2

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq2
	lw	$a1, ord2
	jal	prtSquare

	la	$a0, msq2
	lw	$a1, ord2
	jal	chkMagicSqr

# -----
#  Check Magic Square #3

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq3
	lw	$a1, ord3
	jal	prtSquare

	la	$a0, msq3
	lw	$a1, ord3
	jal	chkMagicSqr

# -----
#  Check Magic Square #4

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq4
	lw	$a1, ord4
	jal	prtSquare

	la	$a0, msq4
	lw	$a1, ord4
	jal	chkMagicSqr

# -----
#  Check Magic Square #5

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq5
	lw	$a1, ord5
	jal	prtSquare

	la	$a0, msq5
	lw	$a1, ord5
	jal	chkMagicSqr

# -----
#  Check Magic Square #6

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq6
	lw	$a1, ord6
	jal	prtSquare

	la	$a0, msq6
	lw	$a1, ord6
	jal	chkMagicSqr

# -----
#  Check Magic Square #7

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq7
	lw	$a1, ord7
	jal	prtSquare

	la	$a0, msq7
	lw	$a1, ord7
	jal	chkMagicSqr

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall

.end main


# -------------------------------------------------------
#  Function to check if a two-dimensional array
#  is a magic square.

#  Algorithm:
#	Find sum for first row

#	Check sum of each row (n row's)
#	  if any sum not equal initial sum, set NOT magic square.
#	Check sum of each column (n col's)
#	  if any sum not equal initial sum, set NOT magic square.
#	Check sum of main diagonal 1
#	  if sum not equal initial sum, set NOT magic square.
#	Check sum of main diagonal 2
#	  if sum not equal initial sum, set NOT magic square.

# -----
#  Formula for multiple dimension array indexing:
#	addr(row,col) = base_address + (rowindex * col_size
#					+ colindex) * element_size

# -----
#  Arguments
#	$a0 - address of two-dimension two-dimension array
#	$a1 - order/size of two-dimension array


.globl chkMagicSqr
.ent   chkMagicSqr
chkMagicSqr:

#prologue 
subu $sp, $sp, 4
sw $ra, ($sp)

subu $sp, $sp, 20
sw $s4, 0($sp)
sw $s3, 4($sp)
sw $s2, 8($sp)
sw $s1, 12($sp)
sw $s0, 16($sp)
#---- 

	#-----
	#calle Saved 
	move $s0, $a0          #base_address 
	move $s1, $a1		   #order/size 

	#------

	#By Default it is a Magic Square
	la $s2, is_msg 	

	#----	
	#Get Sum for Row 

	#for(i=0; i < order; i++)
	move $s3, $zero  					#i=0

	RowSum1:
		bge $s3, $s1, endRS1

		#for(j=0; j < order; j++)
		move $t0, $zero 				#j=0
		move $t3, $zero 				#sum = 0
		RowSum2:
			bge $t0, $s1, endRS2
			move $t1, $s0				#base_address

			mul $t2, $s3, $s1			#((rowindex*col_size
			add $t2, $t2, $t0			# + colIndex)
			mul $t2, $t2, 4				# *4 )

			addu $t1, $t1, $t2 			#base_address + (rowindex*col_size + colIndex)*dataSize
			lw $t4, 0($t1) 				#arr[i][j]

			add $t3, $t3, $t4			#sum = sum + arr[i][j]

			add $t0, $t0, 1				#j++
			b RowSum2
		endRS2:

		bnez $s3, notFirstSum
			move $s4, $t3				#save first sum 
		notFirstSum:

		beqz $s3, firstRSum 				#after first sum check everyother sum 
			beq $s4, $t3, firstRSum
				la $s2, no_msg
		firstRSum:

		#print sum 
		la $a0, rw_msg
		move $a1, $s3 
		move $a2, $t3
		jal prtMsg


		add $s3, $s3, 1					#i++
		b RowSum1
	endRS1:

	#------

	#----
	#Get Column Sum 

	#for(j= 0 ; j < order; j++)
	move $s3, $zero						#j = 0
	ColumnSum1:

	bge $s3, $s1, endCS1

		#for(i = 0; i < order; i++)
		move $t0, $zero 				#i = 0
		move $t3, $zero 				#sum = 0
		ColumnSum2:
			bge $t0, $s1, endCS2
			move $t1, $s0				#base_address

			mul $t2, $t0, $s1 			#((rowIndex*colSize
			add $t2, $t2, $s3			# + colIndex)
			mul $t2, $t2, 4				# * 4)

			addu $t1, $t1, $t2	
			lw $t4, ($t1)

			add $t3, $t3, $t4			#sum = sum + arr[j][i]

			add $t0, $t0, 1				#i ++
			b ColumnSum2

		endCS2:

		beq $s4, $t3, CheckCSum
			la $s2, no_msg
		CheckCSum:

		#call prtMsg
		la $a0, cl_msg
		move $a1, $s3
		move $a2, $t3
		jal prtMsg

		add $s3, $s3, 1 				#j++
		b ColumnSum1
	endCS1:
	#----

	#----
	#Get 1st Diagonal
	
	move $t0, $zero 				#i++
	move $t3, $zero	  				#sum = 0
	firstD:
		move $t1, $s0				#base_address

		mul $t2, $t0, $s1 			#((rowSize * colSize
		add $t2, $t2, $t0    		# + colIndex)
		mul $t2, $t2, 4 			# * 4)

		addu $t1, $t1, $t2 			# add to base_address
		lw $t4, ($t1) 				# arr[i][i]

		add $t3, $t3, $t4 			# sum = sum + arr[i][i]

		add $t0, $t0, 1				#i++
		blt $t0, $s1, firstD 
	#end of firstD

		beq $s4, $t3, CheckD1Sum
			la $s2, no_msg
		CheckD1Sum:
	
		#call prtMsg
		la $a0, d_msg
		li $a1, 1
		move $a2, $t3
		jal prtMsg

	#*********

	#Get 2nd Diagonal

	move $t0, $zero					#i = 0
	move $t3, $zero 				#sum 
	sub $t5, $s1, 1					#size - 1 (j)

	secondD:
		move $t1, $s0				#base_address

		mul $t2, $t0, $s1 			#(( rowIndex * colSize
		add $t2, $t2, $t5 			# + colIndex)
		mul $t2, $t2, 4 			# * 4 )

		addu $t1, $t1, $t2			# baseAddr +  offset 
 		lw $t4, ($t1)				# arr[i][j]

 		add $t3, $t3, $t4	 		#sum = sum + arr[i][j]

		sub $t5, $t5, 1 			#j--
		add $t0, $t0, 1				#i++
		blt $t0, $s1, secondD

	#end of secondD

		beq $s4, $t3, CheckD2Sum
			la $s2, no_msg
		CheckD2Sum:
	
		#call prtMsg
		la $a0, d_msg
		li $a1, 2
		move $a2, $t3
		jal prtMsg

	#----
	#print newline
	la $a0,newLine
	li $v0, 4
	syscall

	#print if Magic Square
	move $a0, $s2
	li $v0, 4 
	syscall
	#----

#----
#epilogue 
lw $s4, 0($sp)
lw $s3, 4($sp)
lw $s2, 8($sp)
lw $s1, 12($sp)
lw $s0, 16($sp)
addu $sp, $sp, 20

lw $ra  ($sp)
addu $sp,$sp, 4

jr $ra 

.end chkMagicSqr

# -------------------------------------------------------
#  Function to display sum message.

# -----
#  Arguments:
#	$a0 - message (address)
#	$a1 - row/col/diag number (value)
#	$a2 - sum


.globl prtMsg
.ent   prtMsg
prtMsg:

#prologue
subu $sp, $sp, 12	
sw $s0, 8($sp)
sw $s1, 4($sp)
sw $s2, 0($sp)
#----

	 
	#----
	#calle Save
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2

	#----
	#print newline
	la $a0, newLine
	li $v0, 4 
	syscall

	#----
	#print message
	move $a0, $s0
	li $v0, 4
	syscall

	#----
	#print row/col/diag
	move $a0, $s1
	li $v0, 1
	syscall

	#----
	#print Sum message
	la $a0, sm_msg
	li $v0,4
	syscall

	#----
	#print Sum 
	move $a0, $s2
	li $v0,1
	syscall


#----
#epilogue
lw $s0, 8($sp)
lw $s1, 4($sp)
lw $s2, 0($sp)
addu $sp, $sp, 12

jr $ra 

.end prtMsg


# ---------------------------------------------------------
#  Display simple header for data set (as per asst spec's).

.globl	prtHeader
.ent	prtHeader
prtHeader:
	subu	$sp, $sp, 4
	sw	$s0, ($sp)

	move	$s0, $a0

	la	$a0, ds_hdr
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, nlines
	li	$v0, 4
	syscall

	lw	$s0, ($sp)
	addu	$sp, $sp, 4

	jr	$ra
.end	prtHeader


# ---------------------------------------------------------
#  Print possible magic square.
#  Note, a magic square is an N x N array.

#  Arguments:
#	$a0 - starting address of square to ptint
#	$a1 - order (size) of the square

.globl prtSquare
.ent   prtSquare
prtSquare:

subu $sp, $sp, 20
sw $s4, 0($sp)
sw $s3, 4($sp)
sw $s2, 8($sp)
sw $s1, 12($sp)
sw $s0, 16($sp)

#----
	move $s2, $a0 				#get base_address
	move $s0, $a1 				#get order (n)
	mul $s3, $s0, $s0 			#n^2
	move $s1, $zero 			#i = 0

	printSqare:
		lw $s4, ($s2)	 		#arr[i]

		#print out right justified 
		bge $s4, 10, GT10
			la $a0, blnks6
			li $v0, 4
			syscall
			b doneBlnk
		GT10:

		bge $s4, 100, GT100
			la $a0, blnks5
			li $v0, 4
			syscall
			b doneBlnk
		GT100:

		bge $s4, 1000, GT1k
			la $a0, blnks4
			li $v0, 4
			syscall
			b doneBlnk
		GT1K:

		bge $s4, 10000, GT10k
			la $a0, blnks3
			li $v0, 4
			syscall
			b doneBlnk
		GT10K:

		bge $s4, 100000, GT1M
			la $a0, blnks2
			li $v0, 4
			syscall
			b doneBlnk
		GT1M:

		bge $s4, 1000000, GT10M
			la $a0, blnks
			li $v0, 4
			syscall
			b doneBlnk
		GT10M:

		doneBlnk:

		#Print arr[i]	
		move $a0, $s4
		li $v0, 1
		syscall

		addu $s2, $s2, 4	#offset 
		add $s1, $s1, 1		#i++

		rem $t0, $s1, $s0 	#if (remainder == 0) get newLine

		bnez $t0, skipNewline
			#Print newline
			la $a0, newLine
			li $v0, 4 
			syscall

		skipNewline:

		blt $s1, $s3, printSqare
#----

lw $s4, 0($sp)
lw $s3, 4($sp)
lw $s2, 8($sp)
lw $s1, 12($sp)
lw $s0, 16($sp)
addu $sp, $sp, 20

jr $ra 

.end prtSquare


