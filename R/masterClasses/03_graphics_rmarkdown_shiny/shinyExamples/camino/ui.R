# Definición del UI
shinyUI(fluidPage(
  
  # Titulo
  titlePanel("Rutas andando por Madrid"),
  
  # Sidebar
  fluidRow(
		column(4,		
			textInput("partida","Dirección del punto de partida:",value = "Calle Orense 4, Madrid") 	  
			),
		column(4,		
			textInput("destino","Dirección del punto de partida:",value = "Calle Quijote 10,Madrid") 	  
			),
		column(4,		
			 sliderInput("zoom","Zoom",min = 14,max = 20,value=14) 	  
			),	
		column(12,align="center",
			plotOutput("Ruta",width="600px",height="600px")
		)
	)
) )

