
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

	B     _running


@****    Rutina para inicio de la seleccion de configuración
_running:

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

	@**   Impresión de configuración
	CMP   R0, #3
	BLEQ  _printInstrucciones

	CMP   R0, #4
	BLEQ   _exit
	BLGT _error


@****    Error de ingreso de primer ciclo
_error:
	LDR   R0, =opcionIn				@ Cargamos dirección de opción
	MOV   R1, #0
	STR   R1,[R0]					@ Restauramos valor inicial en 0
	BL    getchar

	LDR   R0, =msjError				@ Mostramos mensaje de error a usuario
	BL    puts

	B     _running					@ Regresamos a rutina de ejecución


@****    Configuración por medio de motor
_confSys:
	@**   Mensaje de ingreso de opción:
	LDR   R0, =msjOpcion
	BL puts

	@**   Comando para Ingreso de teclado
	LDR   R0, =fIngreso
	LDR   R1, =opcionIn
	BL    scanf

	@**   verificamos que se haya ingresado un número
	CMP   R0, #0
	BEQ _errorSys

	@**   Identificación de operaciones
	LDR   R0, =opcionIn
	LDR   R0, [R0]

	@**   Configura parametros
	CMP   R0, #1
	BLEQ  _confSys
	
	@**   Inicia Programa
	CMP   R0, #2
	BLEQ  _confHardware 

	CMP   R0, #3
	BLEQ  _running
	BLGT  _errorSys


@****    Error de ingreso de segundo ciclo
_errorSys:
	LDR   R0, =opcionIn				@ Cargamos dirección de opción
	MOV   R1, #0
	STR   R1,[R0]					@ Restauramos valor inicial en 0
	BL    getchar

	LDR   R0, =msjError				@ Mostramos mensaje de error a usuario
	BL    puts

	B     _confSys


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
	.ascii "\t\tMenú\n\t1) Configuración Sistema.\n\t2)Configuración Hardware.\n\t3) Instrucciones.\n\t4) Salir."

.align 2
menuSys:
	.ascii "\tMenú Configuración por Sistema \n\n\t1) Configuración de Parametros. \n\t2) Iniciar Configuración. \n\t3) Rregresar."

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
	.ascii "\n\t\tIngreso una opción incorrecta.\n"

