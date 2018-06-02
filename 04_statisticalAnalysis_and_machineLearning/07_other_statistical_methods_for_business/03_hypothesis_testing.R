## -------------------------------------------------------------------------
## SCRIPT: Experimentos.R
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

##### 3. Bloque de carga de datos #####

Conversiones=read.csv2("./datos/Conversiones.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 4. Bloque de revisión basica del dataset #####

str(Conversiones)
head(Conversiones)
summary(Conversiones)

## -------------------------------------------------------------------------

##### 5. Bloque de formateo de variables #####

Conversiones$mes=as.factor(Conversiones$mes)

str(Conversiones)
head(Conversiones)
summary(Conversiones)

## -------------------------------------------------------------------------

##### 6. Bloque de analisis de exito de campaña #####

RESULTADOS=summarise(group_by(Conversiones,mes),
                 Contador=length(ID_CLIENTE),
                 Conversion=mean(microconversion,na.rm=TRUE),
                 PaginasVista=mean(pageviews,na.rm=TRUE)
)

RESULTADOS


t.test(Conversiones$microconversion[Conversiones$mes=="Marzo"],
       Conversiones$microconversion[Conversiones$mes=="Abril"])

t.test(Conversiones$pageviews[Conversiones$mes=="Marzo"],
       Conversiones$pageviews[Conversiones$mes=="Abril"])

## -------------------------------------------------------------------------

##### 7. Bloque de carga de datos #####

Acciones=read.csv2("./datos/Clientes con acción.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 8. Bloque de creación de variable Acción #####

Conversiones$Accion="NO"
Conversiones$Accion[Conversiones$ID_CLIENTE %in% Acciones$ID_CLIENTE]="SI"

## -------------------------------------------------------------------------

##### 9. Bloque de Análisis de éxito diferenciando los que han sido accionados de los que no #####

Conversiones_abril=Conversiones[Conversiones$mes=="Abril",c(1,3:5)]

RESULTADOS_abril=summarise(group_by(Conversiones_abril,Accion),
                     Contador=length(ID_CLIENTE),
                     Conversion=mean(microconversion,na.rm=TRUE),
                     PaginasVista=mean(pageviews,na.rm=TRUE)
)

RESULTADOS_abril


t.test(Conversiones_abril$microconversion[Conversiones_abril$Accion=="SI"],
       Conversiones_abril$microconversion[Conversiones_abril$Accion=="NO"])

t.test(Conversiones_abril$pageviews[Conversiones_abril$Accion=="SI"],
       Conversiones_abril$pageviews[Conversiones_abril$Accion=="NO"])

## -------------------------------------------------------------------------

##### 10. Bloque de Análisis de Resultados por grupos y fecha #####

Conversiones$Agreg=paste(Conversiones$mes,Conversiones$Accion)

RESULTADOS_evolucion=summarise(group_by(Conversiones,Agreg),
                           Contador=length(ID_CLIENTE),
                           Conversion=mean(microconversion,na.rm=TRUE),
                           PaginasVista=mean(pageviews,na.rm=TRUE)
)

RESULTADOS_evolucion

## -------------------------------------------------------------------------

##### 11. Bloque de Contraste Difference in Difference #####

Conversiones_marzo=Conversiones[Conversiones$mes=="Marzo",c(1,3:5)]

colnames(Conversiones_marzo)=c("ID_CLIENTE","pageviews_m","microconversion_m","Accion")
colnames(Conversiones_abril)=c("ID_CLIENTE","pageviews_a","microconversion_a","Accion")

Conversiones_merge=merge(Conversiones_marzo,Conversiones_abril)
head(Conversiones_merge)

Conversiones_merge$microconversion_Diff=Conversiones_merge$microconversion_a-Conversiones_merge$microconversion_m
Conversiones_merge$pageviews_Diff=Conversiones_merge$pageviews_a-Conversiones_merge$pageviews_m


t.test(Conversiones_merge$microconversion_Diff[Conversiones_merge$Accion=="SI"],
       Conversiones_merge$microconversion_Diff[Conversiones_merge$Accion=="NO"])

## -------------------------------------------------------------------------