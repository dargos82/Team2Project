
.global checkRange
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




