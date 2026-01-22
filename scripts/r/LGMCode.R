# Import libraries
library(lavaan)
library(tidyverse)
library(arrow)

#Some of the output can get long, so increasing the print output may be necessary
options(max.print=99999)

# Set directory for output and load in dataset
setwd("~/Desktop/Projects/Programming/PSYC499/scripts/r")
data <- read_parquet("~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_1.parquet")

#The following lavaan code specifies the model
#Replace the harm_block_ variables with the names of your timepoint variables
#They must be in order.

# In Lavaan, =~ is used to assign indicators to a latent factor
# ~ is used to designate a path (i.e., regression) and ~~ is used to designate covariances

sem_model<-'
# This models the latent intercept for the slope (i.e., at initial timepoint). 
# Each gets multiplied by 1.
intercept =~ 1+Y2017_QTR1+ 1*Y2017_QTR2 + 1*Y2017_QTR3 + 1*Y2017_QTR4 + 1*Y2018_QTR1 + 1*Y2018_QTR2 + 1*Y2018_QTR3 + 1*Y2018_QTR4 + 1*Y2019_QTR1 + 1*Y2019_QTR2 + 1*Y2019_QTR3 + 1*Y2019_QTR4 + 1*Y2020_QTR1 + 1*Y2020_QTR2 + 1*Y2020_QTR3 + 1*Y2020_QTR4

# This models the latent slope. Note that each gets multipled by a coefficient 
# that increases with each timepoint.
slope =~ 0*Y2017_QTR1+1*Y2017_QTR2+2*Y2017_QTR3+3*Y2017_QTR4+4*Y2018_QTR1+5*Y2018_QTR2+6*Y2018_QTR3+7*Y2018_QTR4+8*Y2019_QTR1+9*Y2019_QTR2+10*Y2019_QTR3+11*Y2019_QTR4+12*Y2020_QTR1+13*Y2020_QTR2+14*Y2020_QTR3+15*Y2020_QTR4

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
sink(file = "model_output1.txt")

fit.growth_1<-growth(sem_model, data = data, se = "bootstrap", missing = "fiml", check.gradient = FALSE, control=list(iter.max=1000))
summary(fit.growth_1,fit.measures = TRUE,standardized=T, ci=TRUE)
parameterEstimates(fit.growth_1)

#This ends the sink
sink(file = NULL)
