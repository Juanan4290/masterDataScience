# Definición del UI

shinyUI(bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  
  absolutePanel(top = 10, right = 10,
	dateRangeInput('rangeDate',label = "Periodo",	
      start = min(terremotos$Fecha), end = max(terremotos$Fecha),
      separator = " - ", startview = 'year', language = 'es',weekstart = 1
	)
  )
)) 

