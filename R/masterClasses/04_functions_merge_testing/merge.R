library(dplyr)

# he llegado tarde... nameespaces.R
miLista <- list(a=1,b="hola")
attach(miLista)
a
a <- a+1
detach(miLista)
a
# habla de usar with en lugar de attach

# merge
library(nycflights13)
flights

myFlights <- flights %>% head(6)
myFlights <- myFlights %>% select(origin,dest)
View(airports)

merge(myFlights, airports,
      by.x = "origin", by.y = "faa")



# dplyr
myFlights %>%
  merge(y = airports, by.x = "origin", by.y = "faa") %>%
  merge(y = airports, by.x = "dest", by.y="faa",
        suffixes = c("_origin","_dest"), all.x = T) %>% View