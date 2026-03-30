## Code for descriptive statistics, correlations, and misc analyses


# Set directory location ## TODO fix this to be dynamic rather than static?
setwd("~/Desktop/Projects/Programming/PSYC499/scripts/r")

# Packages
library(arrow) # For files
library(patchwork) # ^
library(cowplot) # ^
library(ggh4x) # ˆ
library(tidyverse)
library(svglite)
#library(e1071) 
library(ggh4x)
library(tidyplots)

## Read datasets
Dataset_clean_LONG <- read_parquet(
  "~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_LONG.parquet")
Dataset_clean_WIDE <- read_parquet(
  "~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_WIDE.parquet")

## Prep
# Wide
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
Dataset_clean_WIDE <- Dataset_clean_WIDE[ , !(names(Dataset_clean_WIDE) %in% drops)]
Dataset_clean_WIDE <- Dataset_clean_WIDE[complete.cases(Dataset_clean_WIDE), ]

# Quarter Prep
drops <- c("Y2017_Total","Y2018_Total","Y2019_Total","Y2020_Total",
           "Y2017_Anti-Lesbian","Y2018_Anti-Lesbian","Y2019_Anti-Lesbian","Y2020_Anti-Lesbian",
           "Y2017_Anti-Gay","Y2018_Anti-Gay","Y2019_Anti-Gay","Y2020_Anti-Gay",
           "Y2017_Anti-Bisexual","Y2018_Anti-Bisexual","Y2019_Anti-Bisexual","Y2020_Anti-Bisexual",
           "Y2017_Anti-Transgender","Y2018_Anti-Transgender","Y2019_Anti-Transgender","Y2020_Anti-Transgender",
           "Y2017_Anti-General","Y2018_Anti-General","Y2019_Anti-General","Y2020_Anti-General",
           "Y2017_Anti-Gender_Nonconforming","Y2018_Anti-Gender_Nonconforming","Y2019_Anti-Gender_Nonconforming","Y2020_Anti-Gender_Nonconforming",
           "Y2017_HC_Flag","Y2018_HC_Flag","Y2019_HC_Flag","Y2020_HC_Flag")
Dataset_clean_QUARTER <- Dataset_clean_WIDE[ , !(names(Dataset_clean_WIDE) %in% drops)]
# Pivot for quarters
Dataset_clean_QUARTER <- Dataset_clean_QUARTER %>% 
  pivot_longer(
    cols = c("Y2017_QTR1", "Y2017_QTR2", "Y2017_QTR3", "Y2017_QTR4", 
             "Y2018_QTR1", "Y2018_QTR2", "Y2018_QTR3", "Y2018_QTR4", 
             "Y2019_QTR1", "Y2019_QTR2", "Y2019_QTR3", "Y2019_QTR4", 
             "Y2020_QTR1", "Y2020_QTR2", "Y2020_QTR3", "Y2020_QTR4"), 
    names_to = "Quarter",
    values_to = "Total"
  )
# Reshape the dataframe
Dataset_clean_QUARTER <- Dataset_clean_QUARTER %>% 
  pivot_longer(
    cols = ("Y2017_Population"), 
    names_to = "Year",
    values_to = "Population")
drops <- c("Y2017_Population","Y2018_Population","Y2019_Population","Y2020_Population",
           "Year")
Dataset_clean_QUARTER <- Dataset_clean_QUARTER[ , !(names(Dataset_clean_QUARTER) %in% drops)]
Dataset_clean_QUARTER <- Dataset_clean_QUARTER %>%
  mutate(total_per_capita = (Total / Population) * 10000)
Dataset_clean_QUARTER <- Dataset_clean_QUARTER[complete.cases(Dataset_clean_QUARTER), ]
# Years column
Year <- rep(c(2017, 2018, 2019, 2020), each = 4)
Year <- rep(Year, length.out = 49744)
# Bind
Dataset_clean_QUARTER <- cbind(Dataset_clean_QUARTER, Year)




Dataset_clean_LONG$Year <- as.factor(Dataset_clean_LONG$Year)
Dataset_clean_LONG$Winning_Party <- as.factor(Dataset_clean_LONG$Winning_Party)
Dataset_clean_QUARTER$Quarter <- as.factor(Dataset_clean_QUARTER$Quarter)
Dataset_clean_QUARTER$Winning_Party <- as.factor(Dataset_clean_QUARTER$Winning_Party)

