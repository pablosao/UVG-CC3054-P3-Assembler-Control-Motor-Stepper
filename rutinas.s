

/************************************************************************************/
/*         Autor: Pablo Sao                                                         */
/*         Fecha: 11 de mayo de 2019                                                */
/*   Descripcion: Variables y Rutinas globales para el programa.                    */
/************************************************************************************/




@****    Rutina para esperar el tiempo enviado en R0
.align 2
.global ESPERA
ESPERA:
	PUSH  {LR}

	bl    sleep		@ Espera tiempo pasado en R0
	NOP

	POP   {PC}

@****    Suma de numero de vueltas
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


.align 2
.global _VUELTAS
_VUELTAS:
	.word 0

.align 2
.global _DIRECCION
_DIRECCION:
	.word 0

.align 2
.global _REPETICIONES
_REPETICIONES:
	.word 0


