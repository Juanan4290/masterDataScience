# En cualquier desarrollo de software moderno se utiliza el testing
# como herramienta de control de calidad, incluso coordinación de equipos
# y seguimiento de proyectos.

# Es MUY recomendable que os empecéis a acostumbrar a escribir test en
# vuestros programas. La ventajas son muchas: menor número de errores,
# mejor entendimiento del código por parte del equipo, reduce el número
# de refactorizaciones, errores de retrocompatibilidad (cambiar algo y
# romper la funcionalidad previa), etc.

# De hecho existen metodologías de trabajo que usan los test como una
# de sus piezas centrales. Que se denomina (no necesariamente) TDD
# o Test-Driven Development.
# https://es.wikipedia.org/wiki/Desarrollo_guiado_por_pruebas


# La librería que vamos a usar es testthat, aunque no es la única,
# pero es con diferencia la más usada y es muy completa.

library("testthat")

# Vamos a hacer un test muy sencillito.
sumar <- function(a,b) {
  a+b
}

expect_equal(sumar(1,2), 3) # OK! :)


# La idea es que en vez de comprobar
# tu a mano si una función devuelve lo correcto, lo automatizas
# para poder hacer proyectos más complejos y robustos.

# De hecho mucha gente (sobre todo en TDD) comienza a escribir el
# test antes de escribir el código del programa.
# Yo os recomiendo que lo probéis (de hecho un ejercicio es así)
# porque ayudaa entrenar la forma de pensar de un programador.
# Por ejemplo si no tienes claro cómo estructurar tu código
# a veces es bueno empezar a pensar en test antes del propio código.

# Antes tu forma de trabajar era iterativamente cambiar el código
# de una función, hacer un source on save y luego probar en la consola
# si funciona como esperas.

# Ahora deberías escribir unos test e iterativamente cambiar el código
# y comprobar si los test son positivos.

# Cuando un test falla se muestra un mensaje de error.

expect_equal(1+2, 4)

# Como este:
# Error: 1 + 2 not equal to 4.
# 1/1 mismatches
# [1] 3 - 4 == -1 

test_that("sumar es suma correcta", {
  expect_equal(sumar(1,0), 1)
  expect_equal(sumar(0,0), 0)
  expect_equal(sumar(-1,1), 0)
  expect_equal(sumar(10,100), 110)
})

# Normalmente se hacen packs de test en funcionalidades
# Porque sólo con un test no puedes comprobar todo lo
# que hace una función o conjunto de funciones.

# Si falla el mensaje de error contiene el nombre de la funcionalidad que has escrito
# Error: Test failed: 'sumar es suma correcta'
# 1: expect_equal(suamr(0, 0), 0) at :3
# 2: quasi_label(enquo(object), label)
# 3: eval_bare(get_expr(quo), get_env(quo)) 

# Lo interesante es agrupar tus test en pequeños bloques de funcionaliad

# Existen otros operadores expect.
# Los más importantes son:
# - expect_match: que comprueba si hay un match con expresión regular
# - expect_output: comprueba la salida por la consola
#                  lo que se ve para el usuario
# - expect_error: comprueba que se devuelve un error
# - expect_true: espera que el resultado sea true
#                (existe expect_false también)


# Nosotros siempre hemos source de forma interactiva, para recargar
# el fichero que estábamos editando en ese momento.
# Pero su uso principal es el que vais a ver ahora:
# cargar otro fichero dentro de otro, para crear una relación
# de dependencia (testing depende de simulacion)
# Este es el segundo nivel para estructurar tu código.
# Divide tu código en funciones que sean razonables y agrupalas
# en ficheros de forma que sea entendible y mantenible.

# Los test en un proyecto profesional se ponen en ficheros
# separados de los ficheros que comprueban (como es el caso)
# y normalmente todos los test están separados en otra carpeta
# Esto varía sustantivamente entre lenguajes y equipos, pero
# siempre se tiende a separar los test del código testado.

# Así que cargamos el backtesting
# CUIDADO. Para que esto funcione tenéis que abrir el proyecto de
# Rstudio en esta carpeta. Si no "source" no sabe en qué carpeta buscar
# Es un error MUY frecuente entre estudiantes.
# Por eso es recomendable hacer todo en un proyecto.
source("06. backtesting.R")

# Ahora comprobamos puntosDeCompra.
# De esta forma podemos estar mucho más seguros de que funciona
# correctamente porque hacemos pequeñas pruebas sobre las que 
# tenemos mucho control y podemos razonar una a una.

# En cambio si lo hacemos con un vector de mil números
# de Google o Amazon no podemos razonar correctamente.
test_that("puntosDeCompra funciona correctamente", {
  expect_equal(puntosDeCompra(c(1,2,3), c(3,5,8)), c(0,2,2))
  expect_equal(puntosDeCompra(c(1,2,3), c(3,3.5,8)), c(0,1,2))
  expect_equal(puntosDeCompra(c(5,2,3), c(3,3.5,8)), c(0,0,2))
})

# Por último, para arrancar los test podéis ejecutarlo como cualquier
# código (Ctrl+Enter o Source).

# Pero es mejor tener todos los test en una carpeta llamada
# normalmente "test" dentro de tu directorio raiz
# y ejecutar el comando de testthat:
testthat::test_dir("test")

# Tenéis un ejemplo de esto funcionando en el shiny que os adjunto
# y así podéis ver cómo se escribe un conjunto de testy el tipo
# de estrategias que lelvo a cabo

# Si queréis más información:
# http://r-pkgs.had.co.nz/tests.html