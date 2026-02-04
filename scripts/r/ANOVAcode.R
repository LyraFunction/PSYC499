## Code for running the mixed effects AVNOA and one-way ANOVA 
# Packages
library(arrow)
library(rstatix)
library(afex)
library(performance) 

## Import data
Dataset_clean_LONG <- read_parquet("~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_LONG.parquet")

# Prep data
Dataset_clean_LONG$Year <- as.factor(Dataset_clean_LONG$Year)
Dataset_clean_LONG$Winning_Party <- as.factor(Dataset_clean_LONG$Winning_Party)

Dataset_clean_LONG %>%
  group_by(Year, Winning_Party) %>%
  get_summary_stats(Total_per_capita, type = "full")
## Check assumptions
# Homogeneity of Variances
o1 <- aov_ez("FIPS", "Total_per_capita", Dataset_clean_LONG, 
             between = c("Winning_Party"))
check_homogeneity(o1)
# Sphericity
a1 <- aov_ez("FIPS", "Total_per_capita", Dataset_clean_LONG, 
             between = "Winning_Party", 
             within = c("Year"))
check_sphericity(a1)

## Load models
# The dataset for this study fails the previous assumptions thus another method
# of analysis will be used. 
# res.aov <- anova_test(
#   data = Dataset_clean_LONG, dv = Total_per_capita, wid = FIPS,
#   within = Year, between = c(Winning_Party)
# )
## Output
# get_anova_table(res.aov)



