
.text
.align 2
.global _muestra1
_muestra1:

	LDR   R0, =u1
	BL    puts
	
	LDR   R0, =u2
	BL    puts
	
	LDR   R0, =u3
	BL    puts
	
	LDR   R0, =u4
	BL    puts

	LDR   R0, =u5
	BL    puts
	
	LDR   R0, =u6
	BL    puts
	
	LDR   R0, =u7
	BL    puts
	
	LDR   R0, =u8
	BL    puts

	LDR   R0, =u9
	BL    puts

	LDR   R0, =u10
	BL    puts

	LDR   R0, =u11
	BL    puts

.data	
.align 2
u1:
.asciz "\033[36m    ▄▄▄▄"     

.align 2
u2:
.ascii "  ▄█░░░░▌"    

.align 2
u3:
.ascii " ▐░░▌▐░░▌"

.align 2
u4:
.ascii "  ▀▀ ▐░░▌"  

.align 2
u5:
.ascii "     ▐░░▌"   

.align 2
u6:
.ascii "     ▐░░▌"   

.align 2
u7:
.ascii "     ▐░░▌"

.align 2
u8:
.ascii "     ▐░░▌"

.align 2
u9:
.ascii " ▄▄▄▄█░░█▄▄▄"

.align 2
u10:
.ascii "▐░░░░░░░░░░░▌"

.align 2
u11:
.ascii " ▀▀▀▀▀▀▀▀▀▀▀\033[0m\n"
