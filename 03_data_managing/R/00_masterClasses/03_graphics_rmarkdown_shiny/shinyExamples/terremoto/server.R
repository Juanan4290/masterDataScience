# Terremotos en leaflet

shinyServer(function(input, output,session) {
  filteredData <- reactive({
    subset(terremotos,Fecha >= as.Date(input$rangeDate[1]) & Fecha <= as.Date(input$rangeDate[2]))
  })
  
 
  
  output$map <- renderLeaflet({
    leaflet(terremotos) %>% addTiles() %>%
	 addProviderTiles("Stamen.TonerLite", group = "Toner Lite") %>%
      fitBounds(~min(long), ~min(lat), ~max(long), ~max(lat))
  })
  
  
  observe({
    pal <- colorNumeric("Blues", terremotos$mag)
    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(radius = ~exp(mag-1), weight = 1, color = "#777777",
        fillColor = ~pal(mag), fillOpacity = 0.7, popup = ~paste(mag)
      )
  })

})