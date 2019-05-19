
/************************************************************************************/
/*         Autor: Pablo Sao                                                         */
/*         Fecha: 09 de mayo de 2019                                                */
/*   Descripcion: Control de dirección y vueltas de un motor steeper, por medio     */
/*				  de software (terminal) y hardware (Circuito electronico).         */
/************************************************************************************/

.text
.align 2
.global main
.type main, %function

main:
	STMFD SP!, {LR}

	@**   Configurando pines de salida
	BL   GetGpioAddress			@ Llamamos dirección

	/**************************
	 *  Configurando Stepper  *
	 **************************/
	MOV  R0, #14				@ Seteamos pin 14
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction		@ Configuramos puerto

	MOV  R0, #15				@ Seteamos pin 15
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction

	/****************************
	 *  Configurando dirección  *
	 ****************************/
	MOV  R0, #18				@ Seteamos pin 18
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction

	/************************************
	 *  Configurando display de Vueltas *
	 ************************************/
	MOV  R0, #21				@ Seteamos pin 21
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction

	MOV  R0, #20				@ Seteamos pin 20
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction
	
	MOV  R0, #16				@ Seteamos pin 16
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction

	MOV  R0, #12				@ Seteamos pin 12
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction


	/*****************************************
	 *  Configurando display de Repeticiones *
	 *****************************************/
	MOV  R0, #26				@ Seteamos pin 26
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction

	MOV  R0, #19				@ Seteamos pin 19
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction
	
	MOV  R0, #13				@ Seteamos pin 13
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction

	MOV  R0, #6					@ Seteamos pin 6
	MOV  R1, #1					@ Configuramos salida

	BL   SetGpioFunction

	/**************************************
	 *  Configurando entrada de botones   *
	 **************************************/
	MOV  R0, #2					@ Seteamos pin 26
	MOV  R1, #0					@ Configuramos salida

	BL   SetGpioFunction

	MOV  R0, #3					@ Seteamos pin 19
	MOV  R1, #0					@ Configuramos salida

	BL   SetGpioFunction
	
	MOV  R0, #4					@ Seteamos pin 13
	MOV  R1, #0					@ Configuramos salida

	BL   SetGpioFunction

	MOV  R0, #17					@ Seteamos pin 6
	MOV  R1, #0					@ Configuramos salida

	BL   SetGpioFunction

	MOV  R0, #27					@ Seteamos pin 6
	MOV  R1, #0					@ Configuramos salida

	BL   SetGpioFunction

	@ Mostrando parametros iniciales en circuito
	BL   SHOW_DIRECTION

	@ Cargando configuración de vueltas en display
	LDR   R2, =_VUELTAS
	LDR   R2, [R2]

	@**  Desplegando vueltas en display
	BL   SHOW_DISPLAY1

	@ Cargando configuración de repeticiones en display
	LDR   R2, =_REPETICIONES
	LDR   R2, [R2]

	@**  Desplegando repeticiones en display
	BL   SHOW_DISPLAY2

	B     _running


@****    Rutina para inicio de la seleccion de configuración
.align 2
.global _running
_running:

	BL   DISPLAY_BANNER						@ Mostrando banner

	@**   Despliegue de menú
	LDR   R0, =menu
	BL puts

	@**   Mensaje de ingreso de opción:
	LDR   R0, =msjOpcion
	BL puts

	@**   Comando para Ingreso de teclado
	LDR   R0, =fIngreso
	LDR   R1, =opcionIn
	BL    scanf

	@**   verificamos que se haya ingresado un número
	CMP   R0, #0
	BEQ _error

	@**   Identificación de operaciones
	LDR   R0, =opcionIn
	LDR   R0, [R0]

	@**   Configuración por software
	CMP   R0, #1
	BLEQ  _confSys

	@**   Configuración por hardware
	CMP   R0, #2
	BLEQ  HARDWARE_CONTROLER 

/*	@**   Impresión de configuración
	CMP   R0, #3
	BLEQ  _printInstrucciones
*/
	CMP   R0, #4
	BLEQ   _exit
	BLGT _error


