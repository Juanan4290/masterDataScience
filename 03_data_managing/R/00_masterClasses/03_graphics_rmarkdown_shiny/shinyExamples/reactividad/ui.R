# Definción del UI
shinyUI(fluidPage(
  
  # Titulo
  titlePanel("Muestreo"),
  
  fluidRow(
	column(width = 2, 
		numericInput("n", "Tamaño muestral:", 1000 , min = 1000, max = 10000,step=1000)
		),
	column(width = 5, 
		h4("Descripción de la muestra"),
		verbatimTextOutput("resumen")
		),
	column(width = 5, 
		h4("Histograma de la muestra"),
		plotOutput("histograma")
		)	
	)
))

