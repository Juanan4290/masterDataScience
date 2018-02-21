# library...
library(dplyr)

descargarWeb <- function(url) {
  lines <- readLines(url)
  paste(lines, collapse = "")
}
 

extraerOl <- function(html, pattern = "<ol>.*?<\\/ol>") 
  str_extract(html,  pattern)


extraerNombres <- function(html) {
  reName <- "<li><a .*?>(.*?)<\\/a>.*?<\\/li>"
  str_match_all(html,reName)[[1]][,2]
}

scraping <- function(url) {
  url %>%
    descargarWeb %>%
    extraerOl %>%
    extraerNombres
}