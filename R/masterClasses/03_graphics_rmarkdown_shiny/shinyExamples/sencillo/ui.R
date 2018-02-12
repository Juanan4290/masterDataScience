# Definción del UI
shinyUI(fluidPage(
  
  # Titulo
  titlePanel("Una regresión"),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      sliderInput("grossor",
                  "Tamaño de los puntos:",
                  min = 1,max = 20,value = 2,step=1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("grafico")
    )
  )
))
