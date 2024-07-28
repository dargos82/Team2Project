
.global gcd
.global pow
.global modulo
.global cpubexp
.global cprivexp
.global encrypt
.global decrypt

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




