require(data.table)

######## Muestreo simple ############
sample(1:10,5)

########
N=10000
poblacion=rnorm(N,108,5)
n=200 #tamaño muestral
muestra=sample(poblacion,n)
mean(muestra)
t.test(muestra)

######## Muestreo simple con reposición ############
sample(1:10,5,replace=TRUE)

#######
muestra=sample(poblacion,n,replace=TRUE)
mean(muestra)
t.test(muestra)

######## Muestreo sistematico
r=sample(1:N,1) #arranque
k=round(N/n)
indices=seq(r,r+(n-1)*k,k)
indices2=ifelse(indices<N,indices,indices-10000)
indices2
muestra=poblacion[indices2]
mean(muestra)
t.test(muestra)

######## Muestreo estratificado ############
######## Uso de la base de datos "diamonds" del paquete ggplot2 ### 
require(ggplot2)
DT=data.table(diamonds)
DT[,id:=rownames(.SD)]
dcast(DT,cut~.)
DT[,.(id=sample(id,10)),by=cut] #muestreo estratificado por calidad del diamante

######## Muestreo estratificado con afijación proporcional
N=nrow(DT)
n=50
DT[,Nk:=.N,by=cut]
DT[,.(id=sample(id,round(n*Nk/N))),by=cut]

####### Muestreo estratificado por calidad y color del diamante

DT[,Nk:=.N,by=.(cut,color)]
muestra=DT[,.(id=sample(id,round(n*Nk/N))),by=.(cut,color)]
muestra.dt=merge(muestra,DT,by=c("id","cut","color"),all.x=TRUE)
muestra.dt[,mean(price)] #media estratificada del precio


######## Muestreo por conglomerado (aqui, por origen del diamante)
DT[,origen:=sample(state.name,nrow(DT),replace=TRUE)] #se asigna de manera artificial un estado (americano) a cada diamante
n=10
DT[,Nk:=.N,by=origen] 
muestraO=sample(DT$origen,n) #Primero se muestrean los estados
DT2=subset(DT,origen %in% muestraO)
muestraID=DT2[ ,.(id=sample(id,min(5,Nk))),by=origen] #Luego los diamantes (5 por cada estado seleccionado)
