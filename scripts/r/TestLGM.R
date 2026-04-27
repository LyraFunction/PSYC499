# Import libraries
library(lavaan)
library(tidyverse)
library(arrow)
library(tidySEM)

#Some of the output can get long, so increasing the print output may be necessary
options(max.print=99999)

#If your data is a .csv, use this code below 
#(replace "data.csv" with whatever your dataset is called)
setwd("~/Desktop/Projects/Programming/PSYC499/scripts/r")
data <- read_parquet("~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_WIDE.parquet")


#The following lavaan code specifies the model
#Replace the harm_block_ variables with the names of your timepoint variables
#They must be in order.

# In Lavaan, =~ is used to assign indicators to a latent factor
# ~ is used to designate a path (i.e., regression) and ~~ is used to designate covariances

sem_model<-'
# This models the latent intercept for the slope (i.e., at initial timepoint). 
# Each gets multiplied by 1.
intercept =~ 1+Y2017_Total+ 1*Y2018_Total + 1*Y2019_Total + 1*Y2020_Total

# This models the latent slope. Note that each gets multipled by a coefficient 
# that increases with each timepoint.
slope =~ 0*Y2017_Total+1*Y2018_Total+2*Y2019_Total+3*Y2020_Total

# This will model the path from the vote to the intercept (replace vote with 
# the variable name)
intercept~Winning_Party

# This will model the path from the vote to the slope
slope~Winning_Party

# This will model the covariance between the latent intercept and the latent 
# slope
#This can tell you if counties that started higher in hate crimes also increased faster
intercept ~~ slope
'

#If you don't know how to use R Markdown, you can use the function "sink" to create a text file of your output
#This starts the sink
sink(file = "model_output_test.txt")

fit.growth_1<-growth(sem_model, data = data, se = "bootstrap", missing = "fiml", check.gradient = FALSE, control=list(iter.max=1000))
summary(fit.growth_1,fit.measures = TRUE,standardized=T, ci=TRUE)
parameterEstimates(fit.growth_1)

#This ends the sink
sink(file = NULL)

#Steps to consider for SEM
#1: Does the model converge?
#2: Does it show good fit?
#The three most common fit indices are: RMSEA (> .08 is acceptable), TLI (>.80 is acceptable) and CFI (>.80 is acceptable)

graph_sem(fit.growth_1)