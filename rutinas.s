

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


.align 2 
.global MUEVEMOTOR
MUEVEMOTOR:
	PUSH  {LR}

	@ Cargando cantidad de vueltas que realizara el motor
	LDR   R10, =_VUELTAS
	LDR   R10, [R10]
	
	@ Cargando dirección en la que se movera el motor
	LDR   R11, =_DIRECCION
	LDR   R11, [R11]

	_move:
		PUSH  {R11}
		PUSH  {R10}

		@ Muestra display

		CMP   R11, #1
		BLEQ  MOVE_DERECHA
		BLNE  MOVE_IZQUIERDA

		POP   {R10}
		POP   {R11}

		SUBS  R10, #1
		CMP   R10, #0
		BNE   _move

	POP   {PC}

@****    Recibe en R0 los microsegundos a esperar
.align 2
.global ESPERAMICRO
ESPERAMICRO:
	PUSH  {LR}

	BL    usleep 		@ Espera el tiempo pasado en R0
	NOP

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
	BNE   storeData

	ADD   R2, #1
	CMP   R2, #99
	MOVGT R2, #1	
	MOV   R0, R2
		
	storeData:
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



