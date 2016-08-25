#  CS 218, MIPS Assignment #2
#  Luis Ruiz
#  Section-1001 

#  Provided template

#  MIPS assembly language main program and functions:

#  * MIPS assembly language function, surfaceAreas(), 
#    to calculate the surface areas for each of the rectangular
#    parallelepipeds in a set of rectangular parallelepipeds.

#  * Write a MIPS assembly language function, printAreas(), to
#    display the array of surfaceAreas.  The numbers should be
#    printed 5 per line (see example).

#  * Write a MIPS assembly language function, cocktailSort(), to sort
#    an array of surface areas into ascending order (small to large).

#  * Write a MIPS assembly language function, surfaceAreasStats(), that will
#    find the minimum, median, maximum, sum, and floating point average.
#    You should find the minimum, median, and maximum after the list is
#    sorted.  The average should be calculated as a floating point value.

#  * Write a MIPS assembly language function, printStats(), to print the
#    statistical information (minimum, maximum, median, sum, average) in
#    the format shown in the example.


#####################################################################
#  data segment

.data

# -----
#  Data declarations for main.

aSides1:	.word	19, 17, 15, 13, 11, 19, 17, 15, 13, 11
			.word	10,  3, 12, 14, 16, 18, 10, 21, 2, 190
bSides1:	.word	34, 32, 31, 35, 34, 33, 32, 37, 38, 39
			.word	32,  5, 80, 30, 36, 38, 30, 29, 4, 130
cSides1:	.word	51, 52, 51, 55, 54, 53, 52, 57, 58, 59
			.word	52,  9, 90, 50, 56, 58, 52, 49, 6, 210

len1:		.word	20

surfaceAreas1:	.space	80

min1:		.word	0
med1:		.word	0
max1:		.word	0
sum1:		.word	0
ave1:		.float	0.0

aSides2:	.word	125, 125, 133, 144, 158, 159, 132, 156, 149, 121
			.word	137, 121, 137, 141, 157, 137, 147, 151, 151, 149
			.word	132, 139, 135, 129, 123, 125, 131, 142, 144, 149
			.word	136, 132, 122, 131, 146, 150, 154, 138, 158, 152
			.word	157, 147, 159, 124, 123, 134, 135, 136, 135, 134
			.word	151, 153, 136, 159, 131, 142, 150, 158, 141, 149
			.word	159, 134, 147, 149, 152, 154, 136, 148, 152, 153
			.word	132, 151, 156, 157, 130, 140, 141

bSides2:	.word	242, 271, 276, 257, 230, 240, 241, 253, 232, 245
		.word	244, 252, 234, 276, 257, 224, 236, 240, 236, 253
		.word	252, 253, 232, 269, 244, 251, 261, 278, 246, 237
		.word	253, 235, 251, 269, 248, 259, 262, 274, 250, 241
		.word	230, 244, 236, 257, 254, 255, 236, 239, 248, 252
		.word	241, 233, 234, 256, 240, 256, 275, 257, 250, 256
		.word	232, 255, 257, 242, 237, 247, 267, 279, 248, 244
		.word	230, 231, 243, 232, 245, 250, 251
cSides2:	.word	332, 351, 376, 337, 340, 330, 341, 323, 332, 345
		.word	334, 352, 374, 346, 357, 334, 346, 330, 336, 353
		.word	332, 333, 332, 339, 344, 351, 361, 378, 346, 357
		.word	333, 335, 331, 349, 348, 349, 362, 374, 330, 341
		.word	330, 324, 336, 337, 324, 325, 326, 359, 348, 362
		.word	331, 333, 344, 346, 340, 356, 375, 337, 330, 346
		.word	352, 345, 347, 342, 347, 347, 367, 349, 358, 344
		.word	330, 331, 333, 332, 345, 350, 352

len2:		.word	77

surfaceAreas2:	.space	308
min2:		.word	0
med2:		.word	0
max2:		.word	0
sum2:		.word	0
ave2:		.float	0.0

aSides3:	.word	110, 113, 112, 119, 117, 114, 116, 111, 115, 118
		.word	133, 142, 131, 131, 131, 134, 142, 146, 158, 133
		.word	132, 149, 145, 129, 131, 155, 139, 142, 144, 149
		.word	140, 144, 146, 157, 144, 135, 126, 129, 148, 142
		.word	141, 143, 146, 149, 151, 152, 154, 258, 161, 165
		.word	169, 174, 177, 179, 152, 141, 144, 156, 142, 193
		.word	141, 153, 154, 136, 140, 156, 175, 167, 150, 546
		.word	154, 125, 145, 162, 132, 131, 132, 136, 136, 123
		.word	168, 159, 151, 142, 133, 141, 176, 131, 149, 156
		.word	146, 179, 149, 137, 146  134, 134, 156, 164, 142

