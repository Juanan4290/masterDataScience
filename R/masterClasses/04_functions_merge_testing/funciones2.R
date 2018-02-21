# library...
library(dplyr)

descargarWeb <- function(url) {
  lines <- readLines(url)
  paste(lines, collapse = "")
}


extraccionTag <- function(html, tag) {
  str_extract(html, paste0("<",tag,">.*?<\\/",tag,">"))
}


extraerNombres <- function(html) {
  reName <- "<li><a .*?>(.*?)<\\/a>.*?<\\/li>"
  str_match_all(html,reName)[[1]][,2]
}

scraping <- function(url, tag = "ol") {
  url %>%
    descargarWeb %>%
    extraerTag %>%
    extraerNombres
}