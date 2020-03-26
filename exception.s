# SPIM S20 MIPS simulator.
# The default exception handler for spim.
#
# Copyright (C) 1990-2004 James Larus, larus@cs.wisc.edu.
# ALL RIGHTS RESERVED.
#
# SPIM is distributed under the following conditions:
#
# You may make copies of SPIM for your own use and modify those copies.
#
# All copies of SPIM must retain my name and copyright notice.
#
# You may not sell SPIM or distributed SPIM in conjunction with a commerical
# product or service without the expressed written consent of James Larus.
#
# THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE.
#

# $Header: $


# Define the exception handling code.  This must go first!

	.kdata
__m1_:	.asciiz "  Exception "
__m2_:	.asciiz " occurred and ignored\n"
__e0_:	.asciiz "  [Interrupt] "
__e1_:	.asciiz	"  [TLB]"
__e2_:	.asciiz	"  [TLB]"
__e3_:	.asciiz	"  [TLB]"
__e4_:	.asciiz	"  [Address error in inst/data fetch] "
__e5_:	.asciiz	"  [Address error in store] "
__e6_:	.asciiz	"  [Bad instruction address] "
__e7_:	.asciiz	"  [Bad data address] "
__e8_:	.asciiz	"  [Error in syscall] "
__e9_:	.asciiz	"  [Breakpoint] "
__e10_:	.asciiz	"  [Reserved instruction] "
__e11_:	.asciiz	""
__e12_:	.asciiz	"  [Arithmetic overflow] "
__e13_:	.asciiz	"  [Trap] "
__e14_:	.asciiz	""
__e15_:	.asciiz	"  [Floating point] "
__e16_:	.asciiz	""
__e17_:	.asciiz	""
__e18_:	.asciiz	"  [Coproc 2]"
__e19_:	.asciiz	""
__e20_:	.asciiz	""
__e21_:	.asciiz	""
__e22_:	.asciiz	"  [MDMX]"
__e23_:	.asciiz	"  [Watch]"
__e24_:	.asciiz	"  [Machine check]"
__e25_:	.asciiz	""
__e26_:	.asciiz	""
__e27_:	.asciiz	""
__e28_:	.asciiz	""
__e29_:	.asciiz	""
__e30_:	.asciiz	"  [Cache]"
__e31_:	.asciiz	""
__excp:	.word __e0_, __e1_, __e2_, __e3_, __e4_, __e5_, __e6_, __e7_, __e8_, __e9_
	.word __e10_, __e11_, __e12_, __e13_, __e14_, __e15_, __e16_, __e17_, __e18_,
	.word __e19_, __e20_, __e21_, __e22_, __e23_, __e24_, __e25_, __e26_, __e27_,
	.word __e28_, __e29_, __e30_, __e31_
v0:	.word 0
v1:	.word 0
a0:	.word 0
a1:	.word 0
a2:	.word 0
a3:	.word 0
t0:	.word 0
t1:	.word 0
t2:	.word 0
t3:	.word 0
t4:	.word 0
t5:	.word 0
t6:	.word 0
t9:	.word 0


reciever_data:		.word 0xffff0004
reciever_control:	.word 0xffff0000

# PARAMETROS DEL JUEGO
# Parametro D. Se usa la direccion 0x10000000 pues 0x50000000 no lo acepta Bitmap.
display:	.word 0x10000000
N:	.word 32	# Numero de filas
M:	.word 42	# Numero de columnas
S:	.word 2		# Frames per second (FPS). Tambien es el parametro V (velocidad de la serpiente).
K:	.word 5		# Numero de manzanas para pasar al siguiente nivel.

queue:	.word 0		# Direccion de la cola que representa el movimiento de la serpiente.
head:	.word 0		# Direccion de la cabeza de la serpiente.
dir:	.word 0		# Direccion de movimiento
pause:	.word 0		# Indica si el juego esta en pause.
initial:.word 5 	# Longitud inicial de la serpiente.
level:	.word 0		# Indica el nivel.

