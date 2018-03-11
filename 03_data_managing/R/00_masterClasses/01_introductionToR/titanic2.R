# 1º Vector.

# Como saber el tipo
class(titanic$Survived)
str(titanic$Survived)

str(titanic)

# como crear un vector de cero
edadDeMisAlumnos <- c(18,20,21,18,24,35,45)
str(edadDeMisAlumnos)

nombreDeMisAlumnos <- c("Carlos", "Maria", "Marisa")
str(nombreDeMisAlumnos)

# crear un vector vacio PREALLOCATED
integer(100)
numeric(10)
character(10)

# c tambien concatena vectores
c(edadDeMisAlumnos, 1,3,4)

# Cuando dos tipos no encajan
c(edadDeMisAlumnos,nombreDeMisAlumnos)

# 2º Listas

misAlumnos <- list(18,"Carlos",24,"Maria")
misAlumnos

lista1 <- list(1:10, "Carlos", c("Carlos", "Maria"))
lista1

lista3 <- list(sabor = "Chocolate", tamanio = 3)
lista3

lista1[1]
lista1[[1]]
str(lista1[[1]])

lista3$tamanio

lista3['tamanio']
str(lista3['tamanio'])
str(lista3$tamanio)
str(lista3[['tamanio']])

# Relacion entre un dataframe y una lista
class(titanic)
typeof(titanic)
# Un data frame es un tipo especifico de lista donde todos los vectores tienen 
# que tener la misma longitud

# Devuelve un df de una columna
titanic[, "Age", drop = F]

# IMPORTANTE
str
class


# 4º Factores
str(titanic)
embarked <- titanic$Embarked

str(embarked)
c(embarked,"C")

# as.xxx convierte
as.character(embarked)
c(as.character(embarked),"C")

is.factor(embarked)

levels(embarked)

# Curioso, puedes cambiar el valor de los niveles
levels(embarked)[2] <- "Carlos"
embarked

reorder() # reordena los levels

as.factor() # para hacer factores


# 5º Matrices

# Las matrices son vectores
matrix(1:9, ncol = 3)
matrix(1:9, ncol = 3, byrow = T)


# Vamos a corregir este ejercicio
cor(as.matrix(titanic[,c("Age","Fare")]), use = "complete.obs")

# Gestion de versiones
# ratr