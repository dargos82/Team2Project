#Program Name: RSA.s
#Author: David Blossom, Suresh Alagarsamy, Eric Kozlowski
#Date: 18 August 2024
#Purpose: Implement the RSA algorithm in ARM assembly
#Input: name - type; name - type; etc.
#Output: name - description; etc.
#Program Dictionary:
#	r4:	keyVariable for P
#	r5:	keyVariable for Q
#	r6:

.text
.global main
main:

    #push the stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    StartProgram:
    
    #Get user input for p and q
    LDR r0, =prompt1
    BL printf
    
    #Read, verify, and load user input
    LDR r0, =keyVariableFormat
    LDR r1, =keyVariable
    BL scanf

    LDR r4, =keyVariable
    LDR r4, [r4]			//r4 has value for keyVariable for P

    #Check that keyVariable for P is in correct range
    BL checkRange
    MOV r1, #1				//check against return value from checkRange


	   
    #pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr

.data

    #prompt for user input
    prompt1:	.asciz	"\nPlease enter a number between 1 and 50: "

    #format for user input
    keyVariableFormat:	.asciz	"%d"

    #variable for user input for p and q
    keyVariable:	.word	0
    
