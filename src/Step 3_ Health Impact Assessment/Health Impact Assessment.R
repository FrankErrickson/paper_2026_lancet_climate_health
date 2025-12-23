library(readr)
library(dplyr)
library(tidyr)
library(purrr)
library(tidyverse)
library(stringr)
library(scales)
library(sf)
library(raster)
library(rworldmap)
library(maps)
library(mapdata)
library(ggplot2)
library(ggpattern)
library(ggtext)
library(reshape2)
library(readxl)
library(data.table)

setwd("D:/08 GCAM/global-project output database/R1/Health/")


################################################################# Country-level population data from IISSA ################################################################# 

pop <- read_csv("Pop/SspDb_country_data_2013-06-12.csv")
pop$REGION <- gsub("HKG", "CHN", pop$REGION)
pop$REGION <- gsub("MAC", "CHN", pop$REGION)
pop_AGE <- pop %>%
  filter(grepl("Population\\|Female\\|Aged(\\d+-\\d+|100\\+)|Population\\|Male\\|Aged(\\d+-\\d+|100\\+)", VARIABLE) &
           !grepl("Education", VARIABLE)) %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3 = REGION, AGE = VARIABLE, UNIT, `2015`, `2020`, `2030`, `2050`, `2100`)
pop_AGE$AGE <- gsub("Population\\|Female\\|Aged", "", pop_AGE$AGE)
pop_AGE$AGE <- gsub("Population\\|Male\\|Aged", "", pop_AGE$AGE)
pop_AGE$AGE <- gsub("95-99", "95 plus", pop_AGE$AGE)
pop_AGE$AGE <- gsub("100\\+", "95 plus", pop_AGE$AGE)
pop_AGE <- aggregate(pop_AGE[,6:10],by=list(pop_AGE$MODEL,pop_AGE$SCENARIO,pop_AGE$ISO_A3,pop_AGE$AGE,pop_AGE$UNIT),sum)
pop_AGE <- rename(pop_AGE,"MODEL"="Group.1","SCENARIO"="Group.2","ISO_A3"="Group.3","AGE"="Group.4","UNIT"="Group.5")

pop_AGE_SSP2 <- pop_AGE %>% filter(SCENARIO == "SSP2_v9_130115")
write_csv(pop_AGE_SSP2,"Pop/pop_AGE_IIASA_SSP2.csv")

ssp2_long <- pop_AGE_SSP2 %>%
  pivot_longer(cols = matches("^\\d{4}$"), names_to = "year", values_to = "pop_ssp2")

