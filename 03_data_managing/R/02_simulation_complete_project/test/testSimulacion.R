library(testthat)
library("simulacion.R")

test_that("simulaciones con sensibilidad mínima acaban en el segundo paso",{
  # porque nadie se mueve
  resultadoSimulacion <- simulacion(sensibilidad = 9)
  expect_equal(resultadoSimulacion$nPasos, 2)
})


test_that("simulaciones sin huecos y algo de sensibilidad nunca se detienen",{
  # porque nadie se mueve
  resultadoSimulacion <- simulacion(n=5,
    sensibilidad = 1, probA = 0.5, probB = 0.5, maxIter = 1000)
  expect_equal(resultadoSimulacion$nPasos, 1000)
})


test_that("simulaciones con sensibilidad infinita nunca se detienen",{
  # porque nadie se mueve
  resultadoSimulacion <- simulacion(n=5,
    sensibilidad = 0, maxIter = 1000)
  expect_equal(resultadoSimulacion$nPasos, 1000)
})



