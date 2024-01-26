#author:	Patrick Wacholtz
#name:		string_backwards.asm
#purpose:	use MMIO sim. to recieve user input string and return the string backwards

# Note: After starting the program, press "Reset" on the keyboard/display
#	before things will work correctly
#	Additionaly, set Delay length to 1 instruction executions in the MMIO Simulator
	.eqv	IO_BASE		0xffff0000
	.eqv 	DISP_STATUS	0x08
	.eqv 	DISP_DATA	0x0c
	.eqv 	KBD_STATUS	0x00
	.eqv 	KBD_DATA	0x04
	.eqv	RDK		0xffff0004

.text
	la	$t0,IO_BASE			# load interface base
	la	$t2,LOC				# load string address


print_prompt:
	li	$t3,'E'				
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'n'
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 't'
	sw	$t3,DISP_DATA($t0)
	li	$t3,'e'				
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'r'
	sw	$t3,DISP_DATA($t0)		
	li	$t3, ' '
	sw	$t3,DISP_DATA($t0)
	li	$t3,'S'				
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 't'
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'r'
	sw	$t3,DISP_DATA($t0)
	li	$t3, 'i'
	sw	$t3,DISP_DATA($t0)
	li	$t3, 'n'
	sw	$t3,DISP_DATA($t0)
	li	$t3, 'g'
	sw	$t3,DISP_DATA($t0)
	li	$t3,' '				
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'w'
	sw	$t3,DISP_DATA($t0)		
	li	$t3, '/'
	sw	$t3,DISP_DATA($t0)
	li	$t3, ' '
	sw	$t3,DISP_DATA($t0)
	li	$t3,'C'				
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'R'
	sw	$t3,DISP_DATA($t0)		
	li	$t3, ':'
	sw	$t3,DISP_DATA($t0)
	li	$t3, '\n'
	sw	$t3,DISP_DATA($t0)

	
	li	$t6, -1				#offset counter used to display string backwards
read:	lw	$t4,KBD_STATUS($t0)		# get status
 	andi	$t4,$t4,1			# check key ready flag
	beqz	$t4,read			# if 0, no data
	lw	$t5,KBD_DATA($t0)		# get character
	
	sb	$t5,0($t2)			# save in string
	addi	$t2,$t2,1			# increment pointer
	subi	$t6, $t6, 1			# decrement $t6 pointer
echo:	lw	$t4,DISP_STATUS($t0)		# get display status
	andi	$t4,$t4,1			# check display ready flag
	beqz	$t4,echo			# if 0, wait
	sw	$t5,DISP_DATA($t0)		# output character
	bne	$t5,$t3,read			# if not CR, repeat
	
print_backwards_prompt:
	li	$t3,'S'				
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 't'
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'r'
	sw	$t3,DISP_DATA($t0)
	li	$t3, 'i'
	sw	$t3,DISP_DATA($t0)
	li	$t3, 'n'
	sw	$t3,DISP_DATA($t0)
	li	$t3, 'g'		
	sw	$t3,DISP_DATA($t0)		
	li	$t3, ' '
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'b'
	sw	$t3,DISP_DATA($t0)
	li	$t3,'a'				
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'c'
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'k'
	sw	$t3,DISP_DATA($t0)
	li	$t3, 'w'
	sw	$t3,DISP_DATA($t0)
	li	$t3,'a'				
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'r'
	sw	$t3,DISP_DATA($t0)		
	li	$t3, 'd'
	sw	$t3,DISP_DATA($t0)
	li	$t3, 's'
	sw	$t3,DISP_DATA($t0)
	li	$t3,':'				
	sw	$t3,DISP_DATA($t0)		
	li	$t3, '\n'
	sw	$t3,DISP_DATA($t0)		

	
	li	$t7, -2			#loop increment counter
loop:
	beq	$t7, $t6, end_loop	#end when the loop counter reaches the previously calculated offset counter
	
	add	$t8, $t2, $t7		#calculate the $t2 at offset $t7
	lb 	$t5, ($t8)		#load byte at said address
	sw	$t5,DISP_DATA($t0)
	
	subi	$t7, $t7, 1		#decrement counter
	j	loop
	
end_loop:

	li	$v0, 10
	syscall

.data

# space for storing string
LOC:		.space	100
