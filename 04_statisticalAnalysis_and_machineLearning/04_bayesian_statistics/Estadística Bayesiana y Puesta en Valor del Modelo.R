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
##       PARTE 2: Estadística Bayesiana: Naive Bayes
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 16. Bloque de carga de datos #####

bank=read.csv2("data/bank-full.csv")
##### datos extraidos de https://archive.ics.uci.edu/ml/datasets/bank+Marketing

## -------------------------------------------------------------------------

##### 17. Bloque de revisión basica del dataset #####

str(bank)
head(bank)
summary(bank)

## -------------------------------------------------------------------------

##### 18. Bloque de formateo de variables #####

bank$day=as.factor(bank$day)
bank$campaign=as.factor(bank$campaign)
bank$IndPrevio=as.factor(as.numeric(bank$pdays!=-1))

str(bank)
head(bank)
summary(bank)

## -------------------------------------------------------------------------

##### 19. Bloque de creación de conjuntos de entrenamiento y test #####

set.seed(1234) 
SAMPLE = sample.split(bank$y, SplitRatio = .75)
bankTrain = subset(bank, SAMPLE == TRUE)
bankTest = subset(bank, SAMPLE == FALSE)

## -------------------------------------------------------------------------

##### 20. Bloque de modelo Naive Bayes #####

modeloBayesTrain=naiveBayes(y~job+marital+education+default+balance+housing+loan+contact+month+poutcome, data=bankTrain,family=binomial(link="Bayes"))

modeloBayesTrain

## -------------------------------------------------------------------------

##### 21. Bloque de evaluación de los modelos #####

bankTrain$predDefecto <- predict(modeloBayesTrain,bankTrain)
bankTrain$prediccion <- predict(modeloBayesTrain,bankTrain,type="raw")[,2]
Predauxiliar= prediction(bankTrain$prediccion, bankTrain$y, label.ordering = NULL)
auc.tmp = performance(Predauxiliar, "auc");
aucModeloBayestrain = as.numeric(auc.tmp@y.values)
aucModeloBayestrain

CurvaRocModeloBayesTrain <- performance(Predauxiliar,"tpr","fpr")
plot(CurvaRocModeloBayesTrain,colorize=TRUE)
abline(a=0,b=1)

## Indice de GINI
GINItrain=2*aucModeloBayestrain-1


bankTest$predDefecto <- predict(modeloBayesTrain,bankTest)
bankTest$prediccion <- predict(modeloBayesTrain,bankTest,type="raw")[,2]
Predauxiliar = prediction(bankTest$prediccion, bankTest$y, label.ordering = NULL)
auc.tmp = performance(Predauxiliar, "auc");
aucModeloBayestest = as.numeric(auc.tmp@y.values)
aucModeloBayestest

CurvaRocModeloBayesTest <- performance(Predauxiliar,"tpr","fpr")
plot(CurvaRocModeloBayesTest,colorize=TRUE)
abline(a=0,b=1)

## Indice de GINI
GINItest=2*aucModeloBayestest-1

## Capacidad del Modelo
mean(as.numeric(bankTest$y)-1)
aggregate(bankTest$prediccion~bankTest$y,FUN=mean)

## -------------------------------------------------------------------------
##       PARTE 3: MODELO DE CLASIFICACIÓN: PUESTA EN VALOR DEL MODELO
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 22. Bloque de puesta en valor de un modelo: Fijación del Threshold #####

ALPHA=0.5
ConfusionTest=table(bankTest$y,bankTest$prediccion>=ALPHA)
AccuracyTest= (sum(bankTest$y=="yes" & bankTest$prediccion>=ALPHA)+sum(bankTest$y=="no" & bankTest$prediccion<ALPHA))/length(bankTest$y)
PrecisionTest=sum(bankTest$y=="yes" & bankTest$prediccion>=ALPHA)/sum(bankTest$prediccion>=ALPHA)
CoberturaTest=sum(bankTest$y=="yes" & bankTest$prediccion>=ALPHA)/sum(bankTest$y=="yes")
ConfusionTest
AccuracyTest
PrecisionTest
CoberturaTest

ALPHA=0.2
ConfusionTest=table(bankTest$y,bankTest$prediccion>=ALPHA)
AccuracyTest= (sum(bankTest$y=="yes" & bankTest$prediccion>=ALPHA)+sum(bankTest$y=="no" & bankTest$prediccion<ALPHA))/length(bankTest$y)
PrecisionTest=sum(bankTest$y=="yes" & bankTest$prediccion>=ALPHA)/sum(bankTest$prediccion>=ALPHA)
CoberturaTest=sum(bankTest$y=="yes" & bankTest$prediccion>=ALPHA)/sum(bankTest$y=="yes")
ConfusionTest
AccuracyTest
PrecisionTest
CoberturaTest

