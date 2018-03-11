## -------------------------------------------------------------------------
## SCRIPT: Introducción a la Modelización Estadística.R
## CURSO: Master en Data Science
## SESIÓN: Introducción a la Modelización Estadística
## PROFESOR: Antonio Pita Lozano
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 1. Bloque de inicializacion de librerias #####

if(!require("ggplot2")){
  install.packages("ggplot2")
  library("ggplot2")
}

if (!require("gap")){
  install.packages("gap")
  library(gap)
}

setwd("C:/Users/Juan Antonio/Documents/modelización_estadística")

## -------------------------------------------------------------------------
##       PARTE 1: INTRODUCCIÓN A LA REGRESION LINEAL
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 2. Bloque de carga de datos #####

creditos=read.csv("data/creditos.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 3. Bloque de revisión basica del dataset #####

str(creditos)
head(creditos)
summary(creditos)

## -------------------------------------------------------------------------

##### 4. Bloque de tratamiento de variables #####

creditos$Gender=as.factor(creditos$Gender)
creditos$Mortgage=as.factor(creditos$Mortgage)
creditos$Married=as.factor(creditos$Married)
creditos$Ethnicity=as.factor(creditos$Ethnicity)

summary(creditos)

## -------------------------------------------------------------------------

##### 5. Bloque de test de diferencia de medias mediante regresion lineal #####

t.test(Income ~ Gender, data = creditos)

# mediante un modelo lineal
modeloT=lm(Income ~ Gender, data = creditos)
summary(modeloT)

## -------------------------------------------------------------------------

##### 6. Bloque de regresion lineal individual #####

modeloInd1=lm(Income ~ Rating, data = creditos)
summary(modeloInd1)

## -------------------------------------------------------------------------

##### 7. Bloque de representación gráfica #####

ggplot(creditos, aes(x = Rating, y = Income)) + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)

## -------------------------------------------------------------------------

##### 8. Bloque de regresion lineal otras variables #####

modeloInd2=lm(Income ~ Products, data = creditos)
summary(modeloInd2)

modeloInd3=lm(Income ~ Age, data = creditos)
summary(modeloInd3)

modeloInd4=lm(Income ~ Education, data = creditos)
summary(modeloInd4)

modeloInd5=lm(Income ~ Gender, data = creditos)
summary(modeloInd5)

modeloInd6=lm(Income ~ Mortgage, data = creditos)
summary(modeloInd6)

modeloInd7=lm(Income ~ Married, data = creditos)
summary(modeloInd7)

modeloInd8=lm(Income ~ Ethnicity, data = creditos)
summary(modeloInd8)

modeloInd9=lm(Income ~ Balance, data = creditos)
summary(modeloInd9)

## -------------------------------------------------------------------------

##### 9. Bloque de regresion lineal multiple #####

modeloGlobal=lm(Income ~ ., data = creditos)
summary(modeloGlobal)

## -------------------------------------------------------------------------

##### 10. Bloque de comparacion de modelos #####

anova(modeloInd1,modeloGlobal)

## -------------------------------------------------------------------------

##### 11. Bloque de Ejercicio #####

## ¿Cuales serian las variables que incluiriamos en el modelo?

modeloMultiple=lm(Income ~ Rating + Balance, data = creditos)
summary(modeloMultiple)

anova(modeloInd1,modeloMultiple)
anova(modeloMultiple,modeloGlobal)

## -------------------------------------------------------------------------

##### 12. Bloque de analisis del modelo #####

modeloFinal=lm(Income ~ Rating+Mortgage+Balance, data = creditos)
summary(modeloFinal)
plot(modeloFinal$residuals)
hist(modeloFinal$residuals)
qqnorm(modeloFinal$residuals); qqline(modeloFinal$residuals,col=2)
confint(modeloFinal,level=0.95)

cor(modeloFinal$residuals,creditos$Rating)
cor(modeloFinal$residuals,creditos$Balance)

boxplot(modeloFinal$residuals~creditos$Mortgage)
aggregate(modeloFinal$residuals~creditos$Mortgage,FUN=mean)

shapiro.test(modeloFinal$residual)

anova(modeloFinal,modeloGlobal)

## -------------------------------------------------------------------------

##### 13. Bloque de analisis de variable Balance #####

modeloBalance=lm(Balance ~ ., data = creditos)
summary(modeloBalance)

## -------------------------------------------------------------------------

##### 14. Bloque de ejercicio #####

## ¿Cuales serian las variables que incluiriamos en el modelo?

modeloBalanceFin=lm(Balance ~ Income + Rating + Age, data = creditos)
summary(modeloBalanceFin)

anova(modeloBalance,modeloBalanceFin)

## -------------------------------------------------------------------------

##### 15. Bloque de modelado (stepwise) backward #####

ModelAutoBackward=step(modeloBalance,direction="backward",trace=1)
summary(ModelAutoBackward)
ModelAutoStepwise=step(modeloBalance,direction="both",trace=1)
summary(ModelAutoStepwise)
anova(ModelAutoBackward,modeloBalance)
anova(ModelAutoStepwise,modeloBalance)

## -------------------------------------------------------------------------
##       PARTE 2: REGRESIÓN MULTIPLE:
##                  APLICACIONES AL ESTUDIO DE LA OFERTA y LA DEMANDA
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 16. Bloque de carga de datos #####

