## Data for running mean comparisons tests

# Packages
library(FSA)
library(dplyr)
library(rstatix)
library(dunn.test)
library(ggplot2)
library(conover.test)

## Import data
Dataset_clean_LONG <- read_parquet("~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_LONG.parquet")
Dataset_clean_WIDE <- read_parquet(
  "~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_WIDE.parquet")

# Prep data years
Dataset_clean_LONG <- Dataset_clean_LONG[complete.cases(Dataset_clean_LONG), ]
Dataset_clean_LONG$Year <- as.factor(Dataset_clean_LONG$Year)
Dataset_clean_LONG$Winning_Party <- as.factor(Dataset_clean_LONG$Winning_Party)

data_2017 <- Dataset_clean_LONG %>% filter(Year == 2017)
data_2018 <- Dataset_clean_LONG %>% filter(Year == 2018)
data_2019 <- Dataset_clean_LONG %>% filter(Year == 2019)
data_2020 <- Dataset_clean_LONG %>% filter(Year == 2020)

# Group comparisons
t.test(x = data_2017$Winning_Party, y = data_2017$Total_per_capita, paired = FALSE)
t.test(x = data_2018$Winning_Party, y = data_2018$Total_per_capita, paired = FALSE)
t.test(x = data_2019$Winning_Party, y = data_2019$Total_per_capita, paired = FALSE)
t.test(x = data_2020$Winning_Party, y = data_2020$Total_per_capita, paired = FALSE)

wilcox.test(x = data_2017$Winning_Party, y = data_2017$Total_per_capita, paired = FALSE, conf.int = TRUE)
wilcox_effsize(data = data_2017, formula = Total_per_capita ~ Winning_Party, ref.group = "1", paired = FALSE, alternative = "less", ci = TRUE)
wilcox.test(x = data_2018$Winning_Party, y = data_2018$Total_per_capita, paired = FALSE, conf.int = TRUE)
wilcox_effsize(data = data_2018, formula = Total_per_capita ~ Winning_Party, ref.group = "1", paired = FALSE, alternative = "less", ci = TRUE)
wilcox.test(x = data_2019$Winning_Party, y = data_2019$Total_per_capita, paired = FALSE, conf.int = TRUE)
wilcox_effsize(data = data_2019, formula = Total_per_capita ~ Winning_Party, ref.group = "1", paired = FALSE, alternative = "less", ci = TRUE)
wilcox.test(x = data_2020$Winning_Party, y = data_2020$Total_per_capita, paired = FALSE, conf.int = TRUE)
wilcox_effsize(data = data_2020, formula = Total_per_capita ~ Winning_Party, ref.group = "1", paired = FALSE, alternative = "less", ci = TRUE)

# Year analysis
t.test(x = data_2017$Total_per_capita, y = data_2018$Total_per_capita, paired = TRUE)
t.test(x = data_2018$Total_per_capita, y = data_2019$Total_per_capita, paired = TRUE)
t.test(x = data_2019$Total_per_capita, y = data_2020$Total_per_capita, paired = TRUE)

wilcox.test(x = data_2017$Total_per_capita, y = data_2018$Total_per_capita, paired = TRUE, conf.int = TRUE)
wilcox.test(x = data_2018$Total_per_capita, y = data_2019$Total_per_capita, paired = TRUE, conf.int = TRUE)
wilcox.test(x = data_2019$Total_per_capita, y = data_2020$Total_per_capita, paired = TRUE, conf.int = TRUE)
wilcox_effsize(data = Dataset_clean_LONG, formula = Total_per_capita ~ Year, comparisons = list(c("2017", "2018"), c("2018", "2019"), c("2019", "2020")), paired = TRUE, alternative = "less", ci = TRUE)


rm(data_2017)
rm(data_2018)
rm(data_2019)
rm(data_2020)
rm(drops)
# Exploratory hypothesis
dunn.test(data$Bias_Mean_per_capita, data$Bias_Types, method = "bonferroni")
conover.test(x = data$Bias_Mean_per_capita, g = data$Bias_Types, kw=TRUE, label=TRUE, list = TRUE, alpha = .01)