## Wrangling data with R

# Importing libraries:
  
library(dplyr)
library(quantmod)
library(datasets)
library(nycflights13)

## 1. Taking real data from amazon and google stocks, make an algorithm that perfoms 
## the following: if from one day to another the amazon and google stocks go up, 
## the algorithm will buy the stock that has the higest rise.
## _Note_: use `Open` column.

# Amazon and Google stocks:

amzn <- getSymbols('AMZN', from = "2014-01-01",auto.assign = F)
googl <- getSymbols('GOOGL', from = "2014-01-01",auto.assign = F)
stocks <- cbind(amzn,googl)

stocks <- as.data.frame(stocks)

# Algorithm with loops:

date <- c()
site <- c()
value <- c()

for (stock in 2:nrow(stocks)){
  
  amznStock <- stocks$AMZN.Open[stock] - stocks$AMZN.Open[stock - 1]
  googlStock <- stocks$GOOGL.Open[stock] - stocks$GOOGL.Open[stock - 1]

  if ((amznStock > 0) & (googlStock > 0)){
    
    date <- rbind(date, rownames(stocks[stock,]))
    
    if (amznStock > googlStock){
     
      site <- rbind(site, "amazon")
      value <- rbind(value, stocks$AMZN.Open[stock])
    
    }
    
    else { # if the stock difference is the same in amzn and google, we will buy google
      
      site <- rbind(site, "google")
      value <- rbind(value, stocks$GOOGL.Open[stock])
    
    }
    
  }
  
}

purchases <- data.frame(date = date[,1],
                        stock = site[,1],
                        value = value[,1])

# Algorithm with vertorization

amazonDiff <- diff(stocks$AMZN.Open)
googlDiff <- diff(stocks$GOOGL.Open)

stocksDiff <- data.frame(stocks[2:nrow(stocks),])
stocksDiff$AMZN.Diff <- amazonDiff
stocksDiff$GOOGL.Diff <- googlDiff

getStock <- function(date,amaznOpen, googlOpen, amaznDiff, googlDiff){
    
  if (amaznDiff > googlDiff){
    return(c(date,"amazon",as.double(amaznOpen)))
  }
  
  else return(c(date,"google",as.double(googlOpen)))
}


stocksDiff <- add_rownames(stocksDiff, "date")

purchasesVectorized <- stocksDiff %>%
  select(date,AMZN.Open, GOOGL.Open, AMZN.Diff, GOOGL.Diff) %>%
  filter((AMZN.Diff > 0) & (GOOGL.Diff > 0)) %>%
  apply(1,function(x) getStock(x[1], x[2], x[3], x[4], x[5])) %>% t %>% as.data.frame

colnames(purchasesVectorized) <- c("date","site","value")
purchasesVectorized$date <- as.character(purchasesVectorized$date)
purchasesVectorized$value <- as.numeric(as.character(purchasesVectorized$value))


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