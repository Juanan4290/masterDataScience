titanic <- read.csv("./data/train.csv")

# Así se lee una columna de un dataframe
titanic$Age
titanic[,"Age"]

# Edad del sujeto nº 7
titanic[7,"Age"]
titanic$Age[7]

# Edad de la persona más joven, la media de las edades, y la edad máxima
min(titanic$Age, na.rm = T)
mean(titanic$Age, na.rm = T)    
max(titanic$Age, na.rm = T)

# Usar summary
summary(titanic$Age)

# Personas menores de edad
menores <- titanic[titanic$Age < 18,]

# View es para ver
#View(menores)

# Ejercicio mejorado: Quitar NA
mascaraDeMenores <- titanic$Age < 18
mascaraDeMenores[is.na(mascaraDeMenores)] <- F

menores <- titanic[mascaraDeMenores,]

# Ejercicio v3
menores <- titanic[!is.na(titanic$Age) & titanic$Age < 18,]

#install.packages(c("dplyr","readr", "plotly"))

# cargar dplyr
library("dplyr")

# Seleccionar multiples filas
titanic[c(3,5),c("Age","Sex")]

titanic$Name[c(1,2)]

# Se puede seleccionar y asignar a la vez

titanic$Age[c(1,2)] <- 20

# Funciones utiles de dataframes
colnames()
rownames()
nrow()
ncol()

cbind() # concatenar columnas
rbind() # concatenar filas

colnames(titanic)
colnames(titanic)

# Filtra todas las personas de primera clase y mujeres y cogemos la columna survived y Fare
firstClassWomenByFare = titanic[titanic$Pclass == 1 & titanic$Sex == "female",c("Survived","Fare")]

# Porcentaje de supervivientes entre este grupo
sum(firstClassWomenByFare$Survived)/nrow(firstClassWomenByFare)
mean(firstClassWomenByFare$Survived)

# Calcular para cada clase y genero el porcentaje de supervivencia

tapply(titanic$Survived, titanic$Pclass, mean, na.rm = T)
tapply(titanic$Survived, titanic$Sex, mean, na.rm = T)

table(titanic$Pclass)
table(titanic$Sex)

by(titanic, titanic$Sex, summary)
aggregate(cbind(Survived,Age) ~ Pclass + Sex, titanic, mean)

cor(titanic[,c("Age","Fare")], use = "complete.obs")


## Ejercicios:
# 1. Media de edad de hombres que sobrevivieron
mean(titanic[titanic$Sex == "male" & titanic$Survived,"Age"], na.rm  = T)

# 2. Cuantas personas sobrevivieron
table(titanic$Survived)
table(titanic$Survived)[2]
sum(titanic$Survived)

# 3. Cuantas personas fallecieron
table(titanic$Survived)[1]
nrow(titanic)-sum(titanic$Survived)
sum(!titanic$Survived)

# 4. Cuantas personas viajaron en el titanic
nrow(titanic)
sum(titanic$Embarked != "") # hay dos valores "" que no son NA

# 5. Proporcion entre personas de primera clase y tercera
nrow(titanic[titanic$Pclass==1,]) / nrow(titanic[titanic$Pclass==3,])

# 6. Selecciona columna Age y Sex para personas de primera clase
titanic[titanic$Pclass==1,c("Age", "Sex")]

# 7. Calcula la mascara para seleccionar los supervivientes de tercera clase 
#   o los hombres de primera clase que fallecieron
subset(titanic, (Pclass == 3 & Survived) | (Sex=="male" & Pclass == 1 & !Survived))
(titanic$Pclass == 3 & titanic$Survived) | (titanic$Sex=="male" & titanic$Pclass == 1 & !titanic$Survived)

# 8. COrrelacion entre edad y fare para cada sexo













