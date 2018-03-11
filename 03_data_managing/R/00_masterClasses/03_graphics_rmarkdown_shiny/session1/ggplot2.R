library(ggplot2)
library(plotly)
library(leaflet)
library(ggmap)
library(data.table)
library(raster)
library(maptools)

#ggplot
paro <- read.csv("./data/paro_final.csv", encoding = "UTF-8")

dim(paro)
summary(paro)

ggplot(paro) + # data (data.frame / data.table)
  aes(x = Year, y = tasa.paro, col = Genero) + # aesthetics
  geom_point() + geom_smooth(alpha = 0.5,se = FALSE) + # geometry
  facet_wrap( ~ Provincias) # facets

ggplot(iris) + 
  aes(x = Petal.Length, y = Petal.Width, colour = Species) + 
  geom_point() + geom_smooth(se = F)

ggplot(iris) + 
  aes(x = Petal.Length, y = Petal.Width) + 
  geom_point(col = "blue") + geom_smooth(se = T) +
  facet_grid(~Species)

ggplot(paro) +
  aes(x = Year, y = tasa.paro, colour = Genero) +
  geom_jitter(alpha = 0.15) + geom_smooth(se = F)
                                          
ggplot(paro) +
  aes(x = Year, y = tasa.paro, colour = Genero) +
  geom_jitter(alpha = 0.15) + geom_smooth(se = F) + 
  facet_grid(~Cuat)


paro$Cuat <- factor(paro$Cuat,levels=1:4,
                  labels=c("I","II","III","IV"),ordered=TRUE) #cuatrimestre en notación romana
tmp <- subset(paro, Provincias %in% c("Zaragoza", "Huesca", "Teruel"))

ggplot(tmp, aes(x = Year, y = tasa.paro, color=Genero)) +
  geom_point() + geom_line() + 
  facet_grid(Provincias~Cuat)

ggplot(paro)+
  aes(x=Year,y=tasa.paro,colour=Genero)+
  geom_point(alpha=0.2)+
  facet_grid(Genero~Cuat)

ggplot(paro)+
  aes(x=Cuat,y=tasa.paro,colour=Genero)+
  geom_boxplot(width = 0.25)+
  facet_grid(Genero~Year) + 
  ggtitle("tasa de paro por genero, cuatrimestre y año") + 
  labs(x = "Cuatrimestre",
       y = "Tasa de paro",
       colour = "Generos") +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("./img/myFirstGGplotGraphic.jpeg")

## ggmap
kschool <- geocode('Calle Magallanes 1, Madrid, spain')
mapa <- get_map(location = kschool,zoom = 16,color = "bw")
ggmap(mapa)

terrazas=fread("./data/terrazas.csv")
ggmap(mapa) + 
  geom_point(aes(x = lon, y = lat), 
             data = terrazas, colour = 'orange3',size = 2,alpha=.5) +
  geom_point(aes(x = lon, y = lat), 
             data = kschool, colour = "red", size = 2, alpha = 0.75)



crimes.houston <- subset(crime, ! crime$offense %in% c("auto theft", "theft", "burglary"))

houston<-geocode('houston')
HoustonMap <- ggmap(get_map(houston, zoom = 14, color = "bw"))
HoustonMap +
  geom_point(aes(x = lon, y = lat, colour = offense), 
             data = crimes.houston, size = 1)+
  facet_wrap(~offense)


# polygons

tmp <- getData("GADM", country= "Spain", level = 2) # mapa administrativo a nivel provincial
head(tmp)
plot(tmp)

tmp=subset(tmp,!CCA_2=="")
provincias=unionSpatialPolygons(tmp,tmp$CCA_2) # sintetiza el mapa. 
                                               # Hay problemas de permisos en isTRUE(gpclibPermitStatus())
provincias = tmp
mapa=fortify(provincias) # 
ggplot() + geom_polygon(data = mapa, aes(long, lat, group = group), 
                        fill="grey60",colour = "grey80", size = .1)

plot(tmp, col = sample(colours(),55))

# unemployment rate
paro = fread("./data/paro_final.csv")

Paro=subset(paro,Year==2011 & Cuat==1)
Paro$id=sub(" ","0",format(Paro$prov,width=2))
Mapa=merge(mapa,Paro,by="id")
peninsula=subset(Mapa,!id %in% c(35,38)) # sin canarias

ggplot() + geom_polygon(data = peninsula, aes(long, lat, group = group,fill=tasa.paro), colour = "grey80", size = .1) +
  facet_grid(~ Genero) + scale_fill_gradient(low="aliceblue",high="steelblue4")


centro <- c(lon=-3.70379,lat= 40.41678) #geocode("Madrid, Spain")
mapa <- get_map(centro, zoom = 6,maptype="toner-lite",source="stamen")
mujeres=subset(Mapa,Genero="Mujeres")

ggmap(mapa) + geom_polygon(data = mujeres, aes(long, lat, group = group,fill=tasa.paro),alpha=.5) +
  scale_fill_gradient(low="aliceblue",high="steelblue4")

# Plotly
p<-ggplot(paro, aes(x = Year, y = tasa.paro, color=Genero,label=Provincias)) +
  geom_jitter(alpha=.1) + geom_smooth(se=FALSE) 

ggplotly(p,tooltip = c("label", "color"))


# leaflet
DT<-data.frame(id=names(provincias),row.names=names(provincias))
espana<-SpatialPolygonsDataFrame(provincias,DT)
espana@data=merge(espana@data,subset(Paro,Genero=="Mujeres"),by="id")
rownames(espana@data)<-espana$id
bins <- quantile(espana$tasa.paro,seq(0,1,.2))
pal <- colorBin("YlOrRd", domain = espana$tasa.paro , bins = bins) #escala de colores
espana$color<-pal(espana$tasa.paro)

leaflet(data=espana)%>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillOpacity = 0.5,
              fillColor = ~color,color = "white",weight = 1,dashArray = "3") %>%
  addLegend(pal = pal, values = ~tasa.paro, opacity = 0.7, title = "tasa de paro",
            position = "bottomright",labFormat = labelFormat(digits=2))