### Wrangling data with R

# Importing libraries:
  
library(dplyr)
library(quantmod)
library(datasets)
library(nycflights13)

# 1. Taking real data from amazon and google stocks, make an algorithm that perfoms
# the following: if from one day to another the amazon and google stocks go up,
# the algorithm will buy the stock that has the higest rise.
# _Note_: use `Open` column.

# Amazon and Google stocks:

amzn <- getSymbols('AMZN', from = "2014-01-01",auto.assign = F)
googl <- getSymbols('GOOGL', from = "2014-01-01",auto.assign = F)
stocks <- cbind(amzn,googl)

stocks <- as.data.frame(stocks)

# Algorithm with loops:

puntosDeCompra <- function(precioA, precioB) {
  
  resultado <- integer(length(precioA))
  for (i in 1:(length(precioA)-1)) {
    deltaA <- precioA[[i+1]] - precioA[[i]]
    deltaB <- precioB[[i+1]] - precioB[[i]]
    
    if (deltaA >0 & deltaB > 0) 
      resultado[i+1] <- ifelse(deltaA > deltaB, 1, 2) # (deltaA < deltaB) + 1 --> forma hacker
  }
  resultado
}

backtesting <- function(precioA, precioB, stock) {
  
  precioFinalA <- precioA[length(precioA)]
  precioFinalB <- precioB[length(precioB)]
  
  rentabilidad <- 0
  
  for (i in 1:length(precioA)){
    if (stock[i] == 1) rentabilidad <- rentabilidad + as.numeric(precioFinalA - precioA[[i]])
    if (stock[i] == 2) rentabilidad <- rentabilidad + as.numeric(precioFinalB - precioB[[i]])
  }
  
  rentabilidad
}

# Function Test:

precioA <- bolsa$AMZN.Open
precioB <- bolsa$GOOGL.Open
stock <- puntosDeCompra(precioA, precioB)

backtesting(precioA, precioB, stock)


# Algorithm with vertorization

puntosDeCompraVect <- function(precioA, precioB) {
  if (!is.numeric(precioA)) stop("A no es numerico")
  
  precioA_diff <- diff(precioA)
  precioB_diff <- diff(precioB)
  
  compras <- integer(length(precioA))
  
  compras[((precioA_diff > 0) & (precioB_diff > 0))] <- 1
  compras[(compras == 1) & (precioB_diff > precioA_diff)] <- 2
  compras
  
}

backtestingVect <- function(precioA, precioB, stock) {
  preciosDeCompra <- data.frame(precioA, precioB, stock)
  colnames(preciosDeCompra) <- c("precioA", "precioB", "stock")
  
  precioFinalA <- precioA[length(precioA)]
  precioFinalB <- precioB[length(precioB)]
  
rentabilidad <- preciosDeCompra %>% mutate(rentabilidadParcialA = precioFinalA[[1]] - precioA,
                                           rentabilidadParcialB = precioFinalB[[1]] - precioB) %>% 
  select(rentabilidadParcialA,rentabilidadParcialB,stock) %>% 
  filter(stock == 1 | stock == 2) %>%
  apply(1,FUN = function(x) x[x[3]]) %>%
  sum
  
  return(rentabilidad)
}

# Function Test:

precioA <- bolsa$AMZN.Open
precioB <- bolsa$GOOGL.Open
stockVect <- puntosDeCompraVect(precioA, precioB)

backtestingVect(precioA, precioB, stockVect)


## 3. For this exercise we will use the `airquality` dataset. 
## Filter the odd days of the month using a function that gives you TRUE 
## if it is an odd day and FALSE if it is an even day.

str(airquality)
head(airquality)

oddDay = function(day) {
  if (day%%2 != 0) {
    return (TRUE)
  }
  else return (FALSE)
}

airquality %>%
  filter(sapply(Day, oddDay)) %>% head(10)


## 4. Compute the average of each variable per month.

airquality %>%
  group_by(Month) %>%
  summarise_all(mean,na.rm=T)


## 5. Take the top 5 origin-destination routes with the highest average delay 
## from `flights` dataset.

str(flights)
head(flights)

flights %>%
  group_by(origin,dest) %>%
  summarise(avgDelay = mean(dep_delay+arr_delay,na.rm=T)) %>%
  arrange(desc(avgDelay)) %>% head(5)


## 6. What hour has higest average delays (arrange the dataset from last to greatest)?
  
flights %>%
  group_by(hour) %>%
  summarise(avgDelayPerHour = mean(dep_delay + arr_delay, na.rm = T)) %>%
  arrange(desc(avgDelayPerHour)) %>% head(5)

# 6Bis. If you only want the number of flights with delay (`dep_delay + arr_delay > 0`) 
# by hour:
  

flights %>%
  mutate(totalDelay = dep_delay + arr_delay) %>%
  select(hour, totalDelay) %>%
  filter(totalDelay > 0) %>%
  group_by(hour) %>%
  summarise(totalDelays=n()) %>%
  arrange(desc(totalDelays))