require(ggplot2)
require(data.table)
set.seed(4321) #fija la semilla para que el ejemplo sea reproducible.
n=1000 #tamaño de la muestra
DT=data.table(distancias=rnorm(n,500,100))
DT[,retrasos:= 1 + distancias/100 + rnorm(n,0,1)]
DT=round(DT,2) 
