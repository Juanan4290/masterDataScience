# Como ejercicio final, más completo y difícil vamos a intentar reproducir
# una simulación clásica de comportamiento humano que intenta explicar
# una posible causa de la segregación geográfica (barrios étnicos o guetos)

# Podéis ver un ejemplo muy visual de la simulación en esta web:
# http://ncase.me/polygons-es/

# Primero generamos un tablero de n x n con probA y probB de cada color.
# Notad que las probabilidades no deben sumar uno, para dejar huecos
# en tablero.
generarTablero <- function(n=4, probA, probB) {
  # n**2 es el numero de casillas.
  # rep repite un numero tantas veces como le digas
  # vamos a crear un vector se sujetos con los números correspondientes
  # 0: hueco, 1: color1, 2: color2
  
  # Primero creamos un vector con tantos coloreados como corresponda
  # n**2*prob es el numero de casillas que deben estar de cada color
  sujetos <- c(rep(1, n**2*probA), rep(2, n**2*probB))
  # Añadimos los ceros que falten hasta completar el tablero entero
  sujetos <- c(sujetos, rep(0, n**2 - length(sujetos)))
  # Desordenamos las posiciones
  sujetos <- sample(sujetos)
  
  # Devuelvo el tablero en forma matricial pasando el vector que acabamos
  # de generar en formato de matriz de n x n
  tablero <- matrix(sujetos, ncol = n, nrow = n)
  tablero
}

# Calculamos la matriz de descontento a partir del talero original.
# Esta matriz se define como una matriz booleana con T en las posiciones
# que algún sujeto está descontento.
# El parametro de sensibilidad que se interpreta como el número 
# a partir del cual un sujeto se siente descontento con
# su posicion en el tablero (incluido este número).

# Vamos a devolver un máscara para decir cuáles están incómodos en 
# una matriz del mimso tamaño que el tablero porque luego nos resultará
# útil para hacer los siguientes calculos
descontento <- function(tablero, sensibilidad = 2) {
  # Como voy a necesitar en muchas ocasiones el numero de filas y columnas
  # lo guardo en dos variables para que sea más fácil escribirlo después
  rows <- nrow(tablero)
  cols <- ncol(tablero)
  # Creo un tablero lleno de FALSE de las dimeniones adecuadas
  tableroIncomodidad <- matrix(F, nrow=rows, ncol=cols)
  for (i in 1:cols) {
    for (j in 1:rows) {
      # Recorremos toda la matriz elemento a elemento
      # Tipo es el valor de esa casilla en concreto (1,2 o 0)
      tipo <- tablero[i,j]
      # Tomo la submatriz que representan los 8-vecinos de
      # esa casilla.
      # Fijaos en como pongo los paréntesis para que no nos
      # ocurra el problema de orden de calculo 1:5-1 != (1:5)-1
      
      # Además para no salirme de los bordes uso min y max
      # Nunca puede ser menos que un 1 ni mayor que el numero de filas
      # o columnas
      vecinos <- tablero[max((i-1), 1):min((i+1), rows),
                         max((j-1), 1):min((j+1), cols)]
      
      # vecinosContrarios cuenta el número de vecinos que son de 
      # otro color. Guardo un -1, ahora veréis para qué
      vecinosContrarios <- -1
      
      # Si el tipo de la casilla que estamos analizando es 
      # 1 contamos los doses y viceversa.
      # Nota: sum cuenta el número de TRUEs porque T=1 y F=0
      if (tipo==1)
        vecinosContrarios <- sum(vecinos == 2)
      else if (tipo==2)
        vecinosContrarios <- sum(vecinos == 1)
      
      # Si el número de vecinos contrarios es mayor o igual
      # a la sensibilidad, entonces guarda un T en esta posición
      # Ahora es cuando cobra sentido el -1 de antes.
      # En el caso de que tipo == 0 (casilla vacía)
      # como no se ejecutan ninguno de los dos ifs anterioes
      # vecinos contrarios vale -1. Que por definición NUNCA
      # será mayor o igual a ninguna sensibilidad posible.
      # Así que siempre será un FALSE, como corresponde
      if (vecinosContrarios >= sensibilidad)
        tableroIncomodidad[i,j] = TRUE
      
      # Si lo del -1 os parece complicado, no pasa nada
      # Se podría escribir de otra manera con un poco más de
      # ifs.
      
    }
  }
  tableroIncomodidad
}


