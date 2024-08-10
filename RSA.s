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
    MOV r10, r1             // move public key exp to r10

    LDR r0, =pubKeyExp
    MOV r1, r10
    BL printf

    # Generate private key exponent
    MOV r0, r7              // move totient to r0
    MOV r1, #5              // move pubKeyExp to r1
    BL cprivexp
    MOV r11, r0             // move private key exp to r11

    LDR r0, =privKeyExp
    MOV r1, r11
    BL printf
    
    # Encrypt a message
    MOV r0, #5              // move pubKeyExp to r0
    MOV r1, r6              // move modulus N to r1
    BL encrypt_message

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

    pubKeyExp: .asciz "\nPublic Key Exponent: %d\n"

    privKeyExp: .asciz "\nPrivate Key Exponent: %d\n"

# END main

# ----------------------------------------------------------------------------------
# Purpose: To encrypt a clear text file
#   We will use encrypt functionn to encrypt contents in clear text file.
#   
#   Input : public key exponent (r0), modulus N (r1)
#   Output: None

.text
encrypt_message:

    # Program dictionary
    # r4 - public key exponent
    # r5 - modulus N

    # Push to the stack
    SUB sp, sp, #12
    STR lr, [sp]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    # Store input pubKeyExp into R4
    MOV r4, r0
    # Store input modulus N into R5
    MOV r5, r1

    BL print_line_separator

    LDR r0, =promptFile
    BL printf

    LDR r0, =inputFormat
    LDR r1, =input_file
    BL scanf

    LDR r0, =input_file
    LDR r1, =file_read_mode
    BL fopen

    LDR r1, =file_read_pointer
    STR r0, [r1]
    CMP r0, #0
    BEQ invalid_file

        LDR r0, =outputFileFormat
        LDR r1, =input_file
        BL printf

        # Initialize write file pointer
        LDR r0, =output_file_name
        LDR r1, =file_write_mode
        BL fopen
        LDR r1, =file_write_pointer
        STR r0, [r1]

    read_loop:
        LDR r0, =file_read_pointer
        LDR r0, [r0]
        BL fgetc
        CMP r0, #-1
        BEQ end_read_loop

            LDR r1, =file_content
            STR r0, [r1]

            LDR r1, =file_content
            LDR r1, [r1]
            MOV r0, r1
            MOV r1, r4
            MOV r2, r5

            # Process file content character by character
            # Logic to encrypt character goes here
            BL modulus_exponentiation
            MOV r2, r0

            LDR r0, =file_write_pointer
            LDR r0, [r0]
            LDR r1, =writeFileContentFormat
            BL fprintf

            LDR r1, =file_content
            LDR r1, [r1]
            LDR r0, =outputFileContentFormat
            BL printf

            B read_loop
        
    end_read_loop:
        B close_file

    close_file:
        LDR r0, =file_read_pointer
        LDR r0, [r0]
        BL fclose
        LDR r0, =file_write_pointer
        LDR r0, [r0]
        BL fclose
        B done

    invalid_file:
        LDR r0, =errorInvalidFile
        BL printf

    done:

    LDR r0, =outputNextLineFormat
    BL printf

    LDR r0, =outputEncryptedFileFormat
    BL printf

    # Pop from stack
    LDR lr, [sp]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr

.data
    promptFile: .asciz "\nEnter a clear-text file path to encrypt: "
    inputFormat: .asciz "%s"
    input_file: .space 50

    outputFileFormat: .asciz "\nContent of the file [ %s ] is: "
    outputFileContentFormat: .asciz "%c"
    outputEncryptedFileFormat: .asciz "Encrypted content is written to file [ 'encrypted.txt' ]\n"
    outputNextLineFormat: .asciz "\n"

    writeFileContentFormat: .asciz "%d "

    errorInvalidFile: .asciz "\nError: File doesn't exist or access denied\n"
    file_content: .word 0

    file_read_pointer: .word 0
    file_write_pointer: .word 0
    file_read_mode: .asciz  "r"
    file_write_mode: .asciz  "w"
    output_file_name: .asciz "encrypted.txt"

# END encrypt_message
# ----------------------------------------------------------------------------------
# Purpose: To decrypt an encrypted file
#   We will use decrypt functionn to decrypt contents in encrypted file.
#   
#   Input : private key exponent (r0), modulus N (r1)
#   Output: None

