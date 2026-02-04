## Code for running the regression model 
# Packages
library(ggplot2)
library(pscl)
library(dplyr)
library(arrow)


## Import data
Dataset_clean_LONG <- read_parquet("~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_LONG.parquet")

# Prep data
Dataset_clean_LONG$Year <- as.factor(Dataset_clean_LONG$Year)
Dataset_clean_LONG$Winning_Party <- as.factor(Dataset_clean_LONG$Winning_Party)

# Load Model
zip_model <- zeroinfl(Total_per_capita ~ Winning_Party + Year | Winning_Party, 
                      data = Dataset_clean_LONG, dist = "poisson")
# Get Model
summary(zip_model)

model <- glm(Total_per_capita ~ Winning_Party + Year, 
                 data = Dataset_clean_LONG, 
                 family = poisson())
# Get Model
summary(model)