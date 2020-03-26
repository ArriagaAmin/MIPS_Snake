# DIBUJOS.

# Dibujamos una manzana junto a un numero	
draw_apple:
# PARAMETROS:
#	a0: Display
#	a1: Numero a dibujar.

	before_run(1, -1)
	
	# Posicion Y inicial.
	li	$t0, 7
	sll	$t0, $t0, 8
	# Posicion X inicial del dibujo.
	li	$t1, 5	
	sll	$t1, $t1, 2
	
	move	$a2, $a1
	li	$t2, 1
draw_apple_digits:
	# Obtenemos la potencia de 10 mas pequenya tal que dividiendo el numero a dibujar
	# entre el se obtenga 0.
	mul	$t2, $t2, 10
	divu	$t3, $a1, $t2
	bnez	$t3, draw_apple_digits
	
draw_apple_loop:
	# Obtenemos el i-esimo digito y lo imprimos.
	divu	$t2, $t2, 10
	move	$a1, $a2
	divu	$a1, $a1, $t2
	remu	$a1, $a1, 10
	# Imprimimos el numero
	before_call(2, -1, 2)
	add	$a0, $a0, $t0
	add	$a0, $a0, $t1
	jal	draw_number
	after_call(2, -1, 2)
	add	$t1, $t1, 20
	bne	$t2, 1, draw_apple_loop
	
	add	$t1, $t1, 8
	add	$t0, $t0, -512
	
	# Ahora dibujamos la manzana.Primero dibujaremos la hoja.
	li	$t2, 0x0000ff00 # Verde
	add 	$t3, $t0, $t1
	add	$t3, $t3, $a0
	add	$t3, $t3, 12
	sw	$t2, ($t3)
	
	add	$t3, $t3, 256
	sw	$t2, ($t3)
	add	$t3, $t3, -4
	sw	$t2, ($t3)
	
	add	$t0, $t0, 512
	
	li	$t2, 0x00ff0000	# Rojo
	
	li	$t3, 0		# Iterador de filas
	li	$t4, 0		# Iterador de columnas
	
draw_apple_loop2:
	# Pasamos a la siguiente fila.		
	sll	$t5, $t3, 8	# $t5 = Fila actual * 64 * 4
	add	$t5, $t5, $t0
	add	$t5, $t5, $t1
	add	$t5, $t5, $a0
	
	beq	$t3, 5, draw_apple_end	# Si alcanzamos el numero filas, terminamos.
	# Si la fila actual es la primera o la ultima, dibujamos la linea completa.
		
draw_apple_raw:
	sw	$t2, ($t5)
	add	$t5, $t5, 4
	add	$t4, $t4, 1
	
	# Si alcanzamos al numero de columnas, pasamos a la siguiente fila.
	beq	$t4, 5, draw_apple_raw_end
	b 	draw_apple_raw
	
draw_apple_raw_end:
	# Siguiente fila.
	add	$t3, $t3, 1
	li	$t4, 0
	b	draw_apple_loop2
	
draw_apple_end:
	after_run (1, -1)
	jr	$ra
	
	

# Dibujamos un reloj junto a un numero.
draw_time:
# PARAMETROS:
#	a0: Display
#	a1: Numero a dibujar.
	before_run(1, -1)
	
	# Posicion Y inicial.
	li	$t0, 17
	sll	$t0, $t0, 8
	# Posicion X inicial del dibujo.
	li	$t1, 5	
	sll	$t1, $t1, 2
	
	move	$a2, $a1
	li	$t2, 1
draw_time_digits:
	# Obtenemos la potencia de 10 mas pequenya tal que dividiendo el numero a dibujar
	# entre el se obtenga 0.
	mul	$t2, $t2, 10
	divu	$t3, $a1, $t2
	bnez	$t3, draw_time_digits
	
draw_time_loop:
	# Obtenemos el i-esimo digito y lo imprimos.
	divu	$t2, $t2, 10
	move	$a1, $a2
	divu	$a1, $a1, $t2
	remu	$a1, $a1, 10
	# Imprimimos el numero
	before_call(2, -1, 2)
	add	$a0, $a0, $t0
	add	$a0, $a0, $t1
	jal	draw_number
	after_call(2, -1, 2)
	add	$t1, $t1, 20
	bne	$t2, 1, draw_time_loop
	
	add	$t1, $t1, 8
	add	$t0, $t0, -512
	
	# Dibujamos un reloj
	add	$a0, $a0, $t0
	add	$a0, $a0, $t1
	add	$a0, $a0, 260
	li	$t0, 0x000000ff	# Azul.
	li	$t1, 5
	
	# Los siguientes ciclos son simplemente para conseguir la ubicacion
	# de los pixeles donde se deba dibujar.
draw_time_clock:
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	add	$t1, $t1, -1
	bnez	$t1, draw_time_clock
	
	add	$a0, $a0, 232
	li	$t1, 5
draw_time_clock2:
	sw	$t0, ($a0)
	add	$a0, $a0, 24
	sw	$t0, ($a0)
	add	$a0, $a0, 232
	add	$t1, $t1, -1
	bnez	$t1, draw_time_clock2
	
	add	$a0, $a0, 4
	li	$t1, 5
draw_time_clock3:
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	add	$t1, $t1, -1
	bnez	$t1, draw_time_clock3
	
	add	$a0, $a0, -1292
	li	$t1, 3