pop_AGE_SSP1 <- pop_AGE %>% filter(SCENARIO == "SSP1_v9_130115")
pop_AGE_SSP1_long <- pop_AGE_SSP1 %>%
  pivot_longer(cols = starts_with("2"), names_to = "Year", values_to = "Population_Million") %>%
  group_by(ISO_A3, Year) %>%
  mutate(Total_Pop = sum(Population_Million, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(Pop_Share = Population_Million / Total_Pop)
pop_AGE_SSP1_factor <- pop_AGE_SSP1_long %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, Year, Pop_Share) %>%
  pivot_wider(names_from = Year, values_from = Pop_Share, names_prefix = "", names_sep = "_") %>%
  rename_with(~ paste0(., "_factor"), matches("^[0-9]{4}$"))
write_csv(pop_AGE_SSP1_factor,"Pop/pop_AGE_SSP1_factor.csv")

ssp1_long <- pop_AGE_SSP1_factor %>%
  pivot_longer(cols = ends_with("_factor"), 
               names_to = "year", values_to = "factor") %>%
  mutate(year = gsub("_factor", "", year))

merged <- ssp2_long %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, year, pop_ssp2) %>%
  left_join(ssp1_long %>% dplyr::select(ISO_A3, AGE, year, factor), 
            by = c("ISO_A3", "AGE", "year")) %>%
  group_by(ISO_A3, year) %>%
  mutate(total_pop_ssp2 = sum(pop_ssp2, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(pop_adjusted = factor * total_pop_ssp2)

pop_AGE_SSP1.2 <- merged %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, year, pop_adjusted) %>%
  pivot_wider(names_from = year, values_from = pop_adjusted)
write_csv(pop_AGE_SSP1.2,"Pop/pop_AGE_IIASA_SSP1.csv")


pop_AGE_SSP3 <- pop_AGE %>% filter(SCENARIO == "SSP3_v9_130115")
pop_AGE_SSP3_long <- pop_AGE_SSP3 %>%
  pivot_longer(cols = starts_with("2"), names_to = "Year", values_to = "Population_Million") %>%
  group_by(ISO_A3, Year) %>%
  mutate(Total_Pop = sum(Population_Million, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(Pop_Share = Population_Million / Total_Pop)
pop_AGE_SSP3_factor <- pop_AGE_SSP3_long %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, Year, Pop_Share) %>%
  pivot_wider(names_from = Year, values_from = Pop_Share, names_prefix = "", names_sep = "_") %>%
  rename_with(~ paste0(., "_factor"), matches("^[0-9]{4}$"))
write_csv(pop_AGE_SSP3_factor,"Pop/pop_AGE_SSP3_factor.csv")

SSP3_long <- pop_AGE_SSP3_factor %>%
  pivot_longer(cols = ends_with("_factor"), 
               names_to = "year", values_to = "factor") %>%
  mutate(year = gsub("_factor", "", year))

merged <- ssp2_long %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, year, pop_ssp2) %>%
  left_join(SSP3_long %>% dplyr::select(ISO_A3, AGE, year, factor), 
            by = c("ISO_A3", "AGE", "year")) %>%
  group_by(ISO_A3, year) %>%
  mutate(total_pop_ssp2 = sum(pop_ssp2, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(pop_adjusted = factor * total_pop_ssp2)

pop_AGE_SSP3.2 <- merged %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, year, pop_adjusted) %>%
  pivot_wider(names_from = year, values_from = pop_adjusted)
write_csv(pop_AGE_SSP3.2,"Pop/pop_AGE_IIASA_SSP3.csv")


pop_AGE_SSP4 <- pop_AGE %>% filter(SCENARIO == "SSP4d_v9_130115")
pop_AGE_SSP4_long <- pop_AGE_SSP4 %>%
  pivot_longer(cols = starts_with("2"), names_to = "Year", values_to = "Population_Million") %>%
  group_by(ISO_A3, Year) %>%
  mutate(Total_Pop = sum(Population_Million, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(Pop_Share = Population_Million / Total_Pop)
pop_AGE_SSP4_factor <- pop_AGE_SSP4_long %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, Year, Pop_Share) %>%
  pivot_wider(names_from = Year, values_from = Pop_Share, names_prefix = "", names_sep = "_") %>%
  rename_with(~ paste0(., "_factor"), matches("^[0-9]{4}$"))
write_csv(pop_AGE_SSP4_factor,"Pop/pop_AGE_SSP4_factor.csv")

SSP4_long <- pop_AGE_SSP4_factor %>%
  pivot_longer(cols = ends_with("_factor"), 
               names_to = "year", values_to = "factor") %>%
  mutate(year = gsub("_factor", "", year))

merged <- ssp2_long %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, year, pop_ssp2) %>%
  left_join(SSP4_long %>% dplyr::select(ISO_A3, AGE, year, factor), 
            by = c("ISO_A3", "AGE", "year")) %>%
  group_by(ISO_A3, year) %>%
  mutate(total_pop_ssp2 = sum(pop_ssp2, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(pop_adjusted = factor * total_pop_ssp2)

pop_AGE_SSP4.2 <- merged %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, year, pop_adjusted) %>%
  pivot_wider(names_from = year, values_from = pop_adjusted)
write_csv(pop_AGE_SSP4.2,"Pop/pop_AGE_IIASA_SSP4.csv")


pop_AGE_SSP5 <- pop_AGE %>% filter(SCENARIO == "SSP5_v9_130115")
pop_AGE_SSP5_long <- pop_AGE_SSP5 %>%
  pivot_longer(cols = starts_with("2"), names_to = "Year", values_to = "Population_Million") %>%
  group_by(ISO_A3, Year) %>%
  mutate(Total_Pop = sum(Population_Million, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(Pop_Share = Population_Million / Total_Pop)
pop_AGE_SSP5_factor <- pop_AGE_SSP5_long %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, Year, Pop_Share) %>%
  pivot_wider(names_from = Year, values_from = Pop_Share, names_prefix = "", names_sep = "_") %>%
  rename_with(~ paste0(., "_factor"), matches("^[0-9]{4}$"))
write_csv(pop_AGE_SSP5_factor,"Pop/pop_AGE_SSP5_factor.csv")

SSP5_long <- pop_AGE_SSP5_factor %>%
  pivot_longer(cols = ends_with("_factor"), 
               names_to = "year", values_to = "factor") %>%
  mutate(year = gsub("_factor", "", year))

merged <- ssp2_long %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, year, pop_ssp2) %>%
  left_join(SSP5_long %>% dplyr::select(ISO_A3, AGE, year, factor), 
            by = c("ISO_A3", "AGE", "year")) %>%
  group_by(ISO_A3, year) %>%
  mutate(total_pop_ssp2 = sum(pop_ssp2, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(pop_adjusted = factor * total_pop_ssp2)

pop_AGE_SSP5.2 <- merged %>%
  dplyr::select(MODEL, SCENARIO, ISO_A3, AGE, UNIT, year, pop_adjusted) %>%
  pivot_wider(names_from = year, values_from = pop_adjusted)
write_csv(pop_AGE_SSP5.2,"Pop/pop_AGE_IIASA_SSP5.csv")


################################################################# 

################################################################# Baseline mortality data from IFs ################################################################# 

COPD_mort <- read_csv("Baseline mortality/COPD_SSP2_mort_0.csv")
COPD_mort <- COPD_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
COPD_mort.2 <- COPD_mort %>% gather(key = "AGE", value = COPDmortality, 3:22)
COPD_mort.2$year <- gsub("2099", "2100", COPD_mort.2$year)
COPD_mort.2$AGE <- gsub("Under 5", "0-4", COPD_mort.2$AGE)
COPD_mort.2$AGE <- gsub(" to ", "-", COPD_mort.2$AGE)

IHD_mort <- read_csv("Baseline mortality/IHD_SSP2_mort_0.csv")
IHD_mort <- IHD_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
IHD_mort.2 <- IHD_mort %>% gather(key = "AGE", value = IHDmortality, 3:22)
IHD_mort.2$year <- gsub("2099", "2100", IHD_mort.2$year)
IHD_mort.2$AGE <- gsub("Under 5", "0-4", IHD_mort.2$AGE)
IHD_mort.2$AGE <- gsub(" to ", "-", IHD_mort.2$AGE)

LC_mort <- read_csv("Baseline mortality/LC_SSP2_mort_0.csv")
LC_mort <- LC_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
LC_mort.2 <- LC_mort %>% gather(key = "AGE", value = LCmortality, 3:22)
LC_mort.2$year <- gsub("2099", "2100", LC_mort.2$year)
LC_mort.2$AGE <- gsub("Under 5", "0-4", LC_mort.2$AGE)
LC_mort.2$AGE <- gsub(" to ", "-", LC_mort.2$AGE)

LRI_mort <- read_csv("Baseline mortality/LRI_SSP2_mort_0.csv")
LRI_mort <- LRI_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
LRI_mort.2 <- LRI_mort %>% gather(key = "AGE", value = LRImortality, 3:22)
LRI_mort.2$year <- gsub("2099", "2100", LRI_mort.2$year)
LRI_mort.2$AGE <- gsub("Under 5", "0-4", LRI_mort.2$AGE)
LRI_mort.2$AGE <- gsub(" to ", "-", LRI_mort.2$AGE)

Stroke_mort <- read_csv("Baseline mortality/Stroke_SSP2_mort_0.csv")
Stroke_mort <- Stroke_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
Stroke_mort.2 <- Stroke_mort %>% gather(key = "AGE", value = Strokemortality, 3:22)
Stroke_mort.2$year <- gsub("2099", "2100", Stroke_mort.2$year)
Stroke_mort.2$AGE <- gsub("Under 5", "0-4", Stroke_mort.2$AGE)
Stroke_mort.2$AGE <- gsub(" to ", "-", Stroke_mort.2$AGE)

DB_mort <- read_csv("Baseline mortality/DB_SSP2_mort_0.csv")
DB_mort <- DB_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
DB_mort.2 <- DB_mort %>% gather(key = "AGE", value = Diabetesmortality, 3:22)
DB_mort.2$year <- gsub("2099", "2100", DB_mort.2$year)
DB_mort.2$AGE <- gsub("Under 5", "0-4", DB_mort.2$AGE)
DB_mort.2$AGE <- gsub(" to ", "-", DB_mort.2$AGE)

baseline_mortality <- cbind(COPD_mort.2,IHD_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,LC_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,LRI_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,Stroke_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,DB_mort.2[,4])

write_csv(baseline_mortality,"Baseline mortality/baseline_mortality_AGE_IFv764_SSP2.csv")


COPD_mort <- read_csv("Baseline mortality/COPD_SSP1_mort_0.csv")
COPD_mort <- COPD_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
COPD_mort.2 <- COPD_mort %>% gather(key = "AGE", value = COPDmortality, 3:22)
COPD_mort.2$year <- gsub("2099", "2100", COPD_mort.2$year)
COPD_mort.2$AGE <- gsub("Under 5", "0-4", COPD_mort.2$AGE)
COPD_mort.2$AGE <- gsub(" to ", "-", COPD_mort.2$AGE)

IHD_mort <- read_csv("Baseline mortality/IHD_SSP1_mort_0.csv")
IHD_mort <- IHD_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
IHD_mort.2 <- IHD_mort %>% gather(key = "AGE", value = IHDmortality, 3:22)
IHD_mort.2$year <- gsub("2099", "2100", IHD_mort.2$year)
IHD_mort.2$AGE <- gsub("Under 5", "0-4", IHD_mort.2$AGE)
IHD_mort.2$AGE <- gsub(" to ", "-", IHD_mort.2$AGE)

LC_mort <- read_csv("Baseline mortality/LC_SSP1_mort_0.csv")
LC_mort <- LC_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
LC_mort.2 <- LC_mort %>% gather(key = "AGE", value = LCmortality, 3:22)
LC_mort.2$year <- gsub("2099", "2100", LC_mort.2$year)
LC_mort.2$AGE <- gsub("Under 5", "0-4", LC_mort.2$AGE)
LC_mort.2$AGE <- gsub(" to ", "-", LC_mort.2$AGE)

LRI_mort <- read_csv("Baseline mortality/LRI_SSP1_mort_0.csv")
LRI_mort <- LRI_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
LRI_mort.2 <- LRI_mort %>% gather(key = "AGE", value = LRImortality, 3:22)
LRI_mort.2$year <- gsub("2099", "2100", LRI_mort.2$year)
LRI_mort.2$AGE <- gsub("Under 5", "0-4", LRI_mort.2$AGE)
LRI_mort.2$AGE <- gsub(" to ", "-", LRI_mort.2$AGE)

Stroke_mort <- read_csv("Baseline mortality/Stroke_SSP1_mort_0.csv")
Stroke_mort <- Stroke_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
Stroke_mort.2 <- Stroke_mort %>% gather(key = "AGE", value = Strokemortality, 3:22)
Stroke_mort.2$year <- gsub("2099", "2100", Stroke_mort.2$year)
Stroke_mort.2$AGE <- gsub("Under 5", "0-4", Stroke_mort.2$AGE)
Stroke_mort.2$AGE <- gsub(" to ", "-", Stroke_mort.2$AGE)

DB_mort <- read_csv("Baseline mortality/DB_SSP1_mort_0.csv")
DB_mort <- DB_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
DB_mort.2 <- DB_mort %>% gather(key = "AGE", value = Diabetesmortality, 3:22)
DB_mort.2$year <- gsub("2099", "2100", DB_mort.2$year)
DB_mort.2$AGE <- gsub("Under 5", "0-4", DB_mort.2$AGE)
DB_mort.2$AGE <- gsub(" to ", "-", DB_mort.2$AGE)

baseline_mortality <- cbind(COPD_mort.2,IHD_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,LC_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,LRI_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,Stroke_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,DB_mort.2[,4])

write_csv(baseline_mortality,"Baseline mortality/baseline_mortality_AGE_IFv764_SSP1.csv")


COPD_mort <- read_csv("Baseline mortality/COPD_SSP3_mort_0.csv")
COPD_mort <- COPD_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
COPD_mort.2 <- COPD_mort %>% gather(key = "AGE", value = COPDmortality, 3:22)
COPD_mort.2$year <- gsub("2099", "2100", COPD_mort.2$year)
COPD_mort.2$AGE <- gsub("Under 5", "0-4", COPD_mort.2$AGE)
COPD_mort.2$AGE <- gsub(" to ", "-", COPD_mort.2$AGE)

IHD_mort <- read_csv("Baseline mortality/IHD_SSP3_mort_0.csv")
IHD_mort <- IHD_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
IHD_mort.2 <- IHD_mort %>% gather(key = "AGE", value = IHDmortality, 3:22)
IHD_mort.2$year <- gsub("2099", "2100", IHD_mort.2$year)
IHD_mort.2$AGE <- gsub("Under 5", "0-4", IHD_mort.2$AGE)
IHD_mort.2$AGE <- gsub(" to ", "-", IHD_mort.2$AGE)

LC_mort <- read_csv("Baseline mortality/LC_SSP3_mort_0.csv")
LC_mort <- LC_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
LC_mort.2 <- LC_mort %>% gather(key = "AGE", value = LCmortality, 3:22)
LC_mort.2$year <- gsub("2099", "2100", LC_mort.2$year)
LC_mort.2$AGE <- gsub("Under 5", "0-4", LC_mort.2$AGE)
LC_mort.2$AGE <- gsub(" to ", "-", LC_mort.2$AGE)

LRI_mort <- read_csv("Baseline mortality/LRI_SSP3_mort_0.csv")
LRI_mort <- LRI_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
LRI_mort.2 <- LRI_mort %>% gather(key = "AGE", value = LRImortality, 3:22)
LRI_mort.2$year <- gsub("2099", "2100", LRI_mort.2$year)
LRI_mort.2$AGE <- gsub("Under 5", "0-4", LRI_mort.2$AGE)
LRI_mort.2$AGE <- gsub(" to ", "-", LRI_mort.2$AGE)

Stroke_mort <- read_csv("Baseline mortality/Stroke_SSP3_mort_0.csv")
Stroke_mort <- Stroke_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
Stroke_mort.2 <- Stroke_mort %>% gather(key = "AGE", value = Strokemortality, 3:22)
Stroke_mort.2$year <- gsub("2099", "2100", Stroke_mort.2$year)
Stroke_mort.2$AGE <- gsub("Under 5", "0-4", Stroke_mort.2$AGE)
Stroke_mort.2$AGE <- gsub(" to ", "-", Stroke_mort.2$AGE)

DB_mort <- read_csv("Baseline mortality/DB_SSP3_mort_0.csv")
DB_mort <- DB_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
DB_mort.2 <- DB_mort %>% gather(key = "AGE", value = Diabetesmortality, 3:22)
DB_mort.2$year <- gsub("2099", "2100", DB_mort.2$year)
DB_mort.2$AGE <- gsub("Under 5", "0-4", DB_mort.2$AGE)
DB_mort.2$AGE <- gsub(" to ", "-", DB_mort.2$AGE)

baseline_mortality <- cbind(COPD_mort.2,IHD_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,LC_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,LRI_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,Stroke_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,DB_mort.2[,4])

write_csv(baseline_mortality,"Baseline mortality/baseline_mortality_AGE_IFv764_SSP3.csv")


COPD_mort <- read_csv("Baseline mortality/COPD_SSP4_mort_0.csv")
COPD_mort <- COPD_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
COPD_mort.2 <- COPD_mort %>% gather(key = "AGE", value = COPDmortality, 3:22)
COPD_mort.2$year <- gsub("2099", "2100", COPD_mort.2$year)
COPD_mort.2$AGE <- gsub("Under 5", "0-4", COPD_mort.2$AGE)
COPD_mort.2$AGE <- gsub(" to ", "-", COPD_mort.2$AGE)

IHD_mort <- read_csv("Baseline mortality/IHD_SSP4_mort_0.csv")
IHD_mort <- IHD_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
IHD_mort.2 <- IHD_mort %>% gather(key = "AGE", value = IHDmortality, 3:22)
IHD_mort.2$year <- gsub("2099", "2100", IHD_mort.2$year)
IHD_mort.2$AGE <- gsub("Under 5", "0-4", IHD_mort.2$AGE)
IHD_mort.2$AGE <- gsub(" to ", "-", IHD_mort.2$AGE)

LC_mort <- read_csv("Baseline mortality/LC_SSP4_mort_0.csv")
LC_mort <- LC_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
LC_mort.2 <- LC_mort %>% gather(key = "AGE", value = LCmortality, 3:22)
LC_mort.2$year <- gsub("2099", "2100", LC_mort.2$year)
LC_mort.2$AGE <- gsub("Under 5", "0-4", LC_mort.2$AGE)
LC_mort.2$AGE <- gsub(" to ", "-", LC_mort.2$AGE)

LRI_mort <- read_csv("Baseline mortality/LRI_SSP4_mort_0.csv")
LRI_mort <- LRI_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
LRI_mort.2 <- LRI_mort %>% gather(key = "AGE", value = LRImortality, 3:22)
LRI_mort.2$year <- gsub("2099", "2100", LRI_mort.2$year)
LRI_mort.2$AGE <- gsub("Under 5", "0-4", LRI_mort.2$AGE)
LRI_mort.2$AGE <- gsub(" to ", "-", LRI_mort.2$AGE)

Stroke_mort <- read_csv("Baseline mortality/Stroke_SSP4_mort_0.csv")
Stroke_mort <- Stroke_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
Stroke_mort.2 <- Stroke_mort %>% gather(key = "AGE", value = Strokemortality, 3:22)
Stroke_mort.2$year <- gsub("2099", "2100", Stroke_mort.2$year)
Stroke_mort.2$AGE <- gsub("Under 5", "0-4", Stroke_mort.2$AGE)
Stroke_mort.2$AGE <- gsub(" to ", "-", Stroke_mort.2$AGE)

DB_mort <- read_csv("Baseline mortality/DB_SSP4_mort_0.csv")
DB_mort <- DB_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
DB_mort.2 <- DB_mort %>% gather(key = "AGE", value = Diabetesmortality, 3:22)
DB_mort.2$year <- gsub("2099", "2100", DB_mort.2$year)
DB_mort.2$AGE <- gsub("Under 5", "0-4", DB_mort.2$AGE)
DB_mort.2$AGE <- gsub(" to ", "-", DB_mort.2$AGE)

baseline_mortality <- cbind(COPD_mort.2,IHD_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,LC_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,LRI_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,Stroke_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,DB_mort.2[,4])

write_csv(baseline_mortality,"Baseline mortality/baseline_mortality_AGE_IFv764_SSP4.csv")


COPD_mort <- read_csv("Baseline mortality/COPD_SSP5_mort_0.csv")
COPD_mort <- COPD_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
COPD_mort.2 <- COPD_mort %>% gather(key = "AGE", value = COPDmortality, 3:22)
COPD_mort.2$year <- gsub("2099", "2100", COPD_mort.2$year)
COPD_mort.2$AGE <- gsub("Under 5", "0-4", COPD_mort.2$AGE)
COPD_mort.2$AGE <- gsub(" to ", "-", COPD_mort.2$AGE)

IHD_mort <- read_csv("Baseline mortality/IHD_SSP5_mort_0.csv")
IHD_mort <- IHD_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
IHD_mort.2 <- IHD_mort %>% gather(key = "AGE", value = IHDmortality, 3:22)
IHD_mort.2$year <- gsub("2099", "2100", IHD_mort.2$year)
IHD_mort.2$AGE <- gsub("Under 5", "0-4", IHD_mort.2$AGE)
IHD_mort.2$AGE <- gsub(" to ", "-", IHD_mort.2$AGE)

LC_mort <- read_csv("Baseline mortality/LC_SSP5_mort_0.csv")
LC_mort <- LC_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
LC_mort.2 <- LC_mort %>% gather(key = "AGE", value = LCmortality, 3:22)
LC_mort.2$year <- gsub("2099", "2100", LC_mort.2$year)
LC_mort.2$AGE <- gsub("Under 5", "0-4", LC_mort.2$AGE)
LC_mort.2$AGE <- gsub(" to ", "-", LC_mort.2$AGE)

LRI_mort <- read_csv("Baseline mortality/LRI_SSP5_mort_0.csv")
LRI_mort <- LRI_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
LRI_mort.2 <- LRI_mort %>% gather(key = "AGE", value = LRImortality, 3:22)
LRI_mort.2$year <- gsub("2099", "2100", LRI_mort.2$year)
LRI_mort.2$AGE <- gsub("Under 5", "0-4", LRI_mort.2$AGE)
LRI_mort.2$AGE <- gsub(" to ", "-", LRI_mort.2$AGE)

Stroke_mort <- read_csv("Baseline mortality/Stroke_SSP5_mort_0.csv")
Stroke_mort <- Stroke_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
Stroke_mort.2 <- Stroke_mort %>% gather(key = "AGE", value = Strokemortality, 3:22)
Stroke_mort.2$year <- gsub("2099", "2100", Stroke_mort.2$year)
Stroke_mort.2$AGE <- gsub("Under 5", "0-4", Stroke_mort.2$AGE)
Stroke_mort.2$AGE <- gsub(" to ", "-", Stroke_mort.2$AGE)

DB_mort <- read_csv("Baseline mortality/DB_SSP5_mort_0.csv")
DB_mort <- DB_mort %>% filter(year=="2015" | year=="2020" | year=="2030"| year=="2050"| year=="2099")
DB_mort.2 <- DB_mort %>% gather(key = "AGE", value = Diabetesmortality, 3:22)
DB_mort.2$year <- gsub("2099", "2100", DB_mort.2$year)
DB_mort.2$AGE <- gsub("Under 5", "0-4", DB_mort.2$AGE)
DB_mort.2$AGE <- gsub(" to ", "-", DB_mort.2$AGE)

baseline_mortality <- cbind(COPD_mort.2,IHD_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,LC_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,LRI_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,Stroke_mort.2[,4])
baseline_mortality <- cbind(baseline_mortality,DB_mort.2[,4])

write_csv(baseline_mortality,"Baseline mortality/baseline_mortality_AGE_IFv764_SSP5.csv")

################################################################# 

################################################################# Country-level Ambient PM2,5 concentrations from GEOS-Chem ################################################################# 

## Load the PM2.5 data and the country shape file
pm25_data <- read.csv("PM/GeosChem annual averaged PM2.5.csv")
coordinates(pm25_data) <- ~lon+lat
crs(pm25_data) <- CRS("+init=epsg:4326") # Set CRS
pm25_sf <- st_as_sf(pm25_data, coords = c("lon", "lat"), crs = st_crs(countries)) # Convert PM2.5 data to 'sf' object
countries <- st_read("World_Countries/World_Countries_Generalized.shp") # https://hub.arcgis.com/datasets/esri::world-countries-generalized/explore?location=-0.008740%2C115.852636%2C0.52
countries <- st_transform(countries, crs(pm25_data)) # Ensure same CRS
## Spatial join: PM2.5 data to countries
pm25_countries <- st_join(pm25_sf, countries, join = st_within) 
countries_no_points <- countries[which(!countries$AFF_ISO %in% pm25_countries$AFF_ISO), ] # Identify countries with no points
# Find nearest PM2.5 point for countries without points
nearest_points <- vector("list", nrow(countries_no_points))
for (i in seq_len(nrow(countries_no_points))) {
  distances <- st_distance(countries_no_points[i, ], pm25_sf)
  nearest_point_index <- which.min(distances)
  nearest_point <- pm25_sf[nearest_point_index, ]
  # Add relevant country fields from countries_no_points to nearest_point
  for (field in names(countries)) {
    nearest_point[[field]] <- countries_no_points[i, ][[field]]
  }
  nearest_points[[i]] <- nearest_point
}
nearest_points_sf <- do.call(rbind, nearest_points)  # Convert list to sf object
pm25_all <- rbind(pm25_countries, nearest_points_sf) # Combine original and nearest points data
pm25_all.2 <- as.data.frame(pm25_all) 
pm25_countries_all <- na.omit(pm25_all.2)
pm25_data_by_country <- aggregate(pm25_countries_all[,1:13],by=list(pm25_countries_all$AFF_ISO),mean)
pm25_data_by_country <- rename(pm25_data_by_country,"AFF_ISO"="Group.1")
## match country name and ISO code
region_map <- read_csv("ISO3166-1_country_code.csv")
pm25_data_by_country.2 <- full_join(pm25_data_by_country,region_map,by=c("AFF_ISO"))
pm25_data_by_country.3 <- na.omit(pm25_data_by_country.2)
write_csv(pm25_data_by_country.3,"PM/pm25_by_country.csv")

################################################################# 

################################################################# GEMM ################################################################# 

######## define functions ######## 

calculate_rr <- function(data, disease, year, theta, aerfa, u, v) {
  exp(data[[paste0(disease, "_theta")]] *
        log(1 + (data[[year]] - 2.4) / data[[paste0(disease, "_aerfa")]]) /
        (1 + exp(-((data[[year]] - 2.4) - data[[paste0(disease, "_u")]]) / data[[paste0(disease, "_v")]])))
}

calculate_rr_upper <- function(data, disease, year, theta, se, aerfa, u, v) {
  exp((data[[paste0(disease, "_theta")]] + 2 * data[[paste0(disease, "_se")]]) *
        log(1 + (data[[year]] - 2.4) / data[[paste0(disease, "_aerfa")]]) /
        (1 + exp(-((data[[year]] - 2.4) - data[[paste0(disease, "_u")]]) / data[[paste0(disease, "_v")]])))
}

calculate_rr_lower <- function(data, disease, year, theta, se, aerfa, u, v) {
  exp((data[[paste0(disease, "_theta")]] - 2 * data[[paste0(disease, "_se")]]) *
        log(1 + (data[[year]] - 2.4) / data[[paste0(disease, "_aerfa")]]) /
        (1 + exp(-((data[[year]] - 2.4) - data[[paste0(disease, "_u")]]) / data[[paste0(disease, "_v")]])))
}

calculate_death <- function(rr, mortality, population) {
  (1 - (1 / rr)) * (mortality / 1000) * (population * 1e6)
}


######## Data preparation ######## 

PM <- read_csv("PM/pm25_by_country.csv")
PM <- rename(PM,"ISO_A3"="ISO")

GEMM <- read_csv("health_GEMM_results/GEMM.csv")  ######## RR relevant variables from Burnett et al., 2018

SSP2_pop_AGE <- read_csv("Pop/pop_AGE_IIASA_SSP2.csv")
SSP2_pop_AGE <- SSP2_pop_AGE[,-6]
SSP2_pop_AGE <- rename(SSP2_pop_AGE, "Pop2020"="2020", "Pop2030"="2030", "Pop2050"="2050", "Pop2100"="2100")
SSP2_pop_AGE_PM <- full_join(SSP2_pop_AGE,PM,by=c("ISO_A3"))
SSP2_pop_AGE_PM <- na.omit(SSP2_pop_AGE_PM)

SSP2_mort_AGE <- read_csv("Baseline mortality/baseline_mortality_AGE_IFv764_SSP2.csv")
SSP2_mort_AGE <- SSP2_mort_AGE %>% filter (year != 2015)
SSP2_mort_AGE.2 <- data.frame()
mortality_columns <- c("COPDmortality", "IHDmortality", "LCmortality", "LRImortality", "Strokemortality")
for (mortality in mortality_columns) {
  pivoted_data <- dcast(SSP2_mort_AGE, ISO_A3 + AGE ~ year, value.var = mortality)
  colnames(pivoted_data)[3:ncol(pivoted_data)] <- paste0(colnames(pivoted_data)[3:ncol(pivoted_data)], mortality)
  if (ncol(SSP2_mort_AGE.2) == 0) {
    SSP2_mort_AGE.2 <- pivoted_data
  } else {
    SSP2_mort_AGE.2 <- full_join(SSP2_mort_AGE.2, pivoted_data, by = c("ISO_A3", "AGE"))  }
}

SSP2_pop_mort_AGE_PM <- full_join(SSP2_pop_AGE_PM, SSP2_mort_AGE.2, by=c("ISO_A3", "AGE"))
SSP2_pop_mort_AGE_PM <- na.omit(SSP2_pop_mort_AGE_PM)
SSP2_pop_mort_AGE_PM_GEMM <- full_join(SSP2_pop_mort_AGE_PM, GEMM, by=c("AGE"))

write_csv(SSP2_pop_mort_AGE_PM_GEMM,"health_GEMM_results/HIA_GEMM_original_data_by_country_SSP2.csv")


SSP1_pop_AGE <- read_csv("Pop/pop_AGE_IIASA_SSP1.csv")
SSP1_pop_AGE <- SSP1_pop_AGE[,-6]
SSP1_pop_AGE <- rename(SSP1_pop_AGE, "Pop2020"="2020", "Pop2030"="2030", "Pop2050"="2050", "Pop2100"="2100")
SSP1_pop_AGE_PM <- full_join(SSP1_pop_AGE,PM,by=c("ISO_A3"))
SSP1_pop_AGE_PM <- na.omit(SSP1_pop_AGE_PM)

SSP1_mort_AGE <- read_csv("Baseline mortality/baseline_mortality_AGE_IFv764_SSP1.csv")
SSP1_mort_AGE <- SSP1_mort_AGE %>% filter (year != 2015)
SSP1_mort_AGE.2 <- data.frame()
mortality_columns <- c("COPDmortality", "IHDmortality", "LCmortality", "LRImortality", "Strokemortality")
for (mortality in mortality_columns) {
  pivoted_data <- dcast(SSP1_mort_AGE, ISO_A3 + AGE ~ year, value.var = mortality)
  colnames(pivoted_data)[3:ncol(pivoted_data)] <- paste0(colnames(pivoted_data)[3:ncol(pivoted_data)], mortality)
  if (ncol(SSP1_mort_AGE.2) == 0) {
    SSP1_mort_AGE.2 <- pivoted_data
  } else {
    SSP1_mort_AGE.2 <- full_join(SSP1_mort_AGE.2, pivoted_data, by = c("ISO_A3", "AGE"))  }
}

SSP1_pop_mort_AGE_PM <- full_join(SSP1_pop_AGE_PM, SSP1_mort_AGE.2, by=c("ISO_A3", "AGE"))
SSP1_pop_mort_AGE_PM <- na.omit(SSP1_pop_mort_AGE_PM)
SSP1_pop_mort_AGE_PM_GEMM <- full_join(SSP1_pop_mort_AGE_PM, GEMM, by=c("AGE"))

write_csv(SSP1_pop_mort_AGE_PM_GEMM,"health_GEMM_results/HIA_GEMM_original_data_by_country_SSP1.csv")


SSP3_pop_AGE <- read_csv("Pop/pop_AGE_IIASA_SSP3.csv")
SSP3_pop_AGE <- SSP3_pop_AGE[,-6]
SSP3_pop_AGE <- rename(SSP3_pop_AGE, "Pop2020"="2020", "Pop2030"="2030", "Pop2050"="2050", "Pop2100"="2100")
SSP3_pop_AGE_PM <- full_join(SSP3_pop_AGE,PM,by=c("ISO_A3"))
SSP3_pop_AGE_PM <- na.omit(SSP3_pop_AGE_PM)

SSP3_mort_AGE <- read_csv("Baseline mortality/baseline_mortality_AGE_IFv764_SSP3.csv")
SSP3_mort_AGE <- SSP3_mort_AGE %>% filter (year != 2015)
SSP3_mort_AGE.2 <- data.frame()
mortality_columns <- c("COPDmortality", "IHDmortality", "LCmortality", "LRImortality", "Strokemortality")
for (mortality in mortality_columns) {
  pivoted_data <- dcast(SSP3_mort_AGE, ISO_A3 + AGE ~ year, value.var = mortality)
  colnames(pivoted_data)[3:ncol(pivoted_data)] <- paste0(colnames(pivoted_data)[3:ncol(pivoted_data)], mortality)
  if (ncol(SSP3_mort_AGE.2) == 0) {
    SSP3_mort_AGE.2 <- pivoted_data
  } else {
    SSP3_mort_AGE.2 <- full_join(SSP3_mort_AGE.2, pivoted_data, by = c("ISO_A3", "AGE"))  }
}

SSP3_pop_mort_AGE_PM <- full_join(SSP3_pop_AGE_PM, SSP3_mort_AGE.2, by=c("ISO_A3", "AGE"))
SSP3_pop_mort_AGE_PM <- na.omit(SSP3_pop_mort_AGE_PM)
SSP3_pop_mort_AGE_PM_GEMM <- full_join(SSP3_pop_mort_AGE_PM, GEMM, by=c("AGE"))

write_csv(SSP3_pop_mort_AGE_PM_GEMM,"health_GEMM_results/HIA_GEMM_original_data_by_country_SSP3.csv")


SSP4_pop_AGE <- read_csv("Pop/pop_AGE_IIASA_SSP4.csv")
SSP4_pop_AGE <- SSP4_pop_AGE[,-6]
SSP4_pop_AGE <- rename(SSP4_pop_AGE, "Pop2020"="2020", "Pop2030"="2030", "Pop2050"="2050", "Pop2100"="2100")
SSP4_pop_AGE_PM <- full_join(SSP4_pop_AGE,PM,by=c("ISO_A3"))
SSP4_pop_AGE_PM <- na.omit(SSP4_pop_AGE_PM)

SSP4_mort_AGE <- read_csv("Baseline mortality/baseline_mortality_AGE_IFv764_SSP4.csv")
SSP4_mort_AGE <- SSP4_mort_AGE %>% filter (year != 2015)
SSP4_mort_AGE.2 <- data.frame()
mortality_columns <- c("COPDmortality", "IHDmortality", "LCmortality", "LRImortality", "Strokemortality")
for (mortality in mortality_columns) {
  pivoted_data <- dcast(SSP4_mort_AGE, ISO_A3 + AGE ~ year, value.var = mortality)
  colnames(pivoted_data)[3:ncol(pivoted_data)] <- paste0(colnames(pivoted_data)[3:ncol(pivoted_data)], mortality)
  if (ncol(SSP4_mort_AGE.2) == 0) {
    SSP4_mort_AGE.2 <- pivoted_data
  } else {
    SSP4_mort_AGE.2 <- full_join(SSP4_mort_AGE.2, pivoted_data, by = c("ISO_A3", "AGE"))  }
}

SSP4_pop_mort_AGE_PM <- full_join(SSP4_pop_AGE_PM, SSP4_mort_AGE.2, by=c("ISO_A3", "AGE"))
SSP4_pop_mort_AGE_PM <- na.omit(SSP4_pop_mort_AGE_PM)
SSP4_pop_mort_AGE_PM_GEMM <- full_join(SSP4_pop_mort_AGE_PM, GEMM, by=c("AGE"))

write_csv(SSP4_pop_mort_AGE_PM_GEMM,"health_GEMM_results/HIA_GEMM_original_data_by_country_SSP4.csv")


SSP5_pop_AGE <- read_csv("Pop/pop_AGE_IIASA_SSP5.csv")
SSP5_pop_AGE <- SSP5_pop_AGE[,-6]
SSP5_pop_AGE <- rename(SSP5_pop_AGE, "Pop2020"="2020", "Pop2030"="2030", "Pop2050"="2050", "Pop2100"="2100")
SSP5_pop_AGE_PM <- full_join(SSP5_pop_AGE,PM,by=c("ISO_A3"))
SSP5_pop_AGE_PM <- na.omit(SSP5_pop_AGE_PM)

SSP5_mort_AGE <- read_csv("Baseline mortality/baseline_mortality_AGE_IFv764_SSP5.csv")
SSP5_mort_AGE <- SSP5_mort_AGE %>% filter (year != 2015)
SSP5_mort_AGE.2 <- data.frame()
mortality_columns <- c("COPDmortality", "IHDmortality", "LCmortality", "LRImortality", "Strokemortality")
for (mortality in mortality_columns) {
  pivoted_data <- dcast(SSP5_mort_AGE, ISO_A3 + AGE ~ year, value.var = mortality)
  colnames(pivoted_data)[3:ncol(pivoted_data)] <- paste0(colnames(pivoted_data)[3:ncol(pivoted_data)], mortality)
  if (ncol(SSP5_mort_AGE.2) == 0) {
    SSP5_mort_AGE.2 <- pivoted_data
  } else {
    SSP5_mort_AGE.2 <- full_join(SSP5_mort_AGE.2, pivoted_data, by = c("ISO_A3", "AGE"))  }
}

SSP5_pop_mort_AGE_PM <- full_join(SSP5_pop_AGE_PM, SSP5_mort_AGE.2, by=c("ISO_A3", "AGE"))
SSP5_pop_mort_AGE_PM <- na.omit(SSP5_pop_mort_AGE_PM)
SSP5_pop_mort_AGE_PM_GEMM <- full_join(SSP5_pop_mort_AGE_PM, GEMM, by=c("AGE"))

write_csv(SSP5_pop_mort_AGE_PM_GEMM,"health_GEMM_results/HIA_GEMM_original_data_by_country_SSP5.csv")

######## 

######## Calculate premature deaths ######## 

diseases <- c("COPD", "IHD", "LRI", "LC", "Stroke")
years <- c("REF2020", "REF2030", "REF2050", "REF2100", "Welfare2030", "Welfare2050", "Welfare2100",
           "Cost2030", "Cost2050", "Cost2100", "Impact2030", "Impact2050", "Impact2100")

#### Calculation SSP2

data_SSP2 <- read_csv("health_GEMM_results/HIA_GEMM_original_data_by_country_SSP2.csv")

SSP2_health_outcomes <- data_SSP2 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)
upper_SSP2_health_outcomes <- data_SSP2 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)
lower_SSP2_health_outcomes <- data_SSP2 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    SSP2_health_outcomes[[rr_col]] <- calculate_rr(data_SSP2, disease, year,
                                                   data_SSP2[[paste0(disease, "_theta")]],
                                                   data_SSP2[[paste0(disease, "_aerfa")]],
                                                   data_SSP2[[paste0(disease, "_u")]],
                                                   data_SSP2[[paste0(disease, "_v")]])
    SSP2_health_outcomes[[death_col]] <- calculate_death(SSP2_health_outcomes[[rr_col]],
                                                         data_SSP2[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                         data_SSP2[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}
#write_csv(SSP2_health_outcomes,"health_GEMM_results/health_outcomes_SSP2(withRR).csv")

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    upper_SSP2_health_outcomes[[rr_col]] <- calculate_rr_upper(data_SSP2, disease, year,
                                                               data_SSP2[[paste0(disease, "_theta")]],
                                                               data_SSP2[[paste0(disease, "_se")]],
                                                               data_SSP2[[paste0(disease, "_aerfa")]],
                                                               data_SSP2[[paste0(disease, "_u")]],
                                                               data_SSP2[[paste0(disease, "_v")]])
    upper_SSP2_health_outcomes[[death_col]] <- calculate_death(upper_SSP2_health_outcomes[[rr_col]],
                                                               data_SSP2[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                               data_SSP2[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    lower_SSP2_health_outcomes[[rr_col]] <- calculate_rr_lower(data_SSP2, disease, year,
                                                               data_SSP2[[paste0(disease, "_theta")]],
                                                               data_SSP2[[paste0(disease, "_se")]],
                                                               data_SSP2[[paste0(disease, "_aerfa")]],
                                                               data_SSP2[[paste0(disease, "_u")]],
                                                               data_SSP2[[paste0(disease, "_v")]])
    lower_SSP2_health_outcomes[[death_col]] <- calculate_death(lower_SSP2_health_outcomes[[rr_col]],
                                                               data_SSP2[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                               data_SSP2[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

SSP2_health_outcomes_allage <- SSP2_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)
SSP2_health_outcomes_allage[, 4:13] <- lapply(SSP2_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(SSP2_health_outcomes_allage,"health_GEMM_results/health_outcomes_SSP2.csv")

upper_SSP2_health_outcomes_allage <- upper_SSP2_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

upper_SSP2_health_outcomes_allage[, 4:13] <- lapply(upper_SSP2_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(upper_SSP2_health_outcomes_allage,"health_GEMM_results/upper_health_outcomes_SSP2.csv")

lower_SSP2_health_outcomes_allage <- lower_SSP2_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

lower_SSP2_health_outcomes_allage[, 4:13] <- lapply(lower_SSP2_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(lower_SSP2_health_outcomes_allage,"health_GEMM_results/lower_health_outcomes_SSP2.csv")



#### Calculation SSP1

data_SSP1 <- read_csv("health_GEMM_results/HIA_GEMM_original_data_by_country_SSP1.csv")

SSP1_health_outcomes <- data_SSP1 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)
upper_SSP1_health_outcomes <- data_SSP1 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)
lower_SSP1_health_outcomes <- data_SSP1 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    SSP1_health_outcomes[[rr_col]] <- calculate_rr(data_SSP1, disease, year,
                                                   data_SSP1[[paste0(disease, "_theta")]],
                                                   data_SSP1[[paste0(disease, "_aerfa")]],
                                                   data_SSP1[[paste0(disease, "_u")]],
                                                   data_SSP1[[paste0(disease, "_v")]])
    SSP1_health_outcomes[[death_col]] <- calculate_death(SSP1_health_outcomes[[rr_col]],
                                                         data_SSP1[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                         data_SSP1[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    upper_SSP1_health_outcomes[[rr_col]] <- calculate_rr_upper(data_SSP1, disease, year,
                                                               data_SSP1[[paste0(disease, "_theta")]],
                                                               data_SSP1[[paste0(disease, "_se")]],
                                                               data_SSP1[[paste0(disease, "_aerfa")]],
                                                               data_SSP1[[paste0(disease, "_u")]],
                                                               data_SSP1[[paste0(disease, "_v")]])
    upper_SSP1_health_outcomes[[death_col]] <- calculate_death(upper_SSP1_health_outcomes[[rr_col]],
                                                               data_SSP1[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                               data_SSP1[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    lower_SSP1_health_outcomes[[rr_col]] <- calculate_rr_lower(data_SSP1, disease, year,
                                                               data_SSP1[[paste0(disease, "_theta")]],
                                                               data_SSP1[[paste0(disease, "_se")]],
                                                               data_SSP1[[paste0(disease, "_aerfa")]],
                                                               data_SSP1[[paste0(disease, "_u")]],
                                                               data_SSP1[[paste0(disease, "_v")]])
    lower_SSP1_health_outcomes[[death_col]] <- calculate_death(lower_SSP1_health_outcomes[[rr_col]],
                                                               data_SSP1[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                               data_SSP1[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

SSP1_health_outcomes_allage <- SSP1_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)
SSP1_health_outcomes_allage[, 4:13] <- lapply(SSP1_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(SSP1_health_outcomes_allage,"health_GEMM_results/health_outcomes_SSP1.csv")

upper_SSP1_health_outcomes_allage <- upper_SSP1_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

upper_SSP1_health_outcomes_allage[, 4:13] <- lapply(upper_SSP1_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(upper_SSP1_health_outcomes_allage,"health_GEMM_results/upper_health_outcomes_SSP1.csv")

lower_SSP1_health_outcomes_allage <- lower_SSP1_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

lower_SSP1_health_outcomes_allage[, 4:13] <- lapply(lower_SSP1_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(lower_SSP1_health_outcomes_allage,"health_GEMM_results/lower_health_outcomes_SSP1.csv")



#### Calculation SSP3

data_SSP3 <- read_csv("health_GEMM_results/HIA_GEMM_original_data_by_country_SSP3.csv")

SSP3_health_outcomes <- data_SSP3 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)
upper_SSP3_health_outcomes <- data_SSP3 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)
lower_SSP3_health_outcomes <- data_SSP3 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    SSP3_health_outcomes[[rr_col]] <- calculate_rr(data_SSP3, disease, year,
                                                   data_SSP3[[paste0(disease, "_theta")]],
                                                   data_SSP3[[paste0(disease, "_aerfa")]],
                                                   data_SSP3[[paste0(disease, "_u")]],
                                                   data_SSP3[[paste0(disease, "_v")]])
    SSP3_health_outcomes[[death_col]] <- calculate_death(SSP3_health_outcomes[[rr_col]],
                                                         data_SSP3[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                         data_SSP3[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    upper_SSP3_health_outcomes[[rr_col]] <- calculate_rr_upper(data_SSP3, disease, year,
                                                               data_SSP3[[paste0(disease, "_theta")]],
                                                               data_SSP3[[paste0(disease, "_se")]],
                                                               data_SSP3[[paste0(disease, "_aerfa")]],
                                                               data_SSP3[[paste0(disease, "_u")]],
                                                               data_SSP3[[paste0(disease, "_v")]])
    upper_SSP3_health_outcomes[[death_col]] <- calculate_death(upper_SSP3_health_outcomes[[rr_col]],
                                                               data_SSP3[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                               data_SSP3[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    lower_SSP3_health_outcomes[[rr_col]] <- calculate_rr_lower(data_SSP3, disease, year,
                                                               data_SSP3[[paste0(disease, "_theta")]],
                                                               data_SSP3[[paste0(disease, "_se")]],
                                                               data_SSP3[[paste0(disease, "_aerfa")]],
                                                               data_SSP3[[paste0(disease, "_u")]],
                                                               data_SSP3[[paste0(disease, "_v")]])
    lower_SSP3_health_outcomes[[death_col]] <- calculate_death(lower_SSP3_health_outcomes[[rr_col]],
                                                               data_SSP3[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                               data_SSP3[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

SSP3_health_outcomes_allage <- SSP3_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)
SSP3_health_outcomes_allage[, 4:13] <- lapply(SSP3_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(SSP3_health_outcomes_allage,"health_GEMM_results/health_outcomes_SSP3.csv")

upper_SSP3_health_outcomes_allage <- upper_SSP3_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

upper_SSP3_health_outcomes_allage[, 4:13] <- lapply(upper_SSP3_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(upper_SSP3_health_outcomes_allage,"health_GEMM_results/upper_health_outcomes_SSP3.csv")

lower_SSP3_health_outcomes_allage <- lower_SSP3_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

lower_SSP3_health_outcomes_allage[, 4:13] <- lapply(lower_SSP3_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(lower_SSP3_health_outcomes_allage,"health_GEMM_results/lower_health_outcomes_SSP3.csv")



#### Calculation SSP4

data_SSP4 <- read_csv("health_GEMM_results/HIA_GEMM_original_data_by_country_SSP4.csv")

SSP4_health_outcomes <- data_SSP4 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)
upper_SSP4_health_outcomes <- data_SSP4 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)
lower_SSP4_health_outcomes <- data_SSP4 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    SSP4_health_outcomes[[rr_col]] <- calculate_rr(data_SSP4, disease, year,
                                                   data_SSP4[[paste0(disease, "_theta")]],
                                                   data_SSP4[[paste0(disease, "_aerfa")]],
                                                   data_SSP4[[paste0(disease, "_u")]],
                                                   data_SSP4[[paste0(disease, "_v")]])
    SSP4_health_outcomes[[death_col]] <- calculate_death(SSP4_health_outcomes[[rr_col]],
                                                         data_SSP4[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                         data_SSP4[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    upper_SSP4_health_outcomes[[rr_col]] <- calculate_rr_upper(data_SSP4, disease, year,
                                                               data_SSP4[[paste0(disease, "_theta")]],
                                                               data_SSP4[[paste0(disease, "_se")]],
                                                               data_SSP4[[paste0(disease, "_aerfa")]],
                                                               data_SSP4[[paste0(disease, "_u")]],
                                                               data_SSP4[[paste0(disease, "_v")]])
    upper_SSP4_health_outcomes[[death_col]] <- calculate_death(upper_SSP4_health_outcomes[[rr_col]],
                                                               data_SSP4[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                               data_SSP4[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    lower_SSP4_health_outcomes[[rr_col]] <- calculate_rr_lower(data_SSP4, disease, year,
                                                               data_SSP4[[paste0(disease, "_theta")]],
                                                               data_SSP4[[paste0(disease, "_se")]],
                                                               data_SSP4[[paste0(disease, "_aerfa")]],
                                                               data_SSP4[[paste0(disease, "_u")]],
                                                               data_SSP4[[paste0(disease, "_v")]])
    lower_SSP4_health_outcomes[[death_col]] <- calculate_death(lower_SSP4_health_outcomes[[rr_col]],
                                                               data_SSP4[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                               data_SSP4[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

SSP4_health_outcomes_allage <- SSP4_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)
SSP4_health_outcomes_allage[, 4:13] <- lapply(SSP4_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(SSP4_health_outcomes_allage,"health_GEMM_results/health_outcomes_SSP4.csv")

upper_SSP4_health_outcomes_allage <- upper_SSP4_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

upper_SSP4_health_outcomes_allage[, 4:13] <- lapply(upper_SSP4_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(upper_SSP4_health_outcomes_allage,"health_GEMM_results/upper_health_outcomes_SSP4.csv")

lower_SSP4_health_outcomes_allage <- lower_SSP4_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

lower_SSP4_health_outcomes_allage[, 4:13] <- lapply(lower_SSP4_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(lower_SSP4_health_outcomes_allage,"health_GEMM_results/lower_health_outcomes_SSP4.csv")



#### Calculation SSP5

data_SSP5 <- read_csv("health_GEMM_results/HIA_GEMM_original_data_by_country_SSP5.csv")

SSP5_health_outcomes <- data_SSP5 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)
upper_SSP5_health_outcomes <- data_SSP5 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)
lower_SSP5_health_outcomes <- data_SSP5 %>% dplyr::select(ISO_A3, AFF_ISO, Countryname, AGE)

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    SSP5_health_outcomes[[rr_col]] <- calculate_rr(data_SSP5, disease, year,
                                                   data_SSP5[[paste0(disease, "_theta")]],
                                                   data_SSP5[[paste0(disease, "_aerfa")]],
                                                   data_SSP5[[paste0(disease, "_u")]],
                                                   data_SSP5[[paste0(disease, "_v")]])
    SSP5_health_outcomes[[death_col]] <- calculate_death(SSP5_health_outcomes[[rr_col]],
                                                         data_SSP5[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                         data_SSP5[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    upper_SSP5_health_outcomes[[rr_col]] <- calculate_rr_upper(data_SSP5, disease, year,
                                                               data_SSP5[[paste0(disease, "_theta")]],
                                                               data_SSP5[[paste0(disease, "_se")]],
                                                               data_SSP5[[paste0(disease, "_aerfa")]],
                                                               data_SSP5[[paste0(disease, "_u")]],
                                                               data_SSP5[[paste0(disease, "_v")]])
    upper_SSP5_health_outcomes[[death_col]] <- calculate_death(upper_SSP5_health_outcomes[[rr_col]],
                                                               data_SSP5[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                               data_SSP5[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

for (year in years) {
  for (disease in diseases) {
    rr_col <- paste0("RR_", year, "_", disease)
    death_col <- paste0("death_", year, "_", disease)
    lower_SSP5_health_outcomes[[rr_col]] <- calculate_rr_lower(data_SSP5, disease, year,
                                                               data_SSP5[[paste0(disease, "_theta")]],
                                                               data_SSP5[[paste0(disease, "_se")]],
                                                               data_SSP5[[paste0(disease, "_aerfa")]],
                                                               data_SSP5[[paste0(disease, "_u")]],
                                                               data_SSP5[[paste0(disease, "_v")]])
    lower_SSP5_health_outcomes[[death_col]] <- calculate_death(lower_SSP5_health_outcomes[[rr_col]],
                                                               data_SSP5[[paste0(gsub("[^0-9]", "", year), disease, "mortality")]],
                                                               data_SSP5[[paste0("Pop", gsub("[^0-9]", "", year))]])
  }
}

SSP5_health_outcomes_allage <- SSP5_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)
SSP5_health_outcomes_allage[, 4:13] <- lapply(SSP5_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(SSP5_health_outcomes_allage,"health_GEMM_results/health_outcomes_SSP5.csv")

upper_SSP5_health_outcomes_allage <- upper_SSP5_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

upper_SSP5_health_outcomes_allage[, 4:13] <- lapply(upper_SSP5_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(upper_SSP5_health_outcomes_allage,"health_GEMM_results/upper_health_outcomes_SSP5.csv")

lower_SSP5_health_outcomes_allage <- lower_SSP5_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

lower_SSP5_health_outcomes_allage[, 4:13] <- lapply(lower_SSP5_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(lower_SSP5_health_outcomes_allage,"health_GEMM_results/lower_health_outcomes_SSP5.csv")

######## 

################################################################# 



################################################################# IER ################################################################# 

PM <- read_csv("PM/pm25_by_country.csv")
PM <- rename(PM,"ISO_A3"="ISO")

SSP2_pop_AGE <- read_csv("Pop/pop_AGE_IIASA_SSP2.csv")
SSP2_pop_AGE <- SSP2_pop_AGE[,-6]
SSP2_pop_AGE <- rename(SSP2_pop_AGE, "Pop2020"="2020", "Pop2030"="2030", "Pop2050"="2050", "Pop2100"="2100")
SSP2_pop_AGE_PM <- full_join(SSP2_pop_AGE,PM,by=c("ISO_A3"))
SSP2_pop_AGE_PM <- na.omit(SSP2_pop_AGE_PM)

SSP2_mort_AGE <- read_csv("Baseline mortality/baseline_mortality_AGE_IFv764_SSP2.csv")
SSP2_mort_AGE <- SSP2_mort_AGE %>% filter (year != 2015)
SSP2_mort_AGE.2 <- data.frame()
mortality_columns <- c("COPDmortality", "IHDmortality", "LCmortality", "LRImortality", "Strokemortality", "Diabetesmortality")
for (mortality in mortality_columns) {
  pivoted_data <- dcast(SSP2_mort_AGE, ISO_A3 + AGE ~ year, value.var = mortality)
  colnames(pivoted_data)[3:ncol(pivoted_data)] <- paste0(colnames(pivoted_data)[3:ncol(pivoted_data)], mortality)
  if (ncol(SSP2_mort_AGE.2) == 0) {
    SSP2_mort_AGE.2 <- pivoted_data
  } else {
    SSP2_mort_AGE.2 <- full_join(SSP2_mort_AGE.2, pivoted_data, by = c("ISO_A3", "AGE"))  }
}

SSP2_pop_mort_AGE_PM <- full_join(SSP2_pop_AGE_PM, SSP2_mort_AGE.2, by=c("ISO_A3", "AGE"))
SSP2_pop_mort_AGE_PM <- na.omit(SSP2_pop_mort_AGE_PM)

write_csv(SSP2_pop_mort_AGE_PM,"health_IER_results/HIA_IER_original_data_by_country_SSP2(NoRR).csv")


# 1. 读取数据

hia <- fread("health_IER_results/HIA_IER_original_data_by_country_SSP2(NoRR).csv")
ier <- fread("health_IER_results/IER.csv")

# 2. 清理 AGE
hia[, AGE := trimws(AGE)]
ier[, AGE := trimws(AGE)]

# 3. 找出所有PM2.5浓度列（排除mortality）
pm_cols <- grep("^(REF|Welfare|Cost|Impact)", names(hia), value = TRUE)
pm_cols <- pm_cols[!str_detect(pm_cols, "mortality")]

# 4. 自动识别所有 RR 插值变量（*_min/_max 成对）
rr_types <- names(ier) %>% 
  str_subset("_min$") %>% 
  str_replace("_min$", "")  # 如：RR_IHD, RR_IHD_low, RR_IHD_high

# 5. 初始化结果表
hia[, row_id := .I]
result <- copy(hia)

# 6. 主循环：对每个 PM2.5 列做 RR 插值
for (pm in pm_cols) {
  message("🔄 插值中: ", pm)
  
  hia_sub <- hia[, .(row_id, AGE, conc = get(pm))]
  
  for (rr in rr_types) {
    rr_min_col <- paste0(rr, "_min")
    rr_max_col <- paste0(rr, "_max")
    
    ier_sub <- ier[, .(AGE, Concentration_min, Concentration_max,
                       rr_min = get(rr_min_col), rr_max = get(rr_max_col))]
    
    # 合并按 AGE + allow.cartesian
    merge_dt <- merge(hia_sub, ier_sub, by = "AGE", allow.cartesian = TRUE)
    
    # 筛选浓度落在 min-max 区间内
    merge_dt <- merge_dt[conc >= Concentration_min & conc <= Concentration_max]
    
    # 执行线性插值
    merge_dt[, rr_interp := rr_min + 
               (conc - Concentration_min) / (Concentration_max - Concentration_min + 1e-8) * (rr_max - rr_min)]
    
    # 提取结果（一个 RR 字段 × 一个 PM 列 → 生成一列）
    wide_rr <- merge_dt[, .(row_id, value = rr_interp)]
    setnames(wide_rr, "value", paste0(pm, "_", rr))
    
    # 合并进总结果
    result <- merge(result, wide_rr, by = "row_id", all.x = TRUE, sort = FALSE)
  }
}

# 清除 row_id
result[, row_id := NULL]

fwrite(result, "health_IER_results/HIA_IER_original_data_by_country_SSP2.csv")


######## Calculate premature deaths

df <- read_csv("health_IER_results/HIA_IER_original_data_by_country_SSP2.csv")

rr_cols <- names(df)[str_detect(names(df), "^(REF|Welfare|Cost|Impact)[0-9]{4}_RR_")]

calculate_deaths <- function(df, rr_col) {
  scenario <- str_extract(rr_col, "^(REF|Welfare|Cost|Impact)[0-9]{4}")
  year <- str_extract(scenario, "[0-9]{4}")
  disease <- str_extract(rr_col, "(?<=_RR_)[^_]+")
  ci <- str_extract(rr_col, "low|high") %>% replace_na("central")
  
  pop_col <- paste0("Pop", year)
  mortality_col <- paste0(year, disease, "mortality")
  new_col <- paste0( "death", ifelse(ci == "central", "", paste0("_", ci)), "_", scenario, "_", disease)
  
  # 检查是否所有所需列都存在
  required_cols <- c(rr_col, mortality_col, pop_col)
  missing_cols <- required_cols[!required_cols %in% names(df)]
  
  if (length(missing_cols) == 0) {
    df[[new_col]] <- (1 - (1 / df[[rr_col]])) *
      (df[[mortality_col]] / 1000) *
      (df[[pop_col]] * 1e6)
    message("✅ Created: ", new_col)
  } else {
    message("⚠️ Skipped: ", new_col, " | Missing columns: ", paste(missing_cols, collapse = ", "))
  }
  
  return(df)
}


for (rr in rr_cols) {
  df <- calculate_deaths(df, rr)
}

SSP2_health_outcomes <- df %>% dplyr::select(ISO_A3, AGE, AFF_ISO, Countryname, starts_with("death_"))
SSP2_health_outcomes[is.na(SSP2_health_outcomes)] <- 0

SSP2_health_outcomes_allage <- SSP2_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_REF"), starts_with("death_Cost"), starts_with("death_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)
SSP2_health_outcomes_allage[, 4:13] <- lapply(SSP2_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})

sum(SSP2_health_outcomes_allage$REF2020)

write_csv(SSP2_health_outcomes_allage,"health_IER_results/SSP2_health_outcomes_allage.csv")


upper_SSP2_health_outcomes_allage <- SSP2_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_high_REF"), starts_with("death_high_Cost"), starts_with("death_high_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_high_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_high_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_high_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_high_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_high_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_high_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_high_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_high_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_high_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_high_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

upper_SSP2_health_outcomes_allage[, 4:13] <- lapply(upper_SSP2_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(upper_SSP2_health_outcomes_allage,"health_IER_results/upper_health_outcomes_SSP2.csv")

lower_SSP2_health_outcomes_allage <- SSP2_health_outcomes %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, starts_with("death_low_REF"), starts_with("death_low_Cost"), starts_with("death_low_Welfare")) %>%
  group_by(ISO_A3, AFF_ISO, Countryname) %>%
  summarise(across(starts_with("death_"), sum, .names = "sum_{.col}"), .groups = "drop") %>%
  mutate(
    REF2020 = rowSums(across(starts_with("sum_death_low_REF2020"))),
    REF2030 = rowSums(across(starts_with("sum_death_low_REF2030"))),
    REF2050 = rowSums(across(starts_with("sum_death_low_REF2050"))),
    REF2100 = rowSums(across(starts_with("sum_death_low_REF2100"))),
    Efficiency2030 = rowSums(across(starts_with("sum_death_low_Cost2030"))),
    Efficiency2050 = rowSums(across(starts_with("sum_death_low_Cost2050"))),
    Efficiency2100 = rowSums(across(starts_with("sum_death_low_Cost2100"))),
    Equity2030 = rowSums(across(starts_with("sum_death_low_Welfare2030"))),
    Equity2050 = rowSums(across(starts_with("sum_death_low_Welfare2050"))),
    Equity2100 = rowSums(across(starts_with("sum_death_low_Welfare2100")))
  ) %>%
  dplyr::select(ISO_A3, AFF_ISO, Countryname, REF2020, REF2030, REF2050, REF2100, Efficiency2030, Efficiency2050, Efficiency2100, Equity2030, Equity2050, Equity2100)

lower_SSP2_health_outcomes_allage[, 4:13] <- lapply(lower_SSP2_health_outcomes_allage[, 4:13], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
write_csv(lower_SSP2_health_outcomes_allage,"health_IER_results/lower_health_outcomes_SSP2.csv")


