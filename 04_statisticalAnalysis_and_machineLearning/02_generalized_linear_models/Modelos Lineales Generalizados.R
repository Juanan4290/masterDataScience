## -------------------------------------------------------------------------
## SCRIPT: Modelos Lineales Generalizados.R
## CURSO: Master en Data Science
## SESION: Modelos Lineales Generalizados
## PROFESOR: Antonio Pita Lozano
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 1. Bloque de inicializacion de librerias #####

if(!require("plyr")){
  install.packages("plyr")
  library("plyr")
}

if(!require("caTools")){
  install.packages("caTools")
  library("caTools")
}

if(!require("ROCR")){
  install.packages("ROCR")
  library("ROCR")
}

setwd("~/modelos_lineales_generalizados")

## -------------------------------------------------------------------------
##       PARTE 1: REGRESION BINOMIAL LOGIT/LOGISTICA
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 2. Bloque de carga de datos #####

bank=read.csv2("data/bank-full.csv")
##### datos extraidos de https://archive.ics.uci.edu/ml/datasets/bank+Marketing

## -------------------------------------------------------------------------

##### 3. Bloque de revisión basica del dataset #####

str(bank)
head(bank)
summary(bank)

## -------------------------------------------------------------------------

##### 4. Bloque de formateo de variables #####

bank$day=as.factor(bank$day)
bank$campaign=as.factor(bank$campaign)
bank$IndPrevio=as.factor(as.numeric(bank$pdays!=-1))

str(bank)
head(bank)
summary(bank)

## -------------------------------------------------------------------------

##### 5. Bloque de modelo de regresión logistica #####

modeloLogit=glm(y~job+marital+education+default+balance+housing+loan+contact+month+poutcome, data=bank,family=binomial(link="logit"))
summary(modeloLogit)

## -------------------------------------------------------------------------

##### 6. Bloque de selección de variables #####

modeloLogitFinal=step(modeloLogit,direction="both",trace=1)
summary(modeloLogitFinal)
anova(modeloLogitFinal,modeloLogit)

## -------------------------------------------------------------------------

##### 7. Bloque de interpretación de coeficientes #####

coef(modeloLogitFinal)

exp(coef(modeloLogitFinal))

exp(cbind(coef(modeloLogitFinal), confint(modeloLogitFinal,level=0.95)))  

## -------------------------------------------------------------------------

##### 8. Bloque de modificación de caso base #####

bank$job=relevel(bank$job,ref="housemaid")
bank$marital=relevel(bank$marital,ref="married")
bank$housing=relevel(bank$housing,ref="yes")
bank$loan=relevel(bank$loan,ref="yes")
bank$contact=relevel(bank$contact,ref="unknown")
bank$month=relevel(bank$month,ref="jan")

modeloLogit=glm(y~job+marital+education+default+balance+housing+loan+contact+month+poutcome, data=bank,family=binomial(link="logit"))
summary(modeloLogit)
modeloLogitFinal=step(modeloLogit,direction="both",trace=0)
summary(modeloLogitFinal)

coef(modeloLogitFinal)

exp(coef(modeloLogitFinal))

exp(cbind(coef(modeloLogitFinal), confint(modeloLogitFinal,level=0.95))) 

## -------------------------------------------------------------------------
##       PARTE 2: REGRESION BINOMIAL PROBIT
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 9. Bloque de modelo de regresión probit #####

modeloProbit=glm(y~job+marital+education+default+balance+housing+loan+contact+month+poutcome, data=bank,family=binomial(link="probit"))
summary(modeloProbit)

## -------------------------------------------------------------------------

##### 10. Bloque de diferencias entre la función link del logit y el probit #####

X=seq(from=-4,to=4,by=0.1)
sigmoide=1/(1+exp(-X))
cumulative<-pnorm(X, 0, 1)
plot(sigmoide,type="l",col="red")
lines(cumulative,col="blue")

## -------------------------------------------------------------------------

##### 11. Bloque de selección de variables #####

modeloProbitFinal=step(modeloProbit,direction="both",trace=1)
summary(modeloProbitFinal)
anova(modeloProbitFinal,modeloProbit)

## -------------------------------------------------------------------------
##       PARTE 3: REGRESION POISSON
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 12. Bloque de carga de datos #####

bicis=read.csv("data/hour.csv")
##### datos extraidos de https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset

## -------------------------------------------------------------------------

##### 13. Bloque de revisión basica del dataset #####

str(bicis)
head(bicis)
summary(bicis)

## -------------------------------------------------------------------------

