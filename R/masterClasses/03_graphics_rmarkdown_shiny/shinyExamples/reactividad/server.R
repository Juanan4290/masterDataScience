# Definición de la parte server
shinyServer(function(input, output) {
  todo=rownames(diamonds)	
  datos <- reactive({ indice = sample(todo,input$n); 
					  diamonds[indice,]								
					}) 
  output$resumen    <- renderPrint({ summary(head(diamonds,input$n)) })
  output$histograma <- renderPlot({ 
	ggplot(head(diamonds,input$n),aes(x=x,y=price)) + geom_point(size=.1)
	})
})


###### Muestrear la base
#todo=rownames(diamonds)
#datos <- reactive({ indice = sample(todo,input$n); 
#					  diamonds[indice,]								
#					}) 

### Cambiar titulo sin volver a ejecutar grafico
# ...+ ggtitle(isolate(input$title))
