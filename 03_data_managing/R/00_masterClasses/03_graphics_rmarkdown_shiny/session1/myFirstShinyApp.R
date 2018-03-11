library(shiny)

# Define server logic required to draw a histogram
server <-  function(input, output) {
    
    # Expression that generates a histogram. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should be automatically
    #     re-executed when inputs change
    #  2) Its output type is a plot
    
    output$scatterPlot <- renderPlot({
      size = input$size
      # draw the histogram with the specified number of bins
      ggplot(faithful)+
        aes(x=eruptions,y=waiting)+
        geom_point(size = size, color = "blue")
    })
    
  }

  # Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Hello Shiny!"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
      sidebarPanel(
        sliderInput("size",
                    "Point Size:",
                    min = 0.1,
                    max = 5,
                    value = 1)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("scatterPlot")
      )
    )
  )

shinyApp(ui = ui, server = server)