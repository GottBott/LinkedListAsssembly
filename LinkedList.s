# Ben Gotthold
# November 27, 2012


.text
.align 2
.globl main

main:

	li $t0,0		# put constant 0 in t0 for first ellemnt
	li $t1,100000		# put constant 10000 in t1 for last ellement

	# make a last node
	addi $sp,$sp,-8		# request 8 bytes, 2 words for int and pointer
	sw $t1,0($sp)		# save int in first word
	la $t2,0($sp)		# load the adress of this node into t2
	
	# first noake a first node
	addi $sp,$sp,-8		# request 8 bytes, 2 words for int and pointer
	sw $t0,0($sp)		# save int in first word
	sw $t2,4($sp)		# save adress in second word	

	la $a0,0($sp)		# load adress of stack pointer
	sw $a0,head		# store adress in head
	
	j loop
loop:	
	
	li $v0,4  		# print string systemcall
	la $a0,prompt		# put string in $a0
	syscall 		# system call to print prompt
	li $v0,5		# read system call
	syscall 		# read input
	add $a0,$v0,$zero 	# read move to $a0
	beq $a0,$zero,Traverse  # if zero is entered go to traverse
	j pre_Insert		# call Insert

pre_Insert:
	
	addi $sp,$sp,-8		# request 8 bytes, 2 words for int and pointer
	sw $a0,0($sp)		# save int in first word
	#jal update_head
	jal Insert
	
	j loop			# jump back to main

Insert:
	lw $a1, head		#put addres of head into t0
	j Insert_loop		
	
Insert_loop:
	lw $s1,0($a1)   	# load value of node

	blt $a0,$s1,update	# is smaller value add

	addi $t4,$a1,4		# move to pointer part of node
	move $t3,$t4		# make a copy of previous adress
	lw $a1,0($t4)		# get adress of next node
	
	j Insert_loop	
	
	
update:
	
	move $t0, $a1		# put the adress node sould point to in t0
	sw $t0,4($sp)		# save pointer to next node
	la $t0,0($sp)		# put current node adress in t0
	sw $t0,0($t3)		# place pointer to new node in previous
	j $ra


Traverse:
	lw $a2, head		# load head value which is an adress
	j print
print:
	
	lw $s1,0($a2)   	# load value of node
	li $t5,100000
	beq $t5,$s1,done	# when stack no longer contains values jump to done
	
	li $t5,0		
	beq $s1,$t5,first_print	# dont print the 0 node

	li $v0,1		# print an integer system call
	move $a0,$s1	  	# Copy from stack to $a0
	syscall 		# print result

first_print:	
	addi $t4,$a2,4 		# move to pointer part of node									3
	lw $a2,0($t4)		# load adress of net node
	
	j print
done:
	j main			# done! jump to main



.data
prompt:.asciiz "\nEnter an Integer: "
head: .word 0
