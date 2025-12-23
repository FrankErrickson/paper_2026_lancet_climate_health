library(readr)
library(dplyr)
library(tidyr)
library(tidyverse)
library(stringr)
library(readxl)

setwd("D:/08 GCAM/global-project output database/AirPollutionControl cost/")

############ Clean GCAM emission data and calculate PM emissions ############ 

BC <- c("BC", "BC_AWB")
OC <- c("OC", "OC_AWB")
CH4 <- c("CH4", "CH4_AGR", "CH4_AWB")
CO <- c("CO", "CO_AWB")
NH3 <- c("NH3", "NH3_AGR", "NH3_AWB")
NMVOC <- c("NMVOC", "NMVOC_AGR", "NMVOC_AWB")
NOx <- c("NOx", "NOx_AGR", "NOx_AWB")
SO2 <- c("SO2", "SO2_1","SO2_1_AWB", "SO2_2","SO2_2_AWB", "SO2_3","SO2_3_AWB", "SO2_4","SO2_4_AWB")
sector_mapping <- read_xlsx("GCAM data.xlsx", sheet = 1)

emission_GCAM_ref <- read_excel("GCAM data.xlsx", sheet = 3)
emission_GCAM_ref.2 <- emission_GCAM_ref %>% dplyr::select(region,sector,GHG,`2020`,`2030`,`2050`,`2100`)
emission_GCAM_ref.3 <- emission_GCAM_ref.2 %>% 
  mutate(GHG = ifelse(GHG %in% BC, "BC", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% OC, "OC", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% CH4, "CH4", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% CO, "CO", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% NH3, "NH3", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% NMVOC, "NMVOC", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% NOx, "NOx", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% SO2, "SO2", GHG)) %>%
  filter(GHG %in% c("BC", "OC", "CH4", "CO", "NH3", "NMVOC", "NOx", "SO2")) 
emission_GCAM_ref.4 <- emission_GCAM_ref.3 %>% inner_join(sector_mapping, by = c("sector" = "GCAM Sectors"))

emission_GCAM_ref.4.2 <- emission_GCAM_ref.4 %>% dplyr::select(region, Categories, sector, GHG, `2020`,`2030`,`2050`,`2100`) %>% 
  group_by(region, Categories, sector, GHG) %>% summarise_all(list(sum)) %>% ungroup()
write_csv(emission_GCAM_ref.4.2, "emission_GCAM_ref_region_sector_category.csv")

emission_GCAM_ref.5 <- emission_GCAM_ref.4 %>% dplyr::select(region, Categories, GHG, `2020`,`2030`,`2050`,`2100`) %>% 
  group_by(region, Categories, GHG) %>% summarise_all(list(sum)) %>% ungroup()

bc_data <- emission_GCAM_ref.5 %>% filter(GHG == "BC")
oc_data <- emission_GCAM_ref.5 %>% filter(GHG == "OC")
merged_data <- merge(bc_data, oc_data, by = c("region", "Categories"), suffixes = c("_BC", "_OC"))
pm_data <- merged_data %>%
  mutate(
    GHG = "PM",
    `2020` = (`2020_BC` + `2020_OC` * 1.3) * 1.1,
    `2030` = (`2030_BC` + `2030_OC` * 1.3) * 1.1,
    `2050` = (`2050_BC` + `2050_OC` * 1.3) * 1.1,
    `2100` = (`2100_BC` + `2100_OC` * 1.3) * 1.1
  ) %>%
  dplyr::select(region, Categories, GHG, `2020`,`2030`,`2050`,`2100`)
emission_GCAM_ref.6 <- bind_rows(emission_GCAM_ref.5, pm_data)
write_csv(emission_GCAM_ref.6, "emission_GCAM_ref_region_category.csv")


emission_GCAM_cost <- read_excel("GCAM data.xlsx", sheet = 4)
emission_GCAM_cost.2 <- emission_GCAM_cost %>% dplyr::select(region,sector,GHG,`2020`,`2030`,`2050`,`2100`)
emission_GCAM_cost.3 <- emission_GCAM_cost.2 %>% 
  mutate(GHG = ifelse(GHG %in% BC, "BC", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% OC, "OC", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% CH4, "CH4", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% CO, "CO", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% NH3, "NH3", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% NMVOC, "NMVOC", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% NOx, "NOx", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% SO2, "SO2", GHG)) %>%
  filter(GHG %in% c("BC", "OC", "CH4", "CO", "NH3", "NMVOC", "NOx", "SO2")) 
emission_GCAM_cost.4 <- emission_GCAM_cost.3 %>% inner_join(sector_mapping, by = c("sector" = "GCAM Sectors"))