# Bias 
# Bias Prep
drops <- c("County_Name","Democratic_Votes","Republican_Votes","State_name"
           ,"Y2017_Total","Y2018_Total","Y2019_Total","Y2020_Total","Y2017_QTR1",
           "Y2017_QTR2","Y2017_QTR3","Y2017_QTR4",
           "Y2018_QTR1","Y2018_QTR2","Y2018_QTR3","Y2018_QTR4",
           "Y2019_QTR1","Y2019_QTR2","Y2019_QTR3","Y2019_QTR4",
           "Y2020_QTR1","Y2020_QTR2","Y2020_QTR3","Y2020_QTR4")
Dataset_clean_BIAS <- Dataset_clean_WIDE[ , !(names(Dataset_clean_WIDE) %in% drops)]
Dataset_clean_BIAS <- Dataset_clean_BIAS[complete.cases(Dataset_clean_BIAS), ]
### Descriptive
## Year and Party
Dem_2017 <- (Dataset_clean_LONG %>% filter(Year == 2017, Winning_Party == 0))
round(mean(Dem_2017$Total_per_capita), 2)
round(sd(Dem_2017$Total_per_capita),2)
round(range(Dem_2017$Total_per_capita),2)
round(skewness(Dem_2017$Total_per_capita),2)
round(kurtosis(Dem_2017$Total_per_capita),2)
rm(Dem_2017)
Rep_2017 <- (Dataset_clean_LONG %>% filter(Year == 2017, Winning_Party == 1))
round(mean(Rep_2017$Total_per_capita),2)
round(sd(Rep_2017$Total_per_capita),2)
round(range(Rep_2017$Total_per_capita),2)
round(skewness(Rep_2017$Total_per_capita),2)
round(kurtosis(Rep_2017$Total_per_capita),2)
rm(Rep_2017)
Dem_2018 <- (Dataset_clean_LONG %>% filter(Year == 2018, Winning_Party == 0))
round(mean(Dem_2018$Total_per_capita),2)
round(sd(Dem_2018$Total_per_capita),2)
round(range(Dem_2018$Total_per_capita),2)
round(skewness(Dem_2018$Total_per_capita),2)
round(kurtosis(Dem_2018$Total_per_capita),2)
rm(Dem_2018)
Rep_2018 <- (Dataset_clean_LONG %>% filter(Year == 2018, Winning_Party == 1))
round(mean(Rep_2018$Total_per_capita),2)
round(sd(Rep_2018$Total_per_capita),2)
round(range(Rep_2018$Total_per_capita),2)
round(skewness(Rep_2018$Total_per_capita),2)
round(kurtosis(Rep_2018$Total_per_capita),2)
rm(Rep_2018)
Dem_2019 <- (Dataset_clean_LONG %>% filter(Year == 2019, Winning_Party == 0))
round(mean(Dem_2019$Total_per_capita),2)
round(sd(Dem_2019$Total_per_capita),2)
round(range(Dem_2019$Total_per_capita),2)
round(skewness(Dem_2019$Total_per_capita),2)
round(kurtosis(Dem_2019$Total_per_capita),2)
rm(Dem_2019)
Rep_2019 <- (Dataset_clean_LONG %>% filter(Year == 2019, Winning_Party == 1))
round(mean(Rep_2019$Total_per_capita),2)
round(sd(Rep_2019$Total_per_capita),2)
round(range(Rep_2019$Total_per_capita),2)
round(skewness(Rep_2019$Total_per_capita),2)
round(kurtosis(Rep_2019$Total_per_capita),2)
rm(Rep_2019)
Dem_2020 <- (Dataset_clean_LONG %>% filter(Year == 2020, Winning_Party == 0))
round(mean(Dem_2020$Total_per_capita),2)
round(sd(Dem_2020$Total_per_capita),2)
round(range(Dem_2020$Total_per_capita),2)
round(skewness(Dem_2020$Total_per_capita),2)
round(kurtosis(Dem_2020$Total_per_capita),2)
rm(Dem_2020)
Rep_2020 <- (Dataset_clean_LONG %>% filter(Year == 2020, Winning_Party == 1))
round(mean(Rep_2020$Total_per_capita),2)
round(sd(Rep_2020$Total_per_capita),2)
round(range(Rep_2020$Total_per_capita),2)
round(skewness(Rep_2020$Total_per_capita),2)
round(kurtosis(Rep_2020$Total_per_capita),2)
rm(Rep_2020)

