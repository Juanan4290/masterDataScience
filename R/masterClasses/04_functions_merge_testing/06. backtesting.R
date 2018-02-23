# Vamos a resolver el ejercico de trading algorítmico que estaba en los 
# anteriores ejercicios. Repito el enunciado:

# 1. Cogiendo datos reales del stock de amazon y google (código abajo)
# haz una version CON BUCLES de un algoritmo que haga el siguiente proceso:
# Si de un dia para otro (dia A y dia A+1) sube la bolsa en
# Amazon y google. Compra aquel stock que haya subido más
# P.e: del día 1/1/208 ambos suben, Amazon sube +3 y Google +2
# Entonces compramos Amazon.
# Si empatan en subida, compra el que quieras (solo uno)
# Nota: Usa la columna "Open"

library(quantmod)

# Código para descargarse los datos de bolsa.
# amzn <- getSymbols('AMZN', from = "2014-01-01",auto.assign = F)
# googl <- getSymbols('GOOGL', from = "2014-01-01",auto.assign = F)
# bolsa <- cbind(amzn,googl)


# Vamos a escribirlo dentro de una función y vamos a hacer varias versiones
# para que aprendáis como mejorar poco a poco el algoritmo.

# Empezaremos a hacer el cálculo con bucles y después lo vectorizaremos.
# Cuando se empieza a aprender a programar normalmente se empieza haciendo
# todo con bucles e ifs porque es más intutivo pero tenéis que acostumbraros
# a escribir el código de forma vectorial (o matricial, como queráis verlo)
# No sólo irá más rápido sino que será más fácil de entender y cometeréis
# menos errores

## PRIMERA VERSION. puntosDeCompra, es una función que recibe
# dos vectores de precios (abstractos, no tienen porque ser)
# amazon y google. Y devuelve una máscara (vector de logical/booleanos)
# con las posiciones del vector en las que habría que comprar en cada
# caso.


puntosDeCompra <- function(precioA, precioB) {
  # Siempre que vayáis a crear un vector elemento a elemento
  # si sabéis cuanto ocupa, creadlo al principio con todo 
  # el tamaño que necesitéis.
  resultado <- logical(length(precioA))
  
  # Recorremos todo el vector, cuidado con el -1 cuando hagáis
  # este tipo de bucles, sin los paréntesis va mal.
  # 1:5 - 1   es:    0,1,2,3,4 (resta 1 a todos los elementos)
  # 1:(5 - 1) es:    1,2,3,4 (resta 1 al límite superior)
  for (i in 1:(length(precioA)-1)) {
    # Calculamos los incrementos de cada precio
    deltaA <- precioA[[i+1]] - precioA[[i]]
    deltaB <- precioB[[i+1]] - precioB[[i]]
    
    # Si los dos crecen, guardamos un TRUE en esa posición
    if (deltaA > 0 && deltaB > 0) {
      resultado[i+1] <- T
    }
  }
  # Devolvemos el vector de resultado, si no no devolvería nada.
  # Error típico.
  resultado
}

## SEGUNDA VERSION. ahora vamos a mejorar
# ligeramente la versión anterior haciendo que devuelva un vector
# de enteros con el siguiente significado:
# si hay un 0, significa que no se compra
# si hay un 1 se compra del stock A
# si hay un 2 se compra del stock B

# Podríamos haber dividido el proceso en dos fases:
# primero calcular en qué momento se compra y luego calcular
# de que stock hay que comprar. No lo hacemos así porque como ahora
# verás, el 90% del código es similar (hay que recorrer el vector,
# calcular las deltas, etc). Así que merece la pena juntarlo todo
# y que los vectores sólo se recorran una vez.

puntosDeCompra <- function(precioA, precioB) {
  resultado <- integer(length(precioA))
  for (i in 1:(length(precioA)-1)) {
    deltaA <- precioA[[i+1]] - precioA[[i]]
    deltaB <- precioB[[i+1]] - precioB[[i]]

    # Anidamos (un if dentro de otro if).
    # En el caso de que haya incremento doble, 
    # se calcula cual de los dos se debe comprar
    if (deltaA > 0 && deltaB > 0) {
      if (deltaA > deltaB)
        resultado[i+1] <- 1
      else
        resultado[i+1] <- 2
    }
  }
  resultado
}

## TERCERA VERSION. ahora vamos a mejorar usando ifelse y reducir
# el numero de ifs. Tambien os dejo comentada otra versión
# menos legible pero más compacta (yo elegiría la de ifelse)
puntosDeCompra <- function(precioA, precioB) {
  resultado <- integer(length(precioA))
  for (i in 1:(length(precioA)-1)) {
    deltaA <- precioA[[i+1]] - precioA[[i]]
    deltaB <- precioB[[i+1]] - precioB[[i]]
    
    if (deltaA > 0 && deltaB > 0) {
      resultado[i+1] <- ifelse(deltaA > deltaB, 1, 2)
      # Esto funciona porque (deltaA < deltaB) es booleano.
      # Si lo fuerzas a convertir a entero (sumandole uno)
      # se conviernte TRUE -> 1; FALSE -> 2;
      
      # Si es cierto, es: TRUE + 1 = 2. Es decir, si el incremento
      # en A es MENOR, entonces hay que comprar del segundo.
      
      # Si es falso: FALSE + 1 = 1. Es decir si el incremento es mayor
      # o igual en A compra del primero
      # resultado[i+1] <- (deltaA < deltaB) + 1
    }
  }
  resultado
}

