#-----------------------
#ERCEL R minikurz
#
#Data processing using the Tidyverse
#-----------------------

#this line of code is important and sets the working directory
#(which is the folder that contains all the files required for your code to work)
#please make sure you run this line of code first
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

install.packages("skimr")
install.packages("readxl")
install.packages("ggtext")

library(tidyverse)
library(skimr)
library(readxl)
library(ggtext)

ercel_data_raw <- read_csv("Data/ercel_questionnaire_data.csv")
#ercel_data_raw <- read_excel("Data/ercel_questionnaire_data.xlsx")

mis.data <- read_csv("Data/missing_data_example.csv", na=c("NA", "", "NULL", "ahoj"))


skim(ercel_data_raw)