emission_GCAM_cost.4.2 <- emission_GCAM_cost.4 %>% dplyr::select(region, Categories, sector, GHG, `2020`,`2030`,`2050`,`2100`) %>% 
  group_by(region, Categories, sector, GHG) %>% summarise_all(list(sum)) %>% ungroup()
write_csv(emission_GCAM_cost.4.2, "emission_GCAM_cost_region_sector_category.csv")

emission_GCAM_cost.5 <- emission_GCAM_cost.4 %>% dplyr::select(region, Categories, GHG, `2020`,`2030`,`2050`,`2100`) %>% 
  group_by(region, Categories, GHG) %>% summarise_all(list(sum)) %>% ungroup()

bc_data <- emission_GCAM_cost.5 %>% filter(GHG == "BC")
oc_data <- emission_GCAM_cost.5 %>% filter(GHG == "OC")
merged_data <- merge(bc_data, oc_data, by = c("region", "Categories"), suffixes = c("_BC", "_OC"))
pm_data <- merged_data %>%
  mutate(
    GHG = "PM",
    `2020` = (`2020_BC` + `2020_OC` * 1.3) * 1.1,
    `2030` = (`2030_BC` + `2030_OC` * 1.3) * 1.1,
    `2050` = (`2050_BC` + `2050_OC` * 1.3) * 1.1,
    `2100` = (`2100_BC` + `2100_OC` * 1.3) * 1.1
  ) %>%
  dplyr::select(region, Categories, GHG, `2020`,`2030`,`2050`,`2100`)
emission_GCAM_cost.6 <- bind_rows(emission_GCAM_cost.5, pm_data)
write_csv(emission_GCAM_cost.6, "emission_GCAM_cost_region_category.csv")


emission_GCAM_welfare <- read_excel("GCAM data.xlsx", sheet = 5)
emission_GCAM_welfare.2 <- emission_GCAM_welfare %>% dplyr::select(region,sector,GHG,`2020`,`2030`,`2050`,`2100`)
emission_GCAM_welfare.3 <- emission_GCAM_welfare.2 %>% 
  mutate(GHG = ifelse(GHG %in% BC, "BC", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% OC, "OC", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% CH4, "CH4", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% CO, "CO", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% NH3, "NH3", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% NMVOC, "NMVOC", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% NOx, "NOx", GHG)) %>%
  mutate(GHG = ifelse(GHG %in% SO2, "SO2", GHG)) %>%
  filter(GHG %in% c("BC", "OC", "CH4", "CO", "NH3", "NMVOC", "NOx", "SO2")) 
emission_GCAM_welfare.4 <- emission_GCAM_welfare.3 %>% inner_join(sector_mapping, by = c("sector" = "GCAM Sectors"))

emission_GCAM_welfare.4.2 <- emission_GCAM_welfare.4 %>% dplyr::select(region, Categories, sector, GHG, `2020`,`2030`,`2050`,`2100`) %>% 
  group_by(region, Categories, sector, GHG) %>% summarise_all(list(sum)) %>% ungroup()
write_csv(emission_GCAM_welfare.4.2, "emission_GCAM_welfare_region_sector_category.csv")

emission_GCAM_welfare.5 <- emission_GCAM_welfare.4 %>% dplyr::select(region, Categories, GHG, `2020`,`2030`,`2050`,`2100`) %>% 
  group_by(region, Categories, GHG) %>% summarise_all(list(sum)) %>% ungroup()

bc_data <- emission_GCAM_welfare.5 %>% filter(GHG == "BC")
oc_data <- emission_GCAM_welfare.5 %>% filter(GHG == "OC")
merged_data <- merge(bc_data, oc_data, by = c("region", "Categories"), suffixes = c("_BC", "_OC"))
pm_data <- merged_data %>%
  mutate(
    GHG = "PM",
    `2020` = (`2020_BC` + `2020_OC` * 1.3) * 1.1,
    `2030` = (`2030_BC` + `2030_OC` * 1.3) * 1.1,
    `2050` = (`2050_BC` + `2050_OC` * 1.3) * 1.1,
    `2100` = (`2100_BC` + `2100_OC` * 1.3) * 1.1
  ) %>%
  dplyr::select(region, Categories, GHG, `2020`,`2030`,`2050`,`2100`)
emission_GCAM_welfare.6 <- bind_rows(emission_GCAM_welfare.5, pm_data)
write_csv(emission_GCAM_welfare.6, "emission_GCAM_welfare_region_category.csv")

############ 


