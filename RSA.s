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
	B GetN

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

    #Calculate Modulus n
    GetN:
	MOV r0, r4			//move keyVariableP from r4 to r0
	MOV r1, r5			//move keyVariableQ from r5 to r1
		BL modulus		//modulo returned in r0
    	MOV r6, r0			//move modulo from r0 to r6

    	B GetTotient

    #Calculate Totient theta
    GetTotient:
    	MOV r0, r4			//move keyVariableP from r4 to r0
    	MOV r1, r5			//move keyVariableQ from r5 to r1
   	BL totient			//totient returned in r0
    	MOV r7, r0			//move totient phi from r0 to r7

	B GetPublicKeyExponent

    #Generate public key exponent
    GetPublicKeyExponent:
        BL cpubexp			//r10 = valid public key exponent
        MOV r10, r0			// move public key exp to r10

    #Generate private key exponent


    #Prompt User with options to Encrypt, Decrypt, or Exit
    
    
    #Encrypt a message
    GetInputEM:

        #Get user input for Message to Encrypt
        LDR r0, =promptEM
        BL printf

        #Read, verify, and load user input
        LDR r0, =encryptionMessageFormat
        LDR r1, =encryptionMessage
        BL scanf

        LDR r4, =encryptionMessage
        LDR r4, [r4]			//r4 has value for encryptionMessage

        #Open output file (encrypted.txt)
        LDR r0, =encryptFile
        LDR r1, =fileWrite
        BL fopen
        MOV r9, r0			//move file pointer, r0, into r9

        #Loop through message one character at a time
        StartEncryptLoop:
            #Get ASCII value of character from user input
            LDRB r0, [r4], #1		//move m (character in message) into r0

            #Check if end of string
            CMP r0, #0
            BEQ EndEncryptLoop

            #Calculate cypher value, c, using Encrypt Function
            MOV r1, r10			//move e (public key exponent) from r10 to r1
            MOV r2, r6                  //move n (calculated modulus) from r6 to r2
            BL encrypt			//c is now in r0

            #write c (add space) to output file
            MOV r1, r9
            BL fprintf

            #Restart Loop for next character
            B StartEncryptLoop

        EndEncryptLoop:

        #Close output file (encrypted.txt)
        MOV r0, r9			//move file pointer into r0
        BL fclose

    #Decrypt a message
    GetInputDM:

        #Open input file (encrypted.txt)
        LDR r0, =encryptFile
        LDR r1, =fileRead
        BL fopen
        MOV r9, r0			//move file pointer, r0, into r9

        #Open output file (plaintext.txt)
        LDR r0, =plaintextFile
        LDR r1, =fileWrite
        BL fopen
        MOV r10, r0			//move file pointer, r0, into r10

        #Loop through message one character at a time
        StartDecryptLoop:
            #Get ASCII value of character from encrypt file into r0
            BL fscanf

            #Check if end of file
            CMP r0, #0
            BEQ EndDecryptLoop

            #Calculate m, decrypted character, using Decrypt Function
            MOV r1, r11			//move d (private key) from r11 to r1
            MOV r2, r6			//move n (calculated modulus) from r6 to r2
            BL decrypt

            #Write m (decypt character) to plaintext file
            MOV r1, r10			//move file pointer for plaintext to r1
            BL fprintf

            #Restart Loop for next character
            B StartDecryptLoop

        EndDecryptLoop:

        #Close input file (encrypted.txt)
        MOV r0, r9
        BL fclose

        #Close output file (plaintext.txt)
        MOV r0, r10
        BL fclose

    EndProgram:
	   
    #pop the stack
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
    rangeErrorMsg:	.asciz	"\nInvalid input: value is not in the specified range.\n"

    #error if input is not a prime number
    primeErrorMsg:	.asciz	"\nInvalid input: value must be a prime number\n."

    #error if p and q are equal
    equalErrorMsg:	.asciz	"\nInvalid input: p and q cannot be equal.\n"

    #prompt for user input
    promptO:		.asciz "\nEnter 1 for Encrypt, 2 for Decrypt, or 3 to Exit: "

    #format for user input
    optionsFormat:	.asciz "%d"

    #variable for user input for Options
    optionsVariable:	.word	0

    #prompt for use input
    promptEM:		.asciz "\nPlease enter a short message to encrypt: "

    #format for user input
    encryptionMessageFormat:	.asciz "%s"

    #variable for user input for enryption message
    encryptionMessage:	.space	256

    #encrypt file
    encryptFile:	.asciz "encrypt.txt"

    #file Write
    fileWrite:		.asciz "w"

    #file Read
    fileRead:		.asciz "r"

    #plaintext file
    plaintextFile:	.asciz "plaintext.txt"

  
