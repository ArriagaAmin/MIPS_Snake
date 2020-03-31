# JUEGO SNAKE. 

# Limpia el monitor.
clear:
# PARAMETROS:
#	a0: Display.
#	a1: Numero de filas.
#	a2: Numero de columnas.
	before_run(-1, -1)

	li	$t0, 0		# Iterador en las filas.
	li	$t1, 0		# Iterador en las columnas.\
	li	$t2, 0x10000000	# Negro
	
clear_rows:
	# Obtenemos la fila actual.
	move	$t3, $a0
	sll	$t4, $t0, 8	# $t3 = Fila actual * 64 * 4
	add	$t3, $t3, $t4
	
	beq	$t0, $a1, clear_end	# Si alcanzamos el numero filas, terminamos.
	
clear_loop:
	# Pintamos el pixel actual de blanco y pasamos al siguiente.
	sw	$t2, ($t3)
	add	$t3, $t3, 4
	add	$t1, $t1, 1
	
	# Si alcanzamos al numero de columnas, pasamos a la siguiente fila.
	beq	$t1, $a2, clear_loop_end
	b 	clear_loop
	
clear_loop_end:
	# Siguiente fila.
	add	$t0, $t0, 1
	li	$t1, 0
	b	clear_rows
	
clear_end:
	after_run (-1, -1)
	jr	$ra



# Imprime las paredes del juego.
walls:
# PARAMETROS:
#	a0: Display
#	a1: Numero de filas
#	a2: Numero de columnas
#	a3: Nivel
	before_run (-1, -1)
	
	add	$t5, $a1, -1
	li	$t0, 0		# Iterador en filas.
	li	$t1, 0		# Iterador en columnas.
	li	$t4, 0xffffffff	# Blanco
	
walls_loop:
	# Pasamos a la siguiente fila.
	move	$t2, $a0		
	sll	$t3, $t0, 8	# $t3 = Fila actual * 64 * 4
	add	$t2, $t2, $t3
	
	beq	$t0, $a1, walls_add	# Si alcanzamos el numero filas, terminamos.
	# Si la fila actual es la primera o la ultima, dibujamos la linea completa.
	beqz	$t0, walls_all  
	beq	$t0, $t5, walls_all
	

	# Si es una fila intermedia, dibujamos el primer pixel y el ultimo.
	sw	$t4, ($t2)
	
	# Obtenemos la direccion del ultimo bit.
	sll	$t1, $a2, 2
	add	$t2, $t2, $t1
	add	$t2, $t2, -4
	sw	$t4, ($t2)
	
	# Pasamos a la siguiente fila.
	add	$t0, $t0, 1
	li	$t1, 0
	b	walls_loop
		
walls_all:
	# Pintamos el pixel actual de blanco y pasamos al siguiente.
	sw	$t4, ($t2)
	add	$t2, $t2, 4
	add	$t1, $t1, 1
	
	# Si alcanzamos al numero de columnas, pasamos a la siguiente fila.
	beq	$t1, $a2, walls_all_end
	b 	walls_all
	
walls_all_end:
	# Siguiente fila.
	add	$t0, $t0, 1
	li	$t1, 0
	b	walls_loop
	
walls_add:
	beqz	$a3, walls_end
	beq	$a3, 1, walls_level1
	beq	$a3, 2, walls_level2
	beq	$a3, 3, walls_level3
	
walls_level1:
	# Este nivel tendra una pared horizontal como obstaculo.
	
	# Obtenemos la fila donde dibujaremos la pared.
	divu	$t0, $a1, 3
	sll	$t0, $t0, 9
	add	$t0, $t0, $a0
	
	# Obtenemos la columna donde dibujaremos la pared.
	divu	$t1, $a2, 5
	sll	$t2, $t1, 2
	mul	$t1, $t1, 3
	add	$t0, $t0, $t2
	li	$t2, 0xffffffff
	li	$t3, 0
	
	# Dibujamos la pared.
walls_level1_loop:
	sw	$t2, ($t0)
	add	$t0, $t0, 4
	add 	$t3, $t3, 1
	bne	$t3, $t1, walls_level1_loop
	b 	walls_end
	
