######## Estimación media poblacional ############

N=1e6
poblacion=rnorm(N,108,5) #distribución de la altura de niñas de 5 años en la población 
n=200 #tamaño muestral

      # Estimación puntual
muestra0=sample(poblacion,n) #muestreo simple
mean(muestra0) #media muestral de la altura
mean(muestra0<100) #proporcioón muestral de niñas con un altura inferior a 1 metro

      #distribución de la media muestral
K=1000 #Número de muestras 
medias=replicate(K,mean(sample(poblacion,n))) 
hist(medias,ylab="frecuencia",xlab="Media muestral") 

      #estimación por intervalos
t.test(muestra0) #proporciona intervalo de confianza
t.test((muestra0<100))

##### Determinación del tamaño muestral
e=.5 #margen de error
alfa=.05 # (1-alfa) es el nivel de confianza
sigma=6 # acotamos la desviación tipica
z=qnorm(1-alfa/2) #cuantil de la normal
n=ceiling(z^2/e^2*sigma^2)
muestra1=sample(poblacion,n) #muestreo simple
intervalo=t.test(muestra1)$conf.int
intervalo
diff(intervalo)/2 #semi-longitud del interval: margen de error 

##### Contraste unilateral
N=1e6
poblacion=rnorm(N,325,10) #distribución del contenido de las botellas de coca-cola
n=50 #tamaño muestral
muestra3=sample(poblacion,n) #muestreo simple
t.test(muestra3,alternative="less",mu=330)

##### Contraste bilateral
t.test(muestra3,mu=330)

##### Comparación de medias
N=1e6
poblacionA=rnorm(N,15,10);poblacionB=rnorm(N,20,10) 
nA=50;nB=30 #tamaños muestrales
muestraA=sample(poblacionA,nA) 
muestraB=sample(poblacionB,nB) 
t.test(muestraA,muestraB,alternative="less")