ALPHA=0.8
ConfusionTest=table(bankTest$y,bankTest$prediccion>=ALPHA)
AccuracyTest= (sum(bankTest$y=="yes" & bankTest$prediccion>=ALPHA)+sum(bankTest$y=="no" & bankTest$prediccion<ALPHA))/length(bankTest$y)
PrecisionTest=sum(bankTest$y=="yes" & bankTest$prediccion>=ALPHA)/sum(bankTest$prediccion>=ALPHA)
CoberturaTest=sum(bankTest$y=="yes" & bankTest$prediccion>=ALPHA)/sum(bankTest$y=="yes")
ConfusionTest
AccuracyTest
PrecisionTest
CoberturaTest

## -------------------------------------------------------------------------

##### 23. Bloque de puesta en valor de un modelo: KS y punto de máxima separación #####

bankKS=bankTest[order(bankTest$prediccion, decreasing=TRUE),c("y","prediccion")]
bankKS$N=1:length(bankKS$y)
bankKS$EXITOSACUM=cumsum(as.numeric(bankKS$y)-1)
bankKS$FRACASOSACUM=bankKS$N-bankKS$EXITOSACUM
bankKS$EXITOSTOT=sum(bankKS$y=="yes")
bankKS$FRACASOSTOT=sum(bankKS$y=="no")
bankKS$TOTAL=bankKS$EXITOSTOT+bankKS$FRACASOSTOT
bankKS$TPR=bankKS$EXITOSACUM/bankKS$EXITOSTOT
bankKS$FPR=bankKS$FRACASOSACUM/bankKS$FRACASOSTOT
bankKS$DIFF=bankKS$TPR-bankKS$FPR
plot(bankKS$DIFF)
max(bankKS$DIFF)
which(bankKS$DIFF==max(bankKS$DIFF))
bankKS[2764,]

plot(bankKS$prediccion*1000,1-bankKS$TPR,xlab="SCORE",ylab="Porcentaje acumulado",main="Distribuciones por Score (rojo malos, azul buenos)",type="l",col="blue")
lines(bankKS$prediccion*1000,1-bankKS$FPR,col="red")

## -------------------------------------------------------------------------

##### 24. Bloque de puesta en valor de un modelo: F1Score y punto óptimo estadístico #####

bankKS$Accuracy=(bankKS$EXITOSACUM+bankKS$FRACASOSTOT-bankKS$FRACASOSACUM)/bankKS$TOTAL
bankKS$Precision=bankKS$EXITOSACUM/bankKS$N
bankKS$Cobertura=bankKS$EXITOSACUM/bankKS$EXITOSTOT
bankKS$F1Score=2*(bankKS$Precision*bankKS$Cobertura)/(bankKS$Precision+bankKS$Cobertura)
plot(bankKS$F1Score)
max(bankKS$F1Score,na.rm=TRUE)
which(bankKS$F1Score==max(bankKS$F1Score,na.rm=TRUE))
bankKS[1475,]

ALPHAS=seq(0,1,0.05)
Accuracy=c()
Precision=c()
Cobertura=c()
F1Score=c()
for (i in 1:length(ALPHAS)){
  ALPHA=ALPHAS[i]
  Confusion=table(bankKS$y,bankKS$prediccion>=ALPHA)
  Accuracy=c(Accuracy,(sum(bankKS$y=="yes" & bankKS$prediccion>=ALPHA)+sum(bankKS$y=="no" & bankKS$prediccion<ALPHA))/length(bankKS$y))
  Precision=c(Precision,sum(bankKS$y=="yes" & bankKS$prediccion>=ALPHA)/sum(bankKS$prediccion>=ALPHA))
  Cobertura=c(Cobertura,sum(bankKS$y=="yes" & bankKS$prediccion>=ALPHA)/sum(bankKS$y=="yes"))
}
F1Score=2*(Precision*Cobertura)/(Precision+Cobertura)
DFF1=data.frame(ALPHAS,Accuracy,Precision,Cobertura,F1Score)

DFF1

## -------------------------------------------------------------------------

##### 25. Bloque de puesta en valor de un modelo: Beneficio y punto óptimo financiero #####

costeLlamada=10
beneficioVenta=100

bankKS$BeneficioTP=beneficioVenta-costeLlamada
bankKS$BeneficioTN=0
bankKS$PerdidaFP=-costeLlamada
bankKS$PerdidaFN=-beneficioVenta

bankKS$BeneficioFinan=bankKS$EXITOSACUM*bankKS$BeneficioTP+
  bankKS$FRACASOSACUM*bankKS$PerdidaFP

bankKS$Oportunidad=bankKS$EXITOSACUM*bankKS$BeneficioTP+
  (bankKS$EXITOSTOT-bankKS$EXITOSACUM)*bankKS$PerdidaFN+
  bankKS$FRACASOSACUM*bankKS$PerdidaFP+
  (bankKS$FRACASOSTOT-bankKS$FRACASOSACUM)*bankKS$BeneficioTN

plot(bankKS$BeneficioFinan)
max(bankKS$BeneficioFinan)
which(bankKS$BeneficioFinan==max(bankKS$BeneficioFinan))
bankKS[3646,]

plot(bankKS$Oportunidad)
max(bankKS$Oportunidad)
which(bankKS$Oportunidad==max(bankKS$Oportunidad))
bankKS[8755,]

## -------------------------------------------------------------------------