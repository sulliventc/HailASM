# By Colten Sullivent

.data
  	prompt: .asciiz "Enter an integer.\n"
  	itr: 	.asciiz "\nNumber of iterations: "
  	lbrk: 	.asciiz "\n"
.text
	li 	$t3, 0 		# iteration counter
	
  	la 	$a0, prompt 	# load the prompt
  	li 	$v0, 4 		# load print string syscall
  	syscall 		# print prompt
  	li 	$v0, 5 		# load get input syscall
  	syscall 		# get input
  	move 	$t2, $v0 	# store the input
  
loop:  	addi 	$t3, $t3, 1 	# increment iteration counter
	li 	$v0, 1 		# load print integer syscall
	move 	$a0, $t2 	# load working register to syscall arg
	syscall 		# print working register
	li 	$v0, 4 		# load print string syscall
	la 	$a0, lbrk 	# load lbrk for printing
	syscall 		# print lbrk
	beq 	$t2, 1, done 	# if it's 1, we're done
  	andi 	$t1, $t2, 1 	# $t0 % 2
  	beq 	$t1, $zero, even# $t0 is even
  	
odd:	move 	$a0, $t2 	# move $t2 for multiply call
	li 	$a1, 3 		# load 3 for multiply call
	jal 	multiply 	# multiply $a0 and $a1
	addi 	$t2, $v0, 1 	# add 1 to result and store in $t2
	j 	loop 		# return to start of loop
	
even:	sra 	$t2, $t2, 1 	# divide by 2
	j 	loop 		# return to start of loop
	
done:	la 	$a0, itr 	# load the flavor text
	li 	$v0, 4 		# load print string syscall
	syscall 		# print flavor text
	move 	$a0, $t3 	# load iteration counter
	li 	$v0, 1 		# load print integer syscall
	syscall			# print iteration count
	li 	$v0, 10 	# load terminate program syscall
	syscall 		# We're done here

##########
# ------ #
##########

multiply:
	move	$v0, $0		# start product (result) at zero
	li	$t0, 16		# number of bits to multiply
	
mloop:	andi	$t1, $a0, 1	# get least significant bit of multiplier
	beq	$t1, $0, dontadd	# if zero, skip adding in multiplicand
	add	$v0, $v0, $a1	# add multiplicand to the product
dontadd:
	subi	$t0, $t0, 1	# decrement bit counter
	srl	$a0, $a0, 1	# shift multiplier right (see next bit)
	sll 	$a1, $a1, 1	# multiplying multiplier by 2
	bne	$t0, $0, mloop	# if there are more bits, loop
	
	jr	$ra