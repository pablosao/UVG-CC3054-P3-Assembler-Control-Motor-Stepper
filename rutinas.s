

/************************************************************************************/
/*         Autor: Pablo Sao                                                         */
/*         Fecha: 11 de mayo de 2019                                                */
/*   Descripcion: Variables y Rutinas globales para el programa.                    */
/************************************************************************************/




@****    Recibe en R0 los segundos a esperar
.align 2
.global ESPERASEG
ESPERASEG:
	PUSH  {LR}

	BL    sleep		@ Espera tiempo pasado en R0
	NOP

	POP   {PC}

@****    Recibe en R0 los microsegundos a esperar
.align 2
.global ESPERAMICRO
ESPERAMICRO:
	PUSH  {LR}

	BL    usleep 		@ Espera el tiempo pasado en R0
	NOP

	POP   {PC}

.align 2 
.global MUEVEMOTOR
MUEVEMOTOR:
	PUSH  {LR}

	
	@ Cargando dirección en la que se movera el motor
	LDR   R11, =_DIRECCION
	LDR   R11, [R11]

	@ Cargando cantidad de vueltas que realizara el motor
	LDR   R4, =_REPETICIONES
	LDR   R4, [R4]
	ADD   R4, #1

	LDR   R0, =msj
	MOV   R1, R4
	bl    printf

	_repMotor:

		PUSH  {R4}

		@ Cargando cantidad de vueltas que realizara el motor
		LDR   R10, =_VUELTAS
		LDR   R10, [R10]

		_move:
			PUSH  {R11}
			PUSH  {R10}
	
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
			BNE   _move

		MOV   R0, #2
		BL    ESPERASEG

		POP   {R4}
		SUBS  R4, #1
		CMP   R4, #0
		BNE   _repMotor

	POP   {PC}


@****    Ciclo para movimiento a la derecha
MOVE_DERECHA:
	PUSH  {LR}
	
	MOV  R12, #12			@ Repetición para vuelta completa

	movimientoD:
		PUSH {R12}
		
		MOV  R0, #14
		MOV  R1, #0
		BL   SetGpio
		
		MOV  R0, #15
		MOV  R1, #0
		BL   SetGpio
	
		MOV  R0, #20000					@ Se mandan 0.02 segundos 
		BL   ESPERAMICRO				@ Rutina de espera
		
		MOV  R0, #15
		MOV  R1, #1
		BL   SetGpio
		
		MOV   R0, #20000				@ Se mandan 0.02 segundos
		BL   ESPERAMICRO				@ Rutina de espera

		MOV  R0, #14
		MOV  R1, #1
		BL   SetGpio
		
		MOV  R0, #15
		MOV  R1, #0
		BL   SetGpio
		
		MOV   R0, #20000				@ Se mandan 0.02 segundos
		BL   ESPERAMICRO				@ Rutina de espera
		
		
		MOV  R0, #15
		MOV  R1, #1
		BL   SetGpio
		
		MOV   R0, #20000				@ Se mandan 0.02 segundos
		BL   ESPERAMICRO				@ Rutina de espera
		
		
		POP   {R12}
		SUBS  R12, #1
		CMP   R12, #0
		BNE   movimientoD

	POP    {PC}

SHOW_DIRECTION:
	PUSH  {LR}

	MOV  R0, #18						@ Configurando GPIO 18 
	
	@**   Desplegando Dirección actual
	LDR   R2, =_DIRECCION
	LDR   R2, [R2]

	CMP   R2, #1
	MOVEQ R1, #1						@ Mostrando dirección a la derecha en GPIO 18
	MOVNE R1, #0						@ Mostrando dirección a la izquierda en GPIO 18
	BL   SetGpio

	POP   {PC}

@****    Ciclo para movimiento a la izquierda
MOVE_IZQUIERDA:
	PUSH  {LR}
	
	MOV  R12, #12			@ Repetición para vuelta completa

	movimientoI:
		PUSH {R12}
		
		
		MOV  R0, #14
		MOV  R1, #1
		BL   SetGpio
		
		MOV  R0, #15
		MOV  R1, #1
		BL   SetGpio
	
		MOV  R0, #20000					@ Se mandan 0.02 segundos
		BL   ESPERAMICRO				@ Rutina de espera

		
		MOV  R0, #15
		MOV  R1, #0
		BL   SetGpio
		
		MOV   R0, #20000				@ Se mandan 0.02 segundos
		BL   ESPERAMICRO				@ Rutina de espera

		@**  Cable naranja
		MOV  R0, #14
		MOV  R1, #0
		BL   SetGpio
		
		MOV  R0, #15
		MOV  R1, #1
		BL   SetGpio
		
		MOV   R0, #20000				@ Se mandan 0.02 segundos
		BL   ESPERAMICRO				@ Rutina de espera
		
		
		
		MOV  R0, #15
		MOV  R1, #0
		BL   SetGpio
		
		MOV   R0, #20000				@ Se mandan 0.02 segundos
		BL   ESPERAMICRO				@ Rutina de espera
		
		
		POP   {R12}
		SUBS  R12, #1
		CMP   R12, #0
		BNE   movimientoI

	POP    {PC}




@****    Suma de numero de vueltas
@****    : R0 Se manda con valor 0 si se quiere sumar desde boton
@****         De lo contrario se manda con el valor a almacenar
.align 2
.global SUM_VUELTAS
SUM_VUELTAS:
	PUSH  {LR}
	
	LDR   R1, =_VUELTAS
	LDR   R2, [R1]
	
	CMP   R0, #0
	BNE   storeDataVueltas

	ADD   R2, #1
	CMP   R2, #9
	MOVGT R2, #1	
	MOV   R0, R2
		
	storeDataVueltas:
		STR   R0, [R1]
		
	
	POP   {PC}


@****    Suma de numero de repeticiones de
@****    : R0 Se manda con valor 0 si se quiere sumar desde boton
@****         De lo contrario se manda con el valor a almacenar
.align 2
.global SUM_REPETICION
SUM_REPETICION:
	PUSH  {LR}
	
	LDR   R1, =_REPETICIONES
	LDR   R2, [R1]
	
	CMP   R0, #0
	BNE   storeDataRepeticiones

	ADD   R2, #1
	CMP   R2, #9
	MOVGT R2, #1	
	MOV   R0, R2
		
	storeDataRepeticiones:
		STR   R0, [R1]
		
	
	POP   {PC}


.data
.align 2
.global _VUELTAS
_VUELTAS:
	.word 3

.align 2
.global _DIRECCION
_DIRECCION:
	.word 1

.align 2
.global _REPETICIONES
_REPETICIONES:
	.word 0

.align 2
msj:
	.asciz "Repeticion: %d\n"

