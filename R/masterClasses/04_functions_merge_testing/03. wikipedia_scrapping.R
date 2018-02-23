# Ejercicio de manipulación de cadenas con stringr
# Caso aplicado con scrapping

url <- "https://es.wikipedia.org/wiki/Los_100,_un_ranking_de_las_personas_m%C3%A1s_influyentes_en_la_historia"

# readLines sirve para leer una url si se la mandas como parámetro
htmlLines <- readLines(url)

# si usas str sobre htmlLines verás que es un vector de aproximadamente
# 400 elementos. Porque cada uno es una línea
str(htmlLines)

# Nosotros lo queremos todo de seguido en un vector de un elemento. Para
# ello vamos a usar paste/paste0

# Paste es la función básica (super utilizada) para concatenar cadenas
# Si quieres juntar elementos de un mismo vector se le llama colapsar.
# Para hacerlo hay que enviar a paste el parámetro collapse con el
# separador que quieres usar.

# Metaforicamente hablando el vector se colapsa sobre sí mismo y se
# convierte en una única cadena. Por ejemplo:
paste(c("alejandro", "maria"), collapse = ", ")
# Resultado: [1] "alejandro, maria"

# Por otra parte si quieres conbinar dos o más vectores cada elemento
# con su correspondiente, se usa el parámetro sep
paste(c("alejandro", "maria"), c(1,2), sep=" tiene una nota de: ")
# Resultado: [1] "alejandro tiene una nota de: 1" "maria tiene una nota de: 2"  

# paste0 es una abreviatura equivalente a paste(sep="").
# sirve para pegar cadenas cuando quieres escribir frases compuestas
# de varias partes o variables.
nombre <- "Alex"
nota <- 5
paste0("Hola ", nombre, " tu nota es: ", nota)


## 1er ejercicio. Juntar todas las lineas (htmlLines en una)
htmlCode <- paste(htmlLines, collapse = "")

# Vamos a usar dos herramientas MUY útiles cuando manejamos texto.
# Por un lado, stringr que es una librería hermana de dplyr
# para el procesamiento de cadenas de texto.
# Por otro lado expresiones regulares, que es una manera de procesar
# cadenas de texto mediante la descripción de patrones de texto
# de forma abstracta. No es exclusivo de R y es una forma de trabajar
# muy común con cadenas de texto.

library("stringr")

# Para las expresiones regulares vamos a usar https://regex101.com/
# En esa web puedes ir probando las expresiones regulares y ver si funcionan

# Nota importante: en R tienes que escapar doblemente las barras
# invertidas de las expresiones regulares. Por ejemplo:
reTitle <- "<title>(.*)<\\/title>"
# la barra inversa para escapar la barra normal de </title>
# en una expresión regular normal sólo es: <\/title>
# en R se convierte en <\\/title>

# Otra nota importante:
# Si quieres recoger algo que forma parte de la expresión regular
# usa lo que se llaman grupos. Hay que envolver lo que quieres recoger
# entre paréntesis.
reTitle <- "<title>(.*)<\\/title>"
# Aquí en reTitle, recogemos el contenido entre las etiquetas, por eso
# está entre paréntesis.

# Hacemos otra expresión regular para extraer las etiquetas ol.
reOl <- "<ol>.*?<\\/ol>"

# stringr tiene varias funciones para procesar cadenas con expresiones
# regulares

# str_detect te dice si hay o no hay un patrón dentro de una cadena
#            no dónde está o qué texto es en concreto
# str_count cuenta el número de patrones que se dan en la cadena
# str_locate te da la posición del patrón (inicio y fin)
# str_match extrae el patrón y sus grupos entre paréntesis.
#           este es el que vamos a usar nosotros porque nos hace falta
#           sacar grupos de las expresiones.
# str_replace sustituye un patrón por otro
# str_split divide una cadena por cada aparción del patrón


# Vamos a empezar con el título de la web. Buscamos en el código web
# el patrón de reTitle.
tituloEncontrado <- str_match(htmlCode, reTitle)

# str_match te devuelve un dataframe con tantas columnas como grupos haya.
# Tened en cuenta que el patrón entero se denomina (en todos los lenguajes)
# grupo 0. Por tanto, la primera columna siempre va a ser el patrón completo
# y las siguientes columnas serán los grupos sucesivos.

# Por ejemplo:
tituloEncontrado[1,1] # es el patrón entero
# Resultado: <title>Los 100, un ranking de las personas más
#            influyentes en la historia - Wikipedia, la enciclopedia
#            libre</title>

tituloEncontrado[1,2] # es el grupo 1 (R empieza a contar en 1 por eso, es
                      # la columna 2)

# Resultado: Los 100, un ranking de las personas más influyentes
#            en la historia - Wikipedia, la enciclopedia libre

# str_match solo te devuelve el primer resultado. Si quieres que
# te devuelva el resto hay que utilizar str_match_all.
# Lo mismo pasa con el resto de funciones (str_locate, ...)

# extraemos el codigo que está en el ol.
olCode <- str_extract(htmlCode, reOl)

# Hacemos otra expresión regular para extraer los nombres de esta
# lista (probadlo en regex101)
reName <- "<li><a .*?>(.*?)<\\/a>.*?<\\/li>"

# Ahora como queremos extraer más de uno usamos _all.
# Tened cuidado porque _all devuelve una lista de dataframes.
# Por eso uso [[1]] para coger el primero (y único) dataframe
nombres <- str_match_all(olCode, reName)[[1]]



# Brevente, que sepáis que el scrapping de HTML no se recomienda
# hacer con expresiones regulares, se usan librerías
# que procesan el XML, como xml2 o rvest (recomendada)
library("xml2")

# El problema de xml2 y otras similares es que no son resilientes
# a fallos o a discordancias respecto al estandar.
# De hecho con la página que estabamos trabajando falla:
htmlParsed <- read_xml(htmlCode) # };-)

# Usad rvest. Muy recomendado, es el dplyr de xml

# Para que veáis que funciona, si usamos este ejemplo pequeño:
htmlParsed <- read_xml("<html><a></a></html>")
xml_find_all(htmlParsed, "a")





