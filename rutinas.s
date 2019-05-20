
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
	@ADD   R4, #1

	_repMotor:

		PUSH  {R4}

		MOV   R2, R4

		@**  Desplegando repeticiones en display
		BL   SHOW_DISPLAY2

		@ Cargando cantidad de vueltas que realizara el motor
		LDR   R10, =_VUELTAS
		LDR   R10, [R10]

		POP   {R4}		@ Restaurando R4
		PUSH  {R4}		@ Guaredando R4 en stack
		_move:
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
			BNE   _move

		MOV   R0, #2
		BL    ESPERASEG

		POP   {R4}
		SUBS  R4, #1
		CMP   R4, #0
		BNE   _repMotor

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

	BL   getchar
	POP   {PC}


@****    Ciclo para movimiento a la derecha
.align 2
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

	POP   {PC}

@****    Despliegue de display de vueltas
@****    R2 -> Se manda el número (1 a 9) a mostrar en display
.align 2
.global SHOW_DISPLAY1
SHOW_DISPLAY1:
	PUSH  {LR}

	PUSH  {R2}
	BL   _apagadoVueltas
	
	POP   {R2}

	CMP   R2, #1
	BLEQ  _unov

	CMP   R2, #2
	BLEQ  _dosv

	CMP   R2, #3
	BLEQ  _tresv

	CMP   R2, #4
	BLEQ  _cuatrov

	CMP   R2, #5
	BLEQ  _cincov

	CMP   R2, #6
	BLEQ  _seisv

	CMP   R2, #7
	BLEQ  _sietev

	CMP   R2, #8
	BLEQ  _ochov

	CMP   R2, #9
	BLEQ  _nuevev

	POP   {PC}

_unov:
	PUSH  {LR}

	MOV  R0, #21
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_dosv:
	PUSH  {LR}

	MOV  R0, #20
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_tresv:
	PUSH  {LR}

	MOV  R0, #21
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #20
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_cuatrov:
	PUSH  {LR}

	MOV  R0, #16
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_cincov:
	PUSH  {LR}

	MOV  R0, #16
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #21
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_seisv:
	PUSH  {LR}

	MOV  R0, #16
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #20
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_sietev:
	PUSH  {LR}

	MOV  R0, #16
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #20
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #21
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_ochov:
	PUSH  {LR}

	MOV  R0, #12
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_nuevev:
	PUSH  {LR}

	MOV  R0, #12
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #21
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

@****    Apagado de puertos de pines que controlan el display
_apagadoVueltas:
	PUSH  {LR}

	MOV  R0, #21
	MOV  R1, #0
	BL   SetGpio

	MOV  R0, #20
	MOV  R1, #0
	BL   SetGpio

	MOV  R0, #16
	MOV  R1, #0
	BL   SetGpio

	MOV  R0, #12
	MOV  R1, #0
	BL   SetGpio

	POP   {PC}



@****    Despliegue de display de vueltas
@****    R2 -> Se manda el número (1 a 9) a mostrar en display
.align 2
.global SHOW_DISPLAY2
SHOW_DISPLAY2:
	PUSH  {LR}

	PUSH  {R2}
	BL   _apagadoRepeticion
	
	POP   {R2}

	CMP   R2, #1
	BLEQ  _unor

	CMP   R2, #2
	BLEQ  _dosr

	CMP   R2, #3
	BLEQ  _tresr

	CMP   R2, #4
	BLEQ  _cuatror

	CMP   R2, #5
	BLEQ  _cincor

	CMP   R2, #6
	BLEQ  _seisr

	CMP   R2, #7
	BLEQ  _sieter

	CMP   R2, #8
	BLEQ  _ochor

	CMP   R2, #9
	BLEQ  _nuever

	POP   {PC}

_unor:
	PUSH  {LR}

	MOV  R0, #26
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_dosr:
	PUSH  {LR}

	MOV  R0, #19
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_tresr:
	PUSH  {LR}

	MOV  R0, #26
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #19
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_cuatror:
	PUSH  {LR}

	MOV  R0, #13
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_cincor:
	PUSH  {LR}

	MOV  R0, #13
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #26
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_seisr:
	PUSH  {LR}

	MOV  R0, #13
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #19
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_sieter:
	PUSH  {LR}

	MOV  R0, #13
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #19
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #26
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_ochor:
	PUSH  {LR}

	MOV  R0, #6
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

_nuever:
	PUSH  {LR}

	MOV  R0, #6
	MOV  R1, #1
	BL   SetGpio

	MOV  R0, #26
	MOV  R1, #1
	BL   SetGpio

	POP   {PC}