.text
decrypt_message:

    # Program dictionary
    # r4 - private key exponent
    # r5 - modulus N

    # Push to the stack
    SUB sp, sp, #12
    STR lr, [sp]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    # Store input privKeyExp into R4
    MOV r4, r0
    # Store input modulus N into R5
    MOV r5, r1

    BL print_line_separator

    LDR r0, =promptDecryptFile
    BL printf

    LDR r0, =inputDecryptFormat
    LDR r1, =decrypt_input_file
    BL scanf

    LDR r0, =decrypt_input_file
    LDR r1, =decrypt_file_read_mode
    BL fopen

    LDR r1, =decrypt_file_read_pointer
    STR r0, [r1]
    CMP r0, #0
    BEQ decrypt_invalid_file

        LDR r0, =decrypt_outputFileFormat
        LDR r1, =decrypt_input_file
        BL printf

        # Initialize write file pointer
        LDR r0, =decrypt_output_file_name
        LDR r1, =decrypt_file_write_mode
        BL fopen
        LDR r1, =decrypt_file_write_pointer
        STR r0, [r1]

    decryption_read_loop:
        LDR r0, =decrypt_file_read_pointer
        LDR r0, [r0]
        LDR r1, =decrypt_readFileContentFormat
        LDR r2, =encrypted_file_content
        BL fscanf

        CMP r0, #1
        BNE end_decryption_read_loop

            LDR r0, =encrypted_file_content
            LDR r0, [r0]

            MOV r1, r4
            MOV r2, r5

            # Process file content character by character
            # Logic to encrypt character goes here
            BL modulus_exponentiation
            MOV r2, r0

            LDR r0, =decrypted_file_content
            LDR r0, [r0]

            LDR r0, =decrypt_file_write_pointer
            LDR r0, [r0]
            LDR r1, =decrypt_writeFileContentFormat
            BL fprintf

            LDR r1, =decrypted_file_content
            LDR r1, [r1]
            LDR r0, =decrypt_outputFileContentFormat
            BL printf

            B decryption_read_loop
        
    end_decryption_read_loop:
        B decrypt_close_file

    decrypt_close_file:
        LDR r0, =decrypt_file_read_pointer
        LDR r0, [r0]
        BL fclose
        LDR r0, =decrypt_file_write_pointer
        LDR r0, [r0]
        BL fclose
        B decrypt_done

    decrypt_invalid_file:
        LDR r0, =decrypt_errorInvalidFile
        BL printf

    decrypt_done:

    LDR r0, =decrypt_outputNextLineFormat
    BL printf

    LDR r0, =decrypt_outputDecryptedFileFormat
    BL printf

    BL print_line_separator

    # Pop from stack
    LDR lr, [sp]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr

.data
    promptDecryptFile: .asciz "\nEnter a encrypted file path to decrypt: "
    inputDecryptFormat: .asciz "%s"
    decrypt_input_file: .space 50

    decrypt_outputFileFormat: .asciz "\nContent of the file [ %s ] is: "
    decrypt_readFileContentFormat: .asciz "%d"
    decrypt_outputFileContentFormat: .asciz "%d "
    decrypt_outputDecryptedFileFormat: .asciz "\nDecrypted content is written to file [ 'decrypted.txt' ]\n"
    decrypt_outputNextLineFormat: .asciz "\n"

    decrypt_writeFileContentFormat: .asciz "%c"

    decrypt_errorInvalidFile: .asciz "\nError: File doesn't exist or access denied\n"
    decrypt_file_content: .space 40
    encrypted_file_content: .word 0

    decrypt_file_read_pointer: .word 0
    decrypt_file_write_pointer: .word 0
    decrypt_file_read_mode: .asciz  "r"
    decrypt_file_write_mode: .asciz  "w"
    decrypt_output_file_name: .asciz "decrypted.txt"

# END decrypt_message
# ----------------------------------------------------------------------------------
.text
print_line_separator:
    # Push to the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    LDR r1, =loop_counter
    LDR r1, [r1]

    LDR r0, =outputNextLine
    BL printf

    startLoop:
        CMP r1, #80
        BGT endLoop
            LDR r0, =outputLineSeparator
            BL printf

            LDR r1, =loop_counter
            LDR r1, [r1]
            ADD r1, r1, #1
            LDR r3, =loop_counter
            STR r1, [r3]
            B startLoop
    endLoop:

    LDR r0, =outputNextLine
    BL printf

    MOV r1, #1
    LDR r3, =loop_counter
    STR r1, [r3]

    # Pop from stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    outputLineSeparator: .asciz "-"
    outputNextLine: .asciz "\n"
    loop_counter: .word 1

# END main 
# ----------------------------------------------------------------------------------
  
