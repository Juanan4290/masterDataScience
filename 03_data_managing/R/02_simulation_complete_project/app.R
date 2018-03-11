# Si os fijáis he dividido el código en la lógica de la simulación, por
# otro lado la aplicación y por otro la de gráficas.
# Esto me permite que sea mucho más fácil de entender y mantener

# Además he hecho una carpeta de test (llamada test)

# Así que cargo simulación y las librerías que necesito
library(shiny)
source("simulacion.R")
source("graficacion.R")


# Una aplicación de Shiny se divide en dos partes, el UI (que es la abreviatura
# de User Interface o interfaz de usuario) que define lo que el usuario va a
# ver, la estructura de la aplicación, que partes tienes (textos, imágenes) y
# que contenedores tiene La segunda parte es el server que es la parte que
# implementa la lógica de la aplicación, los cálculos, las gráficas que se
# muestran, que hace cada botón al ser pulsado, etc.

# El concepto más importante en shiny es el par render-output. Por así decirlo
# siempre hay emparejados un hueco en la interfaz para introducir algo (este
# hueco se llama output) y en el servidor hay un render que completa este hueco.
# Ahora veremos algunos ejemplos.

ui <- shinyUI( # shinyUI es el elemento padre de todas las interfaces,
               # puedes omitirlo, pero siempre contiene a cualquier interfaz
  fluidPage( # fluiPage dice que la página se puede ensanchar tanto como el
              #usuario ensanche el navegador web
    sidebarLayout( # Los layouts son formas de posicionar elementos,
                  # en este en concreto estoy usando un layout con una
                  # barra lateral para la configuración
      sidebarPanel(
        # Aquí se pone lo que quieras introducir en la barra
        # Voy a poner lo parámetros de la simulación.
        # Esto se hace con inputs, cuyo primer parámetro SIEMPRE es su ID
        # label es el nombre visible y luego cada uno de ellos tiene
        # otros parámetros para configurar
        
        sliderInput("n", label = "Tamaño del tablero",
                    min = 1, max = 100, value = 25),
        
        numericInput("probA", label = "probabilidad de color A",
                     min = 0, max = 1, value = 0.40, step=0.01),
        
        numericInput("probB", label = "probabilidad de color B",
                     min = 0, max = 1, value = 0.40, step=0.01),
        
        hr(), # linea separadora
        
        sliderInput("sensibilidad", label = "Factor de sensibilidad",
                    min = 1, max = 8, value = 4, step = 1),
        
        numericInput("maxIter", label = "número máximo de iteraciones",
                     min = 0, max = 5000, value = 1000, step = 1),
        
        hr(), # linea separadora
        
        actionButton("run","Ejecutar simulación", icon = icon("play"))
      ),
      mainPanel(
        # Aquí se pone lo que quieras introducir en la parte principal
        
        fluidRow( # Las intefaces se suelen dividir en filas y columnas
          column(7, # hago una columna de ancho 7 (el total de ancho es 12
                    # por estandar de Bootstrap que se usa en shiny)
            
                 # FIJAOS AQUI: Estoy creando un output (un hueco) para introducir
                 # desde el server la gráfica que representa el tablero, este 
                 # hueco se va a lllamar graficaTablero
                 plotOutput("graficaTablero", width = "350px", height = "350px"),
                 
                 uiOutput("sliderTiempo") # esto lo uso para poder
                 # animar el tablero, usa lo que se denomina
                 # dynamic UI: https://shiny.rstudio.com/articles/dynamic-ui.html
                 # Es un tema avanzado que no cubriré aquí
          ),
          column(5, # otra columna para estadísticas y detalle
                 textOutput("estadisticas"),
                 hr(),
                 h4("Estado inicial"),
                 plotOutput("graficaTableroInicial",
                            width = "200px", height = "200px"),
                 hr(),
                 h4("Estado final"),
                 plotOutput("graficaTableroFinal",
                            width = "200px", height = "200px")
          )
        )
        
      )
    )
  )
)


# Ahora vamos con el server que es "el cerebro" de la aplicación que realiza los
# cálculos necesarios en base al input del usuario.
# Es donde voy a generar la gráficas y los textos para los "output" que 
# he creado antes

# Server siempre es una función con input y output, lo cual es un poco 
# extraño porque el output es un parámetro de entrada, pero eso
# es un detalle que no nos debe preocupar.
# en input recibiré lo que el usuario ha introducido (tamaño del tablero,
# sensibilidad, etc...)
# en output introduciré lo que quiero que vaya a los huecos que he dejado
# en UI.

