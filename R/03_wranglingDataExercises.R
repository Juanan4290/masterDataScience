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



# Algorithm with loops:


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