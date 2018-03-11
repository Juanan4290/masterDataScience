# Vamos a aumentar el nivel de abstracción ligeramente. Fijate en 
# la función extraccionTag.
library(stringr)
library(dplyr)

descargarWeb <- function(url) {
  lines <- readLines(url)
  paste(lines, collapse = "")
}

# Si te fijas, es exactamente igual que la función que extraia el código
# dentro de ol. Pero ahora hemos cambiado la forma del parámetro y en vez
# de solicitar el patrón entero sólo pedimos el nombre de la etiqueta
# que es algo mucho más fácil para el usuario y nosotros creamos la
# etiqueta
extraccionTag <- function(html, tag)
  str_extract(html, paste0("<",tag,">.*?<\\/",tag,">"))


extraerNombres <- function(html) {
  reName <- "<li><a .*?>(.*?)<\\/a>.*?<\\/li>"
  str_match_all(html, reName)[[1]][,2]
}

scrapping <- function(url, tag="ol") {
  descargarWeb(url) %>%
    # Y aquí cambiamos el extraer ol por extraccionTag y ponemos por defecto
    # ol
    extraccionTag(tag) %>%
    extraerNombres
}