apples:	.word 0
time:	.word 0

# Timer -> bit 15(8000)
# Keyboard -> bit 8 (0100)
# Interrupts-> bit 1 (0001)
interrupts_code:	.word 0x8101

# This is the exception handler code that the processor runs when
# an exception occurs. It only prints some information about the
# exception, but can server as a model of how to write a handler.
#
# Because we are running in the kernel, we can use $k0/$k1 without
# saving their old values.

# This is the exception vector address for MIPS-1 (R2000):
#	.ktext 0x80000080
# This is the exception vector address for MIPS32:
	.ktext 0x80000180
# Select the appropriate one for the mode in which SPIM is compiled.
	.set noat
	move $k1 $at		# Save $at
	.set at
	sw $v0 v0		# Not re-entrant and we can't trust $sp
	sw $v1 v1		# But we need to use these registers
	sw $a0 a0	
	sw $a1 a1
	sw $a2 a2
	sw $a3 a3
	sw $t0 t0
	sw $t1 t1
	sw $t2 t2
	sw $t3 t3
	sw $t4 t4
	sw $t5 t5
	sw $t6 t6
	sw $t9 t9

	mfc0 $k0 $13		# Cause register
	srl $a0 $k0 2		# Extract ExcCode Field
	andi $a0 $a0 0x1f

	# Print information about exception.
	#
	li $v0 4		# syscall 4 (print_str)
	la $a0 __m1_
	syscall

	li $v0 1		# syscall 1 (print_int)
	srl $a0 $k0 2		# Extract ExcCode Field
	andi $a0 $a0 0x1f
	syscall

	li $v0 4		# syscall 4 (print_str)
	andi $a0 $k0 0x3c
	lw $a0 __excp($a0)
	nop
	syscall

	bne $k0 0x18 ok_pc	# Bad PC exception requires special checks
	nop

	mfc0 $a0 $14		# EPC
	andi $a0 $a0 0x3	# Is EPC word-aligned?
	beq $a0 0 ok_pc
	nop

	li $v0 10		# Exit on really bad PC
	syscall

ok_pc:
	li $v0 4		# syscall 4 (print_str)
	la $a0 __m2_
	syscall

	srl $a0 $k0 2		# Extract ExcCode Field
	andi $a0 $a0 0x1f
	bne $a0 0 ret		# 0 means exception was an interrupt
	nop

# Interrupt-specific code goes here!
# Don't skip instruction at EPC since it has not executed.
interrupts:
	mfc0 	$a0, $13
	srl	$a0, $a0, 15
	andi	$a0, 1
	bgtz	$a0, timer_event

	mfc0	$a0, $13
	srl	$a0, $a0, 8
	andi	$a0, 1
	bgtz	$a0, reciever_event
	
	j	ret_interrupts
	
	
reciever_event:
	# Ignoramos las interrupciones mientras manejamos la actual.
	li 	$t0, 0x0011
	mtc0	$t0, $12
	
	lw	$a0, reciever_data
	lw	$a0, ($a0)
	
	# Primero verificamos si la tecla es "q".
	beq	$a0, 113, event_gameover
	
	# Verificamos si estamos en pausa.
	lw	$a1, pause
	beq	$a0, 112, reciever_event_pause
	beq	$a1, 1, reciever_event_end2
	
	# Si no estamos en pausa, podemos cambiar la direccion de movimiento.
	beq	$a0, 119, reciever_event_top
	beq	$a0, 97, reciever_event_left
	beq	$a0, 115, reciever_event_bot
	beq	$a0, 100, reciever_event_right
	
	j	reciever_event_end
	
# Cambiamos la direccion de movimiento de la serpiente.
reciever_event_top:
	lw	$a1, dir
	beq	$a1, 3, reciever_event_end
	li	$a1, 2
	sw	$a1, dir
	b	reciever_event_end