bSides3:	.word	201, 209, 203, 207, 202, 208, 200, 204, 206, 205
		.word	271, 248, 235, 243, 252, 240, 258, 271, 224, 252
		.word	235, 262, 276, 252, 223, 239, 236, 242, 238, 241
		.word	232, 245, 246, 247, 245, 234, 246, 230, 236, 253
		.word	253, 242, 231, 231, 231, 234, 242, 246, 258, 233
		.word	212, 259, 245, 229, 231, 235, 239, 242, 244, 249
		.word	250, 244, 246, 277, 224, 225, 226, 229, 248, 262
		.word	241, 243, 246, 249, 251, 252, 254, 258, 241, 265
		.word	269, 274, 239, 252, 277, 244, 246, 251, 252, 253
		.word	241, 253, 234, 236, 240, 256, 275, 247, 240, 246

cSides3:	.word	309, 319, 300, 317, 303, 311, 315, 309, 301, 313
		.word	371, 373, 374, 356, 350, 356, 375, 387, 390, 396
		.word	354, 365, 385, 362, 372, 381, 362, 376, 376, 373
		.word	398, 399, 391, 362, 373, 391, 376, 381, 369, 356
		.word	356, 389, 379, 357, 386  384, 374, 356, 364, 362
		.word	371, 378, 395, 363, 392, 370, 358, 371, 354, 392
		.word	365, 362, 376, 392, 383, 369, 396, 362, 388, 391
		.word	382, 355, 376, 387, 385, 384, 386, 380, 366, 353
		.word	373, 382, 381, 381, 371, 374, 362, 376, 358, 383
		.word	352, 379, 365, 369, 361, 365, 359, 362, 384, 379

len3:		.word	100
surfaceAreas3:	.space	400
min3:		.word	0
med3:		.word	0
max3:		.word	0
sum3:		.word	0
ave3:		.float	0.0

aSides4:	.word	112, 119, 125, 129, 131, 135, 139, 142, 144, 149
		.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
		.word	 99, 104, 106, 107, 124, 125, 126, 129, 148, 192
		.word	241, 243, 146, 249, 151, 252, 154, 158, 161, 165
		.word	199, 213, 124, 136, 140, 156, 175, 187, 115, 126
		.word	132, 151, 176, 187, 190, 100, 111, 123, 132, 145
		.word	147, 123, 153, 140, 165, 131, 154, 128, 113, 122
		.word	101, 113, 124, 136, 140, 156, 175, 187, 190, 196
		.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
		.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
		.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
		.word	209, 111, 129, 131, 249, 251, 169, 171, 189, 291
		.word	103, 113, 123, 130, 135, 139, 143, 148, 153, 155
		.word	151, 155, 157, 163, 166, 168, 171, 177, 194, 196
		.word	112, 119, 125, 129, 131, 135, 139, 142, 144, 149
		.word	241, 143, 246, 149, 251, 252, 154, 158, 161, 165
		.word	112, 129, 115, 219, 121, 125, 129, 132, 134, 139
		.word	152, 154, 158, 161, 165
bSides4:	.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
		.word	 69, 174, 177, 179, 182, 184, 186, 188, 192, 193
		.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
		.word	100, 104, 106, 107, 124, 125, 126, 129, 148, 192
		.word	145, 175, 115, 122, 117, 115, 110, 129, 112, 134
		.word	100, 111, 124, 139, 140, 155, 161, 174, 188, 193
		.word	101, 113, 124, 136, 140, 156, 175, 187, 190, 196
		.word	194, 124, 114, 143, 176, 134, 126, 122, 156, 163
		.word	127, 164, 110, 172, 124, 125, 116, 162, 138, 192
		.word	105, 112, 126, 135, 140, 157, 163, 179, 182, 194
		.word	206, 112, 122, 131, 146, 150, 154, 178, 188, 192
		.word	107, 117, 127, 137, 147, 157, 167, 177, 187, 197
		.word	157, 187, 199, 101, 123, 124, 125, 126, 175, 194
		.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
		.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
		.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
		.word	109, 111, 129, 131, 149, 151, 169, 171, 189, 191
		.word	 41,  43, 146, 149, 151