server <- function(input, output) {
  
  # reactiveValues es un tipo especial de lista que se usa en shiny
  # para que funcione dentro de un programa. Si queréis más detalle:
  # https://shiny.rstudio.com/articles/reactivity-overview.html
  resultadoSimulacion <- reactiveValues()
  
  # observeEvent sirve generalmente para "escuchar a un botón", en este
  # caso es para atender al hecho de que el usuario ha pulsado el botón
  # ejecutar
  
  # Podeis ver que los input son input$XXXXX donde XXX es el ID
  # que habéis usado en UI, y siempre tiene que coincidir, por eso
  # es mejor nombres sencillos y con camelCase como las variables
  # ignoreInit hace que no se arranque por primera vez
  observeEvent(input$run, ignoreInit = T, {
    
    if ((input$probA + input$probB) > 1) {
      # Si el usuario ha puesto dos probabilidades que superan el 100%...
      # le muestro un mensaje de error y no ejecuto la simulación
      # (return vacío hace que el observeEvent devuelva NULL y acabe)
      
      showNotification("La suma de ambas probabilidades no puede superar 100%",
                       type = "error")
      return()
    }
    
    
    # muestro un mensaje mientras se ejecuta la simulación
    showNotification("Ejecutando simulación....", id="running")
    
    # ejecuto la simulación y si os fijáis cojo los parámetros
    # de input. Como he nombrado bien las cosas, los nombres
    # de los parámetros y de los inputs coinciden así que es 
    # más fácil conectar el input con la simulación
    
    # y lo guardamos en resultadoSimulacion (que lo hemos creado justo arriba)
    res <- simulacion(n = input$n, probA = input$probA,
                                      probB = input$probB,
                                      maxIter = input$maxIter,
                                      sensibilidad = input$sensibilidad)
    
    # Lo hacemos uno por uno por un motivo técnico de reactividad en
    # Shiny. Si lo hiciesemos de golpe destruiríamos la reactividad de
    # esos valores en Shiny. Es un tema técnico complejo, no es necesario
    # entrar en detalle en este punto :)
    resultadoSimulacion$nPasos <- res$nPasos
    resultadoSimulacion$tablero <- res$tablero
    resultadoSimulacion$descontento <- res$descontento
    
    # Borro el mensaje que he puesto al principio
    removeNotification(id="running")
  })
  
  
  # FIJATE AQUI: Estoy rellenando un output con un render y tengo que usar
  # el MISMO nombre que he definido arriba en UI
  # además tiene que ser del mismo tipo. Si usas plotOutput, este tiene que
  # ser renderPlot. Y así con renderText-textOutput, etc
  
  output$graficaTablero <- renderPlot({# OJO: Poned siempre llaves aquí
                                       #      después de un render
    # Esta gráfica sólo debe pintarse cuando exista 
    # resultadoSimulacion$tablero
    req(resultadoSimulacion$tablero)

    # Pinto en el paso input$step (el que me ha dicho el usuario en el slider)
    if (is.null(input$step)) n <- 1
    else n <- input$step
    pintarTablero(resultadoSimulacion$tablero[,,n],
                  resultadoSimulacion$descontento[,,n])
  })
  
  
  
  
  # Una vez se ha hecho la simulación añadimos 
  # un slider de tiempo para que el usuario pueda moverse hacia 
  # adelante y atrás
  output$sliderTiempo <- renderUI({ 
    # si no están los resultados de la simulación, ignorar.
    # Para eso se usa req
    req(resultadoSimulacion$nPasos)
    
    
    # Ponemos un slider del 1 al nPasos para que el usuario pueda
    # avanzar y animar la gráfica
    sliderInput("step", label = "Iteración", value = 1, min = 1,
                max = resultadoSimulacion$nPasos, animate = T)
    
  })
  
  output$graficaTableroInicial <- renderPlot({
    req(resultadoSimulacion$tablero)
    pintarTablero(resultadoSimulacion$tablero[,,1],
                  resultadoSimulacion$descontento[,,1])
  })
  
  output$graficaTableroFinal <- renderPlot({
    req(resultadoSimulacion$tablero)
    pintarTablero(resultadoSimulacion$tablero[,,resultadoSimulacion$nPasos],
                  resultadoSimulacion$descontento[,,resultadoSimulacion$nPasos])
  })
  
  output$estadisticas <- renderText({
    # Calculamos algunas estadísticas y mostramos el resultado en texto
    # por eso usamos renderText
    
    req(resultadoSimulacion$tablero)
    ultimoStep <- resultadoSimulacion$nPasos
    # La simulacion ha acabado correctamente si no hay nadie descontento
    
    nDescontentos <- sum(resultadoSimulacion$descontento[,,ultimoStep])
    finalizada <- (nDescontentos == 0)
    
    paste0("Simulación ", ifelse(finalizada, "FINALIZADA", "INTERRUMPIDA"),
           " en ", ultimoStep, " pasos.\n\n", "La simulación ha acabado con ",
           nDescontentos, " descontentos")
  })
  
  
}

# Ejecutamos el shiny..
shinyApp(ui = ui, server = server)