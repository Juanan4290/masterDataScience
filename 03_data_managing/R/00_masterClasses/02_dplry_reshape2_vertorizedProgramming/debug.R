invertir <- function(a, b){
  sum(a[a > b])
}

invertir2 <- function(appl, googl){
  coste <- 0
  for (i in 1:length(appl)){
    if (appl[i] < googl[i])
      coste <- coste + googl[i]
  }
  return(coste)
}

a <- c(10,8,7)
b <- c(10,9,6)