reciever_event_left:
	lw	$a1, dir
	beq	$a1, 0, reciever_event_end
	li	$a1, 1
	sw	$a1, dir
	b	reciever_event_end
reciever_event_bot:
	lw	$a1, dir
	beq	$a1, 2, reciever_event_end
	li	$a1, 3
	sw	$a1, dir
	b	reciever_event_end
reciever_event_right:
	lw	$a1, dir
	beq	$a1, 1, reciever_event_end
	li	$a1, 0
	sw	$a1, dir
	b	reciever_event_end
	
reciever_event_pause:
	# Verificamos si estamos en pausa o no.
	lw	$a0, pause
	beqz	$a0, reciever_event_pause_stop
	
	# Si estabamos en pausa, reanudamos las interrupciones del timer.
	lw 	$t0, interrupts_code
	mtc0	$t0, $12
	li	$a0, 0
	sw	$a0, pause
	b	reciever_event_end
reciever_event_pause_stop:
	# Si no estabamos en pausa, ignoramos las interrupciones del timer.
	li 	$t0, 0x0101
	mtc0	$t0, $12
	li	$a0, 1
	sw	$a0, pause
	b	reciever_event_end2
	
reciever_event_end:
	# Reanudamos las interrupciones del timer.
	lw 	$t0, interrupts_code
	mtc0	$t0, $12
reciever_event_end2:
	# Finalizamos la interrupcion.
	j	ret_interrupts
	
	
timer_event:
	mfc0	$a0, $13
	andi	$a0, 0x00007e00
	mtc0	$a0, $13
	mtc0	$0, $9
	
	# Cargamos los datos del juego necesarios para el movimiento de la serpiente.
   	lw	$a0, dir
   	lw	$a1, queue
   	lw	$a2, head
   	lw	$a3, display
   	lw	$t0, N
   	lw	$t1, M
	# Movemos a la serpiente un pixel.
   	la	$t9, snake_move
   	jalr	$t9
   	sw	$v0, head
   	
   	# Verificamos el resultado del movimiento.
   	beqz	$v1, timer_event_end
   	beq	$v1, 1, timer_event_apple
   	beq	$v1, 3, event_gameover
	
	# Si v1 == 2, siginifica que pasamos al siguiente nivel.
	# Limpiamos la pantalla.
	lw	$a0, display
	lw	$a1, N
	lw	$a2, M
   	la	$t9, clear
   	jalr	$t9
   	
   	# Colocamos la direccion hacia la derecha.
   	li	$a0, 0
	sw	$a0, dir
   	
   	# Aumentamos la velocidad (FPS)
   	mfc0	$a0, $11
	addi	$a0, $a0, -20
	bgtz	$a0, timer_event_nonzero
	# Si el nuevo FPS no es positivo, entonces ahora sera 20
	li	$a0, 20
	
timer_event_nonzero:
	mtc0	$a0, $11
   	# Dibujamos las paredes del nuevo nivel.
	lw	$a0, display
	lw	$a1, N
	lw	$a2, M
	lw	$a3, level
	add	$a3, $a3, 1
	sw	$a3, level
	blt	$a3, 4, timer_event_nextlevel
	# Verificamos que el nuevo nivel sea el 0.
	li	$a3, 0
	sw	$a3, level
timer_event_nextlevel:
	la	$t9, walls
	jalr	$t9
	
	
	# Dibujamos y creamos una nueva serpiente.
	lw	$a0, initial
	lw	$a1, display
	lw	$a2, K
	la	$t9, snake
	jalr 	$t9
	sw	$v0, queue
	sw	$v1, head
	
	# Colocamos aleatoriamente la primera manzana
	lw	$a0, display
	lw	$a1, N
	lw	$a2, M
	la	$t9, random_apple
	jalr 	$t9

timer_event_apple:
	# Agregamos una manzana al contador.
	lw	$a0, apples
	add	$a0, $a0, 1
	sw	$a0, apples
	
timer_event_end:
	j 	ret_interrupts

