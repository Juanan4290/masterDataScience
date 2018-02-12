library(leaflet)
library(RColorBrewer)
require(data.table)
tmp=fread("terremotos2013_2016.csv")
tmp[,Fecha:=as.Date(Fecha,"%d/%m/%Y")]
terremotos=subset(tmp,mag>0 & !is.na(mag))
