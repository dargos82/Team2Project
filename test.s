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

    #Purpose: Determine if theta and exponent are co-prime or not
    #Program dictionary:
    #r7:	totient theta
    #r8:	loop counter
    #r9:	r7 mod r8
    #r10:	exponent
    #r11:	r10 mod r8

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
 
    #test values
    MOV r7, #17
    MOV r10, #11
 
    #r0 = totient theta; r1 = public key exponent (this is smaller than totient theta)
    
    #Initialize loop
    MOV r8, r10				//loop initialized to exponent value
    
    StartLoop:
	#check end condition
	MOV r1, #1
	CMP r8, r1
	BEQ EndLoop			//if r8 = 1, no common denominator other than 1
	
	#Loop
	MOV r0, r7
	MOV r1, r8
	BL modulo			//r0 = r7 mod r8
        MOV r9, r0			//move r0 to r9

	MOV r0, r10
        MOV r1, r8
	BL modulo			//r0 = r10 mod r8
	MOV r11, r0			//move r0 to r11

	MOV r1, #0
	MOV r2, #0
	MOV r3, #0
	CMP r1, r9
	ADDEQ r2, #1
	CMP r1, r11
	ADDEQ r3, #1

	AND r0, r2, r3			//r0 = 1 if r7 AND r10 have common denominator

	MOV r1, #1
	CMP r0, r1
	
	#Get next value
	SUB r8, r8, #1
	BNE StartLoop			//if r0 != 1, not a common denominator, restart loop
	    B notCoPrime

    EndLoop:
	LDR r0, =output2
	BL printf
	B End

    notCoPrime:
	LDR r0, =output
	BL printf

    End:
	   
    #pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr

.data

    #output
    output:	.asciz	"\nThese numbers are not co-prime.\n"

    #output
    output2:	.asciz	"\nThese numbers are co-prime.\n"



.text
modulo:

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
  
    #x mod y = x - ((x/y) * y)
    MOV r4, r0			//move r0 to r4
    MOV r5, r1			//move r1 to r5
    BL __aeabi_idiv		//r0 = x/y i.e. r0/r1
    MUL r0, r0, r5		//r0 = (x/y) * y i.e. r0 * r5
    SUB r0, r4, r0		//r0 = x - ((x/y) * y) i.e. r4 - r0

    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

#END modulo

     
