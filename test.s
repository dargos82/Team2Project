#Program Name: test.s
#Author: David Blossom
#Purpose: test functions
#Program Dictionary:
#	r4:
#	r5:
#	r6:
#	r7:

.text
.global main
main:

    #push the stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    MOV r4, #16			//This is the input value (p or q)

    #Get the limit value
    MOV r0, r4
    MOV r1, #2
    BL __aeabi_idiv		//Limit value is input/2
    MOV r8, r0			//Move limit value to r3

    #Initialization
    MOV r9, #2			//initial divisor

    StartIsPrime:
    
    	#Check end condition
    	CMP r9, r8
    	MOV r0, #1
    	BGT EndIsPrime

    	#Loop
    	MOV r0, r4
    	MOV r1, r9
    	BL __aeabi_idiv
    	MUL r1, r1, r0
    	SUB r1, r4, r1
    	MOV r0, #0
    	CMP r0, r1
    	MOV r0, #0
    	BEQ EndIsPrime

    	#Next value
    	ADD r9, r9, #1
    	B StartIsPrime

    EndIsPrime:
    	MOV r1, r0
    	LDR r0, =output
    	BL printf
	   
    #pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr

.data

    #output
    output:	.asciz	"\n%d\n"
      
