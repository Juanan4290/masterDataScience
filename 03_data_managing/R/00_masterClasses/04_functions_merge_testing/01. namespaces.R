## Breve recordatorio de las anteriores clases:
# Namespaces (o espacio de nombres), es un problema en general de
# cualquier lenguaje de programación.
# ¿Cómo sabe R a qué haces referencia cuando escribes el nombre de una variable?
# Si hay más de un objeto que se llama de la misma manera ¿cómo los distingues?

# La forma más frecuente de ver este problema en R es al cargar varias librerías
# Cada vez que cargas una librería, pones todo el namespace de esa librería
# (es decir, todos sus objetos, funciones, etc) en tu espacio global.

# A hacer esto, puede que dos paquetes o más tengan un conflicto de nombres.
# Es decir, que dos paquetes llamen a algo con el mismo nombre.
# Podéis verlo al cargar estas librerías, por ejemplo:
library(MASS)
library(dplyr)

# Aparece un warning (mensaje en rojo) que dice lo siguiente:
#
# Attaching package: ‘dplyr’
# 
# The following object is masked from ‘package:MASS’:
#   
#   select

# Este mensaje quiere decir que el nombre "select" se usa tanto en dplyr
# como en MASS, por tanto cuando cargas los dos ¿Cómo sabe R a cuál te refieres?
# El mensaje en concreto dice que estás "enmascarando" (tapando) el select
# de MASS con el de dplyr.
# Es decir, siempre vas a tomar el del paquete más reciente.

# Una forma de evitar esto es referenciar a los objetos con el operador ::
# que te permite decir de que paquete provienen. Por ejemplo:
ggplot2::aes()
# Esta sintáxis funciona sin haber cargado el paquete (library) pero es necesario
# pero necesita que esté instalado (obviamente)

# Otra forma de gestionar el espacio es ir borrando las variables que ya no
# son necesarias.
a <- 1
rm("a") # Borramos a. Fijate que va entrecomillada, pero también funciona sin comillas


# Si os fijáis en la primera línea del mensaje de error decía:
# Attaching package: ‘dplyr’. attach es el término técnico para incrustar
# todo un espacio de nombres en otro. Como hacemos con library.

# Los attaches se pueden hacer con otros objetos que no son librerías.
# En general cualquier objeto con nombres, el ejemplo clásico que además ya conocéis
# son las listas, pero también funciona con dataframes (que ya sabéis que son listas)
miLista <- list(a=1, b="hola")

# Este attach se puede hacer de dos maneras:
# la buena (y que casi nadie hace) es usando "with" y la mala (más frecuente)
# usando "attach".

# with es en cierta medida similar al with de python. El de R es más específico.
# Lo que hace es tomar el espacio de nombres que le des y ejecutar la expresión
# usando este espacio de nombres

with(miLista, {
  a + 5 # resultado 6 porque coge la a de la lista
  
  # podríais escribir más líneas...
})

# La otra opción es cargar la lista en el espacio de nombres general con attach
# y cuando finalices eliminarlo con detach.

attach(miLista)
a+1
b
detach(miLista)

b # Fallo! porque no existe fuera de miLista

# La opción detach y attach no es recomendado, de hecho muchas guias de estilo
# desaconsejan su uso.
# Es bastante fácil olvidarse de hacer el dettach o no recordar cuales has hecho
# o cambiar la lista y no acordarte que has "pisado" un nombre que ya existía.
# En general, es difícil leer y razonar sobre el código fuente si hay attach y
# dettach.
# MUY POCO recomendable. Pero lo leeréis en códigos de otros, por eso es
# recomendable que lo conozcáis.


# Por último ¿qué pasa si hay dos objetos con el mismo nombre en el espacio
# de nombres que haces attach y en el global?
# Pues depende de si es con attach o con with. Veamos cada caso:

a <- 10 # la a de global es 10
miLista <- list(a=1, b="hola") # la a de la lista es 1
attach(miLista) 

a # Sale 10 y no 1. Es decir, primero siempre va el global enviroment y luego
# los espacios de nombres "atacheados"

a <- a + 1 # De nuevo, hace referencia al global, así que este cambio
# se aplica en el global y no en miLista.

detach(miLista)

# En RStudio si vas a la pestaña "Enviroment"  y pulsas sobre "Global enviroment"
# puedes ver la lista de espacios de nombres ordenadas (se lee de arriba a abajo)
# y cuando R busque una variable la buscará en ese orden.
# Otra manera de ver esta lista es con la función search:
search()

# Como he dicho, no recomiendo (y nadie) attach. With tiene un comportamiento
# más predecible y comunmente aceptado (p.e: en Python es así también con with).

with(miLista, { # explicitamente pides usar el espacio de miLista
  
  # a vale 1 porque lo toma de la lista EN VEZ DE tomarlo del entorno global.
  # al contrario que attach, que no ponía por delante tu lista al entorno global.
  a
})

# Última advertencia. No penséis que al tener una lista atacheada guardáis las nuevas
# variables en esa lista. Ver los ejemplos:

attach(miLista)
k <- 99 # no se guarda en miLista, sino en Global Enviroment
detach(miLista)

miLista$k # no existe
k # sí existe


with(miLista, {
  m <- 10000 + a
})
miLista$m # no existe
m # TAMPOCO existe (con with las variables que generas dentro "se pierden")


# Si has llegado hasta aquí con miedo a todos estos detalles no te preocupes:
# - Usa nombres de variables buenos: contadorFilas, acumuladorMediaEdad, 
#   vuelosFiltrado, ... son nombres buenos.
#   datos, datos1, proceso,... son nombres malos porque te equivocarás al usarlos
# - Estructura bien tu código en funciones y fichero (lo veremos más adelante)
# - Mantén tu enviroment limpio (bórralo cada cierto tiempo)
# - Sigue una nomenclatura lógica y consistente
#
# Si haces eso no necesitarás pensar en attach ni with y tu código dará gusto
# leerlo.