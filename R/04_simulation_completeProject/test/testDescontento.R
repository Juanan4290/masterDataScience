library("testthat")
source("simulacion.R")

test_that("no hay descontento en tableros homogeneos", {
  tablero <- matrix(nrow=3,
                    c(1,1,1,
                      1,1,1,
                      1,1,1))
  
  resultado <- matrix(nrow=3,
                      c(F,F,F,
                        F,F,F,
                        F,F,F))
  
  expect_equal(descontento(tablero, sensibilidad = 8),resultado)
  expect_equal(descontento(tablero, sensibilidad = 7),resultado)
  expect_equal(descontento(tablero, sensibilidad = 1),resultado)
})


test_that("un descontento, maxima sensibilidad", {
  tablero <- matrix(nrow=3,
                    c(1,1,1,
                      1,2,1,
                      1,1,1))
  
  resultado <- matrix(nrow=3,
                      c(F,F,F,
                        F,T,F,
                        F,F,F))
  
  expect_equal(descontento(tablero, sensibilidad = 8),resultado)
})

test_that("test básicos de un descontento", {
  tablero <- matrix(nrow=3,
                    c(1,1,1,
                      1,2,1,
                      1,1,1))
  
  resultadoConTrue <- matrix(nrow=3,
                      c(F,F,F,
                        F,T,F,
                        F,F,F))
  resultadoConFalse <- matrix(nrow=3,
                             c(F,F,F,
                               F,F,F,
                               F,F,F))
  
  expect_equal(descontento(tablero, sensibilidad = 3), resultadoConTrue)
  expect_equal(descontento(tablero, sensibilidad = 8), resultadoConTrue)
  expect_equal(descontento(tablero, sensibilidad = 9), resultadoConFalse)
})

test_that("test de matriz 1x1", {
  tablero <- matrix(nrow=1,
                    c(1))
  resultado <- matrix(nrow=1,
                      c(F))
  
  expect_equal(descontento(tablero, sensibilidad = 1), resultado)
  expect_equal(descontento(tablero, sensibilidad = 8), resultado)
})


test_that("sensibilidad 0 siempre causa descontento salvo en agua", {
  tablero <- matrix(nrow=3,
                    c(1,2,1,
                      2,2,0,
                      1,1,1))
  
  resultado <- matrix(nrow=3,
                             c(T,T,T,
                               T,T,F,
                               T,T,T))
  
  expect_equal(descontento(tablero, sensibilidad = 0), resultado)
})