Ventas=read.csv2("data/ventas.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 17. Bloque de revisión basica del dataset #####

str(Ventas)
head(Ventas)
summary(Ventas)

## -------------------------------------------------------------------------

##### 18. Bloque de formateo de variables #####

Ventas$Fecha=as.Date(Ventas$Fecha)
Ventas$Producto=as.factor(Ventas$Producto)

str(Ventas)
head(Ventas)
summary(Ventas)

## -------------------------------------------------------------------------

##### 19. Bloque de Estimación de ventas en función al precio #####

modelo1=lm(Cantidad~Precio,data=Ventas)
summary(modelo1)

plot(modelo1$residuals)
smoothScatter(modelo1$residuals)
hist(modelo1$residuals)
qqnorm(modelo1$residuals); qqline(modelo1$residuals,col=2)

confint(modelo1,level=0.95)

## -------------------------------------------------------------------------

##### 20. Bloque de Estimación de semielasticidad de las ventas con respecto al precio #####

modelo2=lm(log(Cantidad)~Precio,data=Ventas)
summary(modelo2)
plot(modelo2$residuals)
smoothScatter(modelo2$residuals)
hist(modelo2$residuals)
qqnorm(modelo2$residuals); qqline(modelo2$residuals,col=2)
confint(modelo2,level=0.95)

## -------------------------------------------------------------------------

##### 21. Bloque de Estimación de elasticidad de las ventas con respecto al precio #####

modelo3=lm(log(Cantidad)~log(Precio),data=Ventas)
summary(modelo3)
plot(modelo3$residuals)
hist(modelo3$residuals)
qqnorm(modelo3$residuals); qqline(modelo3$residuals,col=2)
confint(modelo3,level=0.95)

## -------------------------------------------------------------------------
##       PARTE 3: REGRESIÓN LINEAL MULTIPLE: 
##                  ESTUDIO DE CAMBIOS ESTRUCTURALES
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 22. Bloque de análisis gráfico por tipo producto #####

plot(Ventas$Precio,Ventas$Cantidad)
abline(modelo1,col=2)
plot(modelo1$residuals,col=Ventas$Producto)
plot(modelo2$residuals,col=Ventas$Producto)
plot(modelo3$residuals,col=Ventas$Producto)

## -------------------------------------------------------------------------

##### 23. Bloque de análisis de estructuras por producto #####

modelo1_A0143=lm(Cantidad~Precio,data=Ventas[Ventas$Producto=="A0143",])
modelo1_A0351=lm(Cantidad~Precio,data=Ventas[Ventas$Producto=="A0351",])

plot(Ventas$Precio,Ventas$Cantidad)
abline(modelo1,col="red",lty = "dashed")
abline(modelo1_A0143,col="blue")
abline(modelo1_A0351,col="green")

summary(modelo1)
summary(modelo1_A0143)
summary(modelo1_A0351)

## -------------------------------------------------------------------------

##### 24. Bloque de contraste de Chow de diferencias estructurales #####

chow.test(Ventas$Cantidad[Ventas$Producto=="A0143"],Ventas$Precio[Ventas$Producto=="A0143"],Ventas$Cantidad[Ventas$Producto=="A0351"],Ventas$Precio[Ventas$Producto=="A0351"])

modelo1_Chow=lm(Cantidad~Precio*Producto,data=Ventas)

summary(modelo1)
summary(modelo1_Chow)

plot(modelo1$residuals,col=Ventas$Producto)
plot(modelo1_Chow$residuals,col=Ventas$Producto)

plot(Ventas$Precio,Ventas$Cantidad)
abline(modelo1,col="red",lty = "dashed")
abline(a=7264.56,b=-1139.53,col="blue")
abline(a=7264.56-3244.34,b=-1139.53+796.03,col="green")

anova(modelo1,modelo1_Chow)

## -------------------------------------------------------------------------
##       PARTE 3: REGRESIÓN MULTIPLE:
##                  OUTLIERS Y LA FALTA DE ROBUSTEZ
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 25. Bloque de creación de datos simulados #####

x=c(1,2,3,4,5,6,7,8,9,10)
y=3*x+2+rnorm(length(x),0,1)
Datos=data.frame(x,y)
modelolm=lm(y~x, data=Datos)
summary(modelolm)


xOut=c(x,15)
yOut=c(y,300)
DatosOut=data.frame(xOut,yOut)
modelolmOut=lm(yOut~xOut,data=DatosOut)
summary(modelolmOut)

modelolmOut=rlm(yOut~xOut,data=DatosOut)
summary(modelolmOut)
## -------------------------------------------------------------------------

##### 26. Bloque de representación gráfica #####

plot(xOut,yOut)
abline(modelolm,col="blue")
abline(modelolmOut,col="red")
abline(a=modelolm$coefficients[1],b=modelolm$coefficients[2],col="blue")
abline(a=modelolmOut$coefficients[1],b=modelolmOut$coefficients[2],col="red")

ggplot(Datos, aes(x = x, y = y)) + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)

ggplot(DatosOut, aes(x = xOut, y = yOut)) + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)

## -------------------------------------------------------------------------