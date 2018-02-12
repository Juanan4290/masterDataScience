# Definición de la parte server
shinyServer(function(input, output) {
  output$grafico <- renderPlot({
    ggplot(mtcars,aes_string(input$regresor,"mpg"))+
		geom_point(size=input$grossor,col="orange3",alpha=.3) +
		geom_smooth(method='lm',formula=y~x) + ggtitle(input$titulo)
  })
})
