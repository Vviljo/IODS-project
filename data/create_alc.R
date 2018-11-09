#Ville Pikkarainen, November 2018
#this is an r-script for data analysis for IODS-project's chapter 3
#source of the data: https://archive.ics.uci.edu/ml/machine-learning-databases/00320/ (Paulo Cortez, University of Minho, GuimarÃ£es, Portugal, http://www3.dsi.uminho.pt/pcortez)
#more information about the data: https://archive.ics.uci.edu/ml/datasets/Student+Performance

library(dplyr)
library(ggplot2)

math=read.table("student-mat.csv",sep=";",header=TRUE)
por=read.table("student-por.csv",sep=";",header=TRUE)

alc<-c(d1, d2)
# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix=c(".math", ".por"))

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- (first_column)
  }
}

# glimpse at the new combined data
glimpse(alc)


print(nrow(alc)) # 382 students
str(alc)
dim(alc)

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)
#Observations: 382
#Variables: 35
#After the wrangling we create and save the dataset to be used later for the analysis
write.table(alc, file="alc.txt", dec=".", sep=",")
