# IMPLEMENTACION DE UNA COLA.

.text
queue_create:
# PARAMETROS:
# 	a0: Longitud de la cola.
#
# RETURNS:
#	v0: Direccion de la cola.
#	v1: Codigo e error.
#
# RESERVA DE MEMORIA:
#	4: Tail
#	4: Head
#	4: Numero de elementos
#	4: Longitud de la cola
#	4*a0: Espacio para los elementos de la cola.
	
	before_run(-1, -1)
	
	# Si el numero de elementos es menor a 2, error
	blt	$a0, 2, queue_create_error1
	
	move	$t0, $a0
	
	# Reservamos la memoria necesaria.
	li 	$v0, 9
	sll	$a0, $a0, 2
	add	$a0, $a0, 16
	syscall	
	beqz	$v0, queue_create_error2	# Si v0 == 0, error.
	move 	$t1, $v0	# Mover direccion valida a t1
	
	add	$t2, $t1, 16	# Direccion del primer elemento
	sw	$t2, ($t1)
	sw	$t2, 4($t1)
	sw	$0, 8($t1)
	sw	$t0, 12($t1)
	
	# Guardamos en v0 la direccion de la tabla de hash.
	move	$v0, $t1
	# No hubo errores.
	li	$v1, 0
	after_run(-1, -1)
	jr      $ra		
	
queue_create_error1:
	print("Error creando la cola: Longitud menor a 2.")
	b	queue_create_error
queue_create_error2:
	print("Error creando la cola: Espacio insuficiente.")
queue_create_error:
	li	$v0, 0
	li	$v1, 1
	after_run(-1, -1)
	jr	$ra
	
	
	
queue_empty:
# PARAMETROS:
# 	a0: Direccion de la cola
#
# RETURNS:
#	v0: 0 -> No vacio; 1 -> Vacio
	lw	$t0,  8($a0)
	beqz	$t0, queue_empty_true
	li	$v0, 0
	after_run(-1, -1)
	jr      $ra		
queue_empty_true:
	li	$v0, 1
	after_run(-1, -1)
	jr      $ra
	
					

queue_full:
# PARAMETROS:
#	a0: Direccion de la cola.
#
# RETURNS:
#	v0: 0 -> No lleno; 1 -> Lleno
	before_run(-1, -1)
	lw	$t0,  8($a0)
	lw	$t1, 12($a0)
	beq	$t0, $t1, queue_full_true
	li	$v0, 0
	after_run(-1, -1)
	jr      $ra		
queue_full_true:
	li	$v0, 1
	after_run(-1, -1)
	jr      $ra
	
	
enqueue:
# PARAMETROS:
#	a0: Direccion de la cola
#	a1: Elemento
#
# RETURNS:
#	v0: Codigo de error
	
	before_run(-1, -1)
	
	# Verificamos si la cola esta llena.
	lw	$t0, 8($a0)	# Numero de elementos actuales.
	lw	$t1, 12($a0)	# Longitud de la cola.
	beq	$t0, $t1, enqueue_error
	
	# Numero de elementos +1
	add	$t0, $t0, 1
	sw	$t0, 8($a0)
	
	# Insertamos el elemento
	lw	$t2, 4($a0)
	sw	$a1, ($t2)
	
	# Verificamos si alcanzamos el ultimo espacio de memoria de la cola.
	lw	$t0, 12($a0)
	sll	$t0, $t0, 2
	add	$t0, $t0, 12
	add	$t0, $t0, $a0
	beq	$t0, $t2, enqueue_cicle
	
	# Actualizamos el head.
	add	$t2, $t2, 4
	sw	$t2, 4($a0)
	b 	enqueue_end
	
enqueue_cicle:
	# El head sera el primer espacio de memoria para los elementos.
	add	$t2, $a0, 16
	sw	$t2, 4($a0)
	
enqueue_end:
	# No hubo errores.
	li	$v0, 0
	after_run(-1, -1)
	jr      $ra		
	
enqueue_error:
	print("Error insertando un elemento: Overflow.")
	li	$v0, 1
	after_run(-1, -1)
	jr      $ra		
	
	
	
dequeue:
# PARAMETROS:
#	a0: Direccion de la cola
#
# RETURNS:
#	v0: Elemento.
#	v1: Codigo de error.
	
	before_run(-1, -1)
	
	# Verificamos si la cola esta vacia.
	lw	$t0, 8($a0)
	beqz	$t0, dequeue_error
	
	# Obtenemos el elemento
	lw	$t2, ($a0)
	lw	$v0, ($t2)
	
	# Numero de elementos -1
	add	$t0, $t0, -1
	sw	$t0, 8($a0)
	
	# Verificamos si alcanzamos el ultimo espacio de memoria e la cola.
	lw	$t0, 12($a0)
	sll	$t0, $t0, 2
	add	$t0, $t0, 12
	add	$t0, $t0, $a0
	beq	$t0, $t2, dequeue_cicle
	
	# Actualizamos la cola (tail).
	add	$t2, $t2, 4
	sw	$t2, ($a0)
	
	b 	dequeue_end
	
dequeue_cicle:
	# La cola (tail) sera el primer espacio de memoria para los elementos.
	add	$t2, $a0, 16
	sw	$t2, ($a0)
	
dequeue_end:
	# No hubo errores.
	li	$v1, 0
	after_run(-1, -1)
	jr      $ra		
	
dequeue_error:	
	print("Error sacando un elemento: Underflow.")
	li	$v0, 1
	after_run(-1, -1)
	jr      $ra		
	
	
	
	
