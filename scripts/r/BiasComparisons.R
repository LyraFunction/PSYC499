# Packages
library(tidyverse)
library(tidyplots)
library(arrow)
library(patchwork)
library(conover.test)

## Import data
Dataset_clean_WIDE <- read_parquet(
  "~/Desktop/Projects/Programming/PSYC499/data_clean/Dataset_clean_WIDE.parquet")

# Prep data bias types
Dataset_clean_WIDE <- Dataset_clean_WIDE [complete.cases(Dataset_clean_WIDE ), ] 
Dataset_clean_WIDE <- filter(Dataset_clean_WIDE, Dataset_clean_WIDE$Y2017_Population > 0) # Removes rows where the population is 0 as that would give weird results for the following block

Dataset_clean_WIDE$"2017_Anti-Lesbian_Cap" <- (Dataset_clean_WIDE$"Y2017_Anti-Lesbian" / Dataset_clean_WIDE$Y2017_Population) * 10000
Dataset_clean_WIDE$"2017_Anti-Gay_Cap" <- (Dataset_clean_WIDE$"Y2017_Anti-Gay" / Dataset_clean_WIDE$Y2017_Population) * 10000
Dataset_clean_WIDE$"2017_Anti-Bisexual_Cap" <- (Dataset_clean_WIDE$"Y2017_Anti-Bisexual" / Dataset_clean_WIDE$Y2017_Population) * 10000
Dataset_clean_WIDE$"2017_Anti-General_Cap" <- (Dataset_clean_WIDE$"Y2017_Anti-General" / Dataset_clean_WIDE$Y2017_Population) * 10000
Dataset_clean_WIDE$"2017_Anti-Transgender_Cap" <- (Dataset_clean_WIDE$"Y2017_Anti-Transgender" / Dataset_clean_WIDE$Y2017_Population) * 10000
Dataset_clean_WIDE$"2017_Anti-Gender_Nonconforming_Cap" <- (Dataset_clean_WIDE$"Y2017_Anti-Gender_Nonconforming" / Dataset_clean_WIDE$Y2017_Population) * 10000
Dataset_clean_WIDE$"2018_Anti-Lesbian_Cap" <- (Dataset_clean_WIDE$"Y2018_Anti-Lesbian" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2018_Anti-Gay_Cap" <- (Dataset_clean_WIDE$"Y2018_Anti-Gay" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2018_Anti-Bisexual_Cap" <- (Dataset_clean_WIDE$"Y2018_Anti-Bisexual" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2018_Anti-General_Cap" <- (Dataset_clean_WIDE$"Y2018_Anti-General" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2018_Anti-Transgender_Cap" <- (Dataset_clean_WIDE$"Y2018_Anti-Transgender" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2018_Anti-Gender_Nonconforming_Cap" <- (Dataset_clean_WIDE$"Y2018_Anti-Gender_Nonconforming" / Dataset_clean_WIDE$Y2018_Population) * 10000
Dataset_clean_WIDE$"2019_Anti-Lesbian_Cap" <- (Dataset_clean_WIDE$"Y2019_Anti-Lesbian" / Dataset_clean_WIDE$Y2019_Population) * 10000
Dataset_clean_WIDE$"2019_Anti-Gay_Cap" <- (Dataset_clean_WIDE$"Y2019_Anti-Gay" / Dataset_clean_WIDE$Y2019_Population) * 10000
Dataset_clean_WIDE$"2019_Anti-Bisexual_Cap" <- (Dataset_clean_WIDE$"Y2019_Anti-Bisexual" / Dataset_clean_WIDE$Y2019_Population) * 10000
Dataset_clean_WIDE$"2019_Anti-General_Cap" <- (Dataset_clean_WIDE$"Y2019_Anti-General" / Dataset_clean_WIDE$Y2019_Population) * 10000
Dataset_clean_WIDE$"2019_Anti-Transgender_Cap" <- (Dataset_clean_WIDE$"Y2019_Anti-Transgender" / Dataset_clean_WIDE$Y2019_Population) * 10000
Dataset_clean_WIDE$"2019_Anti-Gender_Nonconforming_Cap" <- (Dataset_clean_WIDE$"Y2019_Anti-Gender_Nonconforming" / Dataset_clean_WIDE$Y2019_Population) * 10000
Dataset_clean_WIDE$"2020_Anti-Lesbian_Cap" <- (Dataset_clean_WIDE$"Y2020_Anti-Lesbian" / Dataset_clean_WIDE$Y2020_Population) * 10000
Dataset_clean_WIDE$"2020_Anti-Gay_Cap" <- (Dataset_clean_WIDE$"Y2020_Anti-Gay" / Dataset_clean_WIDE$Y2020_Population) * 10000
Dataset_clean_WIDE$"2020_Anti-Bisexual_Cap" <- (Dataset_clean_WIDE$"Y2020_Anti-Bisexual" / Dataset_clean_WIDE$Y2020_Population) * 10000
Dataset_clean_WIDE$"2020_Anti-General_Cap" <- (Dataset_clean_WIDE$"Y2020_Anti-General" / Dataset_clean_WIDE$Y2020_Population) * 10000
Dataset_clean_WIDE$"2020_Anti-Transgender_Cap" <- (Dataset_clean_WIDE$"Y2020_Anti-Transgender" / Dataset_clean_WIDE$Y2020_Population) * 10000
Dataset_clean_WIDE$"2020_Anti-Gender_Nonconforming_Cap" <- (Dataset_clean_WIDE$"Y2020_Anti-Gender_Nonconforming" / Dataset_clean_WIDE$Y2020_Population) * 10000

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
           "Y2017_QTR1", "Y2017_QTR2", "Y2017_QTR3", "Y2017_QTR4", 
           "Y2018_QTR1", "Y2018_QTR2", "Y2018_QTR3", "Y2018_QTR4", 
           "Y2019_QTR1", "Y2019_QTR2", "Y2019_QTR3", "Y2019_QTR4", 
           "Y2020_QTR1", "Y2020_QTR2", "Y2020_QTR3", "Y2020_QTR4")
Dataset_clean_WIDE <- Dataset_clean_WIDE[ , !(names(Dataset_clean_WIDE) %in% drops)]
rm(drops)
Dataset_clean_WIDE <- Dataset_clean_WIDE %>% 
  pivot_longer(
    cols = c("2017_Anti-Lesbian_Cap",
             "2017_Anti-Gay_Cap",
             "2017_Anti-Bisexual_Cap",
             "2017_Anti-General_Cap",
             "2017_Anti-Transgender_Cap",
             "2017_Anti-Gender_Nonconforming_Cap",
             "2018_Anti-Lesbian_Cap",
             "2018_Anti-Gay_Cap",
             "2018_Anti-Bisexual_Cap",
             "2018_Anti-General_Cap",
             "2018_Anti-Transgender_Cap",
             "2018_Anti-Gender_Nonconforming_Cap",
             "2019_Anti-Lesbian_Cap",
             "2019_Anti-Gay_Cap",
             "2019_Anti-Bisexual_Cap",
             "2019_Anti-General_Cap",
             "2019_Anti-Transgender_Cap",
             "2019_Anti-Gender_Nonconforming_Cap",
             "2020_Anti-Lesbian_Cap",
             "2020_Anti-Gay_Cap",
             "2020_Anti-Bisexual_Cap",
             "2020_Anti-General_Cap",
             "2020_Anti-Transgender_Cap",
             "2020_Anti-Gender_Nonconforming_Cap"), 
    names_to = "Category",
    values_to = "Total"
  )

Dataset_clean_WIDE$Year <- rep(c(rep(2017, 6), rep(2018, 6), rep(2019, 6), rep(2020, 6)), times = 3109) # Not a great solution but it works for now
Dataset_clean_WIDE$Stripped <- gsub("^y\\d{4}_(.*)", "\\1", Dataset_clean_WIDE$Category)
Dataset_clean_WIDE$Stripped <- gsub("^[0-9]{4}_", "", Dataset_clean_WIDE$Stripped)

Types_2017 <- Dataset_clean_WIDE |>
  filter(Category == "2017_Anti-Lesbian_Cap" |
         Category == "2017_Anti-Gay_Cap" |
         Category == "2017_Anti-Bisexual_Cap" |
         Category == "2017_Anti-Transgender_Cap" |
         Category == "2017_Anti-Gender_Nonconforming_Cap")
Types_2018 <- Dataset_clean_WIDE |>
  filter(Category == "2018_Anti-Lesbian_Cap" |
           Category == "2018_Anti-Gay_Cap" |
           Category == "2018_Anti-Bisexual_Cap" |
           Category == "2018_Anti-Transgender_Cap" |
           Category == "2018_Anti-Gender_Nonconforming_Cap")
Types_2019 <- Dataset_clean_WIDE |>
  filter(Category == "2019_Anti-Lesbian_Cap" |
           Category == "2019_Anti-Gay_Cap" |
           Category == "2019_Anti-Bisexual_Cap" |
           Category == "2019_Anti-Transgender_Cap" |
           Category == "2019_Anti-Gender_Nonconforming_Cap")
Types_2020 <- Dataset_clean_WIDE |>
  filter(Category == "2020_Anti-Lesbian_Cap" |
           Category == "2020_Anti-Gay_Cap" |
           Category == "2020_Anti-Bisexual_Cap" |
           Category == "2020_Anti-Transgender_Cap" |
           Category == "2020_Anti-Gender_Nonconforming_Cap")

# Tests
## 2017
conover.test(x = Types_2017$Total, g = Types_2017$Category, method = "bonferroni", kw=TRUE, label=TRUE, list = TRUE, alpha = .01)
## 2018
conover.test(x = Types_2018$Total, g = Types_2018$Category, method = "bonferroni", kw=TRUE, label=TRUE, list = TRUE, alpha = .01)
## 2019
conover.test(x = Types_2019$Total, g = Types_2019$Category, method = "bonferroni", kw=TRUE, label=TRUE, list = TRUE, alpha = .01)
## 2020
conover.test(x = Types_2020$Total, g = Types_2020$Category, method = "bonferroni", kw=TRUE, label=TRUE, list = TRUE, alpha = .01)

# Plots
 y2017_plot <- Types_2017 |>
  tidyplot(x = Category, y = Total, color = Category) |>
  theme_minimal_xy() |>
  add_mean_bar(alpha = 0.8) |> 
  add_sem_errorbar(linewidth = .5) |>
  adjust_size(height = NA, width = NA) |>
  adjust_colors(colors_discrete_ibm) |>
  adjust_font(fontsize = 12, family = "Times") |>
  sort_x_axis_levels() |>
  adjust_x_axis_title("Bias Motivation") |>
  adjust_y_axis_title("Incidents per Capita") |>
  adjust_legend_position("none") |>
  adjust_title("2017 Incidents") |> 
  rename_x_axis_levels(new_names = c(
    "2017_Anti-Lesbian_Cap" = "Anti-Lesbian",
    "2017_Anti-Gay_Cap" = "Anti-Gay",
    "2017_Anti-Bisexual_Cap" = "Anti-Bisexual",
    "2017_Anti-Transgender_Cap" = "Anti-Transgender",
    "2017_Anti-Gender_Nonconforming_Cap" = "Anti-Gender Nonconforming"))

 y2018_plot <- Types_2018 |>
  tidyplot(x = Category, y = Total, color = Category) |>
  theme_minimal_xy() |>
  add_mean_bar(alpha = 0.8) |> 
  add_sem_errorbar(linewidth = .5) |>
  adjust_size(height = NA, width = NA) |>
  adjust_colors(colors_discrete_ibm) |>
  adjust_font(fontsize = 12, family = "Times") |>
  sort_x_axis_levels() |>
  adjust_x_axis_title("Bias Motivation") |>
  adjust_y_axis_title("Incidents per Capita") |>
  adjust_legend_position("none") |>
   adjust_title("2018 Incidents") |> 
  rename_x_axis_levels(new_names = c(
    "2018_Anti-Lesbian_Cap" = "Anti-Lesbian",
    "2018_Anti-Gay_Cap" = "Anti-Gay",
    "2018_Anti-Bisexual_Cap" = "Anti-Bisexual",
    "2018_Anti-Transgender_Cap" = "Anti-Transgender",
    "2018_Anti-Gender_Nonconforming_Cap" = "Anti-Gender Nonconforming"))

 y2019_plot <- Types_2019 |>
  tidyplot(x = Category, y = Total, color = Category) |>
  theme_minimal_xy() |>
  add_mean_bar(alpha = 0.8) |> 
  add_sem_errorbar(linewidth = .5) |>
  adjust_size(height = NA, width = NA) |>
  adjust_colors(colors_discrete_ibm) |>
  adjust_font(fontsize = 12, family = "Times") |>
  sort_x_axis_levels() |>
  adjust_x_axis_title("Bias Motivation") |>
  adjust_y_axis_title("Incidents per Capita") |>
  adjust_legend_position("none") |>
  adjust_title("2019 Incidents") |> 
  rename_x_axis_levels(new_names = c(
    "2019_Anti-Lesbian_Cap" = "Anti-Lesbian",
    "2019_Anti-Gay_Cap" = "Anti-Gay",
    "2019_Anti-Bisexual_Cap" = "Anti-Bisexual",
    "2019_Anti-Transgender_Cap" = "Anti-Transgender",
    "2019_Anti-Gender_Nonconforming_Cap" = "Anti-Gender Nonconforming"))

 y2020_plot <- Types_2020 |>
  tidyplot(x = Category, y = Total, color = Category) |>
  theme_minimal_xy() |>
  add_mean_bar(alpha = 0.8) |> 
  add_sem_errorbar(linewidth = .5) |>
  adjust_size(height = NA, width = NA) |>
  adjust_colors(colors_discrete_ibm) |>
  adjust_font(fontsize = 12, family = "Times") |>
  sort_x_axis_levels() |>
  adjust_x_axis_title("Bias Motivation") |>
  adjust_y_axis_title("Incidents per Capita") |>
  adjust_legend_position("none") |>
  adjust_title("2020 Incidents") |> 
  rename_x_axis_levels(new_names = c(
    "2020_Anti-Lesbian_Cap" = "Anti-Lesbian",
    "2020_Anti-Gay_Cap" = "Anti-Gay",
    "2020_Anti-Bisexual_Cap" = "Anti-Bisexual",
    "2020_Anti-Transgender_Cap" = "Anti-Transgender",
    "2020_Anti-Gender_Nonconforming_Cap" = "Anti-Gender Nonconforming"))
 
Collected_Types_Plot <- y2017_plot + y2018_plot + y2019_plot + y2020_plot

Dataset_clean_WIDE <- filter(Dataset_clean_WIDE, Stripped != "Anti-General_Cap")
Total_plot <- Dataset_clean_WIDE |>
  tidyplot(x = Year, y = Total, color = Stripped) |>
  theme_minimal_xy() |>
  add_mean_line(linewidth = .75) |>
  add_ci95_ribbon() |>
  adjust_size(height = NA, width = NA) |>
  adjust_colors(colors_discrete_ibm) |>
  adjust_font(fontsize = 12, family = "Times") |>
  adjust_x_axis_title("Year") |>
  adjust_y_axis_title("Incidents per Capita") |>
  adjust_legend_title("Bias Motivations") |>
  rename_color_levels(new_names = c(
    "Anti-Lesbian_Cap" = "Anti-Lesbian",
    "Anti-Gay_Cap" = "Anti-Gay",
    "Anti-Bisexual_Cap" = "Anti-Bisexual",
    "Anti-Transgender_Cap" = "Anti-Transgender",
    "Anti-Gender_Nonconforming_Cap" = "Anti-Gender Nonconforming"))
  
# Remove data
rm(Dataset_clean_WIDE)
rm(Types_2017)
rm(Types_2018)
rm(Types_2019)
rm(Types_2020)
rm(y2017_plot)
rm(y2018_plot)
rm(y2019_plot)
rm(y2020_plot)
rm(Collected_Types_Plot)
rm(Total_plot)