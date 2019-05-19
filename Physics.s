
/************************************************************************************/
/*         Autor: Pablo Sao                                                         */
/*         Fecha: 19 de mayo de 2019                                                */
/*   Descripcion: Control de dirección y vueltas de un motor steeper, por medio     */
/*				  de hardware (Circuito electronico).                               */
/************************************************************************************/

.align 2
.global HARDWARE_CONTROLER
HARDWARE_CONTROLER:
	
	MOV  R0, #20000					@ Se mandan 0.02 segundos 
	BL   ESPERAMICRO				@ Rutina de espera
		
	@ Verificamos si se suma un valor a vueltas
	MOV   R1, #2						@ Configuramos pin 2
	BL    GetGpio

	TEQ   R5, #0
	MOVNE R0, #0
	BLNE  SUM_VUELTAS
	BLNE  HARDWARE_CONTROLER

	@ Verificamos si se suma un valor a repeticiones
	MOV   R1, #3						@ Configuramos pin 3
	BL    GetGpio

	TEQ   R5, #0
	MOVNE R0, #0
	BLNE  SUM_REPETICION
	BLNE  HARDWARE_CONTROLER


	@ Verificamos si se suma un valor a repeticiones
	MOV   R1, #4						@ Configuramos pin 4
	BL    GetGpio

	TEQ   R5, #0
	MOVNE R0, #0
	BLNE  _changeDirection
	BLNE  HARDWARE_CONTROLER



	@ Verificamos para inicio de rutina
	MOV   R1, #17						@ Configuramos pin 17
	BL    GetGpio

	TEQ   R5, #0
	MOVNE R0, #0
	BLNE  SUM_REPETICION
	BLNE  HARDWARE_CONTROLER


	@ Verificamos salida de hardware
	MOV   R1, #27						@ Configuramos pin 27
	BL    GetGpio
	
	@** Leemos boton de salida de hardware
	TEQ   R5,#0							@ Si R5 == 0
	BEQ   HARDWARE_CONTROLER				@ repite ciclo
	BNE   _running							@ Si no es igual Regresa a menú de configuración



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
