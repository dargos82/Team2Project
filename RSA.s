#Program Name: RSA.s
#Author: David Blossom, Suresh Alagarsamy, Eric Kozlowski
#Date: 18 August 2024
#Purpose: Implement the RSA algorithm in ARM assembly
#Input: name - type; name - type; etc.
#Output: name - description; etc.
#Program Dictionary:
#	r4:	keyVariableP
#	r5:	keyVariableQ
#	r6:	modulus
#	r7:	variable value for isPrime; theta
#	r8:	loop limit for isPrime
#	r9:	divisor for isPrime

.text
.global main
main:

    #push the stack
    SUB sp, sp, #28
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]
    STR r8, [sp, #20]
    STR r9, [sp, #24]

    GetInputP:
    
    #Get user input for p
    LDR r0, =promptP
    BL printf
    
    #Read, verify, and load user input
    LDR r0, =keyVariablePFormat
    LDR r1, =keyVariableP
    BL scanf

    LDR r4, =keyVariableP
    LDR r4, [r4]			//r4 has value for keyVariable for P

    #Check that keyVariableP is in correct range
    MOV r0, r4				//move value of p from r4 to r0
    BL checkRange			//if p is in correct range, r0 = 1
    MOV r1, #1				//move test value
    CMP r0, r1				//compare r0 to test value
    BNE RangeErrorP
	//B EndProgram

    #Check that keyVariableP is a prime number
    MOV r0, r4				//move value of p from r4 to r0
    BL isPrime				//if p is a prime number, r0 = 1
    MOV r1, #1				//move test value
    CMP r0, r1				//compare r0 to test value
    BNE PrimeErrorP
	//B EndProgram			//comment this out to continue program
	B GetInputQ

    RangeErrorP:
	#print error
	LDR r0, =rangeErrorMsg
	BL printf
	B GetInputP

    PrimeErrorP:
	#print error
	LDR r0, =primeErrorMsg
	BL printf
	B GetInputP

    GetInputQ:
    
    #Get user input for q
    LDR r0, =promptQ
    BL printf
    
    #Read, verify, and load user input
    LDR r0, =keyVariableQFormat
    LDR r1, =keyVariableQ
    BL scanf

    LDR r5, =keyVariableQ
    LDR r5, [r5]			//r5 has value for keyVariableQ

    #Check that keyVariableQ is in correct range
    MOV r0, r5				//move value of q from r5 to r0
    BL checkRange			//if q is in correct range, r0 = 1
    MOV r1, #1				//move test value
    CMP r0, r1				//compare r0 to test value
    BNE RangeErrorQ
	//B EndProgram

    #Check that keyVariableQ is a prime number
    MOV r0, r5				//move value of q from r5 to r0
    BL isPrime				//if q is a prime number, r0 = 1
    MOV r1, #1				//move test value
    CMP r0, r1				//compare r0 to test value
    BNE PrimeErrorQ
	B EndProgram

    RangeErrorQ:
	#print error
	LDR r0, =rangeErrorMsg
	BL printf
	B GetInputQ

    PrimeErrorQ:
	#print error
	LDR r0, =primeErrorMsg
	BL printf
	B GetInputQ



    EndProgram:
	   
    #pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    LDR r9, [sp, #24]
    ADD sp, sp, #28
    MOV pc, lr

.data

    #prompt for user input
    promptP:	.asciz	"\nFor p, please enter a prime number between 1 and 50: "

    #format for user input
    keyVariablePFormat:	.asciz	"%d"

    #variable for user input for p
    keyVariableP:	.word	0

    #prompt for user input
    promptQ:	.asciz	"\nFor q, please enter a prime number between 1 and 50: "

    #format for user input
    keyVariableQFormat:	.asciz	"%d"

    #variable for user input for q
    keyVariableQ:	.word	0

    #error if input is outside acceptable range
    rangeErrorMsg:	.asciz	"\nInvalid input: value is not in the specified range."

    #error if input is not a prime number
    primeErrorMsg:	.asciz	"\nInvalid input: value must be a prime number."
   