@****    Configuración por medio del sistema
_confSys:

	BL   DISPLAY_BANNER						@ Mostrando banner

	@**   Despliegue de menu para configurar por softwrare
	LDR   R0, =menuSys
	BL    puts

	@**  Despliegue de Parametros
	BL   _displayParametros

	@**   Mensaje de ingreso de opción:
	LDR   R0, =msjOpcion
	BL    puts

	@**   Comando para Ingreso de teclado
	LDR   R0, =fIngreso
	LDR   R1, =opcionIn
	BL    scanf

	@**   verificamos que se haya ingresado un número
	CMP   R0, #0
	BEQ   _errorSys

	@**   Identificación de operaciones
	LDR   R0, =opcionIn
	LDR   R0, [R0]

	@**   Inicia rutina de movimiento
	CMP   R0, #1
	BLEQ  MUEVEMOTOR
	BLEQ  _confSys
	
	@**   Configura dirección
	CMP   R0, #2
	BLEQ  _confDireccion

	@**   Configura vueltas
	CMP   R0, #3
	MOVEQ R12, #1
	BLEQ  _inDatos

	@**   Configura repeticiones
	CMP   R0, #4
	MOVEQ R12, #2
	BLEQ  _inDatos

	CMP   R0, #5
	BLEQ  _running
	BLGT  _errorSys


@****    Ingreso de numero de vueltas y Repeticiones
@****    R12 -> 1 si configura vueltas, 2 si configura repeticiones 
_inDatos:
	PUSH  {R12}


	BL   DISPLAY_BANNER						@ Mostrando banner


	POP   {R12}
	PUSH  {R12}
	
	@**   Despliegue de menu para configurar por softwrare
	CMP   R12, #1
	LDREQ R0, =msjIngresoVueltas
	LDRNE R0, =msjIngresoRepeticion
	BL    puts

	@**  Despliegue de Parámetros actuales
	BL   _displayParametros

	@**   Mensaje de ingreso de opción:
	LDR   R0, =msjOpcionVal
	BL    puts

	@**   Comando para Ingreso de teclado
	LDR   R0, =fIngreso
	LDR   R1, =opcionIn
	BL    scanf

	@**   verificamos que se haya ingresado un número
	CMP   R0, #0
	BEQ   _errorSys

	@**   Identificación de operaciones
	LDR   R0, =opcionIn
	LDR   R0, [R0]

	CMP  R0, #0
	BLLT _errorDatos

	CMP  R0, #9
	BLGT _errorDatos

	POP   {R12}
	CMP   R12, #1
	BLEQ  SUM_VUELTAS

	CMP   R12, #2
	BLEQ  SUM_REPETICION

	
	
	B     _confSys

@****    Configura dirección en la que se movera el motor
_confDireccion:

	BL   DISPLAY_BANNER						@ Mostrando banner

	@**   Despliegue de menu para configurar por softwrare
	LDR   R0, =msjInDireccion
	BL    puts

	@**  Despliegue de Parámetros actuales
	BL   _displayParametros
	
	@**   Mensaje de ingreso de opción:
	LDR   R0, =msjOpcion
	BL    puts
	

	@**   Comando para Ingreso de teclado
	LDR   R0, =fIngreso
	LDR   R1, =opcionIn
	BL    scanf

	@**   verificamos que se haya ingresado un número
	CMP   R0, #0
	BEQ   _errorDireccion

	@**   Identificación de operaciones
	LDR   R0, =opcionIn
	LDR   R0, [R0]

	CMP   R0, #1						@ Si R0 < 1
	BLT   _errorDireccion					@ Se muestra error, no se aceptan engativos

	CMP   R0, #3						@ Si R0 > 2
	BGT   _errorDireccion					@ Se muestra error, no puede ser más de 2

	CMP   R0, #3
	BEQ   _confSys

	LDR   R1, =_DIRECCION
	STR   R0, [R1]

	@ Mostrando parametros iniciales en circuito
	BL   SHOW_DIRECTION

	B     _confSys

@****    Error de ingreso de primer ciclo
_error:
	LDR   R0, =opcionIn				@ Cargamos dirección de opción
	MOV   R1, #0
	STR   R1,[R0]					@ Restauramos valor inicial en 0
	BL    getchar

	LDR   R0, =msjError				@ Mostramos mensaje de error a usuario
	BL    puts

	@ Esperamos 3 segundos para mostrar mensaje de error.
	MOV   R0, #3
	BL    ESPERASEG

	B     _running					@ Regresamos a rutina de ejecución

@****    Error de ingreso de segundo ciclo
_errorSys:
	LDR   R0, =opcionIn				@ Cargamos dirección de opción
	MOV   R1, #0
	STR   R1,[R0]					@ Restauramos valor inicial en 0
	BL    getchar

	LDR   R0, =msjError				@ Mostramos mensaje de error a usuario
	BL    puts

	@ Esperamos 3 segundos para mostrar mensaje de error.
	MOV   R0, #3
	BL    ESPERASEG

	B     _confSys

