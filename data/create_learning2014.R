#Ville Pikkarainen, November 2018
#This is an r-script for IODS-project. Source for the data: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt

rm(list=ls()) 
# Access the dplyr library as it is needed later
library(dplyr)

#Read data from the source mentioned above and name it as "lrn14"
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# look at the dimensions of the data
dim(lrn14)
#dataset includes 183 rows (observations) and 60 columns (variables)
# look at the structure of the data
str(lrn14)
#str() gives more detailed information about out dataset. We know that the set includes 183 obs. of  60 variables. Apart from variable "gender", all variables are integers.
#more detailed information about the variables can be found here: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-meta.txt


# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# choose a handful of columns to keep
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
str(keep_columns)
# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# see the stucture of the new dataset
str(learning2014)


# print out the column names of the data
colnames(learning2014)

# change the name of the second column
colnames(learning2014)[2] <- "age"
# change the name of the third column
colnames(learning2014)[3] <- "attitude"

# change the name of "Points" to "points"
colnames(learning2014)[7]<-"points"

# print out the new column names of the data
colnames(learning2014)

# select male students
male_students <- filter(learning2014, gender == "M")

# select rows where points is greater than zero
learning2014 <- filter(learning2014, points >0)
#study the structure after data wrangling
str(learning2014)
#we now have 166 obs. of  7 variables as instructed in the instructions

#After the wrangling we create and save the dataset to be used later for the analysis
write.table(learning2014, file="learning2014.txt", dec=".", sep=",")
setwd("~/Documents/GitHub/IODS-project")
#now lets see if previous step works as intended by importing the new file and studying its structure
learning2014<-read.table("learning2014.txt", dec=".", sep=",") 
str(learning2014)
head(learning2014)
#as expected, the dataset "learning2014.txt" includes 166 obs. of  7 variables
#and head() suggests that the variables match our expectations as well.