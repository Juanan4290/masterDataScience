## -------------------------------------------------------------------------
## SCRIPT: Clustering de clientes RFM.R
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

## -------------------------------------------------------------------------

##### 2. Bloque de parametros iniciales #####

setwd("D:/Documentos, Trabajos y Demás/Formación/Kschool/201711 Clase V Master Data Science/6 Casos de Exito de Negocio")

## -------------------------------------------------------------------------

##### 3. Bloque de extracción y preparación de datos #####

VENTAS=read.csv2("datos/Operaciones.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 4. Bloque de analisis de la información #####

str(VENTAS)
summary(VENTAS)
head(VENTAS)
tail(VENTAS)

## -------------------------------------------------------------------------

##### 5. Bloque de preparación de datos #####

VENTAS$FECHA=as.Date(VENTAS$FECHA)
VENTAS$FRECUENCIA=1
summary(VENTAS)

## -------------------------------------------------------------------------

##### 6. Bloque de construcción de variables RFM #####

FECHA_ANALISIS=as.Date("2014-12-31")
PLAZO_ANALISIS=365

RFM_VENTAS=summarise(group_by(VENTAS[VENTAS$FECHA<FECHA_ANALISIS & VENTAS$FECHA>=FECHA_ANALISIS-PLAZO_ANALISIS,], CLIENTE),
                       RECENCIA = as.numeric(min(FECHA_ANALISIS-FECHA, na.rm = TRUE)),
                       FRECUENCIA = sum(FRECUENCIA, na.rm = TRUE),
                       MONETIZACION =  sum(IMPORTE, na.rm = TRUE)
)

## -------------------------------------------------------------------------

##### 7. Bloque Gráfico de Densidad Modelo RFM #####

dev.off()

png("./graficos clustering RFM/Densidad RFM.png",width = 1024, height = 880)
par(mfrow=c(2, 2),oma = c(1, 0, 3, 0))
smoothScatter(RFM_VENTAS$FRECUENCIA,RFM_VENTAS$RECENCIA, xlab="FRECUENCIA", ylab="RECENCIA")
frame()
smoothScatter(RFM_VENTAS$FRECUENCIA,RFM_VENTAS$MONETIZACION, xlab="FRECUENCIA",ylab="MONETIZACION")
smoothScatter(RFM_VENTAS$RECENCIA,RFM_VENTAS$MONETIZACION, xlab="RECENCIA",ylab="MONETIZACION")
mtext("Densidad de clientes mediante Modelo RFM ", outer = TRUE, cex = 2)
dev.off()

## -------------------------------------------------------------------------

##### 8. Bloque de Clustering mediante Modelo RFM #####

## PREPARAMOS LOS DATOS MEDIANTE SU NORMALIZACIÓN
RFM_VENTAS_NORM=scale(RFM_VENTAS[,-1])

## CALCULAMOS LOS Clusters EN FUNCIÓN AL NÚMERO ELEGIDO
NUM_CLUSTERS=8
set.seed(1234)

Modelo=kmeans(RFM_VENTAS_NORM,NUM_CLUSTERS)

## SELECCIONAMOS LOS GRUPOS
Clusters=Modelo$cluster

## MOSTRAMOS LA DISTRIBUCIÓN DE LOS GRUPOS
table(Clusters)

## MOSTRAMOS LOS DATOS REPRESENTATIVOS DE LOS GRUPOS
aggregate(RFM_VENTAS[,-1], by = list(Clusters), mean)

## O SU VERSIÓN ROBUSTA
aggregate(RFM_VENTAS[,-1], by = list(Clusters), median)

## -------------------------------------------------------------------------

##### 9. Bloque de Representación Gráfica clusters mediante Modelo RFM #####

dev.off()

png(paste("./graficos clustering RFM/Kmeans ",NUM_CLUSTERS," clusters RFM.png",sep=""),width = 1024, height = 880)
par(mfrow=c(2, 2),oma = c(1, 0, 3, 0))
plot(RFM_VENTAS$FRECUENCIA,RFM_VENTAS$RECENCIA,col=Clusters, xlab="FRECUENCIA", ylab="RECENCIA")
plot(c(0,max(RFM_VENTAS$RECENCIA)),c(0,max(RFM_VENTAS$RECENCIA)), type="n", axes=F, xlab="", ylab="",xlim=c(0,max(RFM_VENTAS$RECENCIA)),ylim=c(0,max(RFM_VENTAS$RECENCIA)))
legend(1,max(RFM_VENTAS$RECENCIA)/2-1,legend=c(1:NUM_CLUSTERS),yjust = 0.5,col=c(1:NUM_CLUSTERS),pch=15,cex=2)
plot(RFM_VENTAS$FRECUENCIA,RFM_VENTAS$MONETIZACION,col=Clusters, xlab="FRECUENCIA",ylab="MONETIZACION")
plot(RFM_VENTAS$RECENCIA,RFM_VENTAS$MONETIZACION,col=Clusters, xlab="RECENCIA",ylab="MONETIZACION")
mtext(paste("Clusterización kmeans de clientes mediante Modelo RFM",sep=""), outer = TRUE, cex = 2)
dev.off()

## -------------------------------------------------------------------------

##### 10. Bloque de asignacion de clusters #####

RFM_VENTAS$CLUSTER=Clusters

head(RFM_VENTAS)

## -------------------------------------------------------------------------