walls_level2:
	# Este nivel tendra un par de portales ademas de una pared que divide el campo en dos,
	# siendo una parte alcanzable por la otra a traves de los protales.
	
	# Obtenemos la fila donde dibujaremos los portales.
	divu	$t0, $a1, 5
	mul	$t1, $t0, 3
	sll	$t1, $t0, 9
	add	$t1, $t1, $a0
	
	add	$t2, $a2, -1
	sll	$t2, $t2, 2
	
	li	$t3, 0x000000ff	# Azul
	li	$t4, 0
	
	# Dibujamos los portales.
walls_level2_loop:
	sw	$t3, ($t1)
	add	$t5, $t1, $t2
	sw	$t3, ($t5)
	add	$t1, $t1, 256
	add	$t4, $t4, 1
	bne	$t4, $t0, walls_level2_loop
	
	move	$t0, $a1
	divu	$t1, $a2, 2
	sll	$t1, $t1, 2
	add	$t1, $t1, $a0
	li	$t2, 0xffffffff
	li	$t3, 0
	# Dibujamos la pare.
walls_level2_loop2:
	sw	$t2, ($t1)
	add 	$t1, $t1, 256
	add	$t3, $t3, 1
	bne	$t3, $t0, walls_level2_loop2
	b 	walls_end
	

walls_level3:
	# Este es el nivel mas dificil. Consta un de par de paredes en forma de cruz que 
	# dividen el mapa en 4; y 3 pares de portales que permiten comunicar las 4 partes el mapa.
	
	# Dibujamos la pared vertical en el medio.	
	move	$t0, $a1
	divu	$t1, $a2, 2
	sll	$t1, $t1, 2
	add	$t1, $t1, $a0
	li	$t2, 0xffffffff	# Blanco
	li	$t3, 0
walls_level3_loop:
	sw	$t2, ($t1)
	add 	$t1, $t1, 256
	add	$t3, $t3, 1
	bne	$t3, $t0, walls_level3_loop
	
	# Dibujamos la pared horizonal en el medio.
	move	$t0, $a2
	divu	$t1, $a1, 2
	sll	$t1, $t1, 8
	add	$t1, $t1, $a0
	li	$t2, 0xffffffff	# Blanco.
	li	$t3, 0
walls_level3_loop2:
	sw	$t2, ($t1)
	add 	$t1, $t1, 4
	add	$t3, $t3, 1
	bne	$t3, $t0, walls_level3_loop2
	
	# Dibujamos los portales que se encuentran arriba y abajo del mapa.
	divu	$t0, $a2, 5
	sll	$t1, $t0, 2
	add	$t2, $t1, $a0
	sll	$t1, $t1, 1
	add	$t1, $t1, 12
	
	move	$t3, $a1
	add	$t3, $t3, -1
	sll	$t3, $t3, 8
	
	li	$t4, 0x000000ff # Azul
	li	$t5, 0
walls_level3_loop3:
	sw	$t4, ($t2)
	add	$t6, $t2, $t1
	sw	$t4, ($t6)
	add	$t7, $t2, $t3
	sw 	$t4, ($t7)
	add	$t6, $t7, $t1
	sw	$t4, ($t6)
	add	$t2, $t2, 4
	addi	$t5, $t5, 1
	bne	$t5, $t0, walls_level3_loop3
	
	
	# Dibujamos los portales que se encuentran a los aldos del mapa.
	divu	$t0, $a1, 5
	mul	$t1, $t0, 3
	sll	$t1, $t0, 9
	add	$t1, $t1, $a0
	add	$t1, $t1, 256
	add	$t0, $t0, 1
	
	add	$t2, $a2, -1
	sll	$t2, $t2, 2
	
	li	$t3, 0x000000ff # Azul
	li	$t4, 0
walls_level3_loop4:
	sw	$t3, ($t1)
	add	$t5, $t1, $t2
	sw	$t3, ($t5)
	add	$t1, $t1, 256
	add	$t4, $t4, 1
	bne	$t4, $t0, walls_level3_loop4

	b 	walls_end