cSides4:	.word	132, 151, 136, 187, 190, 100, 111, 123, 132, 145
		.word	157, 187, 199, 101, 123, 124, 125, 126, 175, 194
		.word	149, 126, 162, 131, 127, 177, 199, 197, 175, 114
		.word	164, 141, 142, 133, 166, 134, 146, 123, 156, 163
		.word	121, 118, 177, 143, 178, 112, 111, 110, 135, 110
		.word	127, 144, 110, 172, 124, 125, 116, 162, 128, 192
		.word	123, 132, 246, 176, 111, 116, 164, 165, 295, 156
		.word	137, 123, 123, 140, 115, 111, 154, 128, 113, 122
		.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
		.word	169, 126, 162, 127, 127, 127, 159, 177, 175, 114
		.word	181, 125, 115, 112, 117, 135, 110, 129, 112, 134
		.word	161, 122, 151, 122, 171, 119, 114, 122, 215, 131
		.word	123, 122, 146, 176, 110, 126, 164, 165, 155, 156
		.word	171, 147, 110, 127, 174, 165, 121, 167, 181, 129
		.word	123, 212, 146, 136, 110, 116, 164, 156, 115, 132
		.word	111, 183, 133, 150, 125, 189, 115, 118, 113, 115
		.word	164, 141, 142, 133, 166, 134, 146, 123, 156, 163
		.word	127, 164, 110, 172, 124
len4:		.word	175
surfaceAreas4:	.space	700
min4:		.word	0
med4:		.word	0
max4:		.word	0
sum4:		.word	0
ave4:		.float	0.0

aSides5:	.word	145, 134, 123, 117, 123, 134, 134, 156, 164, 142
		.word	206, 212, 122, 131, 246, 150, 154, 178, 188, 192
		.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
		.word	132, 151, 136, 187, 190, 100, 111, 123, 132, 145
		.word	157, 187, 199, 101, 123, 124, 125, 126, 175, 194
		.word	149, 126, 162, 131, 127, 177, 199, 197, 175, 114
		.word	164, 141, 142, 133, 166, 134, 146, 123, 156, 163
		.word	121, 118, 177, 143, 178, 112, 111, 110, 135, 110
		.word	127, 144, 110, 172, 124, 125, 116, 162, 128, 192
		.word	123, 132, 246, 176, 111, 116, 164, 165, 295, 156
		.word	137, 123, 123, 140, 115, 111, 154, 128, 113, 122
		.word	169, 126, 162, 127, 127, 127, 159, 177, 175, 114
		.word	181, 125, 115, 112, 117, 135, 110, 129, 112, 134
		.word	161, 122, 151, 122, 171, 119, 114, 122, 215, 131
bSides5:	.word	123, 122, 146, 176, 110, 126, 164, 165, 155, 156
		.word	171, 147, 110, 127, 174, 165, 121, 167, 181, 129
		.word	123, 212, 146, 136, 110, 116, 164, 156, 115, 132
		.word	111, 183, 133, 150, 125, 189, 115, 118, 113, 115
		.word	164, 141, 142, 133, 166, 134, 146, 123, 156, 163
		.word	111, 183, 133, 130, 127, 111, 115, 158, 113, 115
		.word	117, 126, 162, 117, 227, 177, 199, 177, 175, 114
		.word	194, 124, 112, 143, 176, 134, 126, 132, 156, 163
		.word	124, 119, 122, 183, 110, 191, 192, 129, 129, 122
		.word	135, 126, 162, 137, 127, 127, 159, 177, 175, 144
		.word	179, 153, 136, 140, 235, 112, 154, 128, 113, 132
		.word	161, 192, 151, 213, 126, 169, 114, 122, 115, 131
		.word	194, 124, 114, 143, 176, 134, 126, 122, 156, 163
		.word	149, 144, 114, 134, 167, 143, 129, 161, 165, 136
cSides5:	.word	103, 113, 123, 130, 135, 139, 143, 148, 153, 155
		.word	151, 155, 157, 163, 166, 168, 171, 177, 194, 196
		.word	112, 119, 125, 129, 131, 135, 139, 142, 144, 149
		.word	241, 143, 246, 149, 251, 252, 154, 158, 161, 165
		.word	112, 129, 115, 219, 121, 125, 129, 132, 134, 139
		.word	152, 154, 158, 161, 165, 121, 112, 212, 171, 119
		.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
		.word	 69, 174, 177, 179, 182, 184, 186, 188, 192, 193
		.word	100, 104, 106, 107, 124, 125, 126, 129, 148, 192
		.word	145, 175, 115, 122, 117, 115, 110, 129, 112, 134
		.word	100, 111, 124, 139, 140, 155, 161, 174, 188, 193
		.word	101, 113, 124, 136, 140, 156, 175, 187, 190, 196
		.word	194, 124, 114, 143, 176, 134, 126, 122, 156, 163
		.word	105, 112, 126, 135, 140, 157, 163, 179, 182, 194
