		.begin

		.org 2048
		call obtener_datos
		halt


		.org 3000

mem_datos1	.equ	B032C008h	!4 bits mas significativos mapea a los botones
mem_datos2	.equ	B032C00Ch	!el bit mas sginificativo mapea al sensor de disco, los tres menos sign. mapean, bandeja, motor y pausa.
ptr1:		mem_datos1
prt2:		mem_datos2

obtener_datos:	ld [ptr1], %r1	!r1 almacena direccion de memoria de datos 1
			ld %r1, %r2		!se carga los bits del primer conjunto de datos en r2
			ld [ptr2], %r1	!r1 almacena direccion de memoria de datos 1
			ld %r1, %r3		!se carga los bits del segundo conjunto de datos en r3
			jmpl %r15+4, %r0
			.end
