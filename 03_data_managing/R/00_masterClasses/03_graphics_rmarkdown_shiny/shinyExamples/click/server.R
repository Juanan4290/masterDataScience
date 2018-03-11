# Clic
shinyServer(function(input, output) {
    output$plot <- renderPlot({
      plot(cars$speed, cars$dist)
    })
    output$plot_clickinfo <- renderPrint({
      cat("Click:\n")
      str(input$plot_click)
    })
    output$plot_hoverinfo <- renderPrint({
      cat("Hover (throttled):\n")
      str(input$plot_hover)
    })
    output$plot_brushinfo <- renderPrint({
      cat("Brush (debounced):\n")
      str(input$plot_brush)
    })
	
	##### Dos funciones de Shiny muy utiles: nearPoints y brushedPoints
    output$plot_clickedpoints <- renderTable({
      res <- nearPoints(cars, input$plot_click, "speed", "dist")
      if (nrow(res) == 0) return()
      res
    })
    output$plot_brushedpoints <- renderDataTable({
      res <- brushedPoints(cars, input$plot_brush, "speed", "dist")
      if (nrow(res) == 0) return()
      res
    })
})
