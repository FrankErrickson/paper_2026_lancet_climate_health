library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(tidyverse)
library(stringr)

setwd("D:/08 GCAM/global-project output database/")

health_results <- read_csv("Health/health_GEMM_results/health_outcomes.csv")
colnames(health_results)[4:13] <- paste0("deaths_", colnames(health_results)[4:13])

health_results_upper <- read_csv("Health/health_GEMM_results/upper_health_outcomes.csv")
colnames(health_results_upper)[4:13] <- paste0("deaths_upper_", colnames(health_results_upper)[4:13])

health_results_lower <- read_csv("Health/health_GEMM_results/lower_health_outcomes.csv")
colnames(health_results_lower)[4:13] <- paste0("deaths_lower_", colnames(health_results_lower)[4:13])

health_results_all <- cbind(health_results,health_results_upper[,4:13],health_results_lower[,4:13])

mitigation_cost <- read_csv("Mitigation cost/mitigationcost.csv")
all_data <- full_join(mitigation_cost,health_results_all,by=c("Country Code"="ISO_A3"))
all_data <- all_data[, -c(3, 5, 15, 16, 17)]

population <- read_csv("Health/HIA_original_data_by_country.csv")
population.2 <- population %>% dplyr::select(`Country Code`="ISO_A3",AGE,
                                             `Pop2020(million)`= `Pop2020`, `Pop2030(million)`= `Pop2030`, `Pop2050(million)`= `Pop2050`, `Pop2100(million)`= `Pop2100`)
population.3 <- population.2 %>%
  group_by(`Country Code`) %>%
  summarize(across(2:5, sum))

all_data <- full_join(all_data,population.3,by=c("Country Code"))

all_data_NoNA <- na.omit(all_data)
all_data_NoNA <- all_data_NoNA %>% mutate(`Country Code` = if_else(Country == "Democratic Peoples Republic of Korea", "PRK", `Country Code`))

region_mapping <- read_csv("GCAM Country Info - corrected.csv")
sum_data <- full_join(all_data_NoNA,region_mapping,by=c("GCAMRegion","Country","Country Code"))

write_csv(sum_data, "health_mitigationcost_data.csv")

sum_data_Incomegroup <- sum_data %>%
  group_by(across(47)) %>%
  summarise(across(4:46, sum, na.rm = TRUE), .groups = "drop")

write_csv(sum_data_Incomegroup, "health_mitigationcost_data_Incomegroup.csv")