############ Calculate air pollution control costs using GAINS 2030 MAC ############ 

GCAM_REF <- read_csv("emission_GCAM_ref_region_category.csv")
GCAM_REF.2 <- GCAM_REF %>% filter(GHG == "NH3" | GHG == "NOx" | GHG == "PM" | GHG == "SO2" | GHG == "NMVOC") %>% filter(Categories != "wildfire") %>%
  mutate(GHG = ifelse(GHG == "NMVOC", "VOC", GHG)) %>%
  mutate(GHG = ifelse(GHG == "NOx", "NOX", GHG)) %>%
  mutate(Categories = ifelse(Categories == "agriculture", "Agriculture", Categories)) %>%
  mutate(Categories = ifelse(Categories == "industry", "Industry", Categories)) %>%
  mutate(Categories = ifelse(Categories == "power", "Power", Categories)) %>%
  mutate(Categories = ifelse(Categories == "residential commercial", "Residential/Commercial", Categories)) %>%
  mutate(Categories = ifelse(Categories == "transportation", "Transport", Categories)) %>%
  mutate(region = ifelse(region == "Central America and Caribbean", "Central America and the Caribbean", region))
GCAM_REF.3 <- GCAM_REF.2 %>% dplyr::select(GCAM_REG=region, Pollutant=GHG, AGG_SEC=Categories, `REF2020`=`2020`, `REF2030`=`2030`, `REF2050`=`2050`, `REF2100`=`2100`)
GCAM_REF.3[,4:7] <- GCAM_REF.3[,4:7] * 1000

GCAM_Efficiency <- read_csv("emission_GCAM_cost_region_category.csv")
GCAM_Efficiency.2 <- GCAM_Efficiency %>% filter(GHG == "NH3" | GHG == "NOx" | GHG == "PM" | GHG == "SO2" | GHG == "NMVOC") %>% filter(Categories != "wildfire") %>%
  mutate(GHG = ifelse(GHG == "NMVOC", "VOC", GHG)) %>%
  mutate(GHG = ifelse(GHG == "NOx", "NOX", GHG)) %>%
  mutate(Categories = ifelse(Categories == "agriculture", "Agriculture", Categories)) %>%
  mutate(Categories = ifelse(Categories == "industry", "Industry", Categories)) %>%
  mutate(Categories = ifelse(Categories == "power", "Power", Categories)) %>%
  mutate(Categories = ifelse(Categories == "residential commercial", "Residential/Commercial", Categories)) %>%
  mutate(Categories = ifelse(Categories == "transportation", "Transport", Categories)) %>%
  mutate(region = ifelse(region == "Central America and Caribbean", "Central America and the Caribbean", region))
GCAM_Efficiency.3 <- GCAM_Efficiency.2 %>% dplyr::select(GCAM_REG=region, Pollutant=GHG, AGG_SEC=Categories, `Efficiency2030`=`2030`, `Efficiency2050`=`2050`, `Efficiency2100`=`2100`)
GCAM_Efficiency.3[,4:6] <- GCAM_Efficiency.3[,4:6] * 1000

GCAM_Equity <- read_csv("emission_GCAM_welfare_region_category.csv")
GCAM_Equity.2 <- GCAM_Equity %>% filter(GHG == "NH3" | GHG == "NOx" | GHG == "PM" | GHG == "SO2" | GHG == "NMVOC") %>% filter(Categories != "wildfire") %>%
  mutate(GHG = ifelse(GHG == "NMVOC", "VOC", GHG)) %>%
  mutate(GHG = ifelse(GHG == "NOx", "NOX", GHG)) %>%
  mutate(Categories = ifelse(Categories == "agriculture", "Agriculture", Categories)) %>%
  mutate(Categories = ifelse(Categories == "industry", "Industry", Categories)) %>%
  mutate(Categories = ifelse(Categories == "power", "Power", Categories)) %>%
  mutate(Categories = ifelse(Categories == "residential commercial", "Residential/Commercial", Categories)) %>%
  mutate(Categories = ifelse(Categories == "transportation", "Transport", Categories)) %>%
  mutate(region = ifelse(region == "Central America and Caribbean", "Central America and the Caribbean", region))
GCAM_Equity.3 <- GCAM_Equity.2 %>% dplyr::select(GCAM_REG=region, Pollutant=GHG, AGG_SEC=Categories, `Equity2030`=`2030`, `Equity2050`=`2050`, `Equity2100`=`2100`)
GCAM_Equity.3[,4:6] <- GCAM_Equity.3[,4:6] * 1000

