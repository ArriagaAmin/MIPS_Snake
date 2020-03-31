# MIPS_Snake
Segundo proyecto de CI-3815 "Organizacion del Computador"

_Implementacion del famoso juego **Snake**. Se define una ventana o tablero de cierta dimensión, digamos NxM, que estará enmarcada por paredes que determinan el fin del tablero. El juego empieza con una culebra de tamaño fijo posicionada en algún punto de tablero. Por cada unidad de tiempo la culebra avanza siempre en la dirección que apunta su cabeza. Se le puede hacer cambiar su dirección haciéndola girar a su derecha o izquierda (no se puede retroceder). En el tablero van apareciendo manzanas, una a la vez. Éstas son el objetivo de la culebra, es decir, el jugador debe hacer que la culebra se “coma” las manzanas. Al comer una manzana, la culebra crece en una unidad de longitud. Cuando la cabeza de la culebra choca con una pared o con algún segmento de sí misma, el juego acaba. Cuando se acumula un número determinado de manzanas comidas, se pasa al siguiente nivel en el cual se aumenta la velocidad de movimiento de la culebra._

## Comenzando
### Pre-requisitos
* ```Java ```

### Descargando el repositorio
Debera clonar este repositorio ejecutando 

```$ git clone https://github.com/ArriagaAmin/MIPS_Snake ```

### Juego
Primero debera ejecutar el simulador de MIPS, MARS. Para ello use el comando

```$ java -jar MarsTimer.jar ```

Una vez dentro del simulador, en la zona superior habra una barra que dice "*Run speed 20 inst/sec*" el cual indica la cantidad de instrucciones que MARS hara por segundo, deslize el indicador al maximo, hasta que diga "*Run speed at max (no interaction)*".

Luego, debera abrir algun programa con una etiqueta **main** que dure lo suficiente como para poder jugar. El repositorio trae un archivo de prueba **Play.s** el cual solo contiene un bucle infinito. Para abrir este archivo en MARS debe darle click a: *File* -> *Open* -> **Play.s** -> *Open*. 

Ahora, hay que asignar al manejador de excepciones que controla al juego. Para ello debe darle a: *Settings* -> *Exception handler* -> *Browse* -> **exception.s** -> *Open* -> *OK*.

Despues, necesitamos el simulador del teclado y del monitor. Para el teclado debe darle a: *Tools* -> *Keyboard and Display MMIO Simulator* -> *Connect to MIPS*. En la ventana que aparecera habran dos cuadros blancos, el de abajo sera el que usaremos como teclado. Para el monitor debe darle a: *Tools* -> *Bitmap Display* -> *Connect to MIPS*. Debe asegurarse que los siguientes parametros tienen los valores:

* *Unit Width in Pixels*: 8
* *Unit Height in Pixels:* 8
* *Base address for display*: 0x10000000 (global data)

Acomode la posicion y el tamaño del teclado y el monitor para que pueda visualizar a ambos con facilidad (recuerde que del teclado solo importa el cuadro blanco inferior, y del monitor solo importa la pantalla negra).

Para finalizar, debe compilar el programa **Play.s**, para ello, situe el mouse en el codigo del programa, de click, y luego presione *F3*. Finalmente, en la zona superior-central del simulador MARS aparecera un boton con una flecha para ejecutar el programa, su descripcion al colocar el mouse sobre ese boton es *Run the current program*. Cuando este listo para jugar, dele click a ese boton! 

## Instrucciones

* Se define un tablero del tamaño de la consola mapeada a memoria implementada. Cada pared es de un pixel de espesor.
* Siempre habrá una y sólo una manzana sobre el tablero a la vez. Cuando la culebra se coma una manzana, se generara otra en algún punto del tablero que no coincida con el cuerpo de la culebra, este nuevo punto debe ser pseudoaleatorio.
* La culebra empieza con un tamaño de 5 (es decir, que ocupa 5 pixeles). Cada vez que ésta se coma una manzana, debe aumentar su tamaño en 1 unidad.
* La culebra sólo puede girar a su derecha o a su izquierda. Comandos que impliquen que siga de frente o que retroceda seran ignorados.
* Si la culebra choca con una pared o consigo misma, termina el juego.
* En cualquier momento puede presionarse la tecla 'p' para pausar el juego, o continuarlo si ya está pausado.
* En cualquier momento puede presionarse la tecla 'q' para terminar el juego.
* Cuando se acabe el juego, ya sea por que se pierde o se abandone, imprimira la
cantidad de manzanas que logró comer la culebra y en cuanto tiempo en segundos.
La culebra tiene una velocidad que aumenta en cada nivel y solo puede moverse horizontal o verticalmente, nunca en diagonal.
* Comandos:
    * 'w': Equivalente a la flecha 'arriba', cambia (si puede) la dirección de la culebra para que avance hacia arriba.
    * 'a': Equivalente a la flecha 'izquierda', cambia (si puede) la dirección de la culebra para que avance hacia la izquierda.
    * 's': Equivalente a la flecha 'abajo', cambia (si puede) la dirección de la culebra para que avance hacia abajo.
    * 'd': Equivalente a la flecha 'derecha', cambia (si puede) la dirección de la culebra para que avance hacia la derecha.
    * 'p': Pausa el juego o lo continua si ya está pausado.
    * 'q': Abandona el juego.
* Para pasar nivel i al nivel i +1, se debe haber comido un número K de manzanas en el nivel i.
* La dificultad de un nivel vendrán dada por la
incorporación de:
    * Obstáculos, específicamente paredes internas.
    * Portales, son de color azul y permiten mover a la serpiente de la pared izquierda a la derecha y viceversa, o de la pared superior a la inferior y viceversa.
    * Aumento en la velocidad de la serpiente.

## Wiki
El enunciado especifico del proyecto se encuentra [aquí](https://github.com/ArriagaAmin/MIPS_Snake/blob/master/Proy2.pdf).

### Archivos
* **Draw.s**: Contiene las instrucciones necesarias para dibujar la pantalla de game over, es decir, dibujar numeros, una manzana y un reloj.
* **MarsTimer.jar**: Simulador e MIPS.
* **Play.s**: Programa con un main en un bucle infinito.
* **Proy2.pdf**: Enunciado del proyecto.
* **Queue.s**: Implementacion de una cola. Esta se usara para almacenar las posiciones ocupadas por la serpiente.
* **Snake.s**: Contiene las instrucciones necesarias para jugar, las cuales son:
    * *clear*: Limpiar la pantalla.
    * *walls*: Dibuja las paredes/portales del nivel indicado.
    * *snake*: Dibuja el estado inicial de la serpiente y crea la cola (queue) que la representa.
    * *snake_move*: Permite mover a la serpiente un pixel y tomar acciones dependiendo del color del pixel al que se dirige la serpiente.
    * *gameover*: Finaliza el juego, imprimiendo el numero de manzanas comidas y el tiempo en segundos.
    * *random_apple*: Genera una manzana aleatoria dentro del mapa.
    * *end*: Finaliza abruptamente la ejecucion del programa.
* **exception.s**: Contiene las interrupciones que permiten ejecutar las instrucciones del juego.
* **macros.s**: Contiene las macros que se usan en todos los archivos de MIPS.

### Autores
* *Amin Arriaga*.
* *Angel Garces*.
* *Eduardo Blanco*.


