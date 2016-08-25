#  CS 218, MIPS Assignment #1
# Luis Ruiz 
#Section 1001

# -----
#	Write a simple assembly language program to calculate the
#	information for a series of cubes; areas and volumes.
#	The information for the cubes are stored in an array.
#   Once the areas and volumes are computed, the program should
# 	find the minimum, maximum, middle value, sum, and average
#	for the areas and volumes.

#  Provided Template

###########################################################
#  data segment

.data

aSides:		.word	   31,    21,    15,    28,    37
		.word	   10,    14,    13,    37,    54
		.word	  -31,   -13,   -20,   -61,   -36
		.word	   14,    53,    44,    19,    42
		.word	  -27,   -41,   -53,   -62,   -10
		.word	   19,    28,    24,    10,    15
		.word	  -15,   -11,   -22,   -33,   -70
		.word	   15,    23,    15,    63,    26
		.word	  -24,   -33,   -10,   -61,   -15
		.word	   14,    34,    13,    71,    81
		.word	  -38,    73,    29,    17,    93

bSides:		.word	  101,   132,   111,   121,   142
		.word	  133,   114,   173,   131,   115
		.word	 -164,  -173,  -174,  -123,  -156
		.word	  144,   152,   131,   142,   156
		.word	 -115,  -124,  -136,  -175,  -146
		.word	  113,   123,   153,   167,   135
		.word	 -114,  -129,  -164,  -167,  -134
		.word	  116,   113,   164,   153,   165
		.word	 -126,  -112,  -157,  -167,  -134
		.word	  117,   114,   117,   125,   153
		.word	 -123,   173,   115,   106,   113

cSides:		.word	 1234,  1111,  1313,  1897,  1321
		.word	 1145,  1135,  1123,  1123,  1123
		.word	-1254, -1454, -1152, -1164, -1542
		.word	 1353,  1457,   182,  1142,  1354
		.word	-1364, -1134, -1154, -1344, -1142
		.word	 1173,  1543,  1151,  1352,  1434
		.word	-1355, -1037,  -123, -1024, -1453
		.word	 1134,  2134,  1156,  1134,  1142
		.word	-1267, -1104, -1134, -1246, -1123
		.word	 1134,  1161,  1176,  1157,  1142
		.word	-1153,  1193,  1184,  1142,  2034

volumes:	.space	220

len:		.word	55

vMin:		.word	0
vMid:		.word	0
vMax:		.word	0
vSum:		.word	0
vAve:		.word	0

# -----
tab:		.asciiz "\t"

hdr:		.ascii	"MIPS Assignment #1 \n"
			.ascii	"  Program to calculate the volume of each rectangular \n"
			.ascii	"  parallelepiped in a series of rectangular parallelepipeds.\n"
			.ascii	"  Also finds min, mid, max, sum, and average for volumes.\n"
			.asciiz	"\n"

sHdr:		.asciiz	"  Volumes: \n"

newLine:	.asciiz	"\n"
blnks:		.asciiz	"    "

minMsg:		.asciiz	"  Volumes Min = "
midMsg:		.asciiz	"  Volumes Mid = "
maxMsg:		.asciiz	"  Volumes Max = "
sumMsg:		.asciiz	"  Volumes Sum = "
aveMsg:		.asciiz	"  Volumes Ave = "


###########################################################
#  text/code segment

