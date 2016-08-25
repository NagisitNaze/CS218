# Example program to find the minimum and maximum from
# a list of numbers.
# #data segment
.data

array: .word 13, 34, 16, 61, 28
.word 24, 58, 11, 26, 41
.word 19, 7, 38, 12, 13
len: .word 15

hdr: .ascii "\nExample program to find max and"
	 .asciiz " min\n\n"

newLine: .asciiz "\n"
a1Msg: 	 .asciiz "min = "
a2Msg: 	 .asciiz "max = "

# #text/code segment
# QtSpim requires the main procedure to be named "main".

.text
.globl main
.ent main
main:

# This program will use pointers.
# t0 array address
# t1 count of elements
# s2 min
# s3 max
# t4 each
# #Display header
# Uses print string system call

la $a0, hdr
li $v0, 4
syscall 

# print header
# #Find max and min of the array.
# Set min and max to first item in list and then
# loop through the array and check min and max against
# each item in the list, updating the min and max values
# as needed.

la $t0, array # set $t0 addr of array
lw $t1, len # set $t1 to length
lw $s2, ($t0) # set min, $t2 to array[0]
lw $s3, ($t0) # set max, $t3 to array[0]

loop:
	lw $t4, ($t0) # get array[n]
	bge $t4, $s2, NotMin # is new min?
	move $s2, $t4 # set new min
NotMin:
	ble $t4, $s3, NotMax # is new max?
	move $s3, $t4 # set new max
NotMax:
	sub $t1, $t1, 1 # decrement counter
	addu $t0, $t0, 4 # increment addr by word
	bnez $t1, loop

# #Display results min and max.
# First display string, then value, then a print a

# new line (for formatting). Do for each max and min.
la $a0, a1Msg
li $v0, 4
syscall

 # print "min = "
move $a0, $s2
li $v0, 1
syscall 

# print min
la $a0, newLine 
# print a newline
li $v0, 4
syscall

la $a0, a2Msg
li $v0, 4
syscall

 # print "max = "
move $a0, $s3
li $v0, 1
syscall

 # print max
la $a0, newLine 
# print a newline
li $v0, 4
syscall

# #Done, terminate program.
li $v0, 10
syscall 
# all done!
.end main