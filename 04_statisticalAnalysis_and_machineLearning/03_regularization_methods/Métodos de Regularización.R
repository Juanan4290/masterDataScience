## -------------------------------------------------------------------------
## SCRIPT: Métodos de Regularización y Estadística Bayesiana.R
## CURSO: Master en Data Science
## SESION: Métodos de Regularización y Estadística Bayesiana
## PROFESOR: Antonio Pita Lozano
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 1. Bloque de inicializacion de librerias #####

if (!require("e1071")){
  install.packages("e1071")
  library("e1071")
}

if (!require("ROCR")){
  install.packages("ROCR")
  library("ROCR")
}

if (!require("glmnet")){
  install.packages("glmnet") 
  library("glmnet")
}

if (!require("caTools")){
  install.packages("caTools") 
  library(caTools)
}

setwd("~/modelos_regularización_y_estadística_bayesiana")

## -------------------------------------------------------------------------
##       PARTE 1: Métodos de Regularización
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 2. Bloque de carga de datos #####

files <- (Sys.glob("./Viviendas/*.csv"))

if (exists("Viviendas")){rm(Viviendas)}

for (file in files){
  print(paste("Procesando fichero: ",file,sep=""))
  data=read.csv2(file,stringsAsFactors = FALSE, fileEncoding = "windows-1252", sep = ";")
  if (exists("Viviendas")){
    Viviendas=rbind(Viviendas,data)
  }else{
    Viviendas=data
  }
}

## -------------------------------------------------------------------------

##### 3. Bloque de revisión basica del dataset #####

str(Viviendas)
head(Viviendas)
tail(Viviendas)
summary(Viviendas)

## -------------------------------------------------------------------------

##### 4. Bloque de formateo de variables #####

Viviendas$Longitud=as.numeric(Viviendas$Longitud)
Viviendas$Latitud=as.numeric(Viviendas$Latitud)

## -------------------------------------------------------------------------

##### 5. Bloque de tratamiento de información #####

table(Viviendas$Planta)
Viviendas$Planta[grepl("Hipoteca",Viviendas$Planta)]=""
table(Viviendas$Planta)
Viviendas$Planta[grepl("Ha bajado",Viviendas$Planta)]=""
table(Viviendas$Planta)

## -------------------------------------------------------------------------

##### 6. Bloque de filtrado de registros #####

# eliminamos los registros sin precio
Viviendas[is.na(Viviendas$Precio),]
Viviendas=Viviendas[!is.na(Viviendas$Precio),]

## -------------------------------------------------------------------------

##### 7. Bloque de filtrado de registros #####

table(Viviendas$Habitaciones, useNA = "always")
#analizar los nulos de habitaciones
Nulos=Viviendas[is.na(Viviendas$Habitaciones),]
Nulos

Viviendas$Habitaciones[is.na(Viviendas$Habitaciones) & grepl("Estudio",Viviendas$Direccion)]=1

Nulos=Viviendas[is.na(Viviendas$Habitaciones),]
Nulos

# Eliminamos los registros sin Habitaciones
Viviendas=Viviendas[!is.na(Viviendas$Habitaciones),]


## -------------------------------------------------------------------------

##### 8. Bloque de análisis gráfico #####

hist(Viviendas$Precio)
hist(log(Viviendas$Precio))
boxplot(Viviendas$Precio)
boxplot(Viviendas$Precio[Viviendas$Precio<300000])

hist(Viviendas$Superficie)
hist(log(Viviendas$Superficie))
boxplot(Viviendas$Superficie)
boxplot(Viviendas$Superficie[Viviendas$Superficie<200])

## -------------------------------------------------------------------------

##### 9. Bloque de creación de variables auxiliares #####

str(Viviendas)

Viviendas$madrid=as.numeric(grepl("Madrid",Viviendas$Info))
sum(Viviendas$madrid)
Viviendas$madrid=as.numeric(grepl("madrid",Viviendas$Info))
sum(Viviendas$madrid)
Viviendas$madrid=as.numeric(grepl("[Mm][Aa][Dd][Rr][Ii][Dd]",Viviendas$Info))
sum(Viviendas$madrid)

