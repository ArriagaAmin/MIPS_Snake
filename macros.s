.data


# --------------------- Responsabilidades antes de llamar -------------------------- #
.macro before_call (%m, %n, %p)
.text
	# Macro para reservar los registros correspondientes al llamador, en este caso:
	# a0 - am;  v0 - vn;  t0 - tp.

	# RESERVA DE LOS a*
	# Guardamos el valor de m
	li	$t9, %m
	beq	$t9, 3, before_call_a3
	beq	$t9, 2, before_call_a2
	beq	$t9, 1, before_call_a1
	beq	$t9, 0, before_call_a0
	# Si no se coloca un valor valido, no se reservara ninguno.
	j	before_call_v
	# Reservamos desde a0 hasta an
before_call_a3: 	
	sw      $a3, ($sp)
	addi    $sp, $sp, -4
before_call_a2:	
	sw      $a2, ($sp)
	addi    $sp, $sp, -4
before_call_a1:	
	sw      $a1, ($sp)
	addi    $sp, $sp, -4
before_call_a0:	
	sw      $a0, ($sp)
	addi    $sp, $sp, -4
	
	
before_call_v:
	# RESERVA DE LOS v*
	# Guardamos el valor de n
	li	$t9, %n
	beq	$t9, 1, before_call_v1
	beq	$t9, 0, before_call_v0
	# Si no se coloca un valor valido, no se reservara ninguno.
	j	before_call_t
	# Reservamos desde v0 hasta vn
before_call_v1: 	
	sw      $v1, ($sp)
	addi    $sp, $sp, -4
before_call_v0:	
	sw      $v0, ($sp)
	addi    $sp, $sp, -4
	

before_call_t:
	# RESERVA DE LOS t*
	# Guardamos el valor de p
	li	$t9, %p
	beq	$t9, 7, before_call_t7
	beq	$t9, 6, before_call_t6
	beq	$t9, 5, before_call_t5
	beq	$t9, 4, before_call_t4
	beq	$t9, 3, before_call_t3
	beq	$t9, 2, before_call_t2
	beq	$t9, 1, before_call_t1
	beq	$t9, 0, before_call_t0
	# Si no se coloca un valor valido, no se reservara ninguno.
	j	before_call_end
	# Reservamos desde v0 hasta vn
before_call_t7:
	sw      $t7, ($sp)
	addi    $sp, $sp, -4
before_call_t6:
	sw      $t6, ($sp)
	addi    $sp, $sp, -4
before_call_t5:
	sw      $t5, ($sp)
	addi    $sp, $sp, -4
before_call_t4:
	sw      $t4, ($sp)
	addi    $sp, $sp, -4
before_call_t3:
	sw      $t3, ($sp)
	addi    $sp, $sp, -4
before_call_t2:
	sw      $t2, ($sp)
	addi    $sp, $sp, -4
before_call_t1:
	sw      $t1, ($sp)
	addi    $sp, $sp, -4
before_call_t0:
	sw      $t0, ($sp)
	addi    $sp, $sp, -4
	
	
before_call_end:
	# Finaliza el macro
.end_macro
# ------------------------------------------------------ #



# --------------------- Responsabilidades despues de ejecutar -------------------------- #
.macro after_call (%m, %n, %p)
.text
	# RECUPERAR LOS t*
	# Guardamos el valor de p
	li	$t9, %p
	blt	$t9, 0, after_call_v
	bgt	$t9, 7, after_call_v
	# t0
	addi    $sp, $sp, 4
	lw      $t0, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_v
	# t1
	addi    $sp, $sp, 4
	lw      $t1, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_v
	# t2
	addi    $sp, $sp, 4
	lw      $t2, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_v
	# t3
	addi    $sp, $sp, 4
	lw      $t3, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_v
	# t4
	addi    $sp, $sp, 4
	lw      $t4, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_v
	# t5
	addi    $sp, $sp, 4
	lw      $t5, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_v
	# t6
	addi    $sp, $sp, 4
	lw      $t6, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_v
	# t7
	addi    $sp, $sp, 4
	lw      $t7, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_v
	

after_call_v:	
	# RECUPERAR LOS v*
	# Guardamos el valor de n
	li	$t9, %n
	blt	$t9, 0, after_call_a
	bgt	$t9, 1, after_call_a
	# v0
	addi    $sp, $sp, 4
	lw      $v0, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_a
	# v1
	addi    $sp, $sp, 4
	lw      $v1, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_a
	
	
