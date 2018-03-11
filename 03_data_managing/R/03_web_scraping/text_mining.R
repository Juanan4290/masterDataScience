gsub("h", "H", c("hola", "búho"))
gsub("^h", "H", c("hola", "búho"))
gsub("o$", "os", c("hola", "búho"))

grep("^h", c("hola", "búho"))


### Ejercicio
colors()[grep("[0-9]",colors())]
colors()[grep("^yellow",colors())]
colors()[grep("blue",colors())]
###


x <- gsub("\\.", "", "100.0367,23")
x <- gsub(",", ".", x) %>% as.numeric
as.numeric(x)

paste("A", 1:6, sep = ",")
paste("A", 1:6, collapse = " ", sep = "-")
date()
paste("Hoy es ", date(), " y tengo clase de R", sep ="")

strsplit("Hoy es martes", split = " ")

library(stringr)
miText = "Hola me llamo Juan Antonio"
str_sub(miText,1,4)


### Ejercicio
ficheros <- c('ventas_20160522_zaragoza.csv', 'pedidos_firmes_20160422_soria.csv') 

getFeatures <- function(features) {
  newFeatures <- features %>% strsplit("_\\d{8}_")
  date <- gsub("[_[:alpha:]]","",ficheros)
  newFeatures
  #data.frame(newFeatures[1], date, newFeatures[2])
}

getFeatures(ficheros)


require(rvest)
mfield<-read_html("https://es.wikipedia.org/wiki/Medalla_Fields")
mfield %>% html_nodes("table") 

tabla <- mfield %>% html_nodes("table") %>% .[[2]] %>% html_table(header=TRUE)
tabla %>% View
knitr:::kable(tabla %>% head(10))

require(stringr)
require(magrittr)
tmp <- tabla$Medallistas %>% str_extract("\\([^()]+\\)")
tmp <- substring(tmp,2)

paises<- tmp %>% str_split_fixed(" y ", 2) %>% str_trim() %>% c()
freq <- table(paises)[-1]
freq %>% View

barplot(sort(freq),las=1,horiz=TRUE,col="lightblue",cex.names=.5)                     
grid()


### Tokenization
texto<-c("Eso es insultar al lector, es llamarle torpe",
         "Es decirle: ¡fíjate, hombre, fíjate, que aquí hay intención!",
         "Y por eso le recomendaba yo a un señor que escribiese sus artículos todo en bastardilla",
         "Para que el público se diese cuenta de que eran intencionadísimos desde la primera palabra a la última.")
texto

require(dplyr)
texto_df <- data_frame(fila = 1:4, texto = texto)

library(tidytext)
texto_df %>% unnest_tokens(palabra, texto)

require(janeaustenr)
require(dplyr)
require(stringr)

libros <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [[:digit:]ivxlc]", ignore_case=TRUE)))) %>%
  ungroup()



austen_books()