walls_end:
	li	$v0, 0
	after_run (-1, -1)
	jr	$ra
	


# Dibuja a la serpiente en su estado inicial.	
snake:
# PARAMETROS:
#	a0: Longitud
#	a1: Display
#	a2: Numero de manzanas para pasar al siguiente nivel
#
# RETURNS:
#	v0: Direccion de la cola que representa a la serpiente
#	v1: Cabeza de la serpiente.

	# Posicion inicial de la serpiente, significa que comienza en ($t0, $t0) hacia la derecha.
	before_run (1, -1)
	
	li 	$t0, 10	
	li	$t1, 0x0000ff00
	
	before_call (2, -1, 1)	# Creamos una cola que representara a la serpiente.
	add	$a0, $a0, $a2
	jal	queue_create
	after_call (2, -1, 1)
	
	li	$t2, 0	# Iterador

		
snake_draw:
	beq 	$t2, $a0, snake_end

	# Obtenemos la posicion del pixel a dibujar.
	sll   	$t3, $t0, 8 	# Y = y * 64 * 4
	# X = 4 * (initial + iterador)
	sll	$t4, $t0, 2	
	sll	$t5, $t2, 2	
	addu  	$t3, $t3, $t4
	addu  	$t3, $t3, $t5 
	addu  	$t3, $t3, $a1
	
	sw    	$t1, ($t3)      # Dibujamos el pixel.
	
	before_call (3, 0, 5)	# Insertamos la posicion de la serpiente en la cola.
	move	$a0, $v0
	move	$a1, $t3
	jal	enqueue
	after_call (3, 0, 5)
	
	move	$v1, $t3

	addi 	$t2, $t2, 1
	b	snake_draw
	
snake_end:
	after_run (1, -1)
	jr	$ra


# Mueve a la serpiente
snake_move:
# PARAMETROS:
#	a0: Direccion de movimiento.
# 	a1: Cola que representa a la serpiente.
#	a2: Head de la serpiente.
#	a3: Display.
#	t0: Numero de filas.
#	t1: Numero de columnas.
#
# RETURNS:
#	v0: Nueva cabeza de la serpiente.
#	v1: 0 -> Nada; 1 -> Se comio una manzana pero no gano; 2 -> Paso al siguiente nivel; 3 -> Perdio.
   	before_run (1, -1)
   	
	beqz	$a0, snake_move_right
	beq	$a0, 1, snake_move_left
   	beq	$a0, 2, snake_move_top
   	beq	$a0, 3, snake_move_bot

# Obtenemos la direccion del nuevo head.
snake_move_right:
	add	$v0, $a2, 4
	b	snake_move_check
snake_move_left:
	add	$v0, $a2, -4
	b	snake_move_check
snake_move_top:
	add	$v0, $a2, -256
	b	snake_move_check
snake_move_bot:
	add	$v0, $a2, 256
	
	
snake_move_check:
	lw	$t2, ($v0)
	# Verificamos que hay en la casilla a donde se quiere mover la serpiente.
	beq	$t2, 0xffffffff, snake_move_gameover
	beq	$t2, 0x0000ff00, snake_move_gameover
	beq	$t2, 0x000000ff, snake_move_portal
	bne	$t2, 0x00ff0000, snake_move_draw
	move	$t2, $v0
	
	# Si la casilla es roja, generamos una nueva manzana.
	before_call (3, -1, -1)
	move	$a0, $a3
	move	$a1, $t0
	move	$a2, $t1
	jal 	random_apple
	after_call (3, -1, -1)
	
	move	$v0, $t2
	li	$t0, 1	# Indica que se comio una manzana
	b 	snake_move_draw
	
snake_move_portal:
	# Si la casilla es azul, significa que entro en un portal.
	
	# Memoria que nos tenemos que mover para saber donde va a aparecer la serpiente.
	add	$t2, $t0, -2
	sll	$t2, $t2, 8
	add	$t3, $t1, -2
	sll	$t3, $t3, 2
	
	# Verificamos de nuevo la direccion de movimento de la serpiente.
	beqz	$a0, snake_move_portalR
	beq	$a0, 1, snake_move_portalL
   	beq	$a0, 2, snake_move_portalT
   	beq	$a0, 3, snake_move_portalB
   
