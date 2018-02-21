library(quantmod)

# amzn <- getSymbols('AMZN', from = "2014-01-01",auto.assign = F)
# googl <- getSymbols('GOOGL', from = "2014-01-01",auto.assign = F)
# bolsa <- cbind(amzn,googl)

puntosDeCompra <- function(precioA, precioB) {
  
  resultado <- integer(length(precioA))
  for (i in 1:(length(precioA)-1)) {
    deltaA <- precioA[[i+1]] - precioA[[i]]
    deltaB <- precioB[[i+1]] - precioB[[i]]
    
    if (deltaA >0 & deltaB > 0) 
      resultado[i+1] <- ifelse(deltaA > deltaB, 1, 2) # (deltaA < deltaB) + 1 --> forma hacker
  }
  resultado
}


puntosDeCompraVect <- function(precioA, precioB) {
  if (!is.numeric(precioA)) stop("A no es numerico")
  
  precioA_diff <- diff(precioA)
  precioB_diff <- diff(precioB)
  
  compras <- integer(length(precioA))
  
  compras[((precioA_diff > 0) & (precioB_diff > 0))] <- 1
  compras[(compras == 1) & (precioB_diff > precioA_diff)] <- 2
  compras
  
}

puntosDeCompraVect(bolsa$AMZN.Open, bolsa$GOOGL.Open)

backtesting <- function(precioA, precioB, stock) {
  
  precioFinalA <- precioA[length(precioA)]
  precioFinalB <- precioB[length(precioB)]
  
  rentabilidad <- 0
  
  for (i in 1:length(precioA)){
    if (stock[i] == 1) rentabilidad <- rentabilidad + as.numeric(precioFinalA - precioA[[i]])
    if (stock[i] == 2) rentabilidad <- rentabilidad + as.numeric(precioFinalB - precioB[[i]])
  }
  
  rentabilidad
}

precioA <- bolsa$AMZN.Open
precioB <- bolsa$GOOGL.Open
stock <- puntosDeCompra(precioA, precioB)

backtesting(precioA, precioB, stock)

