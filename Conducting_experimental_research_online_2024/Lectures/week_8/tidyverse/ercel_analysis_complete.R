#-----------------------
#ERCEL R minikurz
#
#Data processing using the Tidyverse
#-----------------------

#this line of code is important and sets the working directory
#(which is the folder that contains all the files required for your code to work)
#please make sure you run this line of code first
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#install the packages
install.packages("skimr")
install.packages("ggtext")
install.packages("readxl")

#load the package
library(readxl)
library(skimr)
library(ggtext)
library(tidyverse)

#load in the raw .csv file
ercel_data_raw <- read_csv("Data/ercel_questionnaire_data.csv")

#load in the excel version of the data
ercel_data_raw_xlsx <- read_excel("Data/ercel_questionnaire_data.xlsx")

#open new tab showing the raw data
View(ercel_data_raw)

#only code values that are NULL as NAs
#csv file
missing_data_example <- read_csv("Data/missing_data_example.csv", na = "NULL")

#xlsx file
missing_data_example <- read_excel("Data/missing_data_example.xlsx", na = "NULL")

#code values that are NULL, NA, 10 or ahoj empty as NAs
#csv file
missing_data_example2 <- read_csv("Data/missing_data_example.csv", na = c("NULL", "NA", "", 10, "ahoj"))

#xlsx file
missing_data_example2 <- read_excel("Data/missing_data_example.xlsx", na = c("NULL", "NA", "", 10, "ahoj"))

#create a summary object
ercel_data_raw_summary <- skim(ercel_data_raw)

#print the summary
ercel_data_raw_summary

#data cleaning steps
ercel_data_clean <- ercel_data_raw %>%
  filter(Finished == TRUE) %>% #remove the participant who did not finish
  select(vaše_jméno, starts_with("day")) #only keep these variables

#make the ercel_data_clean data long
ercel_data_long <- ercel_data_clean %>%
  pivot_longer(cols = starts_with("day"),
               names_to = "day",
               values_to = "time")

#view the long data
View(ercel_data_long)

#make the time variable have separate rows for each values
ercel_data_long_rows <- ercel_data_long %>%
  separate_rows(time,
                sep = ",")

#remove the "day_" prefix from the the day column"
ercel_data_long_rows <- ercel_data_long_rows %>%
  mutate(day = str_remove(string = day,
                          pattern = "day_"))

#remove the "day_" prefix from the the day column"
ercel_data_long_rows <- ercel_data_long_rows %>%
  mutate(time = fct_explicit_na(f = time,
                                na_level = "none"))

#relevel the day and time variables so they are in a specificed order (not alphabetical)
ercel_data_long_rows <- ercel_data_long_rows %>%
  mutate(day = fct_relevel(day,
                           "pondělí",
                           "úterý",
                           "středa",
                           "čtvrtek",
                           "pátek"),
         time = fct_relevel(time,
                            "9.00-10.30am",
                            "10.30am-12.00pm",
                            "12.00-1.30pm",
                            "1.30-3.00pm",
                            "3.00-4.30pm",
                            "none"))
#create a new variable called time_category where any values that are "9.00-10.30am", "10.30am-12.00pm" are "morning" and every other value is "afternoon"
ercel_data_long_rows <- ercel_data_long_rows %>%
  mutate(time_category = ifelse(time %in% c("9.00-10.30am", "10.30am-12.00pm"),
                                "morning",
                                "afternoon"))