.text
.globl main
.ent main
main:
# ----
	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----

	#Grab needed base addresses 

 	la $t0, volumes  		#address of volumes[]
 	la $t1, aSides 			#address of aSides[]		
 	la $t2, bSides 			#address of bSides[]	
 	la $t3, cSides  		#address of cSides[]

 	li $t7, 0 				#i = 0
 	lw $t8, len 			#get length

 	#loop used to calucate the volumes 
 	findVolumes:

 		li $t4, 0

 		#get initial values 

 		lw $t4, ($t1) 		#aSides[i]
 		lw $t5, ($t2)		#bSides[i]
 		lw $t6, ($t3)        #cSides[i]

 		#volumes[i] = aSides[i] * bSides[i] * cSides[i]

 		mul $t4,$t4,$t5		#$t4 = $t4 * $t5 (aSides[i] * bSides[i])
 		mul $t4,$t4,$t6     #$t4 = $t4 * $t5 * $t6 (aSides[i] * bSides[i] * cSides[i])

 		sw $t4, ($t0) 		# volumes[i] = $t4


 		#offset = base address + 4	

 		add $t0,$t0,4
 		add $t1,$t1,4
 		add $t2,$t2,4
 		add $t3,$t3,4

 		#i++
 		add $t7,$t7,1

 		blt $t7,$t8,findVolumes

 	#end of findVolumes

 	#-------------
 	#GET SUM, MAX, AND MIN

 	la $t0,volumes  	#address of volumes[]
 	lw $t1,volumes  	#Min = volumes[0]
 	lw $t2,volumes  	#Max = volumes[1]

 	li $t7, 0			# i = 0
 	li $t8, 0 			#sum = 0
 	lw $t9, len 		#get length 

 	statsLoop:

 		li $t3, 0			#clear
 		lw $t3, ($t0) 		#volumes[i]

 		add $t8, $t8, $t3 	#sum = sum + volumes[i]

 		ble $t1,$t3,notMin         #if(min > volumes[i])
 			move $t1,$t3 		  	 # $t1 = $t3
 		notMin:

 		bge $t2,$t3,notMax 		 #if(max < volumes[i])
 			move $t2,$t3			 #$t2 = $t3
 		notMax: 

 		add $t0,$t0,4			#volumes[] + 4 

 		add $t7,$t7,1			#i++

 		blt $t7,$t9,statsLoop  #if(i < len) goto statsLoop

 	#end of statsLoop

 	#store values into mem 
 	sw $t8, vSum
 	sw $t1, vMin
 	sw $t2, vMax

 	#------------
 	#Average 
 	#$t9 holds length and $t8 holds sum 

 	div $t7,$t8,$t9			#ave = sum / length
 	sw $t7, vAve

 	#-------------
 	#GET MID

 	lw $t0,len  			#get length 
 	li $t1, 0				#clear
 	rem $t1,$t0,2			#$t1  = $t0(length)%2
 	la $t3, volumes 		#volumes[]

 	beqz $t1,EvenList

 	#ODD LIST 
 		div $t1,$t0,2			#lenght/2
 		li $t2, 0			    #clear

 		mul $t2,$t1,4           #offset for lenght/2
 		add $t3,$t3,$t2

 		lw $t4, ($t3) 		    #get mid value and store it in mem
 		sw $t4, vMid

 		b midDone 			    #jump to midDone

 	EvenList:

 		div $t1,$t0,2			#lenght/2
 		li $t2, 0			    #clear

 		mul $t2,$t1,4           #offset for lenght/2
 		add $t3,$t3,$t2

		lw $t4, ($t3) 		    #get mid value 1
		sub $t3,$t3,4			#offset for length/2 - 1 	
		lw $t5,($t3) 			#get mid value 2		
		add $t4,$t5,$t4 		#MED = M1+M2
		srl $t4, $t4,1			#MED/2

		sw $t4, vMid

midDone:
#----------------------
#OutPut Volumes 
	
	la	$a0, sHdr	
	li	$v0, 4
	syscall 

#-----
	la $t0,volumes
	li $t7,0
	lw $t9,len

	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

	outVolumes:
		lw $a0, ($t0)
		li $v0, 1 			
		syscall

		la $a0, tab
		li $v0, 4
		syscall

		add $t0,$t0,4

		add $t7,$t7,1
		blt $t7,$t9,outVolumes

#-----------------------
#output to console

la	$a0, newLine			# print a newline
li	$v0, 4
syscall 

la	$a0, newLine			# print a newline
li	$v0, 4
syscall 

#PRINT MIN
la $a0,minMsg 		#address of string to print
li $v0, 4 			#call code to print string  
syscall

lw $a0, vMin
li $v0, 1 			#call code to print number
syscall

la	$a0, newLine			# print a newline
li	$v0, 4
syscall

#PRINT MID
la $a0,midMsg 	    #address of string to print
li $v0, 4 			#call code to print string  
syscall

lw $a0,vMid 		#integer to print 
li $v0,1
syscall

la	$a0, newLine			# print a newline
li	$v0, 4
syscall

#PRINT MAX
la $a0,maxMsg 	    #address of string to print
li $v0, 4 			#call code to print string  
syscall

lw $a0,vMax 		#integer to print 
li $v0,1
syscall

la	$a0, newLine			# print a newline
li	$v0, 4
syscall

#PRINT SUM
la $a0,sumMsg 	    #address of string to print
li $v0, 4 			#call code to print string  
syscall

lw $a0,vSum 		#integer to print 
li $v0,1
syscall

la	$a0, newLine			# print a newline
li	$v0, 4
syscall

#PRINT SUM
la $a0,aveMsg 	    #address of string to print
li $v0, 4 			#call code to print string  
syscall

lw $a0,vAve 		#integer to print 
li $v0,1
syscall

# -----
#  Done, terminate program.

endit:
	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall						# all done!

.end main