@****    Apagado de puertos de pines que controlan el display
_apagadoRepeticion:
	PUSH  {LR}

	MOV  R0, #26
	MOV  R1, #0
	BL   SetGpio

	MOV  R0, #19
	MOV  R1, #0
	BL   SetGpio

	MOV  R0, #13
	MOV  R1, #0
	BL   SetGpio

	MOV  R0, #6
	MOV  R1, #0
	BL   SetGpio

	POP   {PC}



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

	/******************************************************
	 *    Actualizando valores de Displays                *
	 ******************************************************/

	LDR   R2, =_VUELTAS
	LDR   R2, [R2]

	@**   actualizando display
	BL    SHOW_DISPLAY1

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
		

	/******************************************************
	 *    Actualizando valores de Displays                *
	 ******************************************************/

	LDR   R2, =_VUELTAS
	LDR   R2, [R2]

	@**   actualizando display
	BL    SHOW_DISPLAY1

	LDR   R2, =_REPETICIONES
	LDR   R2, [R2]

	@**   actualizando display
	BL    SHOW_DISPLAY2
	
	POP   {PC}

.align 2
.global DISPLAY_BANNER
DISPLAY_BANNER:
	PUSH  {LR}

	@** Limpiando terminal
	LDR   R0, =CLEAR
	BL    puts

	@** Mostrando banner
	LDR   R0, =disBanner1
	BL    puts

	LDR   R0, =disBanner2
	BL    puts

	LDR   R0, =disBanner3
	BL    puts

	LDR   R0, =disBanner4
	BL    puts

	LDR   R0, =disBanner5
	BL    puts

	LDR   R0, =disBanner6
	BL    puts

	LDR   R0, =disBanner7
	BL    puts

	LDR   R0, =disBanner8
	BL    puts

	LDR   R0, =disBanner9
	BL    puts

	LDR   R0, =disBanner10
	BL    puts

	POP   {PC}

.align 2
.global DISPLAY_BANNER_REP
DISPLAY_BANNER_REP:
	PUSH  {LR}

	@** Limpiando terminal
	LDR   R0, =CLEAR
	BL    puts

	@** Mostrando banner
	LDR   R0, =disRep1
	BL    puts

	LDR   R0, =disRep2
	BL    puts

	LDR   R0, =disRep3
	BL    puts

	LDR   R0, =disRep4
	BL    puts

	LDR   R0, =disRep5
	BL    puts

	LDR   R0, =disRep6
	BL    puts

	LDR   R0, =disRep7
	BL    puts

	LDR   R0, =disRep8
	BL    puts

	LDR   R0, =disRep9
	BL    puts

	LDR   R0, =disRep10
	BL    puts

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
	.word 1


.align 2
disBanner1:
	.asciz "\033[32m   _____  __"                                 

.align 2
disBanner2:
	.asciz "  / ___/ / /_ ___   ____   ____   ___   _____"

.align 2
disBanner3:
	.asciz "  \\__ \\ / __// _ \\ / __ \\ / __ \\ / _ \\ / ___/"

.align 2
disBanner4:
	.asciz " ___/ // /_ /  __// /_/ // /_/ //  __// /"    

.align 2
disBanner5:
	.asciz "/____/ \\__/ \\___// .___// .___/ \\___//_/"     

.align 2
disBanner6:
	.asciz "                /_/    /_/\033[0m"                   

.align 2
disBanner7:
	.asciz "\033[36m----------------------------------------------\033[0m"

.align 2
disBanner8:
	.asciz "\033[33m               By Pablo Sao\033[0m"

.align 2
disBanner9:
	.asciz "\033[33m	           2019\033[0m"

.align 2
disBanner10:
	.asciz "\033[36m----------------------------------------------\033[0m"

.align 2
disRep1:
	.asciz "\033[36m███████╗     ██╗███████╗ ██████╗██╗   ██╗████████╗ █████╗ ███╗   ██╗██████╗  ██████╗\033[0m" 

.align 2
disRep2:
	.asciz "\033[36m██╔════╝     ██║██╔════╝██╔════╝██║   ██║╚══██╔══╝██╔══██╗████╗  ██║██╔══██╗██╔═══██╗\033[0m"

.align 2
disRep3:
	.asciz "\033[36m█████╗       ██║█████╗  ██║     ██║   ██║   ██║   ███████║██╔██╗ ██║██║  ██║██║   ██║\033[0m"

.align 2
disRep4:
	.asciz "\033[36m██╔══╝  ██   ██║██╔══╝  ██║     ██║   ██║   ██║   ██╔══██║██║╚██╗██║██║  ██║██║   ██║\033[0m"

.align 2
disRep5:
	.asciz "\033[36m███████╗╚█████╔╝███████╗╚██████╗╚██████╔╝   ██║   ██║  ██║██║ ╚████║██████╔╝╚██████╔╝\033[0m"

.align 2
disRep6:
	.asciz "\033[36m╚══════╝ ╚════╝ ╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝\033[0m"

.align 2
disRep7:
	.asciz "\033[35m---------------------------------------------------------------------------------------\033[0m"

.align 2
disRep8:
	.asciz "\033[32m                                     By Pablo Sao\033[0m"

.align 2
disRep9:
	.asciz "\033[32m                                        2019\033[0m"

.align 2
disRep10:
	.asciz "\033[35m---------------------------------------------------------------------------------------\033[0m"	
