All: RSA
LIB=RSALib.o
CC=gcc

RSA: RSA.o
	$(CC) $@.o -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