event_gameover:
	# Ignoramos las interrupciones del teclado y el timer.
	li 	$t0, 0x1
	mtc0	$t0, $12
	
	# Verificamos la hora actual del sistema y le restamos la hora inicial.
	li	$v0, 30
	syscall
	lw	$a1, time
	sub	$t0, $a0, $a1
	divu	$t0, $t0, 1000
	
	# Cargamos los datos finales del juego necesarios para la pantalla de game over.
	lw	$a0, display
	lw	$a1, N
	lw	$a2, M
	lw	$a3, apples
   	la	$t9, gameover
   	jalr	$t9
   	
   	j	ret_interrupts
   	
ret:
# Return from (non-interrupt) exception. Skip offending instruction
# at EPC to avoid infinite loop.
#
	mfc0 $k0 $14		# Bump EPC register
	addiu $k0 $k0 4		# Skip faulting instruction
				# (Need to handle delayed branch case here)
	mtc0 $k0 $14


ret_interrupts:
# Restore registers and reset procesor state
#
	
	lw $v0 v0
	lw $v1 v1
	lw $a0 a0	
	lw $a1 a1
	lw $a2 a2
	lw $a3 a3
	lw $t0 t0
	lw $t1 t1
	lw $t2 t2
	lw $t3 t3
	lw $t4 t4
	lw $t5 t5
	lw $t6 t6
	lw $t9 t9

	.set noat
	move $at $k1		# Restore $at
	.set at

	mtc0 $0 $13		# Clear Cause register

	mfc0 $k0 $12		# Set Status register
	ori  $k0 0x1		# Interrupts enabled
	mtc0 $k0 $12

# Return from exception on MIPS32:
	eret

# Return sequence for MIPS-I (R2000):
#	rfe			# Return from exception handler
				# Should be in jr's delay slot
#	jr $k0
#	 nop



# Standard startup code.  Invoke the routine "main" with arguments:
#	main(argc, argv, envp)
#
	.text
__start:
	
	################################################################
	##
	## El siguiente bloque debe ser usado para la inicializacion
	## de las interrupciones
	## y de los valores del juego
	################################################################
	# aqui puede acceder a las etiquetas definidas en el main como globales.
	# por ejemplo:
	
	# INICIAMOS EL JUEGO
	# Limpiamos la pantalla
	lw	$a0, display
	lw	$a1, N
	lw	$a2, M
	la	$t9, clear
   	jalr	$t9
   	
	# Dibujamos las paredes del primer nivel (0)
	lw	$a0, display
	lw	$a1, N
	lw	$a2, M
	li	$a3, 0
	la	$t9, walls
	jalr	$t9
	
	
	# Dibujamos y creamos a la serpiente.
	lw	$a0, initial
	lw	$a1, display
	lw	$a2, K
	la	$t9, snake
	jalr 	$t9
	sw	$v0, queue
	sw	$v1, head
	
	# Colocamos aleatoriamente la primera manzana
	lw	$a0, display
	lw	$a1, N
	lw	$a2, M
	la	$t9, random_apple
	jalr 	$t9
	
	####################
	lw 	$a0, interrupts_code
	mtc0	$a0, $12
	
	lw	$a1, reciever_control
	lw	$a0, ($a1)
	ori	$a0, $a0, 0x2
	sw	$a0, ($a1)
	
	li	$a0, 1000
	lw	$t0, S
	div	$a0, $a0, $t0
	mtc0	$a0, $11

	lw $a0 0($sp)		# argc
	addiu $a1 $sp 4		# argv
	addiu $a2 $a1 4		# envp
	sll $v0 $a0 2
	addu $a2 $a2 $v0
	
	li	$v0, 30
	syscall
	sw	$a0, time
	
	jal main
	nop

	li $v0 10
	syscall			# syscall 10 (exit)

	.include "macros.s"
	.include "Queue.s"
	.include "Draw.s"
	.include "Snake.s"

