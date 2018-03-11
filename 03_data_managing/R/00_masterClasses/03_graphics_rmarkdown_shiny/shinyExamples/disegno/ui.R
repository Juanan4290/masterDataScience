# Definción del UI
shinyUI(fluidPage(
  
  # Titulo
  titlePanel("Una regresión"),
  
  # Diseño de la interfaz
  fluidRow(
		column(4,		
			selectInput("regresor","Elegir variable de regresión:",choices=names(mtcars)[2:5],selected=1) 	  
			),
		column(4,		
			textInput("titulo","Titulo del gráfico:",value = "Regresión") 	  
			),
		column(4,		
			sliderInput("grossor","Tamaño de los puntos:", min = 1,max = 20,value = 2,step=1) 	  
			),	
		column(7,align="center",
			plotOutput("grafico")
		)
	)
) )

