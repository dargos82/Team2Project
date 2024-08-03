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
#	r7:	theta

.text
.global main
main:

    #push the stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

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

    #Check that keyVariable for P is in correct range
    MOV r0, r4				//move value of p from r4 to r0
    BL checkRange			//if p is in correct range, r0 = 1
    MOV r1, #1				//move test value
    CMP r0, r1				//compare r0 to test value
    BNE RangeError
	B EndProgram

    RangeError:

	#print error
	LDR r0, =rangeErrorMsg
	BL printf
	B GetInputP

    EndProgram:
	   
    #pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr

.data

    #prompt for user input
    promptP:	.asciz	"\nPlease enter a value for p between 1 and 50: "

    #format for user input
    keyVariablePFormat:	.asciz	"%d"

    #variable for user input for p and q
    keyVariableP:	.word	0

    #prompt for user input
    promptQ:	.asciz	"\nPlease enter a value for q between 1 and 50: "

    #format for user input
    keyVariableQFormat:	.asciz	"%d"

    #variable for user input for p and q
    keyVariableQ:	.word	0

    #error if input is invalid
    rangeErrorMsg:	.asciz	"\nInvalid input: value is not in the specified range."

   