Viviendas$piscina=as.numeric(grepl("[Pp][Ii][Ss][Cc][Ii][Nn][Aa]",Viviendas$Info))
Viviendas$garage=as.numeric(grepl("[Gg][Aa][Rr][Aa][Gg][Ee]",Viviendas$Info))
Viviendas$ascensor=as.numeric(grepl("[Aa][Ss][Cc][Ee][Nn][Ss][Oo][Rr]",Viviendas$Info))
Viviendas$terraza=as.numeric(grepl("[Tt][Ee][Rr][Rr][Aa][Zz][Aa]",Viviendas$Info))
Viviendas$amueblado=as.numeric(grepl("[Aa][Mm][Uu][Ee][Bb][Ll][Aa][Dd][OoAa]",Viviendas$Info))

Viviendas$piso=as.numeric(grepl("[Pp][Ii][Ss][Oo]",Viviendas$Direccion))
Viviendas$duplex=as.numeric(grepl("[Dd][UuÚú][Pp][Ll][Ee][Xx]",Viviendas$Direccion))
Viviendas$chalet=as.numeric(grepl("[Cc][Hh][Aa][Ll][Ee][Tt]",Viviendas$Direccion))
Viviendas$estudio=as.numeric(grepl("[Ee][Ss][Tt][Uu][Dd][Ii][Oo]",Viviendas$Direccion))
Viviendas$atico=as.numeric(grepl("[AaÁá][Tt][Ii][Cc][Oo]",Viviendas$Direccion))

head(Viviendas)
summary(Viviendas)

table(Viviendas$piso,Viviendas$duplex)
table(Viviendas$chalet,Viviendas$duplex)
table(Viviendas$chalet,Viviendas$piso)
table(Viviendas$chalet,Viviendas$estudio)
table(Viviendas$piso,Viviendas$estudio)
table(Viviendas$duplex,Viviendas$estudio)

table(Viviendas$piso + Viviendas$duplex + Viviendas$chalet + Viviendas$estudio + Viviendas$atico)

Casos=Viviendas[Viviendas$piso + Viviendas$duplex + Viviendas$chalet + Viviendas$estudio + Viviendas$atico==2,]
Casos
Viviendas$atico[Viviendas$piso + Viviendas$duplex + Viviendas$chalet + Viviendas$estudio + Viviendas$atico==2]=0

Casos=Viviendas[Viviendas$piso + Viviendas$duplex + Viviendas$chalet + Viviendas$estudio + Viviendas$atico==0,]
Casos

Viviendas$casarural=as.numeric(grepl("Casa rural",Viviendas$Direccion))
Viviendas$casapueblo=as.numeric(grepl("Casa de pueblo",Viviendas$Direccion))
Viviendas$fincarustica=as.numeric(grepl("Finca rústica",Viviendas$Direccion))

table(Viviendas$piso + Viviendas$duplex + Viviendas$chalet + Viviendas$estudio + Viviendas$atico + Viviendas$casarural + Viviendas$casapueblo + Viviendas$fincarustica)

Casos=Viviendas[Viviendas$piso + Viviendas$duplex + Viviendas$chalet + Viviendas$estudio + Viviendas$atico + Viviendas$casarural + Viviendas$casapueblo + Viviendas$fincarustica==0,]
Casos

## -------------------------------------------------------------------------

##### 10. Bloque de creación de conjuntos de entrenamiento y test #####

set.seed(12345) 
SAMPLE = sample.split(Viviendas$Precio, SplitRatio = 0.75)
Train = subset(Viviendas, SAMPLE == TRUE)
Test = subset(Viviendas, SAMPLE == FALSE)

## -------------------------------------------------------------------------

##### 11. Bloque de parámetros básicos Regularización #####