GAINS_2030 <- read_csv("GAINS_original_2030.csv")
GAINS_2030 <- GAINS_2030 %>% dplyr::select(GCAM_REG, Pollutant, AGG_SEC, `MC (million Euros per kt)`, `Delta EM (kt)`,
                                           `GAINS_EM_2030(kt)` = `EM (kt)`, `GAINS_CUM_REDUCTIONS_2030(kt)` = `CUM_REDUCTIONS (kt)`) %>% 
  filter(AGG_SEC != "Other" & AGG_SEC != "Waste" & AGG_SEC != "ALL" & GCAM_REG != "Not included" )


####### Map GAINS and GCAM total emissions 

GAINS_2030_match <- GAINS_2030 %>% filter(`GAINS_EM_2030(kt)` != 0) 

GCAM_GAINS <- full_join(GAINS_2030_match, GCAM_REF.3, by=c("GCAM_REG","Pollutant","AGG_SEC"))
GCAM_GAINS <- full_join(GCAM_GAINS, GCAM_Efficiency.3, by=c("GCAM_REG","Pollutant","AGG_SEC"))
GCAM_GAINS <- full_join(GCAM_GAINS, GCAM_Equity.3, by=c("GCAM_REG","Pollutant","AGG_SEC"))

write_csv(GCAM_GAINS,"GCAM_GAINS.csv")

####### Generate MAC for Equity Scenario and calculate air pollution control costs compared to Efficiency scenario

GAINS_2030 <- read_csv("GAINS_original_2030.csv")
GAINS_2030 <- GAINS_2030 %>% dplyr::select(GCAM_REG, Pollutant, AGG_SEC, `MC (million Euros per kt)`, `Delta EM (kt)`,
                                           `GAINS_EM(kt)` = `EM (kt)`, `GAINS_CUM_REDUCTIONS(kt)` = `CUM_REDUCTIONS (kt)`) %>% 
  filter(AGG_SEC != "Other" & AGG_SEC != "Waste" & AGG_SEC != "ALL" & GCAM_REG != "Not included" )

GCAM_GAINS <- read_csv("GCAM_GAINS.csv")

#GCAM_GAINS.2 <- GCAM_GAINS %>% 
  #dplyr::select(GCAM_REG, Pollutant, AGG_SEC, `GAINS_EM_2030(kt)`, Equity2050) %>%
  #filter(!(Pollutant == "NH3" & AGG_SEC != "Agriculture")) %>% 
  #filter(!(Pollutant == "NOX" & AGG_SEC == "Agriculture")) %>% 
  #filter(!(Pollutant == "SO2" & AGG_SEC == "Agriculture")) %>%
  #filter(!(Pollutant == "VOC" & AGG_SEC == "Power")) %>%
  #filter(!(Pollutant == "NOX" & AGG_SEC == "Residential/Commercial")) %>%
  #filter(!(Pollutant == "VOC" & AGG_SEC == "Residential/Commercial")) %>%
  #filter(!(Pollutant == "PM" & AGG_SEC == "Transport")) %>%
  #filter(!(Pollutant == "VOC" & AGG_SEC == "Transport"))
#library(writexl)
#write_xlsx(GCAM_GAINS.2, "GCAM_GAINS_2050_LargeDif.xlsx")

GCAM_GAINS$reduction2030 <- GCAM_GAINS$Equity2030 - GCAM_GAINS$Efficiency2030
GCAM_GAINS$reduction2050 <- GCAM_GAINS$Equity2050 - GCAM_GAINS$Efficiency2050
GCAM_GAINS$reduction2100 <- GCAM_GAINS$Equity2100 - GCAM_GAINS$Efficiency2100

GCAM_GAINS$factor2030 <- GCAM_GAINS$Equity2030/GCAM_GAINS$`GAINS_EM_2030(kt)`  ## scaling factor for 2030
GCAM_GAINS$factor2050 <- GCAM_GAINS$Equity2050/GCAM_GAINS$`GAINS_EM_2030(kt)`  ## scaling factor for 2050
GCAM_GAINS$factor2100 <- GCAM_GAINS$Equity2100/GCAM_GAINS$`GAINS_EM_2030(kt)`  ## scaling factor for 2100

GCAM_GAINS_EquitytoEfficiency <- GCAM_GAINS %>% dplyr::select(GCAM_REG, Pollutant, AGG_SEC, 
                                                              factor2030, reduction2030, factor2050, reduction2050, factor2100, reduction2100)
GCAM_EquitytoEfficiency <- full_join(GCAM_GAINS_EquitytoEfficiency, GAINS_2030, by=c("GCAM_REG","Pollutant","AGG_SEC"))