@****    Error de ingreso de segundo ciclo
_errorDireccion:
	LDR   R0, =opcionIn				@ Cargamos dirección de opción
	MOV   R1, #0
	STR   R1,[R0]					@ Restauramos valor inicial en 0
	BL    getchar

	LDR   R0, =msjError				@ Mostramos mensaje de error a usuario
	BL    puts

	@ Esperamos 3 segundos para mostrar mensaje de error.
	MOV   R0, #3
	BL    ESPERASEG

	B     _confDireccion

@****    Error de ingreso de segundo ciclo
_errorDatos:
	LDR   R0, =opcionIn				@ Cargamos dirección de opción
	MOV   R1, #0
	STR   R1,[R0]					@ Restauramos valor inicial en 0
	BL    getchar

	LDR   R0, =msjError				@ Mostramos mensaje de error a usuario
	BL    puts

	@ Esperamos 3 segundos para mostrar mensaje de error.
	MOV   R0, #3
	BL    ESPERASEG

	B     _inDatos

@****   Despliegue de parametros condigurados
_displayParametros:
	PUSH  {LR}

	LDR   R0, =msjDisplayParametros				@ Cargamos dirección de mensaje
	BL    puts

	@**   Desplegando Dirección actual
	LDR   R0, =_DIRECCION
	LDR   R0, [R0]

	CMP   R0, #1
	LDREQ R0, =showDirDerecha				@ Si el movimiento es a la derecha (1), cargamos mensaje derecha
	LDRNE R0, =showDirIzquierda				@ Si el movimiento es a la derecha (1), cargamos mensaje izquierda
	
	BL    puts

	@**   Desplegando número de rotaciones
	LDR   R0, =displayVueltas
	LDR   R1, =_VUELTAS
	LDR   R1, [R1]
	BL    printf

	@**   Desplegando número de repeticiones
	LDR   R0, =displayRepeticiones
	LDR   R1, =_REPETICIONES
	LDR   R1, [R1]
	BL    printf

	POP   {PC}


_DISHARDWARE:
	PUSH  {LR}

	@    Despliegue de Banner
	BL    DISPLAY_BANNER

	@    Despliegue de parametros
	BL   _displayParametros

	@     Despliegue de mensaje de estado en hardware
	LDR   R0, =msjConfHard
	BL    puts


	POP   {PC}

.align 2
.global drFracSeg 
drFracSeg:
	.word fracSeg

_exit:
	LDMFD SP!,{LR}
	MOV   R7, #1
	SWI   0
	BX LR


.data
.align 2
menu:
	.asciz "\t\tMenú\n\t1) Configuración Sistema.\n\t2) Configuración Hardware.\n\t3) Instrucciones.\n\t4) Salir."

.align 2
menuSys:
	.asciz "\t\tConfiguración por Sistema \n\n\t1) Iniciar Rutina. \n\t2) Configurar Dirección. \n\t3) Configurar Vueltas (1 - 9). \n\t4) Configurar Repeticiones (1 - 9). \n\t5) Rregresar."

.align 2
msjInDireccion:
	.asciz "\t\tDirección de motor \n\t1) Rotar a la derecha. \n\t2) Rotar a la izquierda. \n\t3) Regresar."
	
.align 2
msjOpcion:
	.asciz "\n\nIngrese Opción: "

.align 2
msjIngresoVueltas:
	.asciz "\tConfiguración de Vultas"

.align 2
msjIngresoRepeticion:
	.asciz "\tConfiguración de Repeticiones"

.align 2
msjOpcionVal:
	.asciz "\n\nIngrese Valor (de 1 a 9): "

.align 2	
fIngreso:
	.asciz "%d"

.align 2
msjError:
	.asciz "\033[31;42m\n\t\tIngreso una opción incorrecta.\033[0m\n"

.align 2
displayVueltas:
	.asciz "\tVueltas: \033[36m%d\033[0m"

.align 2
displayRepeticiones:
	.asciz "\n\tRepeticiones: \033[36m%d\033[0m"

.align 2
.global showDirDerecha
showDirDerecha:
	.asciz "\tDirección Actual: \033[36mDerecha\033[0m"
	
.align 2
.global showDirIzquierda
showDirIzquierda:
	.asciz "\tDirección Actual: \033[36mIzquierda\033[0m"

.align 2
.global CLEAR
CLEAR:
	.asciz "\033[H\033[J"

.align 2
.global msjDisplayParametros
msjDisplayParametros:
	.asciz "\nParámetros Configurados:"

.align 2
msjConfHard:
	.asciz "\n\nConfiguración por Hardware. \n\t\033[31;42mSalir desde Hardware.\033[0m"

.align 2
.global myloc
myloc:
	.word 0

.align 2
.global fracSeg
fracSeg:
	.float 50000

.align 2
opcionIn:
	.word 0