variables=c("Superficie","madrid","piscina","garage","ascensor","terraza","amueblado","piso","duplex","chalet","estudio","atico","casarural","casapueblo","fincarustica")
Lambda=50000
Pruebas=1500

## -------------------------------------------------------------------------

##### 12. Bloque de regression Ridge #####

alphaSeleccionado=0

coeficientes=matrix(0,nrow=Pruebas,ncol=length(variables)+1)
coeficientes=as.data.frame(coeficientes)
colnames(coeficientes)=c("termino_independiente",variables)

metricas=data.frame(sceTrain=rep(0,Pruebas),sceTest=rep(0,Pruebas))

for (i in 1:Pruebas){
  modelo_glmnet=glmnet(x=as.matrix(Train[,variables]),y=Train$Precio,lambda=Lambda*(i-1)/Pruebas,alpha=alphaSeleccionado)
  coeficientes[i,]=c(modelo_glmnet$a0,as.vector(modelo_glmnet$beta))
  
  prediccionesTrain=predict(modelo_glmnet,newx = as.matrix(Train[,variables]))
  metricas$sceTrain[i]=sum((Train$Precio-prediccionesTrain)^2)
  
  prediccionesTest=predict(modelo_glmnet,newx = as.matrix(Test[,variables]))
  metricas$sceTest[i]=sum((Test$Precio-prediccionesTest)^2)
}

# Gráfico con evolución de los coeficientes
colores=rainbow(length(variables))
plot(coeficientes[,1],type="l",col="white",ylim=c(-300000,300000))
for (i in 1:length(variables)){
  lines(coeficientes[,i+1],type="l",col=colores[i])
}

# Gráfico con evolución de los errores
par(mar = c(5,5,2,5)) #cambiamos la configuración de la parte gráfica
plot(metricas$sceTrain,col="red",type="l",ylab="Error Train",xlab="Prueba")
par(new = T)
plot(metricas$sceTest,col="blue",type="l",axes=FALSE,xlab=NA, ylab=NA)
axis(side = 4)
mtext(side = 4, line = 3, 'Error Test')
par(mar = c(5.1,4.1,4.1,2.1)) #volvemos a la configuración inicial

# Selección del Lambda Óptimo
min(metricas$sceTest)
which(metricas$sceTest==min(metricas$sceTest))
Caso=1246

# Modelo y Parámetro
metricasRidge=metricas[Caso,]
lambdaRidge=Lambda*(Caso-1)/Pruebas
coeficientesRidge=coeficientes[Caso,]
modeloRidge=glmnet(x=as.matrix(Train[,variables]),y=Train$Precio,lambda=Lambda*(Caso-1)/Pruebas,alpha=alphaSeleccionado)
modeloRidge$beta

## -------------------------------------------------------------------------

##### 13. Bloque de regression Lasso #####

alphaSeleccionado=1

coeficientes=matrix(0,nrow=Pruebas,ncol=length(variables)+1)
coeficientes=as.data.frame(coeficientes)
colnames(coeficientes)=c("termino_independiente",variables)

metricas=data.frame(sceTrain=rep(0,Pruebas),sceTest=rep(0,Pruebas))

for (i in 1:Pruebas){
  modelo_glmnet=glmnet(x=as.matrix(Train[,variables]),y=Train$Precio,lambda=Lambda*(i-1)/Pruebas,alpha=alphaSeleccionado)
  coeficientes[i,]=c(modelo_glmnet$a0,as.vector(modelo_glmnet$beta))
  
  prediccionesTrain=predict(modelo_glmnet,newx = as.matrix(Train[,variables]))
  metricas$sceTrain[i]=sum((Train$Precio-prediccionesTrain)^2)
  
  prediccionesTest=predict(modelo_glmnet,newx = as.matrix(Test[,variables]))
  metricas$sceTest[i]=sum((Test$Precio-prediccionesTest)^2)
}

