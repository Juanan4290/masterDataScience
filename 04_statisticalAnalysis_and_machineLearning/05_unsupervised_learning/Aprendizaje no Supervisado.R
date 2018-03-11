## -------------------------------------------------------------------------
## SCRIPT: Aprendizaje no Supervisado.R
## CURSO: Master en Data Science
## SESIÓN: Aprendizaje no Supervisado
## PROFESOR: Antonio Pita Lozano
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 1. Bloque de inicializacion de librerias #####

if(!require("dummies")){
  install.packages("dummies")
  library("dummies")
}

setwd("~/Aprendizaje_no_supervisado")

# indicar el directorio de trabajo
setwd("C:/....")

## -------------------------------------------------------------------------
##       PARTE 1: CLUSTERING JERARQUICO: NETFLIX MOVIELENS
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 2. Bloque de carga de datos #####

movies = read.table("data/movies.txt",header=TRUE, sep="|",quote="\"")

## -------------------------------------------------------------------------

##### 3. Bloque de analisis preliminar del dataset #####

str(movies)
head(movies)
tail(movies)

table(movies$Comedy)
table(movies$Western)
table(movies$Romance, movies$Drama)

## -------------------------------------------------------------------------

##### 4. Bloque de calculo de distancias #####

distances = dist(movies[2:20], method = "euclidean")

## -------------------------------------------------------------------------

##### 5. Bloque de clustering jerarquico #####

clusterMovies = hclust(distances, method = "ward.D")

dev.off()
plot(clusterMovies)

rect.hclust(clusterMovies, k=2, border="yellow")
rect.hclust(clusterMovies, k=3, border="blue")
rect.hclust(clusterMovies, k=4, border="green")


NumCluster=10

rect.hclust(clusterMovies, k=NumCluster, border="red")

movies$clusterGroups = cutree(clusterMovies, k = NumCluster)

## -------------------------------------------------------------------------

##### 6. Bloque de analisis de clusters #####

table(movies$clusterGroups)

tapply(movies$Action, movies$clusterGroups, mean)
tapply(movies$Adventure, movies$clusterGroups, mean)
tapply(movies$Animation, movies$clusterGroups, mean)
tapply(movies$Childrens, movies$clusterGroups, mean)
tapply(movies$Comedy, movies$clusterGroups, mean)
tapply(movies$Crime, movies$clusterGroups, mean)
tapply(movies$Documentary, movies$clusterGroups, mean)
tapply(movies$Drama, movies$clusterGroups, mean)

aggregate(.~clusterGroups,FUN=mean, data=movies)

## -------------------------------------------------------------------------

##### 7. Bloque de ejemplo #####

subset(movies, Title=="Men in Black (1997)")

cluster2 = subset(movies, movies$clusterGroups==2)

cluster2$Title[1:10]

## -------------------------------------------------------------------------
##       PARTE 2: CLUSTERING kMEANS
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 8. Bloque de carga de Datos #####

