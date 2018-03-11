require(rvest)

# leer html amanece que no es poco de IMDB
amanece <- read_html("http://www.imdb.com/title/tt0094641/")

html_nodes(amanece, "table")

html_nodes(amanece, "table.cast_list")

html_nodes(amanece, "title")

html_node(amanece, "title") # si hay más elementos te devuelve solo el primero

html_node(amanece, "title") %>% html_text

html_node(amanece, "title") %>% html_text(trim = TRUE)


### Ejercicio: Texto discuro del rey:
discursoRey <- read_html("http://www.casareal.es/ES/Actividades/Paginas/actividades_discursos_detalle.aspx?data=5742")
html_node(discursoRey, "title") %>% html_text(trim = TRUE)
discurso <- html_nodes(discursoRey, "p") %>% html_text(trim = TRUE)

paste(discurso, collapse = " ")
###


html_node(amanece, "table.cast_list") %>% html_table(header=TRUE) %>% .[[2]] # .[[2]] para segunda columna
amanece %>% html_nodes("table")  %>% .[[1]] %>% html_table(header = TRUE) %>% .[, c(2,4)]


### Ejercicio: cotizacion en bolsa del IBEX35
ibex35 <- read_html("http://www.bolsamadrid.es/esp/aspx/Mercados/Precios.aspx?indice=ESI100000000")
html_nodes(ibex35, "table") %>% html_table(fill = TRUE)
html_nodes(ibex35, "table") %>% .[[5]] %>% html_table(header = TRUE) %>% View
###


firstLink <- amanece %>% html_nodes("table a") %>% html_attr("href") %>% .[[1]]
raiz <- "http://www.imdb.com"
joseSazatornillURL <- paste(raiz, firstLink, sep = "")


### Ejercicio: extraer el vínculo de la imagen de Jose Saztornill
joseSazatornill <- read_html(joseSazatornillURL)
josePhoto <- joseSazatornill %>% html_nodes("img#name-poster") %>% html_attr("src")
###


sesion <- html_session("http://www.imdb.com")
sesion %>% jump_to("boxoffice") %>% back %>% jump_to(firstLink) %>% session_history
sesion %>% jump_to(firstLink) %>% html_nodes("p") %>% html_text()

html_form(sesion)[[1]] %>% set_values(q = "amanece", s = "Title") %>%
  submit_form(session = sesion) %>% html_nodes("td.result_text") %>% html_text


### Ejercicio: Extraer cotizaciones del ibex 35 utilizando navegación virtual.
cotiz <- html_session("http://www.bolsamadrid.es/esp/aspx/Mercados/Precios.aspx")

html_form(cotiz)[[2]] %>% set_values('ctl00$Contenido$SelIndice' = "ESI100000000") %>% 
  submit_form(session = cotiz) %>% html_nodes("table") %>% .[[5]] %>% 
  html_table(header = TRUE) %>% View
###


require(RJSONIO)
ine <- "http://servicios.ine.es/wstempus/js/ES/DATOS_TABLA/2852?nult=5&tip=AM"
pob <- fromJSON(ine, encoding="UTF-8")

pob %>% class
pob %>% length

pob[[1]]
lapply(pob, data.frame) %>% .[[1]] %>% View

require(data.table)
lista.df <- lapply(pob, data.frame)
pob.df <- rbindlist(lista.df)

pob.df %>% select(MetaData.Nombre, MetaData.Nombre.1, Data.Anyo, Data.Valor) %>% View


bm  <- read_xml("http://api.worldbank.org/countries/all/indicators/NY.GDP.MKTP.CD?date=2009:2010&per_page=500&page=1")
esp <- bm %>% xml_nodes(xpath="//*/wb:data[wb:country[@id='ES']]/wb:value")  
esp %>% xml_text() %>% as.numeric()

