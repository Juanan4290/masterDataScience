# importing libraries
library(dplyr)

# read titanic dataset
titanic <- read.csv("./R/masterClasses/01_introductionToR/data/train.csv")

# filter first class women and get the survived and fare columns
firstClassWomen <- titanic[(titanic$Sex == "female" & titanic$Pclass == 1),c("Survived","Fare")]
  # dplyr
  titanic %>%
    filter(Sex == "female", Pclass == 1) %>%
    select(Survived, Fare)

# survived people percentage of the previous group
mean(firstClassWomen$Survived, na.rm = T)

  #dplyr
  firstClassWomen %>%
    summarise(porcentage = mean(Survived, na.rm = T))

# calculate the survived porcentage for each class and sex group
titanic %>%
  group_by(Pclass, Sex) %>%
  summarise(porcentage = mean(Survived, na.rm = T))

# calculate the mean age of the survived men
mean(titanic[titanic$Sex=="male","Survived"], na.rm = T)

  #dplyr
  titanic %>%
    filter(Sex == "male") %>%
    summarise(porcentage = mean(Survived, na.rm = T))

# how many people survived? how many people died?
table(titanic$Survived)[2]
sum(!titanic$Survived)

  #dplyr
  titanic %>%
    select(Survived) %>%
    table %>% .[2]

# how many people traveled?
nrow(titanic)  
  # dplyr
  titanic %>% nrow

# Ratio between first and thrid class people
nrow(titanic[titanic$Pclass == 1,]) / nrow(titanic[titanic$Pclass == 3,])
  # dplyr
  firstClassPeople = titanic %>%
    filter(Pclass == 1) %>%
    nrow
  
  thirdClassPeople = titanic %>%
    filter(Pclass == 3) %>%
    nrow
  
  firstClassPeople / thirdClassPeople  

# Filter by age and sex first class people
titanic[titanic$Pclass == 1,c("Age","Sex")]
  # dplyr
  titanic %>%
    filter(Pclass == 1) %>%
    select(Age,Sex)

# get the mask to select third class survived or first class men who died
titanic[(titanic$Pclass == 3 & titanic$Survived == 1) | (titanic$Pclass == 1 & titanic$Survived == 0),]
  # dplyr
  titanic %>%
    filter((Pclass == 3 & Survived) | (Pclass == 1 & !Survived))
  
# calculate the correlation between age and fare by sex
cor(titanic[,c("Age","Fare")], use = "complete.obs")
  #dplyr
  titanic %>%
    select(Age,Fare,Sex) %>%
    group_by(Sex) %>%
    summarise(correlation = cor(Age, Fare, use = "complete.obs"))