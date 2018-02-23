library(nycflights13) # Cargamos el dataset que vamos a usar
library(dplyr) # Usaremos dplyr

# head coge los primero registros de un dataset, así que lo usamos para
# hacer un dataset de juguete en myFlights. Además nos quedamos sólo con
# origin y dest
myFlights <- flights %>% head %>% select(origin,dest)

# nycflights13 no sólo tiene flights, también tiene otro dataset
# llamado airports que contiene los datos de cada aeropuerto.
View(airports)

# Cuando se da una situación como esta en la que hay dos tablas relacionadas
# por una o más columnas hay que pensar en si es relevante cruzar estas tablas
# (conocido como JOIN).
# En este caso cada vuelo está relacionado naturalmente con dos aeropuertos,
# el de salida y el de llegada.
# Esto no es muy frecuente (que haya dos relaciones con la misma tabla)
# Pero lo enseño como ejemplo para que veáis que es posible.

# También es posible cruzar una tabla con otras dos distintas. O cualquier tipo
# de relación que se os ocurra

# Algunos ejemplos:
# Salas <----> Horario <---> Asignatura <---> Profesor
# aeropuertos <--(de destino)--> Vuelo <--(de origen)--> aeropuertos
# hospitales <----> pacientes <---> historial médico

# Vamos a cruzar los vuelos con aeropuertos. Para ello tienes que saber
# el nombre de las columnas que se cruzan en cada dataset
# En este caso es "origin" en vuelos y "faa" en airports.

# merge siempre tiene un dataset X e Y (en ese orden)
# y tienes que decirle las columnas con esos nombres:
# by.x y by.y
myFlights2 <- merge(x=myFlights, y=airports,
      by.x = "origin", by.y = "faa") # Fijate en el entrecomillado

# Lo que hace este proceso es añadir las columnas del otro dataset
# según corresponda. Fijate en el nombre del aeropuerto comparado con origin:
# origin dest                name      lat       lon alt tz dst            tzone
# 1    EWR  IAH Newark Liberty Intl 40.69250 -74.16867  18 -5   A America/New_York
# 2    EWR  ORD Newark Liberty Intl 40.69250 -74.16867  18 -5   A America/New_York
# 3    JFK  MIA John F Kennedy Intl 40.63975 -73.77893  13 -5   A America/New_York
# 4    JFK  BQN John F Kennedy Intl 40.63975 -73.77893  13 -5   A America/New_York
# 5    LGA  IAH          La Guardia 40.77725 -73.87261  22 -5   A America/New_York
# 6    LGA  ATL          La Guardia 40.77725 -73.87261  22 -5   A America/New_York


# Ahora vamos a hacer lo mismo pero con destino
myFlights3 <- merge(x=myFlights2, y=airports,
                    by.x = "dest", by.y = "faa")


# Si te fijas en el dataset:
# dest origin              name.x                          name.y
# 1  ATL    LGA          La Guardia Hartsfield Jackson Atlanta Intl
# 2  IAH    EWR Newark Liberty Intl    George Bush Intercontinental
# 3  IAH    LGA          La Guardia    George Bush Intercontinental
# 4  MIA    JFK John F Kennedy Intl                      Miami Intl
# 5  ORD    EWR Newark Liberty Intl              Chicago Ohare Intl

# Como hay conflicto de nombres (porque has cruzado dos veces la misma tabla)
# merge añade un ".x" y ".y" al final de cada uno.
# Puedes cambiar este sufijo con el parámetro suffixes:

myFlights3 <- merge(x=myFlights2, y=airports,
                    by.x = "dest", by.y = "faa",
                    suffixes = c("_orig", "_dest"))
# dest origin           name_orig                       name_dest
# 1  ATL    LGA          La Guardia Hartsfield Jackson Atlanta Intl
# 2  IAH    EWR Newark Liberty Intl    George Bush Intercontinental
# 3  IAH    LGA          La Guardia    George Bush Intercontinental
# 4  MIA    JFK John F Kennedy Intl                      Miami Intl
# 5  ORD    EWR Newark Liberty Intl              Chicago Ohare Intl

# Para repasar dplyr: Si os fijáis estamos encadenando funciones. Hacíamos
# un cálculo lo guardabamos en myFlights, luego otra operación e iba
# a myFlights2,...
# Eso es lo que hace el operador tubería! %>%

myFlights3 <- 
  myFlights %>%
    merge(y=airports,
          by.x = "origin", by.y = "faa") %>%
    merge(y=airports,
          by.x = "dest", by.y = "faa",
          suffixes = c("_orig", "_dest")) %>%
    select(starts_with("name"), origin, dest)

# Cuando haces un cruce entre dos tablas si miras cada registro por
# separado pueden pasar 2 cosas: que esté en una tabla sola,
# que esté en ambas.
# Dependiendo de qué hagas en cada caso el cruce es distinto:
# - si te quedas sólo los que estén en ambas tablas (se llama Inner Join)
# - con todos los de un lado (Left o Right Join)
# - con todos de ambos lados crucen o no crucen (full join)
# más info en: https://www.w3schools.com/sql/sql_join.asp
# Esta terminilogía viene de SQL, no se usa en R pero es útil
# conocerla y saber sus diferencias.


# Si no especificas nada, merge sólo se queda con los que están
# en ambas tablas (inner join).
# Para cambiar este comportamiento existe el parámetro all.x y
# all.y. Sobre x e y ya hemos hablado.
# all señala si quieres conservar TODAS las filas de las
# respectivas tablas al hacer el cruce.

# Por ejemplo, al hacer este merge con all.x a TRUE...
myFlights %>%
  merge(y=airports, by.x = "dest", by.y = "faa", all.x=T)
 
# dest origin                            name      lat       lon  alt tz  dst            tzone
# 1  ATL    LGA Hartsfield Jackson Atlanta Intl 33.63672 -84.42807 1026 -5    A America/New_York
# 2  BQN    JFK                            <NA>       NA        NA   NA NA <NA>             <NA>
# 3  IAH    EWR    George Bush Intercontinental 29.98443 -95.34144   97 -6    A  America/Chicago
# 4  IAH    LGA    George Bush Intercontinental 29.98443 -95.34144   97 -6    A  America/Chicago
# 5  MIA    JFK                      Miami Intl 25.79325 -80.29056    8 -5    A America/New_York
# 6  ORD    EWR              Chicago Ohare Intl 41.97860 -87.90484  668 -6    A  America/Chicago

# Si os fijáis en el segundo registro, en el de BQN (que antes no aparecía)
# no ha encontrado el cruce correcto en airports y deja las columnas a NA
# en vez de eliminar la fila.

# Puedes dejar all.x y all.y ambos a TRUE.

# Un truco práctico que se suele usar mucho en procesos de Big Data
# es hacer cruces tipo inner join (all.x y all.y a FALSE) y contar
# el número de filas.
# Normalmente se intenta que no se reduzca el número de filas,
# eso significa que no se van perdiendo datos debido a que el
# cruce no se está realizando correctamente.




