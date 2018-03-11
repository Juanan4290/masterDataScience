# Funciones para implementar la simulación de Parable of Polygons
# http://ncase.me/polygons-es/

generarTablero <- function(n=4, probA, probB) {
  sujetos <- c(rep(1, n**2*probA), rep(2, n**2*probB))
  # Añadimos los ceros que falten hasta completar el tablero entero
  sujetos <- c(sujetos, rep(0, n**2 - length(sujetos)))
  # Desordenamos las posiciones
  sujetos <- sample(sujetos)
  
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

# TRUE=incómodo; FALSE=cómodo
descontento <- function(tablero, sensibilidad = 2) {
  rows <- nrow(tablero)
  cols <- ncol(tablero)
  tableroIncomodidad <- matrix(F, nrow=rows, ncol=cols)
  for (i in 1:cols) {
    for (j in 1:rows) {
      tipo <- tablero[i,j]
      # Para no salirme de los bordes uso min y max
      # Nunca puede ser menos que un 1 ni mayor que el numero de filas
      # o columnas
      vecinos <- tablero[max((i-1), 1):min((i+1), rows),
                         max((j-1), 1):min((j+1), cols)]
      
      # vecinosContrarios cuenta el número de vecinos que son de 
      # otro color.
      vecinosContrarios <- -99
      
      if (tipo==1)
        vecinosContrarios <- sum(vecinos == 2)
      else if (tipo==2)
        vecinosContrarios <- sum(vecinos == 1)
      
      if (vecinosContrarios >= sensibilidad)
        tableroIncomodidad[i,j] = TRUE
      
    }
  }
  tableroIncomodidad
}

# Esta función mueve los sujetos incómodos a un sitio libre
# si no hay suficientes sitios libres mueve tantos como sean posible.

# Devuelve el tablero en el siguiente instante del tiempo (es decir,
# una vez se han movido una posicion las personas incómodas)
desplazamiento <- function(tablero, descontentoTablero) {
  # Número de huecos disponibles y de sujetos incómodos
  numHuecos <- sum(tablero==0)
  numIncomodos <- sum(descontentoTablero)
  
  # which te dice en que posiciones hay TRUEs en un vector
  # which(descontentoTablero) entonces son las posiciones
  # en las que hay una persona descontenta.
  
  # min(numHuecos, numIncomodos) es para saber cuantas
  # personas se mueven. Siempre es el mínimo entre
  # el número de huecos disponibles y el número de personas
  # que quieren moverse. Si se quieren mover 5 pero hay solo 2
  # huecos, sólo se moverán 2. De forma contraria, si hay 4 
  # persoans incómodas y 10 huecos se moverán 4.
  
  # Por último sample es para coger aleatoriamente de las posiciones el
  # numero de personas que toquen
  aMover <- sample(which(descontentoTablero),
                   min(numHuecos,numIncomodos))
  
  # Buscamos la posicion de huecos libres
  aDonde <- which(tablero==0)
  
  nuevoTablero <- matrix(tablero, nrow = nrow(tablero))
  # Por cada persona que se tiene que mover...
  for (i in seq_along(aMover)) {
    
    nuevoTablero[aDonde[i]] <- # Ponemos en la nueva posición...
      nuevoTablero[aMover[i]] # lo que había en la antigua posición.
    
    nuevoTablero[aMover[i]] <- 0 # La antigua posición queda vacía
  }
  nuevoTablero # devolvemos el nuevo tablero.
}

# Funcion que ejecuta toda la simulación.
# Devuelve una lista con dos matrices TRIDIMENSIONALES (x, y y tiempo)
# la lista tiene dos elementos: "tablero", que recoje todos
# los tableros a lo largo del tiempo, "descontento" que hace lo mismo
# con la matriz de descontento y "nPasos" que dice cuantos pasos
# se han realizado en la simulación hasta parar.

# 
simulacion <- function(n=13, probA=0.45, probB=0.45,
                       sensibilidad=2,
                       maxIter=500) {
  # Creo las matrices multidimensionales donde voy a guardar 
  # los resultados. Y las inicializo con ceros y FALSES.
  # Se crea con array(), le pasas los valores y el tamaño
  # de cada dimensión
  histTablero <- array(0, c(n, n, maxIter))
  histDescontento <- array(FALSE, c(n, n, maxIter))
  
  # Genero el primer tablero en el instante 1 del tiempo
  histTablero[,,1] <- generarTablero(n=n, probA=probA, probB=probB)
  histDescontento[,,1] <- descontento(histTablero[,,1],
                                  sensibilidad=sensibilidad)
  
  # BUCLE PRINCIPAL DE LA SIMULACION
  for (i in (1+1):maxIter) {
    # Guardo en el tablero i el siguiente paso basado en el tablero
    # justo anterior y en el descontento anterio
    histTablero[,,i] <-
      desplazamiento(tablero=histTablero[,,i-1],
                     descontentoTablero = histDescontento[,,i-1])
    
    # Calculo el descontento del paso i-ésimo
    histDescontento[,,i] <- descontento(tablero = histTablero[,,i],
                  sensibilidad = sensibilidad)
    
    # Si no hay nadie descontento...
    if (sum(histDescontento[,,i]) == 0)
      break() # acabamos el bucle for porque ha acabado la simulación
    
  }

  list(tablero=histTablero,
       descontento=histDescontento,
       nPasos=i)
}