### exclude sectors suggested by Fabian

GCAM_EquitytoEfficiency.1 <- GCAM_EquitytoEfficiency %>% 
  filter(!(Pollutant == "NH3" & AGG_SEC != "Agriculture")) %>% 
  filter(!(Pollutant == "NOX" & AGG_SEC == "Agriculture")) %>% 
  filter(!(Pollutant == "SO2" & AGG_SEC == "Agriculture")) %>%
  filter(!(Pollutant == "VOC" & AGG_SEC == "Power")) %>%
  filter(!(Pollutant == "NOX" & AGG_SEC == "Residential/Commercial")) %>%
  filter(!(Pollutant == "VOC" & AGG_SEC == "Residential/Commercial")) %>%
  filter(!(Pollutant == "PM" & AGG_SEC == "Transport")) %>%
  filter(!(Pollutant == "VOC" & AGG_SEC == "Transport"))
  
### divide data to 2030, 2050, and 2100 repectively and re-scale factors to the potential needed

GCAM_EquitytoEfficiency_2030 <- GCAM_EquitytoEfficiency.1 %>% 
  dplyr::select(GCAM_REG, Pollutant, AGG_SEC, factor2030, reduction2030,
                `MC (million Euros per kt)`, `Delta EM (kt)`, `GAINS_EM(kt)`, `GAINS_CUM_REDUCTIONS(kt)`) %>%
  filter(reduction2030 > 0)
GCAM_EquitytoEfficiency_2030[,7:9] <- GCAM_EquitytoEfficiency_2030[,7:9]*GCAM_EquitytoEfficiency_2030$factor2030

GCAM_EquitytoEfficiency_2030.2 <- GCAM_EquitytoEfficiency_2030 %>% filter(`GAINS_EM(kt)` != 0)  %>% filter(`GAINS_CUM_REDUCTIONS(kt)` != 0)
GCAM_EquitytoEfficiency_2030.2$check <- GCAM_EquitytoEfficiency_2030.2$reduction2030 + GCAM_EquitytoEfficiency_2030.2$`GAINS_CUM_REDUCTIONS(kt)`
GCAM_EquitytoEfficiency_2030.2$factor_adjust <- ifelse(GCAM_EquitytoEfficiency_2030.2$check > 0, 
                                                       -GCAM_EquitytoEfficiency_2030.2$reduction2030/GCAM_EquitytoEfficiency_2030.2$`GAINS_CUM_REDUCTIONS(kt)`, 1)
GCAM_EquitytoEfficiency_2030.3 <- GCAM_EquitytoEfficiency_2030.2 %>% dplyr::select(GCAM_REG, Pollutant, AGG_SEC, factor_adjust)

GCAM_EquitytoEfficiency_2030_final <- full_join(GCAM_EquitytoEfficiency_2030, GCAM_EquitytoEfficiency_2030.3, by=c("GCAM_REG","Pollutant","AGG_SEC"))
GCAM_EquitytoEfficiency_2030_final[,7:9] <- GCAM_EquitytoEfficiency_2030_final[,7:9]*GCAM_EquitytoEfficiency_2030_final$factor_adjust
write_csv(GCAM_EquitytoEfficiency_2030_final,"GCAM_EquitytoEfficiency_2030_MAC.csv")

GCAM_EquitytoEfficiency_2050 <- GCAM_EquitytoEfficiency.1 %>% 
  dplyr::select(GCAM_REG, Pollutant, AGG_SEC, factor2050, reduction2050,
                `MC (million Euros per kt)`, `Delta EM (kt)`, `GAINS_EM(kt)`, `GAINS_CUM_REDUCTIONS(kt)`) %>%
  filter(reduction2050 > 0)
GCAM_EquitytoEfficiency_2050[,7:9] <- GCAM_EquitytoEfficiency_2050[,7:9]*GCAM_EquitytoEfficiency_2050$factor2050

GCAM_EquitytoEfficiency_2050.2 <- GCAM_EquitytoEfficiency_2050 %>% filter(`GAINS_EM(kt)` != 0)  %>% filter(`GAINS_CUM_REDUCTIONS(kt)` != 0)
GCAM_EquitytoEfficiency_2050.2$check <- GCAM_EquitytoEfficiency_2050.2$reduction2050 + GCAM_EquitytoEfficiency_2050.2$`GAINS_CUM_REDUCTIONS(kt)`
GCAM_EquitytoEfficiency_2050.2$factor_adjust <- ifelse(GCAM_EquitytoEfficiency_2050.2$check > 0, 
                                                       -GCAM_EquitytoEfficiency_2050.2$reduction2050/GCAM_EquitytoEfficiency_2050.2$`GAINS_CUM_REDUCTIONS(kt)`, 1)
