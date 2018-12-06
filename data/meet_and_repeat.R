#Ville Pikkarainen 22.11.2018
#IODS-project, data wrangling exercise as part of Chapter 6
#info regarding data here: https://mooc.helsinki.fi/pluginfile.php/29659/course/section/2208/MABS4IODS-Part6.pdf

#dataset BPRS: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
#dataset RATS: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

#start with some house keeping
rm(list=ls()) 
library(dplyr)
library(stringr)
library(ggplot2)
library(GGally)
library(tidyr)

### PART 1: Importing data and looking at the datasets

#importing data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", stringsAsFactors = F, na.strings = "..")
#Structure and dimensions of the data for BPRS
str(BPRS) #40 obs. of  11 variables
dim(BPRS)
head(BPRS)
summary(BPRS) #summary of variables in BPRS
#BPRS is a wide format dataset. Here, each participant has its own row and each response is in the separate column (for different weeks)
#also, the first column shows if the participant is in the treatment or the control group 
#and the second column shows the "number" of the subject such that all subjects have their own number.
#As indicated by str() and later explained in more detail, there are 40 obs. of  11 variables 
#so the number of participants is 40 and there are 11 variables for them (treatment, subject number, observations for weeks 0 - 11)


#Backfround info about this particular dataset:
#In BPRS, "40 male subjects were randomly assigned to one of two treatment groups and each subject was rated
#on the brief psychiatric rating scale (BPRS) measured before treatment began
#(week 0) and then at weekly intervals for eight weeks. The BPRS assesses
#the level of 18 symptom constructs such as hostility, suspiciousness, hallucinations
#and grandiosity; each of these is rated from one (not present) to seven
#(extremely severe). The scale is used to evaluate patients suspected of having
#schizophrenia." (https://mooc.helsinki.fi/pluginfile.php/29659/course/section/2208/MABS4IODS-Part6.pdf)


#Structure and dimensions of the data for RATS

str(RATS) #16 obs. of  13 variables
dim(RATS) 
head(RATS)
summary(RATS) #summary of variables in RATS

#Similarly to BPRS, also RATS dataset is in wide form such that there are 16 participants who are assigned an ID (the first column),
#a group (1, 2 or 3) and the rest of the variables are for observations at different points of time.

### PART 2: Converting the categorical variables of both data sets to factors

# Factor treatment & subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# Factor variables ID and Group
RATS$ID<-factor(RATS$ID)
RATS$Group<-factor(RATS$Group)

### PART 3: Converting the data sets to long form and adding a week variable to BPRS and a Time variable to RATS

# Convert to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)

# Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)

# Convert data to long form
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 

# Glimpse the data
glimpse(RATSL)

write.table(RATSL, file = "RATSL.txt")
write.table(BPRSL, file = "BPRSL.txt")

### PART 4: Taking a SERIOUS LOOK (lol) at the new datasets and comparing them to the originals in wide form

#lets take a look at the new and the old datasets
#old BPRS which is in the wide form
glimpse(BPRS)
#new BPRSL, which is in the long form
glimpse(BPRSL)
#old RATS which is in the wide form
glimpse(RATS)
#new RATSL, which is in the long form
glimpse(RATSL)

#Comparing the forms:

#The difference between the wide and long form is that the long form lists observations differently
#The observations are listed by two or more variables. At the case of BPRSL:
#By individual, by group in which the individual belongs to and by the observational point of time
#This is different when compared to the wide form. In the wide form, the observations at different time points
#are all listed as different variables and thus there are more variables in the wide form. (11 variables in BPRS, 5 in BPRSL)

#Long form is convenient as regression tools may be easily used with it. However, the wide form has its benefits as well,
#as the summaries of variables are more informative in the wide form. Also, when collecting the data and studying different variables
#alone, wide form may seem a bit more convenient. 

#Overall, it's good to remember that the same information exists in both forms so in that sense the usability of different forms
#depends on what you want to do with the data.