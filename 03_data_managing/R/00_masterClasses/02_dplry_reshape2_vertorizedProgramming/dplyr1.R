library("dplyr")
library("nycflights13")
# require(dplyr) # es basicamente lo mismo que library

head(flights)
tail(flights)
dim(flights)

# expresiones regulares: https://regex101.com/

# Seleccionar todas las columnas que acaban por delay
colnames(flights)
flights[,grepl("_delay", colnames(flights))]

# Ejercicio 2: selecciona una muestra aleatoria de 10
runif
rnorm

sample.int(100,2)
sample(1:100,2)

flights[sample.int(nrow(flights), 10), grepl("_delay", colnames(flights))]

# muestra aleatoria de 10 y coger solo los carrier = UA
flightsUA <- flights[flights$carrier == "UA",grepl("_delay", colnames(flights))]
flightsUA[sample.int(nrow(flightsUA),10),]

# Offtopic
# IN

c(1,3) %in% 1:10


#### DPLYR
# verbo para seleccionar columnas: select
select(flights, carrier, arr_delay)

select(flights, ends_with("_delay"), carrier)
# ends_with
# starts_with
# contains
# matches

sample_n(
  select(flights, contains("_delay")),
  10)

# Mas refinado... con tuberias
select(flights, contains("_delay")) %>%
  sample_n(10)

# Mas refinado aun ...
flights %>%
  select(contains("_delay")) %>%
  sample_n(10)

# Filter para filtrar
flightsUA <- flights %>%
  filter(carrier = "UA") %>%
  select(contains("_delay")) %>%
  sample_n(10)

flightsUA %>%
  sample_n(1)

flights %>%
  sample_frac(0.05) # te da el porcentaje del total

flightsUA %>%
  select(arr_delay)

## Filtros: filter

# estas tres cosas hacen lo mismo
flights %>%
  filter(carrier == "UA", arr_delay > 1)

flights %>%
  filter(carrier == "UA") %>%
  filter(arr_delay > 1)

flights %>%
  filter(carrier == "UA" & arr_delay > 1)

# Ordenacion: arrange
flights %>%
  arrange(year)

flights %>%
  arrange(desc(year))

flights %>%
  arrange(-year) # solo para números

# Modificacion de datos para crear nuevas variables: mutate y transmutate
flights %>%
  mutate(totalDelay = arr_delay + dep_time,
         cost = totalDelay*385,
         arr_delay = arr_delay+1,
         carrier2 = paste0(carrier, "Hola")) %>%
  View()
  
# Operaciones agrupadas: 
flights %>%
  group_by(carrier) %>%
  summarise(medDelay = mean(arr_delay, na.rm = T))


## Ejercicios

# 1.  filtrar todas las columnas de retraso, origen destino carrier y distancia
# 1a. guarda este dataframe
flightsSampleCols <- flights %>% 
  select(arr_delay,origin,carrier,dest,distance)

flights %>% select(ends_with("delay"),origin,dest,carrier,distance)


# 2. Calcula la media de la distancia para cada par origen-destino
flightsSampleCols %>%
  group_by(origin,dest) %>%
  summarise(meanOriginDest = mean(distance,na.rm=T)) %>%
  View("ej2")



# 3. Calcula la correlacion entre la distancia y el total del retraso
distanceDelayByOriginDest <- flightsSampleCols %>%
  group_by(origin,dest) %>%
  summarise(totalDistance = sum(distance,na.rm=T), totalDelay = sum(arr_delay,na.rm=T))

cor(distanceDelayByOriginDest[,c("totalDelay", "totalDistance")], use = "complete.obs")

#########
fligthsAmpliado <- flights %>%
  mutate(totalDelay = arr_delay + dep_delay)

cor(fligthsAmpliado$totalDelay, fligthsAmpliado$distance, use = "complete.obs")

matrizFlights <- as.matrix(fligthsAmpliado[,c("totalDelay","distance")]) #or with dplyr
matrizFlights <- fligthsAmpliado %>% select(totalDelay,distance) %>% 
  as.matrix

cor(matrizFlights, use = "complete.obs")

######## Usando dplyr --- New!!!
fligthsAmpliado %>% select(totalDelay,distance) %>% 
  as.matrix %>%
  cor(use="complete.obs") %>%
  .[1,2]


# 4. Cual es el top 1 de aeropuertos de origen con mas media de retraso total
flightsSampleCols %>%
  group_by(origin) %>%
  summarise(meanDelayOrigin = mean(arr_delay,na.rm=T)) %>%
  arrange(-meanDelayOrigin) %>% # or top_n(10)
  head(1)


# 5. Filtra todos aquellos vuelos que superen la media de arr_delay
flightsSampleCols %>%
  filter(arr_delay > mean(arr_delay,na.rm=T))



# 6. Filtra aquellas rutas que superen la media de las medias del retraso total de las rutas
meanDelayRoute <- flightsSampleCols %>%
   group_by(origin,dest) %>%
   summarise(meanDelayRoute = mean(arr_delay,na.rm=T)) %>%
   filter(meanDelayRoute > mean(meanDelayRoute,na.rm=T))


## Modificadores
variablesFavorita <- "arr_delay+1"
flights %>%
  mutate_(variablesFavorita) #acepta cadenas de texto

# _at _all _if
flights %>%
  group_by(origin) %>%
  summarise_at(c("arr_delay","dep_delay"), mean, na.rm = T)

flights %>%
  group_by(origin) %>%
  summarise_at(vars(arr_delay:dep_delay), mean, na.rm = T) # util para rangos


flights %>%
  group_by(origin) %>%
  summarise_if(is.numeric, mean, na.rm = T) # util para rangos


flights %>%
  group_by(origin) %>%
  summarise_all(sum) # va a fallar








