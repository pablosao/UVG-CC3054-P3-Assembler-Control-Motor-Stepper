
/************************************************************************************/
/*         Autor: Pablo Sao & Mirka Monzon                                          */
/*         Fecha: 11 de abril de 2019                                               */
/*   Descripcion: Rabbit Chase, donde el objetivo es capturar el conejo en un       */
/*				  tablero.                                          */
/************************************************************************************/

.text
.align 2
.global main
.type main, %function

main:
	STMFD SP!, {LR}

	LRD   R0, =u1
	BL    puts
	
	LRD   R0, =u2
	BL    puts
	
	LRD   R0, =u3
	BL    puts
	
	LRD   R0, =u4
	BL    puts

	LRD   R0, =u5
	BL    puts
	
	LRD   R0, =u6
	BL    puts
	
	LRD   R0, =u7
	BL    puts
	
	LRD   R0, =u8
	BL    puts

	LRD   R0, =u9
	BL    puts

	LRD   R0, =u10
	BL    puts

	LRD   R0, =u11
	BL    puts

	B     _running
	
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

	CMP   R0, #1
	BLEQ  _startPlay

	CMP   R0, #2
	BLEQ  _printInstrucciones

	CMP   R0, #3
	BLEQ   _exit
	BLGT _error


_error:
	LDR   R0, =opcionIn
	MOV   R1, #0
	STR   R1,[R0]
	BL    getchar
	B     _running

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
msjOpcion:
	.ascii "Ingrese Opción: "

.align 2	
fIngreso:
	.asciz "%d"

.align 2
opcionIn:
	.word 0

	
.align 2
u1:
.ascii "    ▄▄▄▄\n"     

.align 2
u2:
.ascii "  ▄█░░░░▌\n"    

.align 2
u3:
.ascii " ▐░░▌▐░░▌\n"

.align 2
u4:
.ascii "  ▀▀ ▐░░▌\n"  

.align 2
u5:
.ascii "     ▐░░▌\n"   

.align 2
u6:
.ascii "     ▐░░▌\n"   

.align 2
u7:
.ascii "     ▐░░▌\n"

.align 2
u8:
.ascii "     ▐░░▌\n"

.align 2
u9:
.ascii " ▄▄▄▄█░░█▄▄▄\n"

.align 2
u10:
.ascii "▐░░░░░░░░░░░▌\n"

.align 2
u11:
.ascii " ▀▀▀▀▀▀▀▀▀▀▀\n"