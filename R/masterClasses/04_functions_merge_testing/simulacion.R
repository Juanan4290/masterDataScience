generarTablero <- function(n = 4, probA, probB) {
  
  sujetos <- c(rep(1, n**2*probA), rep(2, n**2*probB))
  sujetos <- c(sujetos, rep(0, n**2 - length(sujetos)))
  sujetos <- sample(sujetos)
  
  tablero <- matrix(sujetos, ncol = n, nrow = n)
  tablero
  
}

incomodos <- function(tablero, sensibilidad){
  
  resultado <- matrix(0, ncol = ncol(tablero), nrow = nrow(tablero))
  
  for (i in 1:nrow(tablero)){
    for (j in 1:ncol(tablero)){
      subMatrix <- tablero[(max((i-1),1)):(min((i+1),ncol(tablero))),
                           (max((j-1),1)):(min((j+1),nrow(tablero)))]
      tipo <- tablero[i,j]
      numVecinos <- sum(tipo == subMatrix) - 1
      if (numVecinos >= sensibilidad & tipo != 0) resultado[i,j] <- 1
    }
  }
  resultado
}

tab <- generarTablero(9,0.3,0.5)
incomodos(tab,2)
