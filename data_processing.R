# setwd("./Desktop/Online Coursera/Coursera-Developing-Data-Products/project/")

# Load required libraries
require(data.table)
# library(sqldf)
library(dplyr)
library(DT)
library(rCharts)

# Read data
activities <- read.csv(paste(getwd(),"/data/activities.csv",sep=""),sep=";", dec = ",")
