		.begin

		.org 2048
mem_datos1	.equ	B032C008h	!4 bits menos significativos mapea a los botones
mem_datos2	.equ	B032C00Ch	!el bit mas sginificativo mapea al sensor de disco, los tres menos sign. mapean, bandeja, motor y pausa.
puntero1:		mem_datos1
puntero2:		mem_datos2
			ld [puntero1], %r1	!r1 almacena direccion de memoria de datos 1
			ld [puntero2], %r2  !r1 almacena direccion de memoria de datos 2
inicio:		ld %r1, %r3		!se carga los bits del primer conjunto de datos en r3
			ld %r2, %r4		!se carga los bits del segundo conjunto de datos en r4
			ba	inicio

!-------Rutina de delay-------------------------------------------
cant_ciclos	.equ	115384616		!se define la cantidad de ciclos
punt_ciclos:	cant_ciclos			!se establece un puntero para direccionar un valor mayor a 13bits
retraso:		ld [punt_ciclos], %r13 !inicializa el contador
			add %r13,-1,%r13	   !decrementa el contador
			andcc %r13,%r13,%r0	!Pone el flag z en 1 cuando r13 == 0.
			be finRet 		!Revisa el flag z para terminar.
			ba retraso+4		!Itera, ignorando la inicializacon.
finRet:		jmpl %r15+4, %r0



			.end


