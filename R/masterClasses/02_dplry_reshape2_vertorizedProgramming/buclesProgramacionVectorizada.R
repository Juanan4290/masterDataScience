if (5 > 3){
  print("hola")
} else if (2<1){
  print("Adios")
} else {
  print("Cierre")
}

for (x in 1:10){
  print(x)
}

contador <- 5
while (contador > 0){
  print(contador)
  contador = contador -1
}


### Forma vectorial/vectorizada vs bucles
appl <- rnorm(100)
googl <- rnorm(100)
              

# Si compras una accion de google cada dia que este supera a apple.
# en que coste total incurres

coste <- 0

for (i in 1:100){
  if (appl[i] < googl[i])
    coste <- coste + googl[i]
}

coste

# Programacion vectorizada
sum(googl[googl > appl])


# Funciones
miFuncion <- function(a, b){
  return(a + b)
}

miFuncion <- function(a, b){
  #..... cosas
  a + b # es como un return
}

miFuncion <- function(a, b = 5){
  #..... cosas
  a + b # es como un return
}

miFuncion(1)

# Intentar NUNCA hacer esto
miFuncionImpura <- function(df){
  df$a = 3
  df
}






