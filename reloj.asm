.begin

.org 2048
	call retraso
	halt


.org 3000

ciclos:	115384616
	
retraso:ld [ciclos], %r13	!Inicializa el contador.
	add %r13,-1,%r13
	andcc %r13,%r13,%r0	!Pone el flag z en 1 cuando r13 == 0.
	be finRet 		!Revisa el flag z para terminar.
	ba retraso+4		!Itera, ignorando la inicializacon.
finRet:	jmpl %r15+4, %r0

.end