GCAM_EquitytoEfficiency_2050.3 <- GCAM_EquitytoEfficiency_2050.2 %>% dplyr::select(GCAM_REG, Pollutant, AGG_SEC, factor_adjust)

GCAM_EquitytoEfficiency_2050_final <- full_join(GCAM_EquitytoEfficiency_2050, GCAM_EquitytoEfficiency_2050.3, by=c("GCAM_REG","Pollutant","AGG_SEC"))
GCAM_EquitytoEfficiency_2050_final[,7:9] <- GCAM_EquitytoEfficiency_2050_final[,7:9]*GCAM_EquitytoEfficiency_2050_final$factor_adjust
write_csv(GCAM_EquitytoEfficiency_2050_final,"GCAM_EquitytoEfficiency_2050_MAC.csv")


GCAM_EquitytoEfficiency_2100 <- GCAM_EquitytoEfficiency.1 %>% 
  dplyr::select(GCAM_REG, Pollutant, AGG_SEC, factor2100, reduction2100,
                `MC (million Euros per kt)`, `Delta EM (kt)`, `GAINS_EM(kt)`, `GAINS_CUM_REDUCTIONS(kt)`) %>%
  filter(reduction2100 > 0)
GCAM_EquitytoEfficiency_2100[,7:9] <- GCAM_EquitytoEfficiency_2100[,7:9]*GCAM_EquitytoEfficiency_2100$factor2100

GCAM_EquitytoEfficiency_2100.2 <- GCAM_EquitytoEfficiency_2100 %>% filter(`GAINS_EM(kt)` != 0)  %>% filter(`GAINS_CUM_REDUCTIONS(kt)` != 0)
GCAM_EquitytoEfficiency_2100.2$check <- GCAM_EquitytoEfficiency_2100.2$reduction2100 + GCAM_EquitytoEfficiency_2100.2$`GAINS_CUM_REDUCTIONS(kt)`
GCAM_EquitytoEfficiency_2100.2$factor_adjust <- ifelse(GCAM_EquitytoEfficiency_2100.2$check > 0, 
                                                       -GCAM_EquitytoEfficiency_2100.2$reduction2100/GCAM_EquitytoEfficiency_2100.2$`GAINS_CUM_REDUCTIONS(kt)`, 1)
GCAM_EquitytoEfficiency_2100.3 <- GCAM_EquitytoEfficiency_2100.2 %>% dplyr::select(GCAM_REG, Pollutant, AGG_SEC, factor_adjust)

GCAM_EquitytoEfficiency_2100_final <- full_join(GCAM_EquitytoEfficiency_2100, GCAM_EquitytoEfficiency_2100.3, by=c("GCAM_REG","Pollutant","AGG_SEC"))
GCAM_EquitytoEfficiency_2100_final[,7:9] <- GCAM_EquitytoEfficiency_2100_final[,7:9]*GCAM_EquitytoEfficiency_2100_final$factor_adjust
write_csv(GCAM_EquitytoEfficiency_2100_final,"GCAM_EquitytoEfficiency_2100_MAC.csv")


####### Calculate the total costs by MAC

MAC_2030 <- read_csv("GCAM_EquitytoEfficiency_2030_MAC.csv")
MAC_2030.2 <- MAC_2030 %>% filter(`MC (million Euros per kt)`>0) %>% 
  dplyr::select(GCAM_REG, Pollutant, AGG_SEC, reduction2030, `MC (million Euros per kt)`, `Delta EM (kt)`, `GAINS_CUM_REDUCTIONS(kt)`)
MAC_2030.2$`GAINS_CUM_REDUCTIONS(kt)` <- -MAC_2030.2$`GAINS_CUM_REDUCTIONS(kt)`

MAC_2030.3 <- MAC_2030.2 %>%
  group_by(GCAM_REG, Pollutant, AGG_SEC) %>%
  mutate(adjust_flag = reduction2030 < `GAINS_CUM_REDUCTIONS(kt)`, 
         cumulative_flag = cumsum(adjust_flag)) %>%
  mutate( `Delta EM (kt).2` = ifelse(cumulative_flag == 1 & adjust_flag, 
                                     `Delta EM (kt)` + (`GAINS_CUM_REDUCTIONS(kt)` - reduction2030),
                                     `Delta EM (kt)`)) %>%
  filter(cumulative_flag <= 1) %>% 
  ungroup() %>%
  mutate(cost = - `MC (million Euros per kt)` * `Delta EM (kt).2`) %>%
  filter(cost>0)
  