# Calculamos el lugar de aparicion de la cabeza de la serpiente	
snake_move_portalR:
	sub	$v0, $v0, $t3
	b 	snake_move_draw
snake_move_portalL:
	add	$v0, $v0, $t3
	b 	snake_move_draw
snake_move_portalT:
	add	$v0, $v0, $t2
	b 	snake_move_draw
snake_move_portalB:
	sub	$v0, $v0, $t2

# Dibujamos la cabeza de la serpiente.
snake_move_draw:
	li	$t1, 0x0000ff00	# Verde
	sw	$t1, ($v0)
	
	before_call (1, 0, 0)	# Insertamos la posicion de la serpiente en la cola.
	move	$a0, $a1
	move	$a1, $v0
	jal	enqueue
	after_call (1, 0, 0)
	
	bne	$t0, 1, snake_move_del
	
	before_call (-1, 0, -1)	# Verificamos si la serpiente esta llena.
	move	$a0, $a1
	jal	queue_full
	move	$v1, $v0
	after_call (-1, 0, -1)
	
	add	$v1, $v1, 1
	
	b	snake_move_end
	
snake_move_del:
	before_call (-1, 0, -1)	# Eliminamos la cola de la serpiente.
	move	$a0, $a1
	jal	dequeue
	li	$a0, 0x10000000
	sw	$a0, ($v0)
	after_call (-1, 0, -1)
	
	li	$v1, 0
	b	snake_move_end

snake_move_gameover:
	li	$v1, 3
		
snake_move_end:
	after_run(1, -1)
	jr	$ra

		
	
	
# Fin del juego.
gameover:
# PARAMETROS:
#	a0: Display.
#	a1: Numero de filas.
#	a2: Numero de columnas.
#	a3: Numero de manzanas.
#	t0: Segundos.
	before_run(1, -1)
	
	# Limpiamos la pantalla
	before_call(3, 0, 0)
	jal 	clear
	after_call(3, 0, 0)
	
	# Dibujamos el numero de manzanas que se logro comer la serpiente.
	before_call(3, 0, 0)
	move	$a1, $a3
	jal	draw_apple
	after_call(3, 0, 0)
	
	# Dibujamos el tiemp en segundo que duro la partida.
	move	$a1, $t0
	jal	draw_time
	
	after_run(1, -1)
	jr	$ra
	
	
	
# Generamos una manzana aleatoria.
random_apple:
# PARAMETROS
# 	$a0: Display.
#	$a1: Numero de filas
#	$a2: Numero de columnas
	before_run (1, -1)
	
	add	$a1, $a1, -1 	# Para evitar que choque con la pared, restamos 1 al numero de filas
	before_call (2, -1, -1)	# Obtenemos una fila aleatoria usando la hora del sistema.
	move	$t1, $a1
	li	$v0, 30
	syscall
	rem	$t0, $a0, $t1
	after_call (2, -1, -1)
	
	bnez	$t0, random_apple_col
	li	$t0, 1
	
random_apple_col:
	add	$a2, $a2, -1 	# Para evitar que choque con la pared, restamos 1 al numero de columnas.
	before_call (2, -1, 0)	# Obtenemos una columna aleatoria usando la hora el sistema.
	move	$t0, $a2
	li	$v0, 30
	syscall
	rem	$t1, $a0, $t0
	after_call (2, -1, 0)
	
	bnez	$t1, random_apple_draw
	li	$t1, 1
	
random_apple_draw:
	# Obtenemos la direccion del pixal a dibujar.
	sll	$t0, $t0, 8
	sll	$t1, $t1, 2
	add	$t0, $t0, $t1
	add	$t0, $t0, $a0
	
	lw	$t1, ($t0)
	bne	$t1, 0x10000000, random_apple
	
	li	$t1, 0x00ff0000
	sw	$t1, ($t0)
	
	after_run (1, -1)
	jr	$ra
	
	

end:
    	li 	$v0, 10
    	syscall
