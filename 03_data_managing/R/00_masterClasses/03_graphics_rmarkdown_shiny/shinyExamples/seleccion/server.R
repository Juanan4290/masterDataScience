# Selección
shinyServer(function(input, output) {
  rango <- reactiveValues(x = NULL, y = NULL)	
  
  output$original <- renderPlot({
    ggplot(DT, aes(x=distancias,y=retrasos)) + geom_point(size=2,alpha=.3)
	})

  Zoom <- function() {
      ggplot(DT, aes(x=distancias,y=retrasos)) + geom_point(size=2,alpha=.3) +
      coord_cartesian(xlim = rango$x, ylim = rango$y)
    }	
  output$zoom <- renderPlot({ Zoom() })
  
  # Crea un observador para el brush
  observe({
    seleccion <- input$original_brush
    if (!is.null(seleccion)) {
      rango$x <- c(seleccion$xmin, seleccion$xmax)
      rango$y <- c(seleccion$ymin, seleccion$ymax)
    } 
	else {
      rango$x <- NULL
      rango$y <- NULL
    }
  })
  
  output$guardarZoom <- downloadHandler(
    filename = function() {"zoom.pdf"} ,
    content = function(file) {
        ggsave(file, plot = Zoom(), device = "pdf")
		}
	)
})