len5:		.word	140
surfaceAreas5:	.space	560
min5:		.word	0
med5:		.word	0
max5:		.word	0
sum5:		.word	0
ave5:		.float	0.0


# -----
#  Variables for main

hdr:	.ascii	"\nAssignment #2\n"
	.asciiz	"Surface Areas Program\n\n"

hdr_nm:	.ascii	"\n---------------------------"
	.asciiz	"\nData Set #"

hdr_ln:	.asciiz	"\nLength: "
hdr_un:	.asciiz	"\n\n Unsorted Surface Areas: \n\n"
hdr_sr:	.asciiz	"\n Sorted Surface Areas: \n\n"


# -----
#  Variables/constants for surfaceAreas() function (if any).



# -----
#  Variables/constants for cocktailSort() function (if any).

TRUE = 1
FALSE = 0


# -----
#  Variables/constants for surfaceAreasStats() function (if any).



# -----
#  Variables/constants for printAreas() function (if any).

spc:	.asciiz	"     "
tab:	.asciiz	"\t"

NUMS_PER_ROW = 5


# -----
#  Variables for printStats() function (if any).

new_ln:	.asciiz	"\n"

str1:	.asciiz	"\n Surface Areas Min = "
str2:	.asciiz	"\n Surface Areas Med = "
str3:	.asciiz	"\n Surface Areas Max = "
str4:	.asciiz "\n Surface Areas Sum = "
str5:	.asciiz	"\n Surface Areas Ave = "


#####################################################################
#  text/code segment

.text
.globl	main
main:

# -----
#  Display Program Header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

	li	$s0, 1				# counter, data set number

# -----
#  Basic flow:
#	display headers

#	for each data set:
#		* find surface areas
#		* display unsorted surface areas
#		* sort surface areas
#		* find surface areas stats (min, max, med, sum, and average)
#		* display sorted surface areass
#		* display surface areas stats  (min, max, med, sum, and average)

# ----------------------------
#  Data Set #1

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len1
	li	$v0, 1
	syscall

	add	$s0, $s0, 1

#  find surface areas
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

	la	$a0, aSides1
	la	$a1, bSides1
	la	$a2, cSides1
	lw	$a3, len1
	la	$t0, surfaceAreas1
	sub	$sp, $sp, 4
	sw	$t0, ($sp)
	jal	surfaceAreas
	add	$sp, $sp, 4

#  Display unsorted surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas1
	lw	$a1, len1
	jal	printAreas

#  Sort surfaceAreas
#	cocktailSort(surfaceAreas, len)

	la	$a0, surfaceAreas1
	lw	$a1, len1
	jal	cocktailSort

#  Generate surface areas stats
#	surfaceAreasStats(surfaceAreas, len, min, med, max, sum, ave)

	la	$a0, surfaceAreas1		# arg #1
	lw	$a1, len1			# arg #2
	la	$a2, min1			# arg #3
	la	$a3, med1			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max1
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum1
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave1
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	surfaceAreasStats

	addu	$sp, $sp, 12			# clear stack

#  Display surface areas
#	printArea(surfaceAreas, len)

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas1
	lw	$a1, len1
	jal	printAreas

#  Display surface areas stats
#	printStats(min, med, max, sum, ave)

	lw	$a0, min1
	lw	$a1, med1
	lw	$a2, max1
	lw	$a3, sum1
	subu	$sp, $sp, 4
	l.s	$f0, ave1
	s.s	$f0, ($sp)
	jal	printStats

	addu	$sp, $sp, 4

# ----------------------------
#  Data Set #2

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len2
	li	$v0, 1
	syscall

	add	$s0, $s0, 1

#  find surface areas
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

	la	$a0, aSides2
	la	$a1, bSides2
	la	$a2, cSides2
	lw	$a3, len2
	la	$t0, surfaceAreas2
	sub	$sp, $sp, 4
	sw	$t0, ($sp)
	jal	surfaceAreas
	add	$sp, $sp, 4

#  Display unsorted surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas2
	lw	$a1, len2
	jal	printAreas

#  Sort surface areas
#	cocktailSort(surfaceAreas, len)

	la	$a0, surfaceAreas2
	lw	$a1, len2
	jal	cocktailSort

#  Generate surface areas stats
#	surfaceAreasStats(surfaceAreas, len, min, med, max, sum, ave)

	la	$a0, surfaceAreas2		# arg #1
	lw	$a1, len2			# arg #2
	la	$a2, min2			# arg #3
	la	$a3, med2			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max2
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum2
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave2
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	surfaceAreasStats

	addu	$sp, $sp, 12			# clear stack

