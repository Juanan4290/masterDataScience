## -------------------------------------------------------------------------
## SCRIPT: Clustering de clientes RFM.R
## CURSO: Master en Data Science
## PROFESOR: Antonio Pita
## Paquetes Necesarios: forecast
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 1. Bloque de inicializacion de librerias y establecimiento de directorio #####

if (!require("forecast")){
  install.packages("forecast") 
  library(forecast)
}

## -------------------------------------------------------------------------

##### 2. Bloque de establecimiento de directorio #####

setwd("D:/Documentos, Trabajos y Demás/Formación/Kschool/201711 Clase V Master Data Science/6 Casos de Exito de Negocio")

## -------------------------------------------------------------------------

##### 3. Bloque de carga de datos #####

Ventas=read.csv2("./datos/Ventas.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 4. Bloque de revisión básica del dataset #####

str(Ventas)
summary(Ventas)
head(Ventas)
tail(Ventas)

## -------------------------------------------------------------------------

##### 5. Bloque de formateo de variables #####

Ventas$Producto=as.factor(Ventas$Producto)

#lct <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "Spanish_Spain.1252")

Ventas$Fecha=as.Date(Ventas$Fecha)

#Sys.setlocale("LC_TIME", lct)

str(Ventas)
head(Ventas)
summary(Ventas)

## -------------------------------------------------------------------------

##### 6. Bloque de selección de producto #####

Ventas_A0351=Ventas[Ventas$Producto=="A0351",]

str(Ventas_A0351)
head(Ventas_A0351)
summary(Ventas_A0351)

Ventas_A0351=Ventas_A0351[order(Ventas_A0351$Fecha),]
plot(Ventas_A0351$Cantidad, type="l")
plot(Ventas_A0351$Fecha,Ventas_A0351$Cantidad, type="l")

## -------------------------------------------------------------------------

##### 7. Bloque de selección de fecha de analisis y periodo #####

FECHA_ANALISIS=as.Date("2014-02-01")
PERIODO_PREVIO=140
PERIODO_PRUEBA=30

Ventas_A0351_HIS=Ventas_A0351[Ventas_A0351$Fecha<=FECHA_ANALISIS & Ventas_A0351$Fecha>FECHA_ANALISIS-PERIODO_PREVIO,]
Ventas_A0351_NEW=Ventas_A0351[Ventas_A0351$Fecha<=FECHA_ANALISIS + PERIODO_PRUEBA & Ventas_A0351$Fecha>FECHA_ANALISIS,c("Fecha","Cantidad")]

plot(Ventas_A0351_HIS$Fecha,Ventas_A0351_HIS$Cantidad, type="l")
plot(Ventas_A0351_NEW$Fecha,Ventas_A0351_NEW$Cantidad, type="l")

## -------------------------------------------------------------------------

##### 8. Bloque de formateo de serie #####

Ventas_ts = ts(Ventas_A0351_HIS$Cantidad,start=c(2013,1,1),frequency=7)
plot(Ventas_ts)
print(Ventas_ts)

## -------------------------------------------------------------------------

##### 9. Bloque de modelo Arima #####

model_arima=auto.arima(Ventas_ts,seasonal=TRUE,trace=TRUE)
plot(forecast(model_arima,h=24))
summary(model_arima)

Ventas_A0351_NEW$Arima=forecast(model_arima,h=PERIODO_PRUEBA)$mean

## -------------------------------------------------------------------------

##### 10. Bloque de modelo Media Movil #####

model_ma=ma(Ventas_ts,order=3)
summary(model_ma)
plot(forecast(model_ma, fan=TRUE,h=24))
forecast(model_ma, level=c(80,95),h=24)

Ventas_A0351_NEW$MA=forecast(model_ma,h=PERIODO_PRUEBA)$mean

## -------------------------------------------------------------------------

##### 11. Bloque de modelo Holt-Winters #####

model_hw=HoltWinters(Ventas_ts)
summary(model_hw)
plot(forecast(model_hw, fan=TRUE,h=24))
forecast(model_hw,level=c(80,95),h=24)

Ventas_A0351_NEW$HW=forecast(model_hw,h=PERIODO_PRUEBA)$mean

## -------------------------------------------------------------------------

##### 12. Bloque de modelo lineal #####

model_tslm=tslm(Ventas_ts~trend + season,data=Ventas_ts)
summary(model_tslm)
plot(forecast(model_tslm, fan=TRUE,h=24))
forecast(model_tslm,level=c(80,95),h=24)

Ventas_A0351_NEW$tslm=forecast(model_tslm,h=PERIODO_PRUEBA)$mean

## -------------------------------------------------------------------------

##### 13. Bloque de presentación de resultados #####

YMAX=max(Ventas_A0351_NEW[,-1])
YMIN=min(Ventas_A0351_NEW[,-1])

plot(Ventas_A0351_NEW$Cantidad,type="l", ylim=c(YMIN,YMAX),lwd=2)
lines(c(Ventas_A0351_NEW$Arima),col="blue")
lines(c(Ventas_A0351_NEW$MA),col="red")
lines(c(Ventas_A0351_NEW$HW),col="green")
lines(c(Ventas_A0351_NEW$tslm),col="cyan")

Ventas_A0351_NEW

## -------------------------------------------------------------------------