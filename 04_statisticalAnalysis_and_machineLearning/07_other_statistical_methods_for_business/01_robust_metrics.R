## -------------------------------------------------------------------------
## SCRIPT: Introducción a las Métricas Robustas.R
## CURSO: Master en Data Science
## PROFESOR: Antonio Pita
## Paquetes Necesarios: dplyr
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 1. Bloque de inicializacion de librerias #####

if(!require("dplyr")){
  install.packages("dplyr")
  library("dplyr")
}

if(!require("MASS")){
  install.packages("MASS")
  library("MASS")
}

## -------------------------------------------------------------------------

##### 2. Bloque de creación de funciones auxiliares #####

#se <- function(x) sqrt(var(x)/length(x))

MediaWinsor<-function(x,probs=c(0.05,0.95)) {
  xq<-quantile(x,probs=probs)
  x[x < xq[1]]<-xq[1]
  x[x > xq[2]]<-xq[2]
  return(mean(x))
}

## -------------------------------------------------------------------------

##### 3. Bloque de establecimiento de directorio #####

setwd("D:/Documentos, Trabajos y Demás/Formación/Kschool/201711 Clase V Master Data Science/6 Casos de Exito de Negocio")

## -------------------------------------------------------------------------

##### 4. Bloque de carga de datos #####

