# Función para graficar (visualizar un tablero)

pintarTablero <- function(tablero, descontento) {
  # Quito margen en blanco
  par(mar = rep(0,4))
  
  # Pinto la matriz de colores
  image(tablero, col = c("white","#2a8fa3", "#ff8d00"),
        axes = FALSE, xlab=NA, xaxs="i", yaxs="i")
  
  
  posicionesDescontento <- which(descontento, arr.ind = T)
  
  # Pintamos las X sobre las casillas descontentas
  points((posicionesDescontento[,"row"]-1)/(nrow(descontento)-1),
         (posicionesDescontento[,"col"]-1)/(ncol(descontento)-1), pch=4)
}
