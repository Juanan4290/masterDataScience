library(reshape2)
#View(airquality)
colnames(airquality) <- tolower(colnames(airquality))

# derretir: melt
melt(airquality)
melt(airquality, id.vars = c("month","day"), 
     variable.name = "miVariable", value.name = "miValor") %>% View


# congelar: dcast
derretido <- melt(airquality, id.vars = c("month","day"))

dcast(derretido, month ~ variable, fun.aggregate = mean, na.rm=T)

dcast(derretido, month + day ~ variable, fun.aggregate = mean, na.rm=T)

dcast(derretido, month ~ day + variable, fun.aggregate = mean, na.rm=T)

dcast(derretido, month + day + variable ~ .)