#  Display surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas2
	lw	$a1, len2
	jal	printAreas

#  Display surface areas stats
#	printStats(min, med, max, sum, ave)

	lw	$a0, min2
	lw	$a1, med2
	lw	$a2, max2
	lw	$a3, sum2
	subu	$sp, $sp, 4
	l.s	$f0, ave2
	s.s	$f0, ($sp)
	jal	printStats

	addu	$sp, $sp, 4

# ----------------------------
#  Data Set #3

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len3
	li	$v0, 1
	syscall

	add	$s0, $s0, 1

#  find surface areas
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

	la	$a0, aSides3
	la	$a1, bSides3
	la	$a2, cSides3
	lw	$a3, len3
	la	$t0, surfaceAreas3
	sub	$sp, $sp, 4
	sw	$t0, ($sp)
	jal	surfaceAreas
	add	$sp, $sp, 4

#  Display unsorted surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas3
	lw	$a1, len3
	jal	printAreas

#  Sort surface areas
#	cocktailSort(surfaceAreas, len)

	la	$a0, surfaceAreas3
	lw	$a1, len3
	jal	cocktailSort

#  Generate surface areas stats
#	surfaceAreasStats(surfaceAreas, len, min, med, max, sum, ave)

	la	$a0, surfaceAreas3		# arg #1
	lw	$a1, len3			# arg #2
	la	$a2, min3			# arg #3
	la	$a3, med3			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max3
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum3
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave3
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	surfaceAreasStats

	addu	$sp, $sp, 12			# clear stack

#  Display surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas3
	lw	$a1, len3
	jal	printAreas

#  Display surface areas stats
#	printStats(min, med, max, sum, ave)

	lw	$a0, min3
	lw	$a1, med3
	lw	$a2, max3
	lw	$a3, sum3
	subu	$sp, $sp, 4
	l.s	$f0, ave3
	s.s	$f0, ($sp)
	jal	printStats

	addu	$sp, $sp, 4

# ----------------------------
#  Data Set #4

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len4
	li	$v0, 1
	syscall

	add	$s0, $s0, 1

#  find surface areas
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

	la	$a0, aSides4
	la	$a1, bSides4
	la	$a2, cSides4
	lw	$a3, len4
	la	$t0, surfaceAreas4
	sub	$sp, $sp, 4
	sw	$t0, ($sp)
	jal	surfaceAreas
	add	$sp, $sp, 4

#  Display unsorted surface areas
#	printArray(surfaceAreas, len)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas4
	lw	$a1, len4
	jal	printAreas

#  Sort surface areas
#	cocktailSort(surfaceAreas, len)

	la	$a0, surfaceAreas4
	lw	$a1, len4
	jal	cocktailSort

#  Generate surface areas stats
#	surfaceAreasStats(surfaceAreas, len, min, med, max, sum, ave)

	la	$a0, surfaceAreas4		# arg #1
	lw	$a1, len4			# arg #2
	la	$a2, min4			# arg #3
	la	$a3, med4			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max4
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum4
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave4
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	surfaceAreasStats

	addu	$sp, $sp, 12			# clear stack

#  Display surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas4
	lw	$a1, len4
	jal	printAreas

#  Display surface areas stats
#	printStats(min, med, max, sum, ave)

	lw	$a0, min4
	lw	$a1, med4
	lw	$a2, max4
	lw	$a3, sum4
	subu	$sp, $sp, 4
	l.s	$f0, ave4
	s.s	$f0, ($sp)
	jal	printStats

	addu	$sp, $sp, 4

# ----------------------------
#  Data Set #5

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len5
	li	$v0, 1
	syscall

	add	$s0, $s0, 1

#  find surface areas
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

	la	$a0, aSides5
	la	$a1, bSides5
	la	$a2, cSides5
	lw	$a3, len5
	la	$t0, surfaceAreas5
	sub	$sp, $sp, 4
	sw	$t0, ($sp)
	jal	surfaceAreas
	add	$sp, $sp, 4

#  Display unsorted surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas5
	lw	$a1, len5
	jal	printAreas

#  Sort surface areas
#	cocktailSort(surfaceAreas, len)

	la	$a0, surfaceAreas5
	lw	$a1, len5
	jal	cocktailSort

#  Generate surface areas stats
#	surfaceAreasStats(surfaceAreas, len, min, med, max, sum, ave)

	la	$a0, surfaceAreas5		# arg #1
	lw	$a1, len5			# arg #2
	la	$a2, min5			# arg #3
	la	$a3, med5			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max5
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum5
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave5
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	surfaceAreasStats

	addu	$sp, $sp, 12			# clear stack

