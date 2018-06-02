## -------------------------------------------------------------------------
## SCRIPT: RFM de Clientes.R
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

head(RFM_VENTAS)

## -------------------------------------------------------------------------

##### 7. Bloque de calculo de percentiles #####

q_FRECUENCIA=quantile(RFM_VENTAS$FRECUENCIA,probs=c(0.33,0.66))
q_MONETIZACION=quantile(RFM_VENTAS$MONETIZACION,probs=c(0.33,0.66))
q_RECENCIA=quantile(RFM_VENTAS$RECENCIA,probs=c(0.33,0.66))

q_FRECUENCIA
q_MONETIZACION
q_RECENCIA

## -------------------------------------------------------------------------

##### 8. Bloque de asignacion de segmentos #####

RFM_VENTAS$G_FRECUENCIA=1+sapply(RFM_VENTAS$FRECUENCIA,FUN=function(x){sum(x>=q_FRECUENCIA)})
RFM_VENTAS$G_MONETIZACION=1+sapply(RFM_VENTAS$MONETIZACION,FUN=function(x){sum(x>=q_MONETIZACION)})
RFM_VENTAS$G_RECENCIA=1+sapply(RFM_VENTAS$RECENCIA,FUN=function(x){sum(x>=q_RECENCIA)})

RFM_VENTAS$SEGMENTO_RFM=paste(RFM_VENTAS$G_RECENCIA,RFM_VENTAS$G_FRECUENCIA,RFM_VENTAS$G_MONETIZACION,sep="_")

table(RFM_VENTAS$SEGMENTO_RFM)

head(RFM_VENTAS)

## -------------------------------------------------------------------------