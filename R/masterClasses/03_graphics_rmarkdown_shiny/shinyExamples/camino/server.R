# Applicación con ggmap
require(ggmap)
shinyServer(function(input, output) {
  output$Ruta <- renderPlot({
	mapa <- get_map(input$partida, zoom = input$zoom)
	ruta <- route(input$partida,input$destino,mode = "walking", structure="route")
	ggmap(mapa,extent="panel") + geom_path(data = ruta, aes(x = lon, y = lat),size=1,col="blue3")
  })
})
