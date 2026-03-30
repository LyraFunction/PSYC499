### Code for measurement equivalence

# Imports
library(lavaan)
library(arrow)
library(semTools)

# Data read
options(max.print=99999)
setwd("~/Desktop/Projects/Programming/PSYC499/scripts/r")
data <- read_parquet("~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_WIDE.parquet")

# Data prep
drops <- c("Y2017_Anti-Lesbian","Y2018_Anti-Lesbian","Y2019-Anti_Lesbian",
           "Y2020_Anti-Lesbian","Y2017_Anti-Gay","Y2018_Anti-Gay",
           "Y2019_Anti-Gay","Y2020_Anti-Gay","Y2017_Anti-Bisexual",
           "Y2018_Anti-Bisexual","Y2019_Anti-Bisexual","Y2020_Anti-Bisexual",
           "Y2017_Anti-General","Y2018_Anti-General","Y2019_Anti-General",
           "Y2020_Anti-General","Y2017_Anti-Transgender","Y2018_Anti-Transgender",
           "Y2019_Anti-Transgender","Y2020_Anti-Transgender",
           "Y2017_Anti-Gender_Nonconforming","Y2017_Total",
           "Y2018_Anti-Gender_Nonconforming","Y2018_Total",
           "Y2019_Anti-Gender_Nonconforming","Y2019_Total",
           "Y2020_Anti-Gender_Nonconforming","Y2020_Total")
data <- data[, !(names(data) %in% drops)]
data <- data[complete.cases(data), ]

# Load model