after_call_a:
	# RECUPERAR LOS a*
	# Guardamos el valor de m
	li	$t9, %m
	blt	$t9, 0, after_call_end
	bgt	$t9, 7, after_call_end
	# a0
	addi    $sp, $sp, 4
	lw      $a0, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_end
	# a1
	addi    $sp, $sp, 4
	lw      $a1, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_end
	# a2
	addi    $sp, $sp, 4
	lw      $a2, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_end
	# a3
	addi    $sp, $sp, 4
	lw      $a3, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_call_end
	
	
after_call_end:
	# Finaliza el macro
.end_macro
# ------------------------------------------------------ #

	
	
# --------------------- Responsabilidades de ejecutar -------------------------- #
.macro before_run (%m, %n)
.text
	# Macro para reservar los registros correspondientes al llamado, en este caso:
	# fp;  $ra (si m == 1);  s0 - sn.

	# RESERVAR fp	
	sw      $fp, ($sp)
	move	$fp, $sp
	addi    $sp, $sp, -4
	
	
	# RESERVAR ra
	# Guardamos el valor de m
	li	$t9, %m
	bne	$t9, 1, before_run_s
	# Reservamos ra si m == 1.
	sw      $ra, ($sp)
	addi    $sp, $sp, -4
	

before_run_s:
	# RESERVA DE LOS s*
	# Guardamos el valor de n
	li	$t9, %n
	beq	$t9, 7, before_run_s7
	beq	$t9, 6, before_run_s6
	beq	$t9, 5, before_run_s5
	beq	$t9, 4, before_run_s4
	beq	$t9, 3, before_run_s3
	beq	$t9, 2, before_run_s2
	beq	$t9, 1, before_run_s1
	beq	$t9, 0, before_run_s0
	# Si no se coloca un valor valido, no se reservara ninguno.
	j	before_run_end
	# Reservamos desde v0 hasta vn
before_run_s7:
	sw      $s7, ($sp)
	addi    $sp, $sp, -4
before_run_s6:
	sw      $s6, ($sp)
	addi    $sp, $sp, -4
before_run_s5:
	sw      $s5, ($sp)
	addi    $sp, $sp, -4
before_run_s4:
	sw      $s4, ($sp)
	addi    $sp, $sp, -4
before_run_s3:
	sw      $s3, ($sp)
	addi    $sp, $sp, -4
before_run_s2:
	sw      $s2, ($sp)
	addi    $sp, $sp, -4
before_run_s1:
	sw      $s1, ($sp)
	addi    $sp, $sp, -4
before_run_s0:
	sw      $s0, ($sp)
	addi    $sp, $sp, -4
	
	
before_run_end:
	# Finaliza el macro
.end_macro
# ------------------------------------------------------ #




# --------------------- Responsabilidades despues de ejecutar -------------------------- #
.macro after_run (%m, %n)
.text
	# RECUPERAR LOS s*
	# Guardamos el valor de n
	li	$t9, %n
	blt	$t9, 0, after_run_ra
	bgt	$t9, 7, after_run_ra
	# s0
	addi    $sp, $sp, 4
	lw      $s0, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_run_ra
	# s1
	addi    $sp, $sp, 4
	lw      $s1, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_run_ra
	# s2
	addi    $sp, $sp, 4
	lw      $s2, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_run_ra
	# s3
	addi    $sp, $sp, 4
	lw      $s3, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_run_ra
	# s4
	addi    $sp, $sp, 4
	lw      $s4, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_run_ra
	# s5
	addi    $sp, $sp, 4
	lw      $s5, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_run_ra
	# s6
	addi    $sp, $sp, 4
	lw      $s6, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_run_ra
	# s7
	addi    $sp, $sp, 4
	lw      $s7, ($sp)
	add	$t9, $t9, -1
	beq	$t9, -1, after_run_ra
	

after_run_ra:
	# RESERVAR ra
	# Guardamos el valor de m
	li	$t9, %m
	bne	$t9, 1, after_run_fp
	# Reservamos ra si m == 1.
	addi    $sp, $sp, 4	
	lw      $ra, ($sp)
		
	
after_run_fp:	
	# RESERVAR fp
	addi    $sp, $sp, 4	
	lw      $fp, ($sp)
.end_macro
# ------------------------------------------------------ #




# --------------------- Imprimir "Inmediato" -------------------------- #
.macro print (%msg)

.data
Message:	.asciiz %msg
NewLine:	.asciiz "\n"

.text
	li	$v0, 4
	la	$a0, Message
	syscall
	li	$v0, 4
	la	$a0, NewLine
	syscall
.end_macro
# ------------------------------------------------------ #