## 2017
# Lesbian stats
round(mean(Dataset_clean_WIDE$`Y2017_Anti-Lesbian`),2)
round(sd(Dataset_clean_WIDE$`Y2017_Anti-Lesbian`),2)
# Gay stats
round(mean(Dataset_clean_WIDE$`Y2017_Anti-Gay`),2)
round(sd(Dataset_clean_WIDE$`Y2017_Anti-Gay`),2)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-Gay`,Dataset_clean_WIDE$`Y2017_Anti-Lesbian`)
# Bisexual Stats
round(mean(Dataset_clean_WIDE$`Y2017_Anti-Bisexual`),2)
round(sd(Dataset_clean_WIDE$`Y2017_Anti-Bisexual`),2)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-Bisexual`,Dataset_clean_WIDE$`Y2017_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-Bisexual`,Dataset_clean_WIDE$`Y2017_Anti-Gay`)
# Transgender Stats
round(mean(Dataset_clean_WIDE$`Y2017_Anti-Transgender`),2)
round(sd(Dataset_clean_WIDE$`Y2017_Anti-Transgender`),2)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-Transgender`,Dataset_clean_WIDE$`Y2017_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-Transgender`,Dataset_clean_WIDE$`Y2017_Anti-Gay`)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-Transgender`,Dataset_clean_WIDE$`Y2017_Anti-Bisexual`)
# Gender non Stats
round(mean(Dataset_clean_WIDE$`Y2017_Anti-Gender_Nonconforming`),2)
round(sd(Dataset_clean_WIDE$`Y2017_Anti-Gender_Nonconforming`),2)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2017_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2017_Anti-Gay`)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2017_Anti-Bisexual`)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2017_Anti-Transgender`)
# General Stats
round(mean(Dataset_clean_WIDE$`Y2017_Anti-General`),2)
round(sd(Dataset_clean_WIDE$`Y2017_Anti-General`),2)
cor.test(Dataset_clean_WIDE$`Y2017_Anti-General`,Dataset_clean_WIDE$`Y2017_Anti-Lesbian`)  
cor.test(Dataset_clean_WIDE$`Y2017_Anti-General`,Dataset_clean_WIDE$`Y2017_Anti-Gay`)  
cor.test(Dataset_clean_WIDE$`Y2017_Anti-General`,Dataset_clean_WIDE$`Y2017_Anti-Bisexual`)  
cor.test(Dataset_clean_WIDE$`Y2017_Anti-General`,Dataset_clean_WIDE$`Y2017_Anti-Transgender`)  
cor.test(Dataset_clean_WIDE$`Y2017_Anti-General`,Dataset_clean_WIDE$`Y2017_Anti-Gender_Nonconforming`)  

## 2018
# Lesbian stats
round(mean(Dataset_clean_WIDE$`Y2018_Anti-Lesbian`),2)
round(sd(Dataset_clean_WIDE$`Y2018_Anti-Lesbian`),2)
# Gay stats
round(mean(Dataset_clean_WIDE$`Y2018_Anti-Gay`),2)
round(sd(Dataset_clean_WIDE$`Y2018_Anti-Gay`),2)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-Gay`,Dataset_clean_WIDE$`Y2018_Anti-Lesbian`)
# Bisexual Stats
round(mean(Dataset_clean_WIDE$`Y2018_Anti-Bisexual`),2)
round(sd(Dataset_clean_WIDE$`Y2018_Anti-Bisexual`),2)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-Bisexual`,Dataset_clean_WIDE$`Y2018_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-Bisexual`,Dataset_clean_WIDE$`Y2018_Anti-Gay`)
# Transgender Stats
round(mean(Dataset_clean_WIDE$`Y2018_Anti-Transgender`),2)
round(sd(Dataset_clean_WIDE$`Y2018_Anti-Transgender`),2)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-Transgender`,Dataset_clean_WIDE$`Y2018_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-Transgender`,Dataset_clean_WIDE$`Y2018_Anti-Gay`)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-Transgender`,Dataset_clean_WIDE$`Y2018_Anti-Bisexual`)
# Gender non Stats
round(mean(Dataset_clean_WIDE$`Y2018_Anti-Gender_Nonconforming`),2)
round(sd(Dataset_clean_WIDE$`Y2018_Anti-Gender_Nonconforming`),2)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2018_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2018_Anti-Gay`)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2018_Anti-Bisexual`)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2018_Anti-Transgender`)
# General Stats
round(mean(Dataset_clean_WIDE$`Y2018_Anti-General`),2)
round(sd(Dataset_clean_WIDE$`Y2018_Anti-General`),2)
cor.test(Dataset_clean_WIDE$`Y2018_Anti-General`,Dataset_clean_WIDE$`Y2018_Anti-Lesbian`)  
cor.test(Dataset_clean_WIDE$`Y2018_Anti-General`,Dataset_clean_WIDE$`Y2018_Anti-Gay`)  
cor.test(Dataset_clean_WIDE$`Y2018_Anti-General`,Dataset_clean_WIDE$`Y2018_Anti-Bisexual`)  
cor.test(Dataset_clean_WIDE$`Y2018_Anti-General`,Dataset_clean_WIDE$`Y2018_Anti-Transgender`)  
cor.test(Dataset_clean_WIDE$`Y2018_Anti-General`,Dataset_clean_WIDE$`Y2018_Anti-Gender_Nonconforming`)

## 2019
# Lesbian stats
round(mean(Dataset_clean_WIDE$`Y2019_Anti-Lesbian`),2)
round(sd(Dataset_clean_WIDE$`Y2019_Anti-Lesbian`),2)
# Gay stats
round(mean(Dataset_clean_WIDE$`Y2019_Anti-Gay`),2)
round(sd(Dataset_clean_WIDE$`Y2019_Anti-Gay`),2)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-Gay`,Dataset_clean_WIDE$`Y2019_Anti-Lesbian`)
# Bisexual Stats
round(mean(Dataset_clean_WIDE$`Y2019_Anti-Bisexual`),2)
round(sd(Dataset_clean_WIDE$`Y2019_Anti-Bisexual`),2)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-Bisexual`,Dataset_clean_WIDE$`Y2019_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-Bisexual`,Dataset_clean_WIDE$`Y2019_Anti-Gay`)
# Transgender Stats
round(mean(Dataset_clean_WIDE$`Y2019_Anti-Transgender`),2)
round(sd(Dataset_clean_WIDE$`Y2019_Anti-Transgender`),2)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-Transgender`,Dataset_clean_WIDE$`Y2019_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-Transgender`,Dataset_clean_WIDE$`Y2019_Anti-Gay`)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-Transgender`,Dataset_clean_WIDE$`Y2019_Anti-Bisexual`)
# Gender non Stats
round(mean(Dataset_clean_WIDE$`Y2019_Anti-Gender_Nonconforming`),2)
round(sd(Dataset_clean_WIDE$`Y2019_Anti-Gender_Nonconforming`),2)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2019_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2019_Anti-Gay`)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2019_Anti-Bisexual`)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2019_Anti-Transgender`)
# General Stats
round(mean(Dataset_clean_WIDE$`Y2019_Anti-General`),2)
round(sd(Dataset_clean_WIDE$`Y2019_Anti-General`),2)
cor.test(Dataset_clean_WIDE$`Y2019_Anti-General`,Dataset_clean_WIDE$`Y2019_Anti-Lesbian`)  
cor.test(Dataset_clean_WIDE$`Y2019_Anti-General`,Dataset_clean_WIDE$`Y2019_Anti-Gay`)  
cor.test(Dataset_clean_WIDE$`Y2019_Anti-General`,Dataset_clean_WIDE$`Y2019_Anti-Bisexual`)  
cor.test(Dataset_clean_WIDE$`Y2019_Anti-General`,Dataset_clean_WIDE$`Y2019_Anti-Transgender`)  
cor.test(Dataset_clean_WIDE$`Y2019_Anti-General`,Dataset_clean_WIDE$`Y2019_Anti-Gender_Nonconforming`)

## 2020
# Lesbian stats
round(mean(Dataset_clean_WIDE$`Y2020_Anti-Lesbian`),2)
round(sd(Dataset_clean_WIDE$`Y2020_Anti-Lesbian`),2)
# Gay stats
round(mean(Dataset_clean_WIDE$`Y2020_Anti-Gay`),2)
round(sd(Dataset_clean_WIDE$`Y2020_Anti-Gay`),2)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-Gay`,Dataset_clean_WIDE$`Y2020_Anti-Lesbian`)
# Bisexual Stats
round(mean(Dataset_clean_WIDE$`Y2017_Anti-Bisexual`),2)
round(sd(Dataset_clean_WIDE$`Y2020_Anti-Bisexual`),2)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-Bisexual`,Dataset_clean_WIDE$`Y2020_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-Bisexual`,Dataset_clean_WIDE$`Y2020_Anti-Gay`)
# Transgender Stats
round(mean(Dataset_clean_WIDE$`Y2020_Anti-Transgender`),2)
round(sd(Dataset_clean_WIDE$`Y2020_Anti-Transgender`),2)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-Transgender`,Dataset_clean_WIDE$`Y2020_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-Transgender`,Dataset_clean_WIDE$`Y2020_Anti-Gay`)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-Transgender`,Dataset_clean_WIDE$`Y2020_Anti-Bisexual`)
# Gender non Stats
round(mean(Dataset_clean_WIDE$`Y2020_Anti-Gender_Nonconforming`),2)
round(sd(Dataset_clean_WIDE$`Y2020_Anti-Gender_Nonconforming`),2)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2020_Anti-Lesbian`)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2020_Anti-Gay`)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2020_Anti-Bisexual`)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-Gender_Nonconforming`,Dataset_clean_WIDE$`Y2020_Anti-Transgender`)
# General Stats
round(mean(Dataset_clean_WIDE$`Y2020_Anti-General`),2)
round(sd(Dataset_clean_WIDE$`Y2020_Anti-General`),2)
cor.test(Dataset_clean_WIDE$`Y2020_Anti-General`,Dataset_clean_WIDE$`Y2020_Anti-Lesbian`)  
cor.test(Dataset_clean_WIDE$`Y2020_Anti-General`,Dataset_clean_WIDE$`Y2020_Anti-Gay`)  
cor.test(Dataset_clean_WIDE$`Y2020_Anti-General`,Dataset_clean_WIDE$`Y2020_Anti-Bisexual`)  
cor.test(Dataset_clean_WIDE$`Y2020_Anti-General`,Dataset_clean_WIDE$`Y2020_Anti-Transgender`)  
cor.test(Dataset_clean_WIDE$`Y2020_Anti-General`,Dataset_clean_WIDE$`Y2020_Anti-Gender_Nonconforming`)

## Year comparisons
# Manuscript
dem_group <- ggplot(Dataset_clean_LONG, aes(x = Year, y = Total_per_capita, fill = Winning_Party)) + 
  geom_bar(stat = "summary", fun = "mean", position = position_dodge(), color = "black") +
  geom_errorbar(stat = "summary", 
                fun.data = mean_cl_boot,
                position = position_dodge(.9), 
                width = 0.33) +
  scale_fill_manual(labels = c("Democrat", "Republican"), values = c("#0015BC", "#E81B23"), ) +
  theme_bw() +
  labs(x = "Year", y = "Mean Events per Capita", fill = "County Result") +  
  theme(
    legend.position = c(.99, .99),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.text = element_text(size = 10, family="Times New Roman", color = "black"),
    legend.title = element_text(size = 12, family="Times New Roman", color = "black"),
    axis.title = element_text(size = 12, family="Times New Roman", color = "black"),
    axis.text = element_text(size = 10, family="Times New Roman", color = "black"))
print(dem_group)
rm(dem_group)

# Poster 
dem_group <- ggplot(Dataset_clean_LONG, aes(x = Year, y = Total_per_capita, fill = Winning_Party)) + 
  geom_bar(stat = "summary", fun = "mean", position = position_dodge(), color = "black") +
  geom_errorbar(stat = "summary", 
                fun.data = mean_cl_boot,
                position = position_dodge(.9), 
                width = 0.33) +
  scale_fill_manual(labels = c("Democrat", "Republican"), values = c("#0015BC", "#E81B23"), ) +
  labs(x = "Year", y = "Average Bias-Motivated Incidents per Capita", fill = "Party") +  
  theme_minimal() + theme(
    legend.box.just = "right",
    legend.title = element_text(size = 36, family="Helvetica Neue", color = "black", face="bold"),
    legend.text = element_text(size = 32, family="Helvetica Neue", color = "black"),
    axis.title = element_text(size = 36, family="Helvetica Neue", color = "black", face="bold"),
    axis.title.y = element_text(size = 30, family="Helvetica Neue", color = "black", face="bold"),
    axis.text = element_text(size = 28, family="Helvetica Neue", color = "black"),
    plot.margin = margin(t = 50,
                         r = 20,  
                         b = 50, 
                         l = 20))
print(dem_group)
ggsave(filename =  "Year_To_Year_Differences.tiff", plot = dem_group, width = 28, height = 11)
rm(dem_group)

# Bias Comparison by year
y2017_bias <- ggplot(data_2017, aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2017 Data", x = "Event total", y = "Count") +
  scale_x_sqrt() +
  scale_y_sqrt()
y2018_bias <- ggplot(data_2018, aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2018 Data", x = "Event total", y = "Count") +
  scale_x_sqrt() +
  scale_y_sqrt()
y2019_bias <- ggplot(Dataset_clean_LONG %>% filter(Year == 2019), aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2019 Data", x = "Event total", y = "Count") +
  scale_x_sqrt() +
  scale_y_sqrt()
y2020_bias <- ggplot(Dataset_clean_LONG %>% filter(Year == 2020), aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2020 Data", x = "Event total", y = "Count") +
  scale_x_sqrt() +
  scale_y_sqrt()
y2017_bias + y2018_group + y2019_group + y2020_group +
  plot_layout(guides = 'collect') + 
  plot_annotation(
    title = 'Figure 1',
    subtitle = 'Anti-LGBTQ bias events per capita',
    theme = theme(plot.title = element_text(size = 12))
  )

# Total count chart 
y2017_group <- ggplot(Dataset_clean_LONG %>% filter(Year == 2017), aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2017", x = "Event total", y = "Count") +
  scale_x_sqrt()
y2018_group <- ggplot(Dataset_clean_LONG %>% filter(Year == 2018), aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2018", x = "Event total", y = "Count") +
  scale_x_sqrt()
y2019_group <- ggplot(data_2019, aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2019", x = "Event total", y = "Count") +
  scale_x_sqrt()
y2020_group <- ggplot(data_2020, aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2020", x = "Event total", y = "Count") +
  scale_x_sqrt()
y2017_group + y2018_group + y2019_group + y2020_group +
  plot_layout(guides = 'collect') + 
  plot_annotation(
    title = 'Figure 1',
    subtitle = 'Anti-LGBTQ bias events per capita',
    theme = theme(plot.title = element_text(size = 12))
  )

# Density
y2017_group <- ggplot(Dataset_clean_LONG %>% filter(Year == 2017), aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_density() +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2017", x = "Event total", y = "Count") +
  scale_color_manual(labels = c("Democrat", "Republican"), values = c("#0015BC", "#E81B23")) +
  scale_x_sqrt() +
  scale_y_sqrt()
y2018_group <- ggplot(Dataset_clean_LONG %>% filter(Year == 2018), aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_density() +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2018", x = "Event total", y = "Count") +
  scale_color_manual(labels = c("Democrat", "Republican"), values = c("#0015BC", "#E81B23")) +
  scale_x_sqrt() +
  scale_y_sqrt()
y2019_group <- ggplot(data_2019, aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_density() +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2019", x = "Event total", y = "Count") +
  scale_color_manual(labels = c("Democrat", "Republican"), values = c("#0015BC", "#E81B23")) +
  scale_x_sqrt() +
  scale_y_sqrt()
y2020_group <- ggplot(data_2020, aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_density() +
  scale_fill_manual(values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  labs(title = "2020", x = "Event total", y = "Count") +
  scale_color_manual(labels = c("Democrat", "Republican"), values = c("#0015BC", "#E81B23")) +
  scale_x_sqrt() +
  scale_y_sqrt()
y2017_group + y2018_group + y2019_group + y2020_group +
  plot_layout(guides = 'collect') + 
  plot_annotation(
    title = 'Figure 1',
    subtitle = 'Anti-LGBTQ bias events per capita',
    theme = theme(plot.title = element_text(size = 12))
  )


## Quarter Rank Plot
# Manuscript
quarter_plot <- ggplot(Dataset_clean_QUARTER, aes(x = Quarter, y = Total, group = Winning_Party)) +
  #geom_line(linewidth =.2) +
  #geom_point(size = 1) +
  stat_summary(
    aes(
      x = Quarter,
      y = Total,
      group = Winning_Party),
    fun.data = mean_cl_boot, 
    geom = "ribbon", 
    alpha = .2,  # Set transparency
    inherit.aes = FALSE
  ) +
  stat_summary(
    aes(
      x = Quarter,
      y = Total,
      group = Winning_Party,
      color = Winning_Party),
    fun = mean, 
    size = .6, 
    geom="line",
    inherit.aes = FALSE
    ) +
  labs(x = "Quarter",
       y = "Mean Bias-Motivated Events",
       color = "Party") +
  scale_x_discrete(labels=c('2017, Q1','2017, Q2','2017, Q3','2017, Q4',
                            '2018, Q1','2018, Q2','2018, Q3','2018, Q4',
                            '2019, Q1','2019, Q2','2019, Q3','2019, Q4',
                            '2020, Q1','2020, Q2','2020, Q3','2020, Q4'))+
  scale_color_manual(labels = c("Democrat","Republican"), values = c("#0015BC", "#E81B23")) +
  theme_bw() +
  theme_minimal() + theme(
  legend.position = c(.99, .99),
  legend.justification = c("right", "top"),
  legend.box.just = "right",
  legend.text = element_text(size = 30, family="Helvetica Neue", color = "black"),
  legend.title = element_text(size = 34, family="Helvetica Neue", color = "black"),
  axis.title = element_text(size = 34, family="Helvetica Neue", color = "black"),
  axis.text = element_text(size = 30, family="Helvetica Neue", color = "black"),
  plot.margin = margin(t = 20,
                       r = 20,  
                       b = 20, 
                       l = 20) 

)
print(quarter_plot)
ggsave(filename =  "Quarter_Rank_Plot.tiff", plot = quarter_plot, width = 40, height = 10)

# Poster
quarter_plot <- ggplot(Dataset_clean_QUARTER, aes(x = Quarter, y = total_per_capita, group = Winning_Party)) +
  stat_summary(
    aes(
      x = Quarter,
      y = total_per_capita,
      group = Winning_Party,
      fill = Winning_Party),
    fun.data = mean_cl_boot, 
    geom = "ribbon", 
    alpha = .1,
    inherit.aes = FALSE,
  ) +
  stat_summary(
    aes(
      x = Quarter,
      y = total_per_capita,
      group = Winning_Party,
      color = Winning_Party),
    fun = mean, 
    size = .75, 
    geom="line",
    inherit.aes = FALSE,
  ) +
  labs(x = "Quarter",
       y = "Average Bias-Motivated Incidents per Capita",
       color = "Party") +
  #facet_grid2(cols = vars(Year), scales = "free_x", space = "free_x") +
  scale_x_discrete(labels=c('2017 Q1',' 2017 Q2',' 2017 Q3',' 2017 Q4',
                            '2018 Q1','2018 Q2','2018 Q3','2018 Q4',
                            '2019 Q1','2019 Q2','2019 Q3','2019 Q4',
                            '2020 Q1','2020 Q2','2020 Q3','2020 Q4'))+
  scale_color_manual(labels = c("Democrat","Republican"), values = c("#0015BC", "#E81B23")) +
  scale_fill_manual(
    values = c("#0015BC", "#E81B23"),
    guide = "none") + 
  theme_bw() +
  theme_minimal() + theme(
    legend.box.just = "right",
    legend.title = element_text(size = 36, family="Helvetica Neue", color = "black", face="bold"),
    legend.text = element_text(size = 32, family="Helvetica Neue", color = "black"),
    axis.title = element_text(size = 36, family="Helvetica Neue", color = "black", face="bold"),
    axis.text = element_text(size = 28, family="Helvetica Neue", color = "black"),
    plot.margin = margin(t = 20,
                         r = 20,  
                         b = 20, 
                         l = 20) 
  )
print(quarter_plot)
ggsave(filename =  "Quarter_Rank_Plot.tiff", plot = quarter_plot, width = 40, height = 12)