cost2030 <- MAC_2030.3 %>%
  group_by(GCAM_REG, Pollutant, AGG_SEC) %>%
  summarise(total_cost_2030 = sum(cost, na.rm = TRUE)) %>%
  ungroup()

cost2030_region <- MAC_2030.3 %>%
  group_by(GCAM_REG) %>%
  summarise(total_cost_2030 = sum(cost, na.rm = TRUE)) %>%
  ungroup()


MAC_2050 <- read_csv("GCAM_EquitytoEfficiency_2050_MAC.csv")

#MAC_2050_AfricanSouthern <- MAC_2050 %>% filter(GCAM_REG=='Africa_Southern')
#write_csv(MAC_2050_AfricanSouthern, "MAC_AS.csv")

MAC_2050.2 <- MAC_2050 %>% filter(`MC (million Euros per kt)`>0) %>% 
  dplyr::select(GCAM_REG, Pollutant, AGG_SEC, reduction2050, `MC (million Euros per kt)`, `Delta EM (kt)`, `GAINS_CUM_REDUCTIONS(kt)`)
MAC_2050.2$`GAINS_CUM_REDUCTIONS(kt)` <- -MAC_2050.2$`GAINS_CUM_REDUCTIONS(kt)`

MAC_2050.3 <- MAC_2050.2 %>%
  group_by(GCAM_REG, Pollutant, AGG_SEC) %>%
  mutate(adjust_flag = reduction2050 < `GAINS_CUM_REDUCTIONS(kt)`, 
         cumulative_flag = cumsum(adjust_flag)) %>%
  mutate( `Delta EM (kt).2` = ifelse(cumulative_flag == 1 & adjust_flag, 
                                     `Delta EM (kt)` + (`GAINS_CUM_REDUCTIONS(kt)` - reduction2050),
                                     `Delta EM (kt)`)) %>%
  filter(cumulative_flag <= 1) %>% 
  ungroup() %>%
  mutate(cost = - `MC (million Euros per kt)` * `Delta EM (kt).2`) %>%
  filter(cost>0)

cost2050 <- MAC_2050.3 %>%
  group_by(GCAM_REG, Pollutant, AGG_SEC) %>%
  summarise(total_cost_2050 = sum(cost, na.rm = TRUE)) %>%
  ungroup()
# write_csv(cost2050, "cost2050.csv")

cost2050_region <- MAC_2050.3 %>%
  group_by(GCAM_REG) %>%
  summarise(total_cost_2050 = sum(cost, na.rm = TRUE)) %>%
  ungroup()


MAC_2100 <- read_csv("GCAM_EquitytoEfficiency_2100_MAC.csv")
MAC_2100.2 <- MAC_2100 %>% filter(`MC (million Euros per kt)`>0) %>% 
  dplyr::select(GCAM_REG, Pollutant, AGG_SEC, reduction2100, `MC (million Euros per kt)`, `Delta EM (kt)`, `GAINS_CUM_REDUCTIONS(kt)`)
MAC_2100.2$`GAINS_CUM_REDUCTIONS(kt)` <- -MAC_2100.2$`GAINS_CUM_REDUCTIONS(kt)`

MAC_2100.3 <- MAC_2100.2 %>%
  group_by(GCAM_REG, Pollutant, AGG_SEC) %>%
  mutate(adjust_flag = reduction2100 < `GAINS_CUM_REDUCTIONS(kt)`, 
         cumulative_flag = cumsum(adjust_flag)) %>%
  mutate( `Delta EM (kt).2` = ifelse(cumulative_flag == 1 & adjust_flag, 
                                     `Delta EM (kt)` + (`GAINS_CUM_REDUCTIONS(kt)` - reduction2100),
                                     `Delta EM (kt)`)) %>%
  filter(cumulative_flag <= 1) %>% 
  ungroup() %>%
  mutate(cost = - `MC (million Euros per kt)` * `Delta EM (kt).2`) %>%
  filter(cost>0)

cost2100 <- MAC_2100.3 %>%
  group_by(GCAM_REG, Pollutant, AGG_SEC) %>%
  summarise(total_cost_2100 = sum(cost, na.rm = TRUE)) %>%
  ungroup()

cost2100_region <- MAC_2100.3 %>%
  group_by(GCAM_REG) %>%
  summarise(total_cost_2100 = sum(cost, na.rm = TRUE)) %>%
  ungroup()

