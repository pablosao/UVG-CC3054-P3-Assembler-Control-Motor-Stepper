
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

	/**   Configurando puertos para control de stepper   **/
	MOV  R0, #14				@ Seteamos pin 
	MOV  R1, #1				@ Configuramos salida

	BL   SetGpioFunction			@ Configuramos puerto

	MOV  R0, #15				@ Seteamos pin 17
	MOV  R1, #1				@ Configuramos salida

	BL   SetGpioFunction
	
	B     _running


@****    Rutina para inicio de la seleccion de configuración
_running:

	@** Limpiando terminal
	LDR   R0, =CLEAR
	BL    puts

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
	BLEQ  _confHardware 

/*	@**   Impresión de configuración
	CMP   R0, #3
	BLEQ  _printInstrucciones
*/
	CMP   R0, #4
	BLEQ   _exit
	BLGT _error



@****    Configuración por medio del sistema
_confSys:

	@** Limpiando terminal
	LDR   R0, =CLEAR
	BL    puts

	@**   Despliegue de menu para configurar por softwrare
	LDR   R0, =menuSys
	BL    puts

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
	BLEQ  _confParametros
	
	@**   Configura dirección
	CMP   R0, #2
	BLEQ  _confDireccion

	CMP   R0, #5
	BLEQ  _running
	BLGT  _errorSys


@****    Configura dirección en la que se movera el motor
_confDireccion:
	
	@** Limpiando terminal
	LDR   R0, =CLEAR
	BL    puts

	@**   Despliegue de menu para configurar por softwrare
	LDR   R0, =msjInDireccion
	BL    puts
	
	@**  Desplegando parametros actuales
	LDR  R0, =_DIRECCION
	LDR  R0, [R0]
	
	CMP   R0, #1
	LDREQ R0, =showDirDerecha				@ Si el movimiento es a la derecha (1), cargamos mensaje derecha
	LDRNE R0, =showDirIzquierda				@ Si el movimiento es a la derecha (1), cargamos mensaje izquierda
	
	BL    puts
	
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

	CMP   R0, #2						@ Si R0 > 2
	BGT   _errorDireccion					@ Se muestra error, no puede ser más de 2
	
	LDR   R1, =_DIRECCION
	STR   R0, [R1]
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


@****     Configuración por Hardware
_confHardware:
	b _exit


_exit:
	LDMFD SP!,{LR}
	MOV   R7, #1
	SWI   0
	BX LR


.data
.align 2
menu:
	.ascii "\t\tMenú\n\t1) Configuración Sistema.\n\t2) Configuración Hardware.\n\t3) Instrucciones.\n\t4) Salir.\n"

.align 2
menuSys:
	.ascii "\t\tConfiguración por Sistema \n\n\t1) Iniciar Rutina. \n\t2) Configurar Dirección. \n\t3) Configurar Vueltas (1 - 99). \n\t4) Configurar Repeticiones (1 - 99). \n\t5) Rregresar.\n"

.align 2
msjInDireccion:
	.ascii "\t\tDirección de motor \n\t1) Mover a la derecha. \n\t2) mover a la izquierda."
	
.align 2
msjOpcion:
	.ascii "Ingrese Opción: "

.align 2
msjVueltas:
	.ascii "Ingrese Número de Vueltas (de 1 a 99): "

.align 2	
fIngreso:
	.asciz "%d"

.align 2
opcionIn:
	.word 0

.align 2
msjError:
	.asciz "\033[31;42m\n\t\tIngreso una opción incorrecta.\033[0m\n"


.align 2
.global showDirDerecha
showDirDerecha:
	.asciz "Dirección Actual: \033[36mDerecha\033[0m\n"
	
.align 2
.global showDirIzquierda
showDirIzquierda:
	.asciz "Dirección Actual: \033[36mIzquierda\033[0m\n"

.align 2
.global CLEAR
CLEAR:
	.asciz "\033[H\033[J"

.align 2
.global myloc
myloc:
	.word 0
