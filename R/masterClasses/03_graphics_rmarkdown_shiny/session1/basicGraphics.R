library(dplyr)
library(MASS) # survey dataset

# scatterplot
plot(speed~dist,data=cars)
plot(cars$speed, cars$dist)

plot(speed~dist,data=cars, ylab="Velocidad (milla por hora)",xlab="Distancia (pies)")
abline(lm(speed~dist,data=cars), col = "red")
grid()

?par # graphical parameters

dev.new()
pairs(trees, panel = panel.smooth, main = "Medidas de 31 arboles")
?pairs

# barplot
VADeaths
barplot(VADeaths[, 2], 
        xlab = "Tramos de edad", 
        ylab = "Tasa de mortalidad (por 1000 mujeres)", 
        main = "Tasa de mortalidad en Virginia \n (mujeres en ambito rural, 1940)")

dotchart(VADeaths)

dotchart(t(VADeaths),  
         main = "Tasa de mortalidad (por 1000 hab.), Virginia (1940)", cex = 0.8)


barplot(islands, main = "Superficie de las islas más grandes (en millas cuadradas)")

# improving a bit...
logIslandsSorted <- islands %>% sort(decreasing = F) %>% log

barplot(logIslandsSorted, main = "Superficie de las islas más grandes (en millas cuadradas",
        horiz = T, las = 1, col = "pink", cex.names = 0.5)

# histograms
names(survey)

alturas=na.omit(survey$Height) # actually hist function does omit NA
hist(alturas, labels=TRUE, las=1, ylim = c(0,50), col = "lightblue2", breaks = 15,
     border = "blue4",
     main = "Altura de estudiantes de la Universidad de Adelaide")

hist(alturas, las=2, col = "lightblue2", breaks = 20,
     border = "blue4", probability = T,
     main = "Altura de estudiantes de la Universidad de Adelaide")

m=mean(alturas);s=sd(alturas)
x=seq(min(alturas),max(alturas),.1)
p=dnorm(x,m,s)

lines(x,p,col="red") # verosimilitud

summary(alturas)


hist(survey$Pulse, col = "lightblue", breaks = 9, probability = T,
     xlab = "Pulse",
     main = "Pulse of Adelaide University Students")
pulseMean <- mean(survey$Pulse, na.rm = T)
abline(v = mean(survey$Pulse, na.rm = T), col = "red", lwd = 3)

colors()

# colors in R: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf


# boxplot

boxplot(survey$Height, col = "gray",main = "Altura de los estudiantes")
rug(survey$Height, side = 2) # points of the population

boxplot(Height ~ Sex, data=survey, notch=TRUE, col = "gray",
        main = "Altura según sexo") # notch -> IC

pdf("img/mifichero.pdf")
boxplot(Height ~ Sex, data=survey, notch=TRUE, col = "gray",
        main = "Altura según sexo")
dev.off()

png("img/mifichero.png")
boxplot(Height ~ Sex, data=survey, notch=TRUE, col = "gray",
        main = "Altura según sexo")
dev.off()
 