##### 14. Bloque de modelos de regresión poisson #####

hist(bicis$cnt)
mean(bicis$cnt)
sd(bicis$cnt)

modeloPoisson=glm(cnt~.-instant-dteday, family=poisson(link = "log"),data=bicis)
summary(modeloPoisson)

## -------------------------------------------------------------------------

##### 15. Bloque de formateo de variables #####

bicis$season=as.factor(bicis$season)
bicis$yr=as.factor(bicis$yr)
bicis$mnth=as.factor(bicis$mnth)
bicis$hr=as.factor(bicis$hr)
bicis$holiday=as.factor(bicis$holiday)
bicis$weekday=as.factor(bicis$weekday)
bicis$workingday=as.factor(bicis$workingday)
bicis$weathersit=as.factor(bicis$weathersit)

## -------------------------------------------------------------------------

##### 16. Bloque de modelo de regresión poisson #####

modeloPoisson=glm(cnt~.-instant-dteday, family=poisson(link = "log"),data=bicis)
summary(modeloPoisson)

## -------------------------------------------------------------------------

##### 17. Bloque de selección automática de variables #####

modeloPoissonFinal=step(modeloPoisson,direction="both",trace=1)
anova(modeloPoisson,modeloPoissonFinal)

## -------------------------------------------------------------------------

##### 18. Bloque de interpretación de coeficientes #####

coef(modeloPoissonFinal)
exp(coef(modeloPoissonFinal))

## -------------------------------------------------------------------------

##### 19. Bloque de selección de variables #####

modeloPoisson=glm(cnt~.-instant-dteday-casual-registered, family=poisson(link = "log"),data=bicis)
summary(modeloPoisson)
modeloPoissonFinal=step(modeloPoisson,direction="both",trace=1)
anova(modeloPoisson,modeloPoissonFinal)

## -------------------------------------------------------------------------

##### 20. Bloque de cálculo de predicciones #####

bicis$prediccion=predict(modeloPoissonFinal,type="response")

## -------------------------------------------------------------------------

##### 21. Bloque de representación de distribución #####

Caso=5 #35,
bicis[Caso,]

lambda=bicis$prediccion[Caso]
lambda

plot(dpois(1:120,lambda), type="l")
round(dpois(1:120,lambda),4)*100

## -------------------------------------------------------------------------
##       PARTE 4: REGRESION LOGISTICA: MODELO PREDICTIVO
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 22. Bloque de creación de conjuntos de entrenamiento y test #####

set.seed(1234)
SAMPLE = sample.split(bank$y, SplitRatio = .75)
bankTrain = subset(bank, SAMPLE == TRUE)
bankTest = subset(bank, SAMPLE == FALSE)

## -------------------------------------------------------------------------

##### 23. Bloque de modelos de regresión lineal generalizados #####

modeloLogitTrain=glm(y~job+marital+education+default+balance+housing+loan+contact+month+poutcome, data=bankTrain,family=binomial(link="logit"))
summary(modeloLogitTrain)

## -------------------------------------------------------------------------

##### 24. Bloque de evaluación de los modelos #####

bankTrain$prediccion=predict(modeloLogitTrain,type="response")
Predauxiliar= prediction(bankTrain$prediccion, bankTrain$y, label.ordering = NULL)
auc.tmp = performance(Predauxiliar, "auc");
aucModeloLogittrain = as.numeric(auc.tmp@y.values)
aucModeloLogittrain

CurvaRocModeloLogitTrain <- performance(Predauxiliar,"tpr","fpr")
plot(CurvaRocModeloLogitTrain,colorize=TRUE)
abline(a=0,b=1)

## Indice de GINI
GINItrain=2*aucModeloLogittrain-1

bankTest$prediccion=predict(modeloLogitTrain, newdata=bankTest,type="response")
Predauxiliar = prediction(bankTest$prediccion, bankTest$y, label.ordering = NULL)
auc.tmp = performance(Predauxiliar, "auc");
aucModeloLogittest = as.numeric(auc.tmp@y.values)
aucModeloLogittest

CurvaRocModeloLogitTest <- performance(Predauxiliar,"tpr","fpr")
plot(CurvaRocModeloLogitTest,colorize=TRUE)
abline(a=0,b=1)

## Indice de GINI
GINItest=2*aucModeloLogittest-1

## Capacidad del Modelo
mean(as.numeric(bankTest$y)-1)
aggregate(bankTest$prediccion~bankTest$y,FUN=mean)

## -------------------------------------------------------------------------