# Ahora la función que hace el backtesting. Recibe los precios
# y el vector de compras que acabamos de crear antes.
backtesting <- function (precioA, precioB, puntosDeCompra) {
  comprasA <- c() # vectores donde guardo las compras
  comprasB <- c()
  for(i in 1:length(precioA)) {
    if (puntosDeCompra[i] == 1)
      comprasA <- c(comprasA, precioA[[i]])
    else if (puntosDeCompra[i] == 2)
      comprasB <- c(comprasB, precioB[[i]])
  }
  
  # cojo los últimos elementos de los vectores de precios
  # que es el precio de mercado actual (a día de hoy)
  precioFinalA <- precioA[[length(precioA)]]
  precioFinalB <- precioB[[length(precioB)]]
  
  # Beneficio en A es la diferencia del precio actual
  # menos el precio ponderado promedio de todas mis compras
  # multiplicado por el numero de stocks que tengo en A
  (precioFinalA - mean(comprasA)) * length(comprasA) +
    (precioFinalB - mean(comprasB)) * length(comprasB)
  
  # Este último comentario es el único que yo en un código
  # real hubiese puesto, porque el cálculo que hago no es
  # autoevidente y para alguien no familiarizado esa
  # pequeña explicación puede ahorrarle muchos quebraderos
  # de cabeza
}



## VERSION DOS DE BACKTESTING. Vamos a comenzar a vectorizarla
backtesting <- function (precioA, precioB, puntosDeCompra) {
  comprasA <- c()
  comprasB <- c()
  
  # nos quitamos TODO el bucle for en estas dos líneas
  comprasA <- precioA[puntosDeCompra == 1]
  comprasB <- precioB[puntosDeCompra == 2]
  
  # puntosDeCompra == 1 es una máscara que pone en TRUE
  # aquellos elementos que son 1, es decir aquellos 
  # en los que deberíamos comprar del stock 1.
  
  # usando esa máscara podemos elegir del vecto precioA
  # el precio en esos días para ver a que precio hemos comprado
  # el stock.
  
  precioFinalA <- precioA[[length(precioA)]]
  precioFinalB <- precioB[[length(precioB)]]
  
  (precioFinalA - mean(comprasA)) * length(comprasA) +
    (precioFinalB - mean(comprasB)) * length(comprasB)
}



## VERSION VECTORIZADA DE PUNTOS DE COMPRA
puntosDeCompra <- function(precioA, precioB) {
  resultado <- integer(length(precioA))
  # diff es el equivalente al cálculo de delta que estabamos haciendo
  deltaA <- diff(as.numeric(precioA))
  deltaB <- diff(as.numeric(precioB))
  
  # mascaras que determinan cuando suben ambos (subidaDoble)
  subidaDoble <- deltaA > 0 & deltaB > 0
  # y cuando A crece mas (compraA)
  compraA <- deltaA > deltaB
  
  
  # Hacemos un vector de uno menos de longitud porque al calcular
  # el delta con diff, se desplaza 1 posición el vector
  # Es decir, entre n número hay n-1 diferencias posibles.
  resultado <- integer(length(precioA)-1)
  
  
  # Guardamos en resultado, cuando hay subida doble y sube más A
  resultado[subidaDoble & compraA] <- 1
  # Para 2 lo mismo pero negando el mayor de A
  resultado[subidaDoble & !compraA] <- 2
  
  # Añadimos un 0 delante porque como hemos mencionado antes
  # todo se ha desplazado un día.
  c(0, resultado)
}

## MEJORA DE LA VERSION VECTORIZADA DE puntosDeCompra
puntosDeCompra <- function(precioA, precioB) {
  resultado <- integer(length(precioA))
  deltaA <- diff(as.numeric(precioA))
  deltaB <- diff(as.numeric(precioB))
  
  # Hago todo el cálculo de 1 y 2 en una misma sentencia.
  # Aprovecho que se pudede multiplicar un vector boolano
  # para aplicarlo como máscara.
  
  # La primera parte (deltaA > 0 & deltaB > 0) es el anterior
  # subidaDoble. Que aplica como máscara, es decir cuando sea FALSE
  # valdrá 0 (porque no hay que comprar) y cuando valga TRUE valdrá
  # el valor de la segunda parte.
  
  # (deltaB < deltaA) + 1 es la segunda parte que como hemos hecho antes
  # vale 1 o 2 según el stock que haya que comprar
  r <- (deltaA > 0 & deltaB > 0) *
    ((deltaB > deltaA) + 1)
  
  c(0, r)
}



# Por último enseñaros como se comprueba si el usuario ha introducido
# los datos correctamente, normalmente se hace con un if y un stop
# Aunque las condiciones pueden ser tan complejas como quieras
# y no hace falta que estén al principio. Normalmente están al principio 
# porque así se comprueban antes de hacer cualquier otra cosa y gastar CPU

puntosDeCompra <- function(precioA, precioB) {
  if (!is.numeric(precioA)) stop("A no es numerico")
  
  resultado <- integer(length(precioA))
  deltaA <- diff(as.numeric(precioA))
  deltaB <- diff(as.numeric(precioB))
  
  r <- (deltaA > 0 & deltaB > 0) *
    ((deltaB > deltaA) + 1)
  
  c(0, r)
}