draw_time_clock4:
	sw	$t0, ($a0)
	add	$a0, $a0, 256
	add	$t1, $t1, -1
	bnez	$t1, draw_time_clock4
	
	add	$a0, $a0, -252
	sw	$t0, ($a0)
	
draw_time_end:
	after_run (1, -1)
	jr	$ra
	
	
	
# Dibujamos un numero
draw_number:
# PARAMETROS:
#	a0: (X, Y) Direccion de la esquina superior izquierda del dibujo.
#	a1: Numero
	
	before_run(-1, -1)
	li	$t0, 0xffffffff	# Blanco
	
	# Verificamos que numero debemos dibujar.
	beqz	$a1, draw_number0
	beq	$a1, 1, draw_number1
	beq	$a1, 2, draw_number2
	beq	$a1, 3, draw_number3
	beq	$a1, 4, draw_number4
	beq	$a1, 5, draw_number5
	beq	$a1, 6, draw_number6
	beq	$a1, 7, draw_number7
	beq	$a1, 8, draw_number8
	beq	$a1, 9, draw_number9
	
# Todos los siguientes bloques de codigos se encargan de conseguir la
# ubicacion de los pixeles a dibujar dependiendo del numero indicado.
draw_number0:
	li	$t1, 3
	li	$t2, 1
	li	$t4, 3
draw_number0_loop:
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	add	$t1, $t1, -1
	bnez	$t1, draw_number0_loop
	add	$a0, $a0, 244
	li	$t1, 3
	beqz	$t2, draw_number_end
	add	$t2, $t2, -1
draw_number0_loop2:
	sw	$t0, ($a0)
	add	$a0, $a0, 8
	sw	$t0, ($a0)
	add	$t4, $t4, -1
	add	$a0, $a0, 248
	beqz	$t4, draw_number0_loop
	b	draw_number0_loop2
	
	
draw_number1:
	li	$t1, 5
	add	$a0, $a0, 8
draw_number1_loop:
	beqz	$t1, draw_number_end
	sw	$t0, ($a0)
	add	$a0, $a0, 256
	add	$t1, $t1, -1
	b 	draw_number1_loop
	
	
draw_number2:
	li	$t1, 3
draw_number2_loop:
	li	$t2, 3
draw_number2_loop2:
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	add	$t2, $t2, -1
	bnez	$t2, draw_number2_loop2
	add	$a0, $a0, 500
	add	$t1, $t1, -1
	bnez 	$t1, draw_number2_loop
	add	$a0, $a0, -768
	sw	$t0, ($a0)
	add	$a0, $a0, -504
	sw	$t0, ($a0)
	b 	draw_number_end
	

draw_number3:
	li	$t1, 3
draw_number3_loop:
	li	$t2, 3
draw_number3_loop2:
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	add	$t2, $t2, -1
	bnez	$t2, draw_number3_loop2
	add	$a0, $a0, 500
	add	$t1, $t1, -1
	bnez 	$t1, draw_number3_loop
	add	$a0, $a0, -760
	sw	$t0, ($a0)
	add	$a0, $a0, -512
	sw	$t0, ($a0)
	b 	draw_number_end
	
draw_number4:
	li	$t1, 2
	li	$t2, 2
	li	$t3, 3
draw_number4_loop:
	beqz	$t1, draw_number4_loop2
	sw	$t0, ($a0)
	add	$a0, $a0, 8
	sw	$t0, ($a0)
	add	$a0, $a0, 248
	add	$t1, $t1, -1
	b 	draw_number4_loop
draw_number4_loop2:
	beqz	$t2, draw_number4_loop3
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	add	$t2, $t2, -1
	b 	draw_number4_loop2
draw_number4_loop3:
	beqz	$t3, draw_number_end
	sw	$t0, ($a0)
	add	$a0, $a0, 256
	add	$t3, $t3, -1
	b 	draw_number4_loop3
	

draw_number5:
	li	$t1, 3
draw_number5_loop:
	li	$t2, 3
draw_number5_loop2:
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	add	$t2, $t2, -1
	bnez	$t2, draw_number5_loop2
	add	$a0, $a0, 500
	add	$t1, $t1, -1
	bnez 	$t1, draw_number5_loop
	add	$a0, $a0, -760
	sw	$t0, ($a0)
	add	$a0, $a0, -520
	sw	$t0, ($a0)
	b 	draw_number_end
	
	
draw_number6:
	li	$t1, 2
	li	$t2, 3
draw_number6_loop:
	beqz	$t1, draw_number6_loop2
	sw	$t0, ($a0)
	add	$a0, $a0, 256
	add	$t1, $t1, -1
	b 	draw_number6_loop
draw_number6_loop2:
	beqz	$t2, draw_number6_end
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	add	$t2, $t2, -1
	b 	draw_number6_loop2
draw_number6_end:
	add	$a0, $a0, 244
	sw	$t0, ($a0)
	add	$a0, $a0, 8
	sw	$t0, ($a0)
	add	$a0, $a0, 248
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	sw	$t0, ($a0)
	b 	draw_number_end
	
	
draw_number7:
	sw	$t0, ($a0)
	add	$a0, $a0, 4
	sw	$t0, ($a0)
	add	$a0, $a0, -4
	b 	draw_number1
	
draw_number8:
	add	$a0, $a0, 516
	sw	$t0, ($a0)
	add	$a0, $a0, -516
	b	draw_number0
	
draw_number9:
	add	$a0, $a0, 4
	sw	$t0, ($a0)
	add	$a0, $a0, -4
	b	draw_number4
	
draw_number_end:
	after_run (-1, -1)
	jr	$ra




