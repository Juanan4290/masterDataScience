# Definición del UI
shinyUI(basicPage(
  h4("Seleccionar ventana de puntos en el gráfico de la izquierda"), 
  fluidRow(    
    column(width = 5,class="well",
			plotOutput("original", height = 500,
			brush = brushOpts(id = "original_brush",resetOnNew = TRUE)
			)
        ),
    column(width = 5,class="well",offset=1,
			plotOutput("zoom", height = 500),
			br(),
			downloadButton("guardarZoom",'Guardar el zoom (en pdf)')
        )
      )
) )