# Gráfico con evolución de los coeficientes
colores=rainbow(length(variables))
plot(coeficientes[,1],type="l",col="white",ylim=c(-300000,300000))
for (i in 1:length(variables)){
  lines(coeficientes[,i+1],type="l",col=colores[i])
}

# Gráfico con evolución de los errores
par(mar = c(5,5,2,5)) #cambiamos la configuración de la parte gráfica
plot(metricas$sceTrain,col="red",type="l",ylab="Error Train",xlab="Prueba")
par(new = T)
plot(metricas$sceTest,col="blue",type="l",axes=FALSE,xlab=NA, ylab=NA)
axis(side = 4)
mtext(side = 4, line = 3, 'Error Test')
par(mar = c(5.1,4.1,4.1,2.1)) #volvemos a la configuración inicial

# Selección del Lambda Óptimo
min(metricas$sceTest)
which(metricas$sceTest==min(metricas$sceTest))
Caso=708

# Modelo y Parámetro
metricasLasso=metricas[Caso,]
lambdaLasso=Lambda*(Caso-1)/Pruebas
coeficientesLasso=coeficientes[Caso,]
modeloLasso=glmnet(x=as.matrix(Train[,variables]),y=Train$Precio,lambda=Lambda*(Caso-1)/Pruebas,alpha=alphaSeleccionado)
modeloLasso$beta

## -------------------------------------------------------------------------

##### 14. Bloque de regression Elastic Net #####

alphaSeleccionado=0.5

coeficientes=matrix(0,nrow=Pruebas,ncol=length(variables)+1)
coeficientes=as.data.frame(coeficientes)
colnames(coeficientes)=c("termino_independiente",variables)

metricas=data.frame(sceTrain=rep(0,Pruebas),sceTest=rep(0,Pruebas))

for (i in 1:Pruebas){
  modelo_glmnet=glmnet(x=as.matrix(Train[,variables]),y=Train$Precio,lambda=Lambda*(i-1)/Pruebas,alpha=alphaSeleccionado)
  coeficientes[i,]=c(modelo_glmnet$a0,as.vector(modelo_glmnet$beta))
  
  prediccionesTrain=predict(modelo_glmnet,newx = as.matrix(Train[,variables]))
  metricas$sceTrain[i]=sum((Train$Precio-prediccionesTrain)^2)
  
  prediccionesTest=predict(modelo_glmnet,newx = as.matrix(Test[,variables]))
  metricas$sceTest[i]=sum((Test$Precio-prediccionesTest)^2)
}

# Gráfico con evolución de los coeficientes
colores=rainbow(length(variables))
plot(coeficientes[,1],type="l",col="white",ylim=c(-200000,300000))
for (i in 1:length(variables)){
  lines(coeficientes[,i+1],type="l",col=colores[i])
}

# Gráfico con evolución de los errores
par(mar = c(5,5,2,5)) #cambiamos la configuración de la parte gráfica
plot(metricas$sceTrain,col="red",type="l",ylab="Error Train",xlab="Prueba")
par(new = T)
plot(metricas$sceTest,col="blue",type="l",axes=FALSE,xlab=NA, ylab=NA)
axis(side = 4)
mtext(side = 4, line = 3, 'Error Test')
par(mar = c(5.1,4.1,4.1,2.1)) #volvemos a la configuración inicial

# Selección del Lambda Óptimo
min(metricas$sceTest)
which(metricas$sceTest==min(metricas$sceTest))
Caso=1156

# Modelo y Parámetro
metricasElasticNet=metricas[Caso,]
lambdaElasticNet=Lambda*(Caso-1)/Pruebas
coeficientesElasticNet=coeficientes[Caso,]
modeloElasticNet=glmnet(x=as.matrix(Train[,variables]),y=Train$Precio,lambda=Lambda*(Caso-1)/Pruebas,alpha=alphaSeleccionado)
modeloElasticNet$beta

## -------------------------------------------------------------------------

##### 15. Bloque de comparativa de Modelos #####

metricasRidge
metricasLasso
metricasElasticNet