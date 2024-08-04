
.global checkRange
.global isPrime
.global gcd
.global pow
.global modulo
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

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
  


    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

#END gcd


.text
pow:

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
  


    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

#END pow


.text
modulo:

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
  


    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

#END modulo


.text
cpubexp:

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
  


    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

#END cbpuexp


.text
cprivexp:

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
  


    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

#END cprivexp


.text
encrypt:

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
  


    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

#END encrypt


.text
decrypt:

    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
  


    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr    

.data

#END decrypt




