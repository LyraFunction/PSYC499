# Import libraries
library(lavaan)
library(tidyverse)

#Some of the output can get long, so increasing the print output may be necessary
options(max.print=99999)

#If your data is a .csv, use this code below 
#(replace "data.csv" with whatever your dataset is called)
data<-read.csv("data.csv")

#The following lavaan code specifies the model
#Replace the harm_block_ variables with the names of your timepoint variables
#They must be in order.

# In Lavaan, =~ is used to assign indicators to a latent factor
# ~ is used to designate a path (i.e., regression) and ~~ is used to designate covariances

sem_model<-'
#This model the latent intercept for the slope (i.e., at initial timepoint). Each gets multiplied by 1.
intercept =~ 1*harm_block_1 + 1*harm_block_2 + 1*harm_block_3 + 1*harm_block_4 + 1*harm_block_5 + 1*harm_block_6 + 1*harm_block_7 + 1*harm_block_8 + 1*harm_block_9 + 1*harm_block_10 + 1*harm_block_11 + 1*harm_block_12 + 1*harm_block_13 + 1*harm_block_14 + 1*harm_block_15 + 1*harm_block_16

#This models the latent slope. Note that each gets multipled by a coefficient that increases with each timepoint.
slope =~ 0*harm_block_1+1*harm_block_2+2*harm_block_3+3*harm_block_4+4*harm_block_5+5*harm_block_6+6*harm_block_7+7*harm_block_8+8*harm_block_9+9*harm_block_10+10*harm_block_11+11*harm_block_12+12*harm_block_13+13*harm_block_14+14*harm_block_15+15*harm_block_16

#This will model the path from the vote to the intercept (replace vote with the variable name)
intercept~vote

#This will model the path from the vote to the slope
slope~vote

#This will model the covariance between the latent intercept and the latent slope
#This can tell you if counties that started higher in hate crimes also increased faster
intercept ~~ slope
'

#If you don't know how to use R Markdown, you can use the function "sink" to create a text file of your output
#This starts the sink
sink(file = "model_output.txt")

fit.growth_1<-growth(sem_model, data = data, se = "bootstrap", missing = "fiml", check.gradient = FALSE, control=list(iter.max=1000))
summary(fit.growth_1,fit.measures = TRUE,standardized=T, ci=TRUE)
parameterEstimates(fit.growth_1)

#This ends the sink
sink(file = NULL)

#Steps to consider for SEM
#1: Does the model converge?
#2: Does it show good fit?
#The three most common fit indices are: RMSEA (> .08 is acceptable), TLI (>.80 is acceptable) and CFI (>.80 is acceptable)

