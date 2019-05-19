
/************************************************************************************/
/*         Autor: Pablo Sao                                                         */
/*         Fecha: 19 de mayo de 2019                                                */
/*   Descripcion: Control de dirección y vueltas de un motor steeper, por medio     */
/*				  de hardware (Circuito electronico).                               */
/************************************************************************************/

.align 2
.global HARDWARE_CONTROLER
HARDWARE_CONTROLER:
	
	LDR  R1, =drFracSeg		@ Cargamos dirección de valor en usegundos
	LDR  R1, [R1]			 
	MOV  R0, R1			@ Movemos valor a r0
	BL   ESPERAMICRO		@ Rutina de espera

	BL   _DISHARDWARE

	@ Comprobamos si se selecciona opción para salir de conf por hardware
	MOV   R1, #2
	BL    GetGpio

	TEQ   R5, #0
	BLNE  main

	LDR  R1, =drFracSeg		@ Cargamos dirección de valor en usegundos
	LDR  R1, [R1]			 
	MOV  R0, R1			@ Movemos valor a r0
	BL   ESPERAMICRO		@ Rutina de espera


	@ Cambio de repeticiones
	MOV   R1, #17
	BL    GetGpio

	TEQ   R5, #0
	MOVNE R0, #0
	BLNE  SUM_REPETICION
	BLNE  HARDWARE_CONTROLER

	LDR  R1, =drFracSeg		@ Cargamos dirección de valor en usegundos
	LDR  R1, [R1]			 
	MOV  R0, R1			@ Movemos valor a r0
	BL   ESPERAMICRO		@ Rutina de espera


	@ Cambio de vueltas
	MOV   R1, #27
	BL    GetGpio

	TEQ   R5, #0
	MOVNE R0, #0
	BLNE  SUM_VUELTAS
	BLNE  HARDWARE_CONTROLER

	LDR  R1, =drFracSeg		@ Cargamos dirección de valor en usegundos
	LDR  R1, [R1]			 
	MOV  R0, R1			@ Movemos valor a r0
	BL   ESPERAMICRO		@ Rutina de espera



	@ inicia rutina
	MOV   R1, #3
	BL    GetGpio

	TEQ   R5, #0
	BNE   _movimiento	

	LDR  R1, =drFracSeg		@ Cargamos dirección de valor en usegundos
	LDR  R1, [R1]			 
	MOV  R0, R1			@ Movemos valor a r0
	BL   ESPERAMICRO		@ Rutina de espera



	@ Cambio de dirección del motor
	MOV   R1, #4
	BL    GetGpio

	TEQ   R5, #0
	BLNE  _changeDirection
	BLNE  HARDWARE_CONTROLER

	LDR  R1, =drFracSeg		@ Cargamos dirección de valor en usegundos
	LDR  R1, [R1]			 
	MOV  R0, R1			@ Movemos valor a r0
	BL   ESPERAMICRO		@ Rutina de espera

	
	BL  HARDWARE_CONTROLER
	


_changeDirection:
	PUSH  {LR}

	LDR   R1, =_DIRECCION				@ Cargamos de dirección donde esta el valor de "Direccion"
	LDR   R0, [R1]						@ Almacenamos valor de dirección en R0

	ADDS  R0, #1						@ Sumamos 1 al registro cargado

	CMP   R0, #2						@ Si R0 > 2
	MOVGT R0, #1							@ Colocamos 1 en dirección. R0 -> 1

	STR   R0, [R1]						@ Almacenamos dirección en variable

	BL   SHOW_DIRECTION					@ Mostramos el cambio de la dirección en circuito

	POP   {PC}

_movimiento:

	BL    MUEVEMOTOR
	BL    HARDWARE_CONTROLER
	MOV   R5, #0