#  Display surface areas
#	printArray(surfaceAreas, len)

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas5
	lw	$a1, len5
	jal	printAreas

#  Display surface areas stats
#	printStats(min, med, max, sum, ave)

	lw	$a0, min5
	lw	$a1, med5
	lw	$a2, max5
	lw	$a3, sum5
	subu $sp, $sp, 4
	l.s	$f0, ave5
	s.s	$f0, ($sp)
	jal	printStats

	addu	$sp, $sp, 4

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall					# au revoir...
.end main


#####################################################################
#  Find surface areas
#	surfaceAreas[n] = 2 [ asides(n)*bsides(n) + asides(n)*csides(n)
#				+ bsides(n)*csides(n) ]

# -----
#  HLL Call:
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

#    Arguments:
#	$a0   - starting address of the aSides array
#	$a1   - starting address of the bSides array
#	$a2   - starting address of the cSides array
#	$a3   - length
#	($fp) - starting address of the surfaceAreas array

#    Returns:
#	surfaceAreas[] array via passed address

.globl surfaceAreas
.ent surfaceAreas
surfaceAreas:

#------
#prologue 

subu $sp,$sp, 4 		#preserve $fp
sw $fp,($sp)

addu $fp, $sp, 4		#$fp point at itself 

subu $sp,$sp, 4 		#preserve $s0
sw $s0, ($sp)

#-----
lw $s0, ($fp) 			#grab the base address of surfaceArea

#-----
#sufaceArea = 2(aSides[i]*bSides[i]+aSides[i]*cSides[i]+cSides[i]*bSides[i])
	move $t9, $zero			#i = 0

getSurfaceArea:
	lw $t0, ($a0) 			#aSides[i]
	lw $t1, ($a1) 			#bSides[i]
	lw $t2, ($a2) 			#cSides[i]

	#---
	mul $t4, $t0, $t1 		#aSides[i]*bSides[i]
	mul $t5, $t0, $t2 		#aSides[i]*cSides[i]
	mul $t6, $t1, $t2       #bSides[i]*cSides[i]
	add $t4, $t5, $t4 		#aSides[i]*bSides[i]+aSides[i]*cSides[i]
	add $t4, $t4, $t6 		#aSides[i]*bSides[i]+aSides[i]*cSides[i]+bSides[i]*cSides[i]
	mul $t4, $t4, 2 		#$t4 = 2*$t4

	#----
	sw $t4, ($s0)			#$t4 = surfaceAreas[i]

	#----
	#Offset
	add $a0, $a0, 4
	add $a1, $a1, 4
	add $a2, $a2, 4
	add $s0, $s0, 4

	#-----
	add $t9, $t9, 1 		#i++
	#if(i<length) goto getSurfaceArea
	blt $t9, $a3, getSurfaceArea 

#endofgetSurfaceArea

#------
#epilogue 

lw $s0, 0($sp)
lw $fp, 4($sp) 
addu $sp, $sp, 8

jr $ra

.end surfaceAreas

#####################################################################
#  Sort surface areas using cocktail sort.

# -----
#    Arguments:
#	$a0 - starting address of the surface areas array
#	$a1 - list length

#    Returns:
#	sorted surface areas (via passed address)

.globl cocktailSort
.ent cocktailSort
cocktailSort:
	
	move $t0,$a0 		#$t0 = surfaceArea
	move $t1,$zero 		#bottom = 0
	move $t2,$a1 		#(top)$t1 = length 
	sub $t2,$t2,1	 	#(top)$t1 = length - 1
	li $t3,TRUE  		#swapped = 0

	#while(swapped == TRUE)
	whileLoop:
		bne $t3,TRUE,endofWhile			#if(swapped != TRUE)

		li $t3, FALSE					#swapped = FALSE

		#for(i = bottom; i < top; i++)
		move $t4,$t1					#i = bottom 
		forLoop1:
			bge $t4,$t2, endofFL1 		#if(i>=top) goto endofFL1

			mul $t5,$t4,4				#offset = i*4
			add $t6,$t0,$t5				#address+(i*4)

			lw $t7, ($t6)				#list[i]
			lw $t8, 4($t6) 				#list[i+1]

			#if(list[i] > list[i+1])
			ble $t7,$t8,noSwap1
				sw $t7, 4($t6) 			#swap (list[i], list[i+1])
				sw $t8, ($t6)
				li $t3,TRUE				#swapped = TRUE 
			noSwap1: 

			add $t4,$t4,1 				#i++
			b forLoop1					#goto forLoop1

		endofFL1:

		sub $t2,$t2,1					#top--

		#for(i = top; i > bottom ; i--)
		move $t4,$t2 					#i = top
		forLoop2:

			ble $t4,$t1,endofFL2		#if(i <= bottom) goto endofFL2

			mul $t5,$t4,4				#offset = i*4
			addu $t6,$t0,$t5			#address+(i*4)
			lw $t7, ($t6)				#list[i]

			subu $t6,$t6,4 				#(address+(i*4)-4)
			lw $t8, ($t6) 				#list[i-1]

			#if(list[i] < list[i-1])
			bge $t7,$t8,noSwap2
				sw $t7, ($t6)			#swap (list[i], list[i-1])
				sw $t8, 4($t6)
				li $t3,TRUE				#swapped = TRUE
			noSwap2:

			sub $t4,$t4,1 				#i--
			b forLoop2					#goto forLoop2

		endofFL2:

		add $t1,$t1,1					#bottom++
		b whileLoop 					#goto whileLoop

	endofWhile:	