creditos=read.csv("data/creditos.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 9. Bloque de revisión basica del dataset #####

str(creditos)
head(creditos)
summary(creditos)

## -------------------------------------------------------------------------

##### 10. Bloque de tratamiento de variables #####

creditosNumericos=dummy.data.frame(creditos, dummy.class="character" )

## -------------------------------------------------------------------------

##### 11. Bloque de Segmentación mediante Modelo RFM 12M  #####

creditosScaled=scale(creditosNumericos)

NUM_CLUSTERS=8
set.seed(1234)
Modelo=kmeans(creditosScaled,NUM_CLUSTERS)

creditos$Segmentos=Modelo$cluster
creditosNumericos$Segmentos=Modelo$cluster

table(creditosNumericos$Segmentos)

aggregate(creditosNumericos, by = list(creditosNumericos$Segmentos), mean)

## -------------------------------------------------------------------------

##### 12. Bloque de Ejericio  #####

## Elegir el numero de clusters

## -------------------------------------------------------------------------

##### 13. Bloque de Metodo de seleccion de numero de clusters (Elbow Method) #####

Intra <- (nrow(creditosNumericos)-1)*sum(apply(creditosNumericos,2,var))
for (i in 2:15) Intra[i] <- sum(kmeans(creditosNumericos, centers=i)$withinss)
plot(1:15, Intra, type="b", xlab="Numero de Clusters", ylab="Suma de Errores intragrupo")

## -------------------------------------------------------------------------
##       PARTE 3: PCA: REDUCCIÓN DE DIMENSIONALIDAD.
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 14. Bloque de carga de datos #####

coches=mtcars # Base de datos ejemplo en R

## -------------------------------------------------------------------------

##### 15. Bloque de revisión basica del dataset #####

str(coches)
head(coches)
summary(coches)

## -------------------------------------------------------------------------

##### 16. Bloque de modelo lineal #####

modelo_bruto=lm(mpg~.,data=coches)
summary(modelo_bruto)

cor(coches)

## -------------------------------------------------------------------------

##### 17. Bloque de modelos univariables #####

modelo1=lm(mpg~cyl,data=coches)
summary(modelo1)
modelo2=lm(mpg~disp,data=coches)
summary(modelo2)
modelo3=lm(mpg~hp,data=coches)
summary(modelo3)
modelo4=lm(mpg~drat,data=coches)
summary(modelo4)
modelo5=lm(mpg~wt,data=coches)
summary(modelo5)
modelo6=lm(mpg~qsec,data=coches)
summary(modelo6)
modelo7=lm(mpg~vs,data=coches)
summary(modelo7)
modelo8=lm(mpg~am,data=coches)
summary(modelo8)
modelo9=lm(mpg~gear,data=coches)
summary(modelo9)
modelo10=lm(mpg~carb,data=coches)
summary(modelo10)

cor(coches)

## -------------------------------------------------------------------------

##### 18. Bloque de Ejercicio #####

## ¿Qué modelo de regresión lineal realizarías?

modelo11=lm(mpg ~ cyl + wt + hp               ,data=coches)
summary(modelo11)


## -------------------------------------------------------------------------

##### 19. Bloque de Analisis de Componentes Principales #####

PCA<-prcomp(coches[,-c(1)],scale. = TRUE)

summary(PCA)
plot(PCA)

## -------------------------------------------------------------------------

##### 20. Bloque de ortogonalidad de componentes principales #####

cor(coches)
cor(PCA$x)

## -------------------------------------------------------------------------

##### 21. Bloque de representacion grafica mediante componentes principales #####

biplot(PCA)

PCA$rotation

## -------------------------------------------------------------------------

##### 22. Bloque de creacion de variables componentes principales #####

coches$PCA1=PCA$x[,1]
coches$PCA2=PCA$x[,2]
coches$PCA3=PCA$x[,3]

## -------------------------------------------------------------------------

##### 23. Bloque de regresion lineal con componentes principales #####

modelo_PCA=lm(mpg~PCA1,data=coches)
summary(modelo_PCA)

modelo_PCA=lm(mpg~PCA$x,data=coches)
summary(modelo_PCA)

modelo_PCA=lm(mpg~PCA1+PCA3,data=coches)
summary(modelo_PCA)

biplot(PCA,choices=c(1,3))

## -------------------------------------------------------------------------
##       PARTE 4: CLUSTERING K-MEANS Y PCA. SAMSUNG MOBILITY DATA
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 24 Bloque de inicializacion de librerias y establecimiento de directorio #####

library(ggplot2)
library(effects)
library(plyr)

## -------------------------------------------------------------------------

##### 25. Bloque de carga de Datos #####

load("data/samsungData.rda")

## -------------------------------------------------------------------------

##### 26. Bloque de analisis preliminar del dataset #####

str(samsungData)
head(samsungData)
tail(samsungData)

table(samsungData$activity)
str(samsungData[,c(562,563)])
## -------------------------------------------------------------------------

##### 27. Bloque de segmentacion kmeans #####

samsungScaled=scale(samsungData[,-c(562,563)])

set.seed(1234)
kClust1 <- kmeans(samsungScaled,centers=8)

table(kClust1$cluster,samsungData[,563])

nombres8<-c("walkup","laying","walkdown","laying","standing","sitting","laying","walkdown")

Error8=(length(samsungData[,563])-sum(nombres8[kClust1$cluster]==samsungData[,563]))/length(samsungData[,563])

Error8

## CLuster con 10 centros.
set.seed(1234)
kClust1 <- kmeans(samsungScaled,centers=10)

table(kClust1$cluster,samsungData[,563])

nombres10<-c("walkup","laying","walkdown","sitting","standing","laying","laying","walkdown","sitting","walkup")

Error10=(length(samsungData[,563])-sum(nombres10[kClust1$cluster]==samsungData[,563]))/length(samsungData[,563])

Error10

## -------------------------------------------------------------------------

##### 28. Bloque de PCA #####

PCA<-prcomp(samsungData[,-c(562,563)],scale=TRUE)
#PCA$rotation
#attributes(PCA)
summary(PCA)
plot(PCA)
PCA$x[,1:3]

dev.off()
par(mfrow=c(1,3))
plot(PCA$x[,c(1,2)],col=as.numeric(as.factor(samsungData[,563])))
plot(PCA$x[,c(2,3)],col=as.numeric(as.factor(samsungData[,563])))
plot(PCA$x[,c(1,3)],col=as.numeric(as.factor(samsungData[,563])))

par(mfrow=c(1,1))
plot(PCA$x[,c(1,2)],col=as.numeric(as.factor(samsungData[,563])))

## -------------------------------------------------------------------------