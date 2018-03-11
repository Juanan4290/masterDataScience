library(dplyr)

set.seed(1234)
x <- runif(10)
hist(x)
summary(x)
x <- rpois(365, 10)
table(x)
round(table(x)/365*100,2)
barplot(table(x))
mean(x)
var(x)
sd(x)

#Binomial
?rbinom
rbinom(50, size = 10, prob = 0.) #random
dbinom(5, size = 10, prob = 0.1) #distribucion
pbinom(5, size = 10, prob = 0.1) #acumulado
x <- rbinom(200, 10, prob = 0.4)
barplot(table(x))

#Poisson
rpois(100,5)
dpois(0,5)
dpois(2,5)
ppois(2,5)
rpois(20000, 1.25) %>% table %>% barplot

mu <- 0.9323
dpois(0, mu)*576

#Normal
pnorm(90, mean = 100, sd = 10)
pnorm(110, mean = 100, sd = 10)
pnorm(110, mean = 100, sd = 10) - pnorm(90, mean = 100, sd = 10)

qnorm(0.15, mean = 100, sd = 10)
