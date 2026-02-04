## Data for running mean comparisons tests

# Packages
library(FSA)
library(dplyr)
library(rstatix)
library(dunn.test)
library(ggplot2)
library(conover.test)

## Import data
bias_data <- read_parquet("~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_BIAS.parquet")
tota_data <- read_parquet("~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_LONG.parquet")

# Prep data
bias_data$Bias_Types <- as.factor(data$Bias_Types)
mean_values <- data %>%
  group_by(Bias_Types) %>%
  summarise(Mean_Bias_Mean = mean(Bias_Mean_per_capita, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(Mean_Bias_Mean))  # Order by descending mean values


# Group comparisons


# Year analysis

# Exploratory hypothesis
dunn.test(data$Bias_Mean_per_capita, data$Bias_Types, method = "bonferroni")
conover.test(x = data$Bias_Mean_per_capita, g = data$Bias_Types, kw=TRUE, label=TRUE, list = TRUE, alpha = .01)


ggplot(data, aes(x = Bias_Types, y = Bias_Mean_per_capita)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Bias Mean by Type", x = "Bias Type", y = "Mean Bias")
ggplot(data, aes(x = Bias_Types, y = Bias_Mean_per_capita)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Bias Mean by Type", x = "Bias Type", y = "Mean Bias")
Bias_Bar <-ggplot(mean_values,aes(Bias_Types,Mean_Bias_Mean))+geom_bar(stat="identity")
Bias_Bar
Bias_Bar+geom_path(x=c(1,1,2,2),y=c(25,26,26,25))+
  geom_path(x=c(2,2,3,3),y=c(37,38,38,37))+
  geom_path(x=c(3,3,4,4),y=c(49,50,50,49))+
  annotate("text",x=1.5,y=27,label="p=0.012")+
  annotate("text",x=2.5,y=39,label="p<0.0001")+
  annotate("text",x=3.5,y=51,label="p<0.0001")