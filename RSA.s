#Program Name: RSA.s
#Author: David Blossom, Suresh Alagarsamy, Eric Kozlowski
#Date: 18 August 2024
#Purpose: Implement the RSA algorithm in ARM assembly
#Input: name - type; name - type; etc.
#Output: name - description; etc.
#Program Dictionary:
#	r4:	main: keyVariableP; modulo: numerator
#	r5:	main: keyVariableQ; modulo: denominator
#	r6:	main: modulus n
#	r7:	isPrime: variable value; totient: phi
#	r8:	isPrime: loop limit; gcd: loop counter
#	r9:	isPrime: divisor; gcd: value of r7 mod r8
#	r10:	cpubexp: pubKeyExp
#	r11:	cpriexp: priKeyExp; gcd: value of r10 mod r8

.text
.global main
main:

    #push the stack
    SUB sp, sp, #36
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]
    STR r8, [sp, #20]
    STR r9, [sp, #24]
    STR r10, [sp, #28]
    STR r11, [sp, #32]     

    #User Options 1
    LDR r0, =promptOp1
    BL printf

    #Read, verify, and load user input
    LDR r0, =opFormat
    LDR r1, =opVariable1
    BL scanf

    LDR r4, =opVariable1
    LDR r4, [r4]

    #Branch to Generation of Private and Public Keys if user inputs 1
    CMP r4, #1
    BEQ GetInputP

    #Branch to Exit if user inputs 2
    CMP r4, #2
    BEQ EndProgram

    GetInputP:
    
        #Get user input for P
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

            #Check that keyVariableP is a prime number
            MOV r0, r4				//move value of p from r4 to r0
            BL isPrime				//if p is a prime number, r0 = 1
            MOV r1, #1				//move test value
            CMP r0, r1				//compare r0 to test value
            BNE PrimeErrorP
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

        #Check that keyVariableP != keyVariableQ
        CMP r4, r5
        BEQ EqualError

        #Check that keyVariableQ is in correct range
        MOV r0, r5				//move value of q from r5 to r0
        BL checkRange			//if q is in correct range, r0 = 1
        MOV r1, #1				//move test value
        CMP r0, r1				//compare r0 to test value
        BNE RangeErrorQ

        #Check that keyVariableQ is a prime number
        MOV r0, r5				//move value of q from r5 to r0
        BL isPrime				//if q is a prime number, r0 = 1
        MOV r1, #1				//move test value
        CMP r0, r1				//compare r0 to test value
        BNE PrimeErrorQ
            B InputPQDone

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

    EqualError:
        #print error
        LDR r0, =equalErrorMsg
        BL printf
        B GetInputQ
    
    InputPQDone:


    # Calculate Modulus n
    MOV r0, r4			//move keyVariableP from r4 to r0
    MOV r1, r5			//move keyVariableQ from r5 to r1
    BL modulus		    //modulo returned in r0
    MOV r6, r0			//move modulo from r0 to r6

    # Calculate Totient theta
    MOV r0, r4			//move keyVariableP from r4 to r0
    MOV r1, r5			//move keyVariableQ from r5 to r1
    BL totient			//totient returned in r0
    MOV r7, r0			//move totient phi from r0 to r7

    # Generate public key exponent
    BL cpubexp				//r10 = valid public key exponent
    MOV r10, r0             // move public key exp to r10

    LDR r0, =pubKeyExp
    MOV r1, r10
    BL printf

    # Generate private key exponent
    MOV r0, r7              // move totient to r0
    MOV r1, r10              // move pubKeyExp to r1
    BL cprivexp
    MOV r11, r0             // move private key exp to r11

    LDR r0, =privKeyExp
    MOV r1, r11
    BL printf

    #Prompt user for options 2
    LDR r0, =promptOp2
    BL printf

    #Read, verify, and load user input
    LDR r0, =opFormat
    LDR r1, =opVariable2
    BL scanf

    LDR r4, =opVariable2
    LDR r4, [r4]

    #Branch to Encrypt if user inputs 1
    CMP r4, #1
    BEQ Encrypt

    #Branch to Decrypt if user inputs 2
    CMP r4, #2
    BEQ Decrypt

    #Branch to Exit if user inputs 3
    CMP r4, #3
    BEQ EndProgram
    
    Encrypt:
    # Encrypt a message
    MOV r0, r10              // move pubKeyExp to r0
    MOV r1, r6              // move modulus N to r1
    BL encrypt_message

    B EndProgram

    Decrypt:
    # Decrypt a message
    MOV r0, r11             // move privKeyExp to r0
    MOV r1, r6              // move modulus N to r1
    BL decrypt_message

    EndProgram:
	   
    # pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    LDR r9, [sp, #24]
    LDR r10, [sp, #28]
    LDR r11, [sp, #32]
    ADD sp, sp, #36
    MOV pc, lr

.data

    #prompt for user input
    promptP:	.asciz	"\nFor p, please enter a prime number between 1 and 200: "

    #format for user input
    keyVariablePFormat:	.asciz	"%d"

    #variable for user input for p
    keyVariableP:	.word	0

    #prompt for user input
    promptQ:	.asciz	"\nFor q, please enter a prime number between 1 and 200: "

    #format for user input
    keyVariableQFormat:	.asciz	"%d"

    #variable for user input for q
    keyVariableQ:	.word	0

    #error if input is outside acceptable range
    rangeErrorMsg:	.asciz	"\nInvalid input: value is not in the specified range.\n"

    #error if input is not a prime number
    primeErrorMsg:	.asciz	"\nInvalid input: value must be a prime number\n."

    #error if p and q are equal
    equalErrorMsg:	.asciz	"\nInvalid input: p and q cannot be equal.\n"

    pubKeyExp: .asciz "\nPublic Key Exponent: %d\n"

    privKeyExp: .asciz "\nPrivate Key Exponent: %d\n"

    #prompt for user options1
    promptOp1:		.asciz "\nPlease enter 1 to Generate Private and Public Keys or 2 to Exit: "

    #varibale for user options1
    opVariable1:	.word	0

    #prompt for user options2
    promptOp2:		.asciz "\nPlease enter 1 to Encrypt, 2 to Decrypt, or 3 to Exit: "

    #variable for user options2
    opVariable2:	.word	0

    #format for user options
    opFormat:		.asciz "%d"
   

# END main
  
