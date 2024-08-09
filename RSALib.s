
.global checkRange
.global isPrime
.global gcd
.global pow
.global modulus
.global modulo
.global totient
.global cpubexp
.global cprivexp
.global encrypt
.global decrypt

.text
checkRange:

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
  
    MOV r1, #1
    MOV r2, #0
    CMP r0, r1
    ADDGE r2, r2, #1		//if r0 >= 1, r2 = 1

    MOV r1, #50
    MOV r3, #0
    CMP r0, r1
    ADDLE r3, r3, #1		//if r0 <= 50, r3 = 1

    AND r0, r2, r3		//if r2 = 1 AND r3 = 1, r0 = 1 (number in range) 

    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

#END checkRange

.text
#Purpose: function returns r0 = 1 if true (is a prime), r0 = 0 if false (is not a prime)
#Program dictionary:
#r7:	input value
#r8:	loop limit
#r9:	divisor (incremented each loop)

isPrime:

    #push stack
    SUB sp, sp, #16
    STR lr, [sp]
    STR r7, [sp, #4]
    STR r8, [sp, #8]
    STR r9, [sp, #12]
  
    MOV r7, r0			//move input value to r7

    #Get the limit value
    MOV r1, #2
    BL __aeabi_idiv		//Limit value is r4/2
    MOV r8, r0			//Move limit value to r8

    #Initialization
    MOV r9, #2			//initial divisor

    StartIsPrime:
    
    	#Check end condition
    	CMP r9, r8
    	MOV r0, #1
    	BGT EndIsPrime

    	#Loop
    	MOV r0, r7
    	MOV r1, r9
    	BL __aeabi_idiv
    	MUL r1, r1, r0
    	SUB r1, r7, r1
    	MOV r0, #0
    	CMP r0, r1
    	MOV r0, #0
    	BEQ EndIsPrime

    	#Next value
    	ADD r9, r9, #1
    	B StartIsPrime

    EndIsPrime:
    	//MOV r1, r0		//this block can be used for testing; 1=true, 0=false
    	//LDR r0, =output
    	//BL printf

    #pop stack
    LDR lr, [sp]
    LDR r7, [sp, #4]
    LDR r8, [sp, #8]
    LDR r9, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr    

.data

#END isPrime



.text
gcd:

    #Purpose: Determine if phi and exponent are co-prime or not;
    #r0 = 0 if co-prime; r0 = 1 if not co-prime
    #Program dictionary:
    #r7:	totient phi
    #r8:	loop counter
    #r9:	r7 mod r8
    #r10:	exponent
    #r11:	r10 mod r8

    #push stack
    SUB sp, sp, #24
    STR lr, [sp]
    STR r7, [sp, #4]
    STR r8, [sp, #8]
    STR r9, [sp, #12]
    STR r10, [sp, #16]
    STR r11, [sp, #20]
 
    #r0 = totient theta; r1 = public key exponent (this is smaller than totient theta)
    
    #Initialize loop
    MOV r7, r0				//move totient from r0 to r7
    MOV r0, #0				//initialize r0 to 0
    MOV r10, r1				//move exponent from r1 to r10
    MOV r8, r1				//loop initialized to exponent value
    
    StartLoop:
	#check end condition
	MOV r1, #1
	CMP r8, r1
	BEQ EndGCD			//if r8 = 1, r0 = 0 and no common denominator other than 1
	
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
	CMP r1, r9			//compare r7 mod r8 to 0
	ADDEQ r2, #1			//if mod != 0, r2 = 1
	CMP r1, r11			//compare r11 mod r8 to 0
	ADDEQ r3, #1			//if mod != 0, r3 = 1

	AND r0, r2, r3			//if r0 = 1, r7 and r10 have common denominator > 1 

	MOV r1, #1
	CMP r0, r1

	#Get next value
	SUB r8, r8, #1
	BNE StartLoop			//if r0 = 0, not a common denominator, restart loop for next test
	    B EndGCD			//Branch to end, r0 = 1 and they have a common denominator > 1

    EndGCD:
	   
    #pop the stack
    LDR lr, [sp, #0]
    LDR r7, [sp, #4]
    LDR r8, [sp, #8]
    LDR r9, [sp, #12]
    LDR r10, [sp, #16]
    LDR r11, [sp, #20]
    ADD sp, sp, #24
    MOV pc, lr

.data

    #output
    output:	.asciz	"\nThese numbers are not co-prime.\n"

    #output
    output2:	.asciz	"\nThese numbers are co-prime.\n"

#END gcd


.text
pow:
    #Purpose: Calculates the power of r0^r1
    #Program Dictionary:
    #r4:	Loop Counter
    #r5:	Loop Limit

    #push stack
    SUB sp, sp, #12
    STR lr, [sp]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    #Initialize Loop Counter
    MOV r4, #1

    #Move base from r0 to r2
    MOV r2, r0

    #Move exponent from r1 to r5, loop limit
    MOV r5, r1
  
    #Loop
    startPowLoop:
        # Check the limit
        CMP r4, r5
        BGE endPowLoop

            # Multiply base by base
            MUL r0, r0, r2

            #Get next
            ADD r4, r4, #1
            B startPowLoop

    endPowLoop:

    #pop stack
    LDR lr, [sp]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr    
	
.data

# END pow

.text
modulo:

    #push stack
    SUB sp, sp, #12
    STR lr, [sp]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
  
    #x mod y = x - ((x/y) * y)
    MOV r4, r0			//move r0 to r4
    MOV r5, r1			//move r1 to r5
    BL __aeabi_idiv		//r0 = x/y i.e. r0/r1
    MUL r0, r0, r5		//r0 = (x/y) * y i.e. r0 * r5
    SUB r0, r4, r0		//r0 = x - ((x/y) * y) i.e. r4 - r0

    #pop stack
    LDR lr, [sp]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr    

.data

#END modulo



.text
modulus:

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
  
    MUL r0, r0, r1

    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

#END modulus


.text
totient:
    #push stack
    SUB sp, sp, #4
    STR lr, [sp]

    #(p-1)
    SUB r2, r0, #1

    #(q-1)
    SUB r3, r1, #1

    #(p-1)*(q-1)
    MUL r0, r2, r3

    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr

.data

#END totient

.text
cpubexp:
#Purpose: prompts user for e and checks it against set parameters
#Program dictionary:
#r7:	totient phi
#r10:	pubKeyExp

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]

    GetPubKeyExp:
  
        MOV r0, r7
        MOV r1, #10
        BL __aeabi_idiv
        MOV r1, r0

    	LDR r0, =pubKeyExpPrompt
   	//MOV r1, r7
   	BL printf
    
   	LDR r0, =pubKeyExpFormat
   	LDR r1, =pubKeyExp
   	BL scanf

   	LDR r10, =pubKeyExp
   	LDR r10, [r10]			//load r10 with value of pubKeyExp

   	#check that value is between 1 and theta
   	MOV r0, r10			//move exponent value from r10 to r0
   	MOV r1, #1
   	MOV r2, #0
    	CMP r0, r1			//compare exponent to 1
    	ADDGE r2, r2, #1		//if r0 >= 1, r2 = 1

   	MOV r1, r7			//move totient phi from r7 to r1
    	MOV r3, #0
   	CMP r0, r1			//compare exponent to phi
    	ADDLE r3, r3, #1		//if r0 <= totient phi, r3 = 1

    	AND r0, r2, r3		//if r2 = 1 AND r3 = 1, r0 = 1 (number in range) 
    	MOV r1, #1
	CMP r0, r1
    	BNE ExpErrorRange
	    MOV r0, r7			//move totient phi to r0
	    MOV r1, r10			//move exponent to r1
	    BL gcd			//determine if phi and exponent are co-prime
	   				//if they are co-prime, r0 = 0

	MOV r1, #0
	CMP r0, r1

	BNE ExpErrorCoPrime
	    LDR r0, =validExpMsg
	    MOV r1, r10
	    BL printf
	    B EndCPubExp

    ExpErrorRange:
	LDR r0, =expErrorRangeMsg
	BL printf
	B GetPubKeyExp

    ExpErrorCoPrime:
	LDR r0, =expErrorCoPrimeMsg
        MOV r1, r7
	BL printf
	B GetPubKeyExp
   
    EndCPubExp:

    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

    #prompt for public key exponent
    pubKeyExpPrompt:	.asciz	"\nPlease enter a number between 1 and %d: "

    #format for public key exponent
    pubKeyExpFormat:	.asciz	"%d"

    #variable for user input for public key exponent
    pubKeyExp:	.word	0

    #error message if public key exponent value not valid
    expErrorRangeMsg:	.asciz	"\nInvalid input.  Number is not in the specified range.\n"

    #message for valid exponent
    validExpMsg:	.asciz	"\n%d is a valid public key exponent.\n"

    #error message if exponent is not co-prime to phi
    expErrorCoPrimeMsg:	.asciz	"\nInvalid input.  Number is not co-prime to %d.\n"

#END cbpuexp


.text
cprivexp:
# Purpose: compute private key exponent from totient and pubKeyExp
#   This function will return a private key exponent for valid totient and pubKeyExp
#   Return -1, if private key exponent can't be computed
#
# Program dictionary:
# r4:	totient phi(n)
# r5:	pubKeyExp

    # Push to the stack
    SUB sp, sp, #12
    STR lr, [sp]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
  
    # Store input totient in R0 into R4
    MOV r4, r0
    # Store input pubKeyExp in R1 into R5
    MOV r5, r1

    # Initialize R0 with 1 to compute X in solve following equation
    # (1 + x * totient) / e
    LDR r2, =x_loop_counter
    LDR r2, [r2]

    startLoop:

        CMP R2, R4
        BGT x_not_found

        MUL r0, r2, r4      // x * totient
        ADD r0, r0, #1      // 1 + (x * totient)

        MOV r1, r5
        BL modulo

        # If modulo function returns 0, then X is valid
        # else increment X and continue
        CMP r0, #0
        BEQ endLoop

            # Increment X
            LDR r2, =x_loop_counter
            LDR r2, [r2]
            ADD r2, r2, #1
            LDR r3, =x_loop_counter
            STR r2, [r3]
            B startLoop

    endLoop:

    # Compute privateKeyExp using following formula
    # R2 will hold the valid X for computing privateKeyExp
    # (1 + x * totient) / e
    LDR r2, =x_loop_counter
    LDR r2, [r2]
    MUL r0, r2, r4      // x * totient
    ADD r0, r0, #1      // 1 + (x * totient)
    MOV r1, r5          // move pubKeyExp e to r1

    BL __aeabi_idiv
    B done

    x_not_found:
        LDR r0, =xNotFoundMsg
        BL printf

        # return -1 If X can't be computed
        MOV r0, #-1

    done:

    # Pop from stack
    LDR lr, [sp]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr    

.data
    #error message if x value is not found
    xNotFoundMsg:	.asciz	"\nUnable to compute private key exponent.\n"

    x_loop_counter: .word 1

#END cprivexp


.text
encrypt:

    #push stack
    SUB sp, sp, #16
    STR lr, [sp]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    MOV r4, r0          // move clear-text character to R4
    MOV r5, r1          // move pubKeyExp to R5
    MOV r6, r2          // move modulus N to R6
  
    #c = (m^e) % n
    #Calculate m to the power of e
    BL pow

    #Move n from r2 to r1
    MOV r1, r6

    #Calculate Modulo, r0 % r1, result is c
    BL modulo

    #pop stack
    LDR lr, [sp]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr    

.data

#END encrypt


.text
decrypt:

    #push stack
    SUB sp, sp, #16
    STR lr, [sp]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    MOV r4, r0          // move encrypted character to R4
    MOV r5, r1          // move pubKeyExp to R5
    MOV r6, r2          // move modulus N to R6
  
    #m = (c^d) % n
    #Calculate c to the power of d
    BL pow

    #Move n from r2 to r1
    MOV r1, r6

    #Calculate Modulo, r0 % r1, result is m
    BL modulo

    #pop stack
    LDR lr, [sp]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr    

.data

#END decrypt




