library(testthat)
source("simulacion.R")
sumar <- function(a,b) {
  a+b
}

expect_equal(sumar(1,2),3)
