
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
	MOV  R0, R1				@ Movemos valor a r0
	BL   ESPERAMICRO		@ Rutina de espera

	BL   _DISHARDWARE

	@ Comprobamos si se selecciona opción para salir de conf por hardware
	MOV   R1, #2
	BL    GetGpio

	TEQ   R5, #0
	BLNE  main

	LDR  R1, =drFracSeg		@ Cargamos dirección de valor en usegundos
	LDR  R1, [R1]			 
	MOV  R0, R1				@ Movemos valor a r0
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



	@ inicia rutina DE MOTOR
	MOV   R1, #3
	BL    GetGpio

	TEQ   R5, #0
	BLNE  MUEVESTEPPER
	BLNE  HARDWARE_CONTROLER	
	

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
	

.align 2
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



.align 2 
MUEVESTEPPER:
	PUSH  {LR}

	
	@ Cargando dirección en la que se movera el motor
	LDR   R11, =_DIRECCION
	LDR   R11, [R11]

	@ Cargando cantidad de vueltas que realizara el motor
	LDR   R4, =_REPETICIONES
	LDR   R4, [R4]
	@ADD   R4, #1

	_repMotorH:

		PUSH  {R4}

		MOV   R2, R4

		@**  Desplegando repeticiones en display
		BL   SHOW_DISPLAY2

		@ Cargando cantidad de vueltas que realizara el motor
		LDR   R10, =_VUELTAS
		LDR   R10, [R10]

		POP   {R4}		@ Restaurando R4
		PUSH  {R4}		@ Guaredando R4 en stack
		_moveH:
			PUSH  {R11}
			PUSH  {R10}

			
			@Envio de parametros para actualizar en pantalla para numero de vueltas
			BL    displayConteo
			
			MOV   R2, R10

			@**   Desplegando vueltas en display
			BL    SHOW_DISPLAY1

			@ Muestra display
	
			CMP   R11, #1
			BLEQ  MOVE_IZQUIERDA
			BLNE  MOVE_DERECHA
	
			MOV   R0, #1
			BL    ESPERASEG
	
			POP   {R10}
			POP   {R11}
	
			SUBS  R10, #1
			CMP   R10, #0
			BNE   _moveH

		MOV   R0, #2
		BL    ESPERASEG

		POP   {R4}
		SUBS  R4, #1
		CMP   R4, #0
		BNE   _repMotorH

	/***********************************************************
	 * Desplegando valores iniciales de Vueltas y Repeticiones *
	 ***********************************************************/
	LDR   R2, =_VUELTAS
	LDR   R2, [R2]

	@**  Desplegando vueltas en display
	BL   SHOW_DISPLAY1


	LDR   R2, =_REPETICIONES
	LDR   R2, [R2]

	@**  Desplegando repeticiones en display
	BL   SHOW_DISPLAY2

	POP   {PC}
	
@****    Muestra conteo regresivo de datos
@****    R4, Repeticiones
@****    R10, Vueltas
.align 2
.global displayConteo
displayConteo:
	PUSH  {LR}

	@** Limpiando terminal
	LDR   R0, =CLEAR
	BL    puts

	@** Mostrando banner de ejecución
	BL   DISPLAY_BANNER_REP

	@**   Desplegando Dirección actual
	LDR   R0, =_DIRECCION
	LDR   R0, [R0]

	CMP   R0, #1
	LDREQ R0, =showDirDerecha				@ Si el movimiento es a la derecha (1), cargamos mensaje derecha
	LDRNE R0, =showDirIzquierda				@ Si el movimiento es a la derecha (1), cargamos mensaje izquierda
	BL    puts
	
	
	@**   Desplegando número de rotaciones
	LDR   R0, =displayVueltas
	MOV   R1, R10
	BL    printf

	@**   Desplegando número de repeticiones
	LDR   R0, =displayRepeticiones
	MOV   R1, R4
	BL    printf
	
	LDR   R0, =msjHardConteo
	BL    puts

	POP  {PC}
