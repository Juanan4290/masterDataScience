# Applicación con leaflet
require(leaflet)
shinyServer(function(input, output) {
  output$Mapa <- renderLeaflet({
  #output$Mapa <- renderPlot({
	leaflet() %>% setView(input$lng, input$lat, zoom = 6) %>%
	addTiles() %>%  # Add default OpenStreetMap map tiles
	addMarkers(lng=input$lng, lat=input$lat, popup="Es aquí!")
	#plot(input$lng, input$lat)
  })
})
