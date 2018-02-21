url <- "https://es.wikipedia.org/wiki/Los_100,_un_ranking_de_las_personas_m%C3%A1s_influyentes_en_la_historia"

htmlLines <- readLines(url)

paste(c("alejandro","maria"), collapse=",")
paste(c("alejandro","maria"), c(1,2), sep=",")

nombre <- "alex"
paste0("hola",nombre)

htmlCode <- paste(htmlLines, collapse="")

library(stringr)
library(xml2)

reTitle <- "<title>(.*)<\\/title>"

str_extract(htmlCode, reTitle)
str_match(htmlCode, reTitle)

reOl <- "<ol>.*?<\\/ol>"
olCode <- str_extract(htmlCode, reOl)

reName <- "<li><a .*?>(.*?)<\\/a>.*?<\\/li>"
nombres <- str_match_all(htmlCode,reName)[[1]]
View(nombres)