Viviendas=read.csv2("./datos/Viviendas.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 5. Bloque de revisión basica del dataset #####

str(Viviendas)
head(Viviendas)
summary(Viviendas)

# eliminamos los registros sin precio
Viviendas=Viviendas[!is.na(Viviendas$Precio),]

summary(Viviendas)

## -------------------------------------------------------------------------

##### 6. Bloque de creación de variables auxiliares #####

str(Viviendas)

Viviendas$piso=as.numeric(grepl("[Pp][Ii][Ss][Oo]",Viviendas$Direccion))
Viviendas$duplex=as.numeric(grepl("[Dd][UuÚú][Pp][Ll][Ee][Xx]",Viviendas$Direccion))
Viviendas$chalet=as.numeric(grepl("[Cc][Hh][Aa][Ll][Ee][Tt]",Viviendas$Direccion))
Viviendas$estudio=as.numeric(grepl("[Ee][Ss][Tt][Uu][Dd][Ii][Oo]",Viviendas$Direccion))
Viviendas$atico=as.numeric(grepl("[AaÁá][Tt][Ii][Cc][Oo]",Viviendas$Direccion))

# Suponemos que la intersección es disjunta aunque puede no serlo
Viviendas$Tipologia=""
Viviendas$Tipologia[Viviendas$piso==1]="Piso"
Viviendas$Tipologia[Viviendas$duplex==1]="Duplex"
Viviendas$Tipologia[Viviendas$atico==1]="Atico"
Viviendas$Tipologia[Viviendas$chalet==1]="Chalet"
Viviendas$Tipologia[Viviendas$estudio==1]="Estudio"

table(Viviendas$Tipologia)

Viviendas$piscina=as.numeric(grepl("[Pp][Ii][Ss][Cc][Ii][Nn][Aa]",Viviendas$Info))
Viviendas$garage=as.numeric(grepl("[Gg][Aa][Rr][Aa][Gg][Ee]",Viviendas$Info))
Viviendas$ascensor=as.numeric(grepl("[Aa][Ss][Cc][Ee][Nn][Ss][Oo][Rr]",Viviendas$Info))
Viviendas$terraza=as.numeric(grepl("[Tt][Ee][Rr][Rr][Aa][Zz][Aa]",Viviendas$Info))
Viviendas$amueblado=as.numeric(grepl("[Aa][Mm][Uu][Ee][Bb][Ll][Aa][Dd][OoAa]",Viviendas$Info))

## -------------------------------------------------------------------------

##### 7. Bloque de cálculo de estadísticos por tipología de vivienda #####

RESUMEN=summarise(group_by(Viviendas, Tipologia),
                  Num_Viv=length(Precio),
                  Precio = mean(Precio),
                  Superficie = mean(Superficie),
                  Piscina = mean(piscina),
                  Garage = mean(garage),
                  Ascensor = mean(ascensor),
                  Terraza = mean(terraza),
                  Amueblado = mean(amueblado)
                  
)

RESUMEN

## -------------------------------------------------------------------------

##### 8. Bloque de analisis de outliers #####

summary(Viviendas$Precio)
hist(Viviendas$Precio)
hist(log(Viviendas$Precio))
boxplot(Viviendas$Precio)
boxplot(Viviendas$Precio[Viviendas$Precio<300000])

summary(Viviendas$Superficie)
hist(Viviendas$Superficie)
hist(log(Viviendas$Superficie))
boxplot(Viviendas$Superficie)
boxplot(Viviendas$Superficie[Viviendas$Superficie<200])

## -------------------------------------------------------------------------

##### 9. Bloque de cálculo de estadísticos por tipología de vivienda #####

ALPHA=0.15

PRECIOS=summarise(group_by(Viviendas, Tipologia),
                     Num_Viv=length(Precio),
                     Media = mean(Precio),
                     p_Media=sum(Precio<=Media)/length(Precio),
                     Mínimo = min(Precio),
                     Q1 = quantile(Precio,probs=0.25),
                     Mediana = median(Precio),
                     Q3 = quantile(Precio,probs=0.75),
                     Máximo = max(Precio),
                     MediaWindsor =  MediaWinsor(Precio,prob=c(ALPHA,1-ALPHA)),
                     p_Windsor=sum(Precio<=MediaWindsor)/length(Precio),
                     MediaRecortada =mean(Precio,trim=ALPHA),
                     p_Recortada=sum(Precio<=MediaRecortada)/length(Precio)
)

PRECIOS

## -------------------------------------------------------------------------

##### 10. Bloque de cálculo de estadísticos robustos #####

alphas=seq(from=0,to=0.5,by=0.01)
medias_recortadas=c()
medias_winsorizadas=c()
for (alpha in alphas){
  medias_recortadas=c(medias_recortadas,mean(Viviendas$Precio, trim=alpha))
  medias_winsorizadas=c(medias_winsorizadas,MediaWinsor(Viviendas$Precio,probs=c(alpha,1-alpha)))
}

Estimadores=data.frame(alphas)
Estimadores$media=mean(Viviendas$Precio)
Estimadores$mediana=median(Viviendas$Precio)
Estimadores$recortada=medias_recortadas
Estimadores$winsorizada=medias_winsorizadas

Estimadores

plot(Estimadores$recortada~Estimadores$alphas,ylim=c(min(Estimadores[,2:5]),max(Estimadores[,2:5])),col="red",type="l", main="representación de medias robustas", xlab="alfas",ylab="precio")
lines(alphas,Estimadores$winsorizada,col="blue")
lines(alphas,Estimadores$media,col="orange")
lines(alphas,Estimadores$mediana,col="green")
legend(x=mean(alphas),y=max(Estimadores[,2:5]),legend=c("media","mediana","media recortada","media winsorizada"),col=c("orange","green","red","blue"),pch=20)

## -------------------------------------------------------------------------

##### 11. Bloque de selección de threshold #####

modelorlm=rlm(Precio~1,data=Viviendas)
summary(modelorlm)

abline(h=modelorlm$coefficients[1],col="black")

## -------------------------------------------------------------------------
##       ANEXO: REGRESIÓN LINEAL ROBUSTA
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 12. Bloque de creación de datos simulados #####

x1=c(1,2,3,4,5,6,7,8,9,10)
y1=3*x1+2+rnorm(length(x1),0,1)
modelolm1=lm(y1~x1)
summary(modelolm1)

x2=c(x1,15)
y2=c(y1,300)
modelolm2=lm(y2~x2)
summary(modelolm2)

## -------------------------------------------------------------------------

##### 13. Bloque de representación gráfica #####

plot(x2,y2)
abline(a=modelolm1$coefficients[1],b=modelolm1$coefficients[2],col="blue")
abline(a=modelolm2$coefficients[1],b=modelolm2$coefficients[2],col="red")

modelorlm1=rlm(y1~x1)
summary(modelorlm1)
modelorlm2=rlm(y2~x2)
summary(modelorlm2)

abline(a=modelorlm1$coefficients[1],b=modelorlm1$coefficients[2],col="green")
abline(a=modelorlm2$coefficients[1],b=modelorlm2$coefficients[2],col="orange")

## -------------------------------------------------------------------------