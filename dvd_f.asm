
			.begin

			.org 2048
mem_datos1		.equ	B032C008h	!Los 4 LSB mapean los botones EJ,PL,PA,ST
mem_datos2		.equ	B032C00Ch	!el bit mas sginificativo mapea al sensor de disco, los tres menos sign. mapean, bandeja, motor y pausa.
mask1			.equ	80000000h	!mascara para bit de sensor presencia
mask2			.equ	00000007h

e_000			.equ 00000b	!e_XXX: S,T,B,M,R
e_001			.equ 10000b
e_010			.equ 10011b
e_011			.equ 10010b
e_100			.equ 11000b
e_101			.equ 11000b
e_110			.equ 0100b	!el bit de S en este estado no importa

b_ej 			.equ 1000b
b_pl 			.equ 0100b
b_pa 			.equ 0010b
b_st 			.equ 0001b
sen_pre		.equ 10000b	
temp			.equ 01000b

puntero1:		mem_datos1
puntero2:		mem_datos2
mask1_p:		mask1
mask2_p:		mask2
	

inicializacion:	ld [puntero1], %r1	!r1 almacena direccion de memoria de datos 1
			ld [puntero2], %r2  !r1 almacena direccion de memoria de datos 2
			xor %r0,e_000,%r5			!seteo de salidas en estado inicial
			

inicio:		call actualizar_salida		!almacena en memoria las salidas
			ld %r1, %r3		!En r3 estan los botones EJ,PL,PA,ST
			ld %r2, %r4		!En r4 esta el estado S...B,M,R
			ld [mask1_p],%r30
			and %r4,%r30,%r30	!Ahora el primer MSB de r5 es S
			srl %r30,27,%r30	!S esta en 5to LSB de r30
			ld [mask2_p],%r31
			and %r4,%r31,%r31
			add %r30,%r31,%r30	!Los 5 LSB de r30 tienen el estado S,T,B,M,R = X,0,X,X,X
			and %r5,temp,%r5	!conservo el estado de T, r5 = S,T,B,M,R = 0,X,0,0,0
			add %r5,%r30,%r5	!r5 tiene el estado actual S,T,B,M,R = X,X,X,X,X
			

			!Veo cual es el estado actual
			subcc %r5,e_000,%r0
			be estado_0
			subcc %r5,e_001,%r0
			be estado_1
			subcc %r5,e_010,%r0
			be estado_2
			subcc %r5,e_011,%r0
			be estado_3
			subcc %r5,e_100,%r0
			be estado_4
			subcc %r5,e_101,%r0
			be estado_5
			subcc %r5,e_110,%r0
			be estado_6	


estado_0: 		andcc %r3,b_ej,%r0	!EJ
			bne trans_a_6
			ba  inicio	

estado_1:		andcc %r3,b_ej,%r0	!EJ
			bne trans_a_6
			andcc %r3,b_pl,%r0	!PL
			bne trans_a_2
			ba  inicio

estado_2:		andcc %r3,b_ej,%r0	!EJ
			bne trans_a_4
			andcc %r3,b_pa,%r0	!PA
			bne trans_a_3
			andcc %r3,b_st,%r0	!ST
			bne trans_a_5
			ba  inicio

estado_3:		andcc %r3,b_ej,%r0	!EJ
			bne trans_a_4
			andcc %r3,b_pl,%r0	!PL
			bne trans_a_2
			andcc %r3,b_st,%r0	!ST
			bne trans_a_5
			ba  inicio

estado_4:		call retraso
			ba  trans_a_6

estado_5:		call	retraso
			ba  trans_a_1

estado_6:		andcc %r2,b_ej,%r0	!EJ
			bne trans_a_0
			ba  inicio		


trans_a_0:	xor %r0,e_000,%r5 
		ba inicio

trans_a_1:	xor %r0,e_001,%r5 
		ba inicio

trans_a_2:	xor %r0,e_010,%r5 
		ba inicio

trans_a_3:	xor %r0,e_011,%r5 
		ba inicio

trans_a_4:	xor %r0,e_100,%r5 
		ba inicio

trans_a_5:	xor %r0,e_101,%r5 
		ba inicio

trans_a_6:	xor %r0,e_110,%r5 
		ba inicio

!----------Rutina de actualizacion--------------------------
actualizar_salida:	
			ld %r2, %r4		!En r4 esta el estado S...B,M,R
			ld [mask1_p],%r30
			and %r4,%r30,%r30	
			ld [mask2_p],%r31
			and %r5,%r31,%r31
			add %r30,%r31,%r30	
			st  %r30,%r2	
			jmpl %r15+4, %r0

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