#-----
#return once done 

	jr $ra     #return;

.end cocktailSort

#####################################################################
#  MIPS assembly language function, surfaceAreasStats, that
#    will find the minimum, median, maximum, sum, and average 
#    of the surface areas array.

#    Finds the maximum after the array is sorted
#    (i.e, max=list(len-1)).
#    The average is calculated as floating point value.

# -----
#    Arguments:
#	$a0 - starting address of the surface areas array
#	$a1 - list length
#	$a2 - addr of min
#	$a3 - addr of med
#	($fp) - addr of max
#	4($fp) - addr of sum
#	8($fp) - addr of ave (float)

#    Returns (via addresses):
#	min
#	med
#	max
#	sum
#	average

.globl surfaceAreasStats
.ent surfaceAreasStats
surfaceAreasStats:

	#------
	#prolgue

	subu $sp,$sp,4 				#save $fp constent
	sw $fp, ($sp)

	addu $fp,$sp,4	 			#points at at the first Argument

	#------
	#grab addresses on stack 

	lw $t0, 0($fp) 				#address of max 
	lw $t1, 4($fp) 				#address of sum 
	lw $t2, 8($fp) 				#address of ave

	#---------
	#Find Sum,Min,and Max 

	move $t8, $a0 				#surfaceAreas[]
	move $t3, $zero 			#i = 0
	move $t4, $zero 			#tempSum = 0
	lw $t5, 0($a0)  			#get Min 
	lw $t6, 0($a0)				#get Max 

	statsLoop:
		move $t7,$zero 			#clear
		lw $t7, ($t8) 			#surfaceAreas [i]	

		add $t4,$t4,$t7 		#tempSum = tempSum + surfaceAreas[i]

		ble $t5,$t7,notMin		#if(min > surfaceArea[i])
			move $t5,$t7 		# $t5 = $t7
		notMin:

		bge $t6,$t7,notMax		#if(max < surfaceArea[i])
			move $t6,$t7 		# $t6 = $t7
		notMax:

		addu $t8,$t8,4 			#offset 
		add $t3,$t3,1			#i++

		blt $t3, $a1, statsLoop	
	#end of statsLoop

	sw $t5, ($a2)	 			#store value of Min 
	sw $t6, ($t0)	 			#store value of Max 
	sw $t4, ($t1) 				#store value of Sum 

	#----
	#get Average 
	#$t4 = TempSum 

	mtc1 $t4, $f0 				#$t4(sum) -> $f0 as int 
	cvt.s.w $f0,$f0 			#convert word to 32 bit floating point 

	move $t5, $a1 				#get length
	mtc1 $t5, $f1 				#convet length into 32 bit float 
	cvt.s.w $f1, $f1

	div.s $f2, $f0, $f1 		#get average as float
	s.s $f2, ($t2) 				#store floating  point 

	#----
	#get Med 
	move $t5, $a1 				#get length
	move $t6, $a0 				#surfaceAreas[]
	rem $t4, $t5, 2				# length%2 

	beqz $t4, EvenList
		#ODD List 
		div $t3, $t5, 2			# length/2
		move $t4, $zero 		#clear 

		mul $t4,$t3, 4	 		#offset for lenght/2
		addu $t6, $t6, $t4
		lw $t4, 0($t6)
		sw $t4, 0($a3) 			#store med 
		b midDone

	EvenList:
		div $t3, $t5, 2	 		# length/2
		sub $t3, $t3, 1 		# length/2 - 1

		mul $t4, $t3, 4 		#offset for lenght/2 - 1
		addu $t6, $t6, $t4

		lw $t4, 0($t6)			#surfaceAreas[length/2 - 1]
		lw $t5, 4($t6) 			#surfaceAreas[length/2]

		move $t3, $zero
		add $t3, $t4, $t5
		div $t3, $t3, 2

		sw $t3, 0($a3) 			#store med 

	midDone:

	#---------
	#epilogue
	lw $fp, ($sp)
	addu $sp, $sp, 4


