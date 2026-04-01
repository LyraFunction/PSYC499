## Code for quarter comparisons and plotting
# Set directory location ## TODO fix this to be dynamic rather than static?
setwd("~/Desktop/Projects/Programming/PSYC499/scripts/r")

# Packages
library(arrow)
library(tidyverse)
library(tidyplots)
library(legendry)
library(patchwork)

## Read datasets
Dataset_clean_WIDE <- read_parquet(
  "~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_WIDE.parquet")

## Prep
Dataset_clean_WIDE <- Dataset_clean_WIDE [complete.cases(Dataset_clean_WIDE ), ] 
Dataset_clean_WIDE <- filter(Dataset_clean_WIDE, Dataset_clean_WIDE$Y2017_Population > 0) # Removes rows where the population is 0 as that would give weird results for the following block

Dataset_clean_WIDE$"2017_Quarter_1_Cap" <- (Dataset_clean_WIDE$"Y2017_QTR1" / Dataset_clean_WIDE$Y2017_Population) * 10000
Dataset_clean_WIDE$"2017_Quarter_2_Cap" <- (Dataset_clean_WIDE$"Y2017_QTR2" / Dataset_clean_WIDE$Y2017_Population) * 10000
Dataset_clean_WIDE$"2017_Quarter_3_Cap" <- (Dataset_clean_WIDE$"Y2017_QTR3" / Dataset_clean_WIDE$Y2017_Population) * 10000
Dataset_clean_WIDE$"2017_Quarter_4_Cap" <- (Dataset_clean_WIDE$"Y2017_QTR4" / Dataset_clean_WIDE$Y2017_Population) * 10000
Dataset_clean_WIDE$"2018_Quarter_1_Cap" <- (Dataset_clean_WIDE$"Y2018_QTR1" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2018_Quarter_2_Cap" <- (Dataset_clean_WIDE$"Y2018_QTR2" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2018_Quarter_3_Cap" <- (Dataset_clean_WIDE$"Y2018_QTR3" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2018_Quarter_4_Cap" <- (Dataset_clean_WIDE$"Y2018_QTR4" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2019_Quarter_1_Cap" <- (Dataset_clean_WIDE$"Y2019_QTR1" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2019_Quarter_2_Cap" <- (Dataset_clean_WIDE$"Y2019_QTR2" / Dataset_clean_WIDE$Y2019_Population) * 10000
Dataset_clean_WIDE$"2019_Quarter_3_Cap" <- (Dataset_clean_WIDE$"Y2019_QTR3" / Dataset_clean_WIDE$Y2019_Population) * 10000
Dataset_clean_WIDE$"2019_Quarter_4_Cap" <- (Dataset_clean_WIDE$"Y2019_QTR4" / Dataset_clean_WIDE$Y2019_Population) * 10000
Dataset_clean_WIDE$"2020_Quarter_1_Cap" <- (Dataset_clean_WIDE$"Y2019_QTR1" / Dataset_clean_WIDE$Y2020_Population) * 10000
Dataset_clean_WIDE$"2020_Quarter_2_Cap" <- (Dataset_clean_WIDE$"Y2019_QTR2" / Dataset_clean_WIDE$Y2020_Population) * 10000
Dataset_clean_WIDE$"2020_Quarter_3_Cap" <- (Dataset_clean_WIDE$"Y2019_QTR3" / Dataset_clean_WIDE$Y2020_Population) * 10000
Dataset_clean_WIDE$"2020_Quarter_4_Cap" <- (Dataset_clean_WIDE$"Y2019_QTR4" / Dataset_clean_WIDE$Y2020_Population) * 10000

drops <- c("Y2017_Total","Y2018_Total","Y2019_Total","Y2020_Total",
           "Y2017_Population","Y2018_Population","Y2019_Population",
           "Y2020_Population","Y2017_Anti-Lesbian","Y2018_Anti-Lesbian","Y2019_Anti-Lesbian","Y2020_Anti-Lesbian",
           "Y2017_Anti-Gay","Y2018_Anti-Gay","Y2019_Anti-Gay","Y2020_Anti-Gay",
           "Y2017_Anti-Bisexual","Y2018_Anti-Bisexual","Y2019_Anti-Bisexual","Y2020_Anti-Bisexual",
           "Y2017_Anti-Transgender","Y2018_Anti-Transgender","Y2019_Anti-Transgender","Y2020_Anti-Transgender",
           "Y2017_Anti-General","Y2018_Anti-General","Y2019_Anti-General","Y2020_Anti-General",
           "Y2017_Anti-Gender_Nonconforming","Y2018_Anti-Gender_Nonconforming","Y2019_Anti-Gender_Nonconforming","Y2020_Anti-Gender_Nonconforming",
           "Y2017_HC_Flag","Y2018_HC_Flag","Y2019_HC_Flag","Y2020_HC_Flag",
           "Democratic_Votes","Republican_Votes",
           "Y2017_QTR1","Y2017_QTR2","Y2017_QTR3","Y2017_QTR4",
           "Y2018_QTR1","Y2018_QTR2","Y2018_QTR3","Y2018_QTR4",
           "Y2019_QTR1","Y2019_QTR2","Y2019_QTR3","Y2019_QTR4",
           "Y2020_QTR1","Y2020_QTR2","Y2020_QTR3","Y2020_QTR4")
Dataset_clean_WIDE <- Dataset_clean_WIDE[ , !(names(Dataset_clean_WIDE) %in% drops)]
rm(drops)
Dataset_clean_WIDE <- Dataset_clean_WIDE %>% 
  pivot_longer(
    cols = c("2017_Quarter_1_Cap",
             "2017_Quarter_2_Cap",
             "2017_Quarter_3_Cap",
             "2017_Quarter_4_Cap",
             "2018_Quarter_1_Cap",
             "2018_Quarter_2_Cap",
             "2018_Quarter_3_Cap",
             "2018_Quarter_4_Cap",
             "2019_Quarter_1_Cap",
             "2019_Quarter_2_Cap",
             "2019_Quarter_3_Cap",
             "2019_Quarter_4_Cap",
             "2020_Quarter_1_Cap",
             "2020_Quarter_2_Cap",
             "2020_Quarter_3_Cap",
             "2020_Quarter_4_Cap"), 
    names_to = "Quarter",
    values_to = "Total"
  )

Dataset_clean_WIDE$Year <- rep(c(rep(2017, 4), rep(2018, 4), rep(2019, 4), rep(2020, 4)), times = 3109) # Not a great solution but it works for now
Dataset_clean_WIDE$Winning_Party <- as.factor(Dataset_clean_WIDE$Winning_Party) 
Dataset_clean_WIDE$Year <- as.factor(Dataset_clean_WIDE$Year)
Dataset_clean_WIDE$State_name <- as.factor(Dataset_clean_WIDE$State_name)




Quarter_Plot <- Dataset_clean_WIDE |> 
  #mutate(w = paste0(Quarter, "&", Year))|>
  tidyplot(x = Quarter, y = Total) |>
  add_ci95_ribbon() |>
  add_mean_line(linewidth = .25) |>
  theme_minimal_xy() |>
  adjust_size(height = NA, width = NA) |>
  adjust_colors(new_colors = "#63187A", saturation = .75) |>
  adjust_font(fontsize = 12, family = "Times") |>
  adjust_title(title = "Incidents Per Capita For All Counties", face = "bold") |>
  adjust_x_axis(rotate_labels = "TRUE", title = "Year & Quarter")|>
  adjust_y_axis_title("Incidents per Capita") |>
  rename_x_axis_labels(new_names = c(
    "2017_Quarter_1_Cap" = "2017 Q1",
    "2017_Quarter_2_Cap" = '2017 Q2',
    "2017_Quarter_3_Cap" = '2017 Q3',
    "2017_Quarter_4_Cap" = '2017 Q4',
    "2018_Quarter_1_Cap" = '2018 Q1',
    "2018_Quarter_2_Cap" = '2018 Q2',
    "2018_Quarter_3_Cap" = '2018 Q3',
    "2018_Quarter_4_Cap" = '2018 Q4',
    "2019_Quarter_1_Cap" = '2019 Q1',
    "2019_Quarter_2_Cap" = '2019 Q2',
    "2019_Quarter_3_Cap" = '2019 Q3',
    "2019_Quarter_4_Cap" = '2019 Q4',
    "2020_Quarter_1_Cap" = '2020 Q1',
    "2020_Quarter_2_Cap" = '2020 Q2',
    "2020_Quarter_3_Cap" = '2020 Q3',
    "2020_Quarter_4_Cap" = '2020 Q4'))

Quarter_Plot_Party <- Dataset_clean_WIDE |> 
  #mutate(w = paste0(Quarter, "&", Year))|>
  tidyplot(x = Quarter, y = Total, color = Winning_Party) |>
  add_ci95_ribbon(dodge_width = 0) |>
  add_mean_line(linewidth = .25, dodge_width = 0) |>
  theme_minimal_xy() |>
  adjust_size(height = NA, width = NA) |>
  adjust_colors(new_colors = c("#0015BC", "#E81B23"), saturation = .75) |>
  adjust_font(fontsize = 12, family = "Times") |>
  adjust_title(title = "Incidents Per Capita by County Vote Outcome", face = "bold") |>
  adjust_x_axis(rotate_labels = "TRUE", title = "Year & Quarter")|>
  adjust_y_axis_title("Incidents per Capita") |>
  adjust_legend_title("Vote Outcome") |>
  adjust_legend_position(position = "top") |>
  rename_color_levels(new_names = c("0" = "Democrat", "1" = "Republican")) |>
  rename_x_axis_labels(new_names = c(
    "2017_Quarter_1_Cap" = "2017 Q1",
    "2017_Quarter_2_Cap" = '2017 Q2',
    "2017_Quarter_3_Cap" = '2017 Q3',
    "2017_Quarter_4_Cap" = '2017 Q4',
    "2018_Quarter_1_Cap" = '2018 Q1',
    "2018_Quarter_2_Cap" = '2018 Q2',
    "2018_Quarter_3_Cap" = '2018 Q3',
    "2018_Quarter_4_Cap" = '2018 Q4',
    "2019_Quarter_1_Cap" = '2019 Q1',
    "2019_Quarter_2_Cap" = '2019 Q2',
    "2019_Quarter_3_Cap" = '2019 Q3',
    "2019_Quarter_4_Cap" = '2019 Q4',
    "2020_Quarter_1_Cap" = '2020 Q1',
    "2020_Quarter_2_Cap" = '2020 Q2',
    "2020_Quarter_3_Cap" = '2020 Q3',
    "2020_Quarter_4_Cap" = '2020 Q4'))

Mixed = (Quarter_Plot / Quarter_Plot_Party)
  
#Quarter_Plot + guides(x = guide_axis_nested(key = "&"), subtitle = "Quarter", title = "Year")

rm(Dataset_clean_WIDE)
rm(Mixed)
rm(Quarter_Plot)
rm(Quarter_Plot_Party)