Air_pollution_control_cost_region <- full_join(cost2030_region, cost2050_region, by = "GCAM_REG")
Air_pollution_control_cost_region <- full_join(Air_pollution_control_cost_region, cost2100_region, by = "GCAM_REG")
Air_pollution_control_cost_region[is.na(Air_pollution_control_cost_region)] <- 0

write_csv(Air_pollution_control_cost_region,"Air_pollution_control_cost_GCAMregion_EquityToEfficiency.csv")

############ 


############ Downscale to country-level and group to four income groups ############ 

Air_pollution_control_cost_region <- read_csv("Air_pollution_control_cost_GCAMregion_EquityToEfficiency.csv")

GDP_2022 <- read_csv("GDP_matching.csv")    #### GDP 2022 : https://databank.worldbank.org/reports.aspx?source=2&series=NY.GDP.MKTP.CD&country=#

Air_pollution_control_cost_region$GCAM_REG <- gsub("Central America and the Caribbean", "Central America and Caribbean", Air_pollution_control_cost_region$GCAM_REG)

Air_pollution_control_cost_country <- GDP_2022 %>% full_join(Air_pollution_control_cost_region, by = c("GCAMRegion" = "GCAM_REG"))

taiwan_data <- Air_pollution_control_cost_country %>% filter(GCAMRegion == "Taiwan") # Group Taiwan data to China
china_data <- Air_pollution_control_cost_country %>% filter(GCAMRegion == "China")
if(nrow(taiwan_data) > 0){
  Air_pollution_control_cost_country <- Air_pollution_control_cost_country %>%
    mutate(across(6:8, ~ ifelse(GCAMRegion == "China", . + taiwan_data[[cur_column()]], .)))
  Air_pollution_control_cost_country <- Air_pollution_control_cost_country %>% filter(GCAMRegion != "Taiwan")
}
Air_pollution_control_cost_country <- Air_pollution_control_cost_country %>%      # Calculate the GDP proportion of each country relative to its GCAM region
  group_by(GCAMRegion) %>%
  mutate(factor = `2022 [YR2022]` / sum(`2022 [YR2022]`)) %>%
  ungroup()

Air_pollution_control_cost_country[,6:8] <- Air_pollution_control_cost_country[,6:8]*Air_pollution_control_cost_country$factor

Air_pollution_control_cost_country.2 <- Air_pollution_control_cost_country[,-c(3,5,9)]
Air_pollution_control_cost_country.2 <- Air_pollution_control_cost_country.2 %>% mutate(`Country Code` = if_else(Country == "Democratic Peoples Republic of Korea", "PRK", `Country Code`))

combined_data <- read_csv("D:/08 GCAM/global-project output database/health_mitigationcost_data.csv")
combined_data <- combined_data[,c(1,2,3,47)]
Air_pollution_control_cost_country.3 <- full_join(Air_pollution_control_cost_country.2,combined_data,by=c("GCAMRegion","Country","Country Code"))
Air_pollution_control_cost_country.4 <- na.omit(Air_pollution_control_cost_country.3)

pollution <- read_csv("D:/08 GCAM/global-project output database/Health/PM/pm25_by_country.csv")
pollution$`2030PM` <- pollution$Welfare2030 - pollution$Cost2030
pollution$`2050PM` <- pollution$Welfare2050 - pollution$Cost2050
pollution$`2100PM` <- pollution$Welfare2100 - pollution$Cost2100
pollution.2 <- pollution %>% dplyr::select(`Country Code` = ISO, `2030PM`, `2050PM`, `2100PM`)

Air_pollution_control_cost_country.5 <- full_join(Air_pollution_control_cost_country.4,pollution.2,by=c("Country Code"))
Air_pollution_control_cost_country.5 <- na.omit(Air_pollution_control_cost_country.5)

Air_pollution_control_cost_country.5$total_cost_2030[Air_pollution_control_cost_country.5$`2030PM` < 0] <- 0
Air_pollution_control_cost_country.5$total_cost_2050[Air_pollution_control_cost_country.5$`2050PM` < 0] <- 0
Air_pollution_control_cost_country.5$total_cost_2100[Air_pollution_control_cost_country.5$`2100PM` < 0] <- 0
write_csv(Air_pollution_control_cost_country.5,"Air_pollution_control_cost_country_EquityToEfficiency.csv")

sum_Air_pollution_control_cost_Incomegroup <- Air_pollution_control_cost_country.5 %>%
  group_by(across(7)) %>%
  summarise(across(4:6, sum, na.rm = TRUE), .groups = "drop")
write_csv(sum_Air_pollution_control_cost_Incomegroup, "Air_pollution_control_cost_Incomegroup_EquityToEfficiency.csv")

############ 

