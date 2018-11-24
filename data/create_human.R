#Ville Pikkarainen 22.11.2018
#IODS-project, data wrangling exercise as part of exercise 4, preparing dataset for chapter 5

rm(list=ls()) 
library(dplyr)
#Importing data from UNDPs human development repors

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")
class(hd)
class(gii)
#Structure and dimensions of the data
str(hd)
dim(hd)
head(hd)
summary(hd) #summary of variables in hd

str(gii)
dim(gii)
head(gii)
summary(gii) #summary of variables in gii
#hd has 195 obs. of  8 variables
#gii has 195 obs. of  10 variables

#renaming the variables with shorter & descriptive names

names(hd)
names(gii)

colnames(hd) <- c("HDI.Rank","Country","HDI","Life.Exp","Edu.Exp","Edu.Mean","GNI","GNI.Minus.Rank")
colnames(gii) <- c("GII.Rank", "Country", "GII","Mat.Mor","Ado.Birth","Parli.F","Edu2.F","Edu2.M","Labo.F","Labo.M")

#Create two new variables: ratio of female and male populations with secondary education in each country. (i.e. edu2F / edu2M). The second new 
#variable should be the ratio of labour force participation of females and males in each country (i.e. labF / labM).

gii <- mutate(gii, Edu2.FM = Edu2.F/Edu2.M)
gii <- mutate(gii, Labo.FM = Labo.F/Labo.M)

#Joining together the two datasets using the variable "country" as the identifier. 
#Keep only the countries  in both data sets (Hint: inner join). 
#The joined data should have 195 observations and 19 variables. 
#Call the new joined data "human" and save it in your data folder.
head(gii)

human <- inner_join(hd, gii, by = "Country")
str(human) 
#dataset "human" has 195 obs. of  19 variables

write.table(human, file = "human.txt", , dec=".", sep=",")
human <- read.table("human.txt", sep = "," , header=TRUE)
#calling "human"
human

#Everything seems to work!