jr $ra

.end surfaceAreasStats

#####################################################################
#  MIPS assembly language function, printAreas(), to display
#   a surface areas array.  The surface areas should be printed
#   5 per line (as per example).

#   The numbers are right justified (i.e., lined up on right
#   side).  Assumes that the largest number is 5 digits.

#  Note, due to the system calls, the saved registers must
#        be used.  As such, push/pop saved registers altered.

# -----
#    Arguments:
#	$a0 - starting address of the surface areas array
#	$a1 - list length

#    Returns:
#	N/A


.globl printAreas
.ent printAreas
printAreas:

#-------
#prolgue 

subu $sp, $sp, 12 
sw $s0, 8($sp) 					#push $s0
sw $s1, 4($sp)		 			#push $s1		
sw $s2, 0($sp) 					#push $s2

#-----

	move $s0, $a0 				#get base address 
	move $s1, $zero  			#i = 0 
	move $s2, $a1 				#get length 

	printAreaLoop:
		#print surfaceArea[i]
		li $v0, 1				#call code for print int
		lw $a0, ($s0) 			#grab surfaceArea[i]
		syscall

		#------
		#print spaces 
		li $v0, 4
		la $a0, tab
		syscall

		addu $s0, $s0, 4		#base address + 4
		add $s1, $s1, 1			#i++

		rem $t0,$s1,5			#temp0 = i%5
		bnez $t0,skipNewLine  	#if(temp0 == 0)

			#-----
			#print newline feed 
			li $v0, 4
			la $a0, new_ln
			syscall

		skipNewLine:

		blt $s1, $s2, printAreaLoop

#-----
#epilogue 

lw $s2, 0($sp) 				#pop $s0
lw $s1, 4($sp)				#pop $s1
lw $s0, 8($sp)				#pop $s2
addu $sp, $sp, 12 

jr $ra

.end printAreas




#####################################################################
#  MIPS assembly language function, printStats(), to display
#   the final surface areas array.
#   Prints the maximum, median, sum, and average.

# -----
#    Arguments:
#	$a0 - min
#	$a1 - med
#	$a2 - max
#	$a3 - sum1
#	($fp) - average

#    Returns:
#	n/a


.globl printStats
.ent printStats
printStats:

	#----
	#prolgue
	subu $sp, $sp, 4
	sw $fp, 0($sp) 
	addu $fp , $sp, 4

	subu $sp, $sp, 20
	s.s $f20, 0($sp)
	sw $s3, 4($sp)
	sw $s2, 8($sp)
	sw $s1, 12($sp)
	sw $s0, 16($sp)

	#-----
	#callee saved

	move $s0, $a0 	#min - value
	move $s1, $a1   #med - value
	move $s2, $a2   #max - value
	move $s3, $a3 	#sum - value
	l.s $f20, 0($fp)  #average - value

	#-----
	#Print newline

	la $a0, new_ln
	li $v0, 4
	syscall

	#-----
	#Print Surface Area Min

	la $a0, str1
	li $v0, 4
	syscall

	move $a0, $s0
	li $v0, 1
	syscall 

	#-----
	#Print Surface Area Med

	la $a0, str2
	li $v0, 4
	syscall

	move $a0, $s1
	li $v0, 1
	syscall

	#-----
	#Print Surface Area Max

	la $a0, str3
	li $v0, 4
	syscall

	move $a0, $s2
	li $v0, 1
	syscall

	#-----
	#Print Surface Area Sum

	la $a0, str4
	li $v0, 4
	syscall

	move $a0, $s3
	li $v0, 1
	syscall

	#-----
	#Print Surface Area Ave

	la $a0, str5
	li $v0, 4
	syscall

	mov.s $f12, $f20
	li $v0, 2
	syscall

	#-----
	#Print newline

	la $a0, new_ln
	li $v0, 4
	syscall

	#-----
	#epilogue 

	l.s $f20, 0($sp)
	lw $s3, 4($sp)
	lw $s2, 8($sp)
	lw $s1, 12($sp)
	lw $s0, 16($sp)	
	addu $sp, $sp, 20

	lw $fp, 0($sp)
	addu $fp, $sp, 4

jr $ra

.end printStats

#####################################################################


