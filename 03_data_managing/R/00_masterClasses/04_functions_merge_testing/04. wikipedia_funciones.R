library(stringr)
library(dplyr)

# Vamos a dividir el ejemplo anterior en funciones.
# Estructurar el código en funciones es MUY importante para que tus 
# programas funciones bien, los entiendan otras personas y especialmente
# tu mismo en el futuro.

# Si dividimos conceptualmente el proceso de la wikipedia. La primera
# parte es descargar la web.
descargarWeb <- function(url) {
  readLines(url)
}

# Esta función es muy poco útil como puedes ver porque es literalmente
# un sinónimo de readLines.

# Esto es una señal de que he pensado mal cómo dividir el código
# y debemos darle otro enfoque. Así que voy a incluir la parte
# del programa que junta todas las líneas de la página web.

descargarWeb <- function(url) {
  lines <- readLines(url)
  paste(lines, collapse = "")
}

# Ahora sí tiene mucho sentido por varias razones:
# - El readLines y el paste van juntos, o al menos, irán la mayoría
#   de veces juntos, por eso tiene sentido agruparlos en una misma
#   función
# - Ahora el usuario de esta función se puede olvidar de que tiene
#   que juntar las líneas, lo que facilita su tarea y reduce la
#   sobrecarga cognitiva al programar.
# - Es una función que muy probablemente vayas a reutilizar en el futuro
#   o incluso en otro programa.

# El siguiente paso sería extraer el código del ol
extraerOl <- function(html) 
  str_extract(html, "<ol>.*?<\\/ol>")

# Esta función es corta y tiene como ventaja que el usuario no tiene
# que conocer la expresión regular adecuada para detectar un ol.

# Por otra parte es poco flexible, puesto que si quiero buscar otra
# etiqueta HTML no me sirve para nada esta función y tendría que 
# escribir otra prácticamente igual.
# Así que vamos a hacer una ligera modificación para que el usuario
# de esta función pueda cambiar de patrón si quiere en el futuro

extraerOl <- function(html, pattern =  "<ol>.*?<\\/ol>") 
  str_extract(html, pattern)

# Hemos usado el valor por defecto de pattern de forma inteligente
# para que el usuario no tenga porque conocerlo. Si quiere cambiarlo
# puede, pero si no lo conoce no tiene porque hacerlo.

# Este cambio, de poner como parámetro algo que antes estaba fijo
# se puede denominar parametrizar o exponer el parámetro.
# Las funciones (y cualquier otra técnica para encapsular) esconde
# ciertos detalles y expone otros al exterior. 
# La razón para hacer esto es que así puedes crear cada vez
# software más complejo encima de otras piezas hechas anteriormente.

# Siguiente paso, extraer los nombres. Ya hemos visto como se hace
# anteriormente, lo único que hacemos es meterlo dentro de una función
extraerNombres <- function(html) {
  reName <- "<li><a .*?>(.*?)<\\/a>.*?<\\/li>"
  str_match_all(html, reName)[[1]][,2]
}


# Ahora una función que hace todo el proceso.
# Aprovechamos y lo escribimos con el operador tubería porque de nuevo
# si os fijáis lo que estamos haciendo es paso a paso, enviando el resultado
# a la siguiente función. Así que nuestra función total con todo el proceso
# no es más que la composión (o concatenación) de las funciones que hemos
# escrito antes.
scrapping <- function(url) {
  descargarWeb(url) %>%
    extraerOl %>%
    extraerNombres
}

# Ha quedado bonito, elegante y entendible. Que es como hay que escribir
# el código.

# Al proceso de cambiar o reestructurar el código fuente como hemos hecho
# con el ejercicio de la wikipedia se le denomina refactorizar.