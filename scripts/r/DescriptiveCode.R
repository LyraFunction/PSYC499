## Code for descriptive statistics, correlations, and misc analyses


# Set directory location ## TODO fix this to be dynamic rather than static
setwd("~/Desktop/Projects/Programming/PSYC499/scripts/r")

# Packages
library(arrow)
library(ggplot2)
library(patchwork)
library(cowplot)
library(dplyr)
library(tidyr)
library(e1071)
library(apaTables)

## Read dataset
Dataset_clean_LONG <- read_parquet("~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_LONG.parquet")
Dataset_clean_WIDE <- read_parquet("~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_WIDE.parquet")

## Prep
Dataset_clean_LONG$Year <- as.factor(Dataset_clean_LONG$Year)
Dataset_clean_LONG$Winning_Party <- as.factor(Dataset_clean_LONG$Winning_Party)
data_2017 <- Dataset_clean_LONG %>% filter(Year == 2017)
mean(data_2017$Total)
sd(data_2017$Total)
range(data_2017$Total)
skewness(data_2017$Total)
kurtosis(data_2017$Total)
data_2018 <- Dataset_clean_LONG %>% filter(Year == 2018)
data_2019 <- Dataset_clean_LONG %>% filter(Year == 2019)
data_2020 <- Dataset_clean_LONG %>% filter(Year == 2020)

# Select relevant columns
Quarter_Long <- Dataset_clean_WIDE[, c("FIPS", "State_name", "County_Name", 
                                       "Y2017_QTR1", "Y2017_QTR2", "Y2017_QTR3",
                                       "Y2017_QTR4", "Y2018_QTR1", "Y2018_QTR2", 
                                       "Y2018_QTR3", "Y2018_QTR4", "Y2019_QTR1",
                                       "Y2019_QTR2", "Y2019_QTR3", "Y2019_QTR4",
                                       "Y2020_QTR1", "Y2020_QTR2", "Y2020_QTR3",
                                       "Y2020_QTR4", "Winning_Party", 
                                       "Y2017_Population", "Y2018_Population",
                                       "Y2019_Population", "Y2020_Population")]

# Pivot for quarters
Quarter_Long <- Quarter_Long %>% 
  pivot_longer(
    cols = c("Y2017_QTR1", "Y2017_QTR2", "Y2017_QTR3", "Y2017_QTR4", 
             "Y2018_QTR1", "Y2018_QTR2", "Y2018_QTR3", "Y2018_QTR4", 
             "Y2019_QTR1", "Y2019_QTR2", "Y2019_QTR3", "Y2019_QTR4", 
             "Y2020_QTR1", "Y2020_QTR2", "Y2020_QTR3", "Y2020_QTR4"), 
    names_to = "Quarter",
    values_to = "Total"
  )

## Plots
# Violin plot
violin <- ggplot(Dataset_clean_LONG, aes(x=Year, y=Total_per_capita, color = Winning_Party)) +
  geom_violin(position=position_dodge(1)) +
  labs(title = "Bias Motivated Incidents per Year",
       x = "Year",
       y = "Total Bias Events",
       color = "Party") +
  scale_color_manual(labels = c("Democrat", "Republican"), values = c("#0015BC", "#E81B23")) +
  theme_bw()
print(violin + scale_y_sqrt()) + theme(
  legend.position = c(.99, .99),
  legend.justification = c("right", "top"),
  legend.box.just = "right"
)
# line plot
drops <- c("County_Name","Democratic_Votes","Republican_Votes","State_name",
           "Y2017_Anti-Lesbian","Y2018_Anti-Lesbian","Y2019-Anti_Lesbian",
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

# Histogram 
y2017_group <- ggplot(data_2017, aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23"))
y2018_group <- ggplot(data_2018, aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23"))
y2019_group <- ggplot(data_2019, aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23"))
y2020_group <- ggplot(data_2020, aes(x = Total_per_capita, fill = Winning_Party)) + 
  geom_histogram(bins = 8) +
  scale_fill_manual(values = c("#0015BC", "#E81B23"))

plot_grid(y2017_group, y2018_group, y2019_group, y2020_group,           
          labels = c('2017', '2018', '2019', '2020'), # Or "AUTO" or "auto"
          label_fontfamily = "sans_serif",
          label_fontface = "bold",
          label_colour = "black",
          align = "hv")

# Rank Order Change Plot
rank_plot <- ggplot(Dataset_clean_LONG, aes(x = Year, y = Total_per_capita, group = interaction(FIPS, Winning_Party), color = Winning_Party)) +
  geom_line(linewidth =.35) +
  geom_point(size = 1) +
  labs(title = "Bias Motivated Incidents over Time",
       x = "Year",
       y = "Total Bias Events",
       color = "Party") +
  scale_color_manual(labels = c("Democrat", "Republican"), values = c("#0015BC", "#E81B23")) +
  theme_bw()
print(rank_plot + scale_y_sqrt()) + theme(
  legend.position = c(.99, .99),
  legend.justification = c("right", "top"),
  legend.box.just = "right"
)

# Map



