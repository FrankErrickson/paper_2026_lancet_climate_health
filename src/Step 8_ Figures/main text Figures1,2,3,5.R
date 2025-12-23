library(readr)
library(readxl)
library(dplyr)
library(tidyr)
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
library(ggpattern)

setwd("~/")

combined_data <- read_csv("Figures1-3,5/health_mitigationcost_data.csv")

########################################################  Figure 1 CO2 Emissions  ########################################################  

emission_ref <- read_csv("Figures1-3,5/GCAMemission/emission_GCAM_ref_region_category.csv")
emission_ref$scenario <- "Ref"
emission_efficiency <- read_csv("Figures1-3,5/GCAMemission/emission_GCAM_cost_region_category.csv")
emission_efficiency$scenario <- "Efficiency"
emission_equity <- read_csv("Figures1-3,5/GCAMemission/emission_GCAM_welfare_region_category.csv")
emission_equity$scenario <- "Equity"

emission_all <- rbind(emission_ref,emission_efficiency,emission_equity)

emission_all.2 <- emission_all %>%
  dplyr::select(`scenario`, `GCAMRegion` = `region`, `Categories`, `GHG`, `2020`, `2030`, `2050`, `2100`) %>%
  group_by(`scenario`, `GCAMRegion`, `GHG`) %>% 
  summarise(`2020`=sum(`2020`), `2030`=sum(`2030`),`2050`=sum(`2050`),`2100`=sum(`2100`), .groups = "drop")
  
emission_co2 <- read_xlsx("Figures1-3,5/GCAMemission/GCAM data.xlsx",sheet = "CO2")
emission_co2.2 <- emission_co2 %>%
  filter(scenario != "Impact") %>%
  dplyr::select(`scenario`, `GCAMRegion` = `region`, `sector`, `GHG`, `2020`, `2030`, `2050`, `2100`) %>%
  group_by(`scenario`, `GCAMRegion`, `GHG`) %>% 
  summarise(`2020`=sum(`2020`), `2030`=sum(`2030`),`2050`=sum(`2050`),`2100`=sum(`2100`), .groups = "drop")
  
emission_all.3 <- rbind(emission_all.2, emission_co2.2)  

taiwan_data <- emission_all.3 %>% filter(GCAMRegion == "Taiwan") # Group Taiwan data to China
china_data <- emission_all.3 %>% filter(GCAMRegion == "China")
if(nrow(taiwan_data) > 0){
  emission_all.3 <- emission_all.3 %>%
    mutate(across(4:7, ~ ifelse(GCAMRegion == "China", . + taiwan_data[[cur_column()]], .)))
  emission_all.3 <- emission_all.3 %>% filter(GCAMRegion != "Taiwan")
}

write_csv(emission_all.3,"Figures1-3,5/GCAMemission/emission_all.csv")
####

 
EDGAR_CO2_2021 <- read_csv("Figures1-3,5/GCAMemission/EDGAR_CO2_2021.csv")
regions_to_merge <- c("Macao", "Taiwan", "Hong Kong", "China")
merged_data <- subset(EDGAR_CO2_2021, Country %in% regions_to_merge)
merged_total <- sum(merged_data$`2021`, na.rm = TRUE)
EDGAR_CO2_2021$`2021` <- ifelse(EDGAR_CO2_2021$`Country` == "China", merged_total, EDGAR_CO2_2021$`2021`)
EDGAR_CO2_2021 <- subset(EDGAR_CO2_2021, !Country %in% c("Macao", "Taiwan", "Hong Kong", "GLOBAL TOTAL"))

CO2_emission_matching <- full_join(region_mapping,EDGAR_CO2_2021,by=c("Country Code"))
write_csv(CO2_emission_matching,"Figures1-3,5/GCAMemission/CO2_emission_matching.csv")
### manually check un-matched countries ###

CO2_emission_matching <- read_csv("Figures1-3,5/GCAMemission/CO2_emission_matching.csv")
gcam_emission <- read_csv("Figures1-3,5/GCAMemission/emission_all.csv")
gcam_emission_CO2 <- gcam_emission %>% filter(GHG=="CO2")
CO2_emission_Country <- full_join(gcam_emission_CO2, CO2_emission_matching, by = c("GCAMRegion"))
CO2_emission_Country.2 <- CO2_emission_Country %>%      # Calculate the CO2 proportion of each country relative to its GCAM region
  group_by(GCAMRegion,scenario) %>%
  mutate(factor = `2021` / sum(`2021`)) %>%
  ungroup()
CO2_emission_Country.2[,4:7] <- CO2_emission_Country.2[,4:7]*CO2_emission_Country.2$factor

pop <- combined_data %>% dplyr::select(`Country Code`, `Pop2020(million)`,`Pop2030(million)`,`Pop2050(million)`,`Pop2100(million)`)
CO2_emission_Country.3 <- left_join(CO2_emission_Country.2,pop,by=c("Country Code"))

emission_CO2 <- CO2_emission_Country.3 %>%
  dplyr::select(scenario, region=`Country Income Classification`, `2020`,`2030`,`2050`,`2100`, 
                `Pop2020`=`Pop2020(million)`,`Pop2030`=`Pop2030(million)`,`Pop2050`=`Pop2050(million)`,`Pop2100`=`Pop2100(million)`) %>%
  group_by(`scenario`, `region`) %>% 
  summarise(`2020`=sum(`2020`), `2030`=sum(`2030`),`2050`=sum(`2050`),`2100`=sum(`2100`),
            `Pop2020`=sum(`Pop2020`), `Pop2030`=sum(`Pop2030`),`Pop2050`=sum(`Pop2050`),`Pop2100`=sum(`Pop2100`), .groups = "drop")

emission_all.CO2_2050 <- emission_CO2 %>% dplyr::select(scenario, region,`2050`, Pop=`Pop2050`)
emission_all.CO2_2020 <- emission_CO2 %>% filter(scenario == "Ref") %>% dplyr::select(scenario, region,`2020`, Pop=`Pop2020`)

data_long_2050 <- emission_all.CO2_2050 %>% pivot_longer(cols = `2050`, names_to = "Year", values_to = "Value")
data_long_2050$scenario <- paste(data_long_2050$Year, data_long_2050$scenario, sep = "_")
data_long_2020 <- emission_all.CO2_2020 %>% pivot_longer(cols = `2020`, names_to = "Year", values_to = "Value")
data_long_2020$scenario <- paste(data_long_2020$Year, data_long_2020$scenario, sep = "_")
data_long_CO2 <- rbind(data_long_2050,data_long_2020)
new_row <- data.frame(scenario = "A", region = "High", Pop = 0, Year = 0, Value = 0)
data_long_CO2 <- rbind(data_long_CO2, new_row)
data_long_CO2$`region` <- factor(data_long_CO2$`region`,levels=c("Low", "Lower_Middle", "Upper_Middle", "High"))
data_long_CO2$scenario <- factor(data_long_CO2$scenario,levels=c("2020_Ref","A","2050_Ref","2050_Efficiency", "2050_Equity"))

bar.CO2_all <- ggplot(data_long_CO2, aes(x = scenario, y = Value/1000*44/12, fill = region)) +
  geom_rect(mapping = aes(xmin = 0.25, xmax = 1.75, ymin = -5, ymax = 60), fill = "lightgrey", alpha = 0.2) +
  geom_bar(stat = "identity") +
  scale_y_continuous(limits = c(-5, 60), breaks=seq(-10, 60, 10), expand = expansion(0)) + 
  geom_segment(aes(x = 0, xend = 6, y = 0, yend = 0), size = 0.5, color = "darkgray", linetype ="dashed") + 
  theme_bw() +
  theme(
    legend.position = "right",
    legend.text = element_text(margin = margin(t = 5, b = 5, l=10)),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size = 40),
    panel.background = element_blank(),
    plot.margin = margin(t = 20, r = 30, b = 30, l = 30, unit = "pt"),
    axis.text.x = element_blank(),
    axis.title.x = element_blank())+
  labs(x = "Scenario",
       y = expression(CO[2] ~ "Emissions (Gt" ~ CO[2] ~ ")"),
       fill = "Income group") +
  scale_fill_manual(values = c("Low" = "#B7410E",
                               "Lower_Middle" = "#FF7900",
                               "Upper_Middle" = "#FFBF00",
                               "High" = "#1E90FF"),
                    labels= c("Low","Lower-middle","Upper-middle", "High"))
print(bar.CO2_all)

data_long_CO2$y = data_long_CO2$Value/data_long_CO2$Pop*44/12

bar.CO2_percapita <- ggplot() +
  geom_rect(mapping = aes(xmin = 0.25, xmax = 1.75, ymin = -5, ymax = 15), fill = "lightgrey") +
  geom_point(data = data_long_CO2, aes(x = scenario, y = Value/Pop*44/12, color = region), size = 11, shape = 21, stroke = 4, alpha = 0.75) +
  scale_y_continuous(limits = c(-5, 15), breaks=seq(-5, 15, 5), expand = expansion(0)) + 
  geom_segment(aes(x = 0, xend = 6, y = 0, yend = 0), size = 0.5, color = "darkgray", linetype ="dashed") + 
  theme_bw() +
  theme(
    legend.position = "right",
    legend.text = element_text(margin = margin(t = 5, b = 5, l=10)),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size = 40),
    panel.background = element_blank(),
    plot.margin = margin(t = 20, r = 30, b = 30, l = 30, unit = "pt"),
    axis.text.x = element_blank(),
    axis.title.x = element_blank())+
  labs(x = "Scenario",
       y = expression(CO[2] ~ "Emissions (t" ~ CO[2] ~ " per capita)"),
       color = "Income group") +
  scale_color_manual(values = c("Low" = "#B7410E",
                               "Lower_Middle" = "#FF7900",
                               "Upper_Middle" = "#FFBF00",
                               "High" = "#1E90FF"),
                     labels= c("Low","Lower-middle","Upper-middle", "High"))
print(bar.CO2_percapita)

########################################################  


########################################################  Figure 2 Health Co-benefits  ########################################################  

########## Global distribution ########## 

countries <- st_read("Health Impact Assessment/World_Countries/World_Countries_Generalized.shp")

global_all_PM <- read_csv("Health Impact Assessment/PM/pm25_by_country.csv")
world_PM <- countries %>%
  left_join(global_all_PM, by = "AFF_ISO")

world_PM_2050REF <- ggplot(data = world_PM) +
  geom_sf(aes(fill = REF2050)) +
  scale_fill_gradientn(
    colors = c("white", "#fe6e00", "#ff0000"),
    values = scales::rescale(c(0, 37, 46)),
    limits = c(0, 46),
    breaks = seq(0, 45, by = 15),
    na.value = "white") +
  coord_sf(crs = "+proj=moll") +
  labs(title = "Reference",
       fill = expression("" *mu*g/m^3 * "")) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 24, face = "bold"),  
    legend.title = element_text(size = 24),                    
    legend.text = element_text(size = 24),                     
    legend.spacing.y = unit(1, 'cm')
  )
print(world_PM_2050REF)

world_PM_2050Efficiency <- ggplot(data = world_PM) +
  geom_sf(aes(fill = Cost2050 - REF2050)) +
  scale_fill_gradient2(low = "#03045e", high = "white", mid = "blue", midpoint = -10, limits = c(-20, 0), breaks = seq(-20, 0, by = 5), na.value = "white") +
  coord_sf(crs = "+proj=moll") +
  labs(title = "Least-cost compared to Reference",
       fill = expression("" *mu*g/m^3 * "")) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 24, face = "bold"),  
    legend.title = element_text(size = 24),                    
    legend.text = element_text(size = 24),                     
    legend.spacing.y = unit(1, 'cm')
  )
print(world_PM_2050Efficiency)

world_PM_2050EuityEfficiency <- ggplot(data = world_PM) +
  geom_sf(aes(fill = Welfare2050 - Cost2050 )) +
  scale_fill_gradientn(
    colors = c("darkgreen", "lightgreen", "white", "orange", "brown"),
    values = scales::rescale(c(-2, -0.5, 0, 2, 6)),
    limits = c(-2, 6.1),
    breaks = seq(-2, 6, by = 2),
    na.value = "white") +
  coord_sf(crs = "+proj=moll") +
  labs(title = "Equity compared to Least-cost",
       fill = expression("" *mu*g/m^3 * "")) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 24, face = "bold"),  
    legend.title = element_text(size = 24),                    
    legend.text = element_text(size = 24),                     
    legend.spacing.y = unit(1, 'cm')
  )
print(world_PM_2050EuityEfficiency)

########## 

########## mapping to WHO air quality standard ########## 

global_all_PM <- read_csv("Health Impact Assessment/PM/pm25_by_country.csv")

global_all_PM.2 <- global_all_PM %>% dplyr::select(`Country Code` = ISO, REF2020, REF2050, Efficiency2050 = Cost2050, Equity2050 = Welfare2050)

Income <- combined_data %>% dplyr::select(Country,`Country Code`, Income = `Country Income Classification`)

PM_country <- full_join(global_all_PM.2,Income,by=c("Country Code"))
PM_country <- na.omit(PM_country)

categories <- list(
  ">35 µg/m³" = function(x) x > 35,
  "25–35 µg/m³" = function(x) x > 25 & x <= 35,
  "15–25 µg/m³" = function(x) x > 15 & x <= 25,
  "10–15 µg/m³" = function(x) x > 10 & x <= 15,
  "5–10 µg/m³" = function(x) x > 5 & x <= 10,
  "≤5 µg/m³" = function(x) x <= 5
)

classify_and_calculate <- function(data, column) {
  classified <- sapply(categories, function(cond) sum(cond(data[[column]])))
  total <- sum(classified)
  percentages <- (classified / total) * 100
  return(percentages)
}

Reference2020 <- classify_and_calculate(PM_country, "REF2020")
Reference2050 <- classify_and_calculate(PM_country, "REF2050")
Leastcost2050 <- classify_and_calculate(PM_country, "Efficiency2050")
Equity2050 <- classify_and_calculate(PM_country, "Equity2050")

results <- data.frame(
  Category = factor(c(">35 µg/m³", "25–35 µg/m³", "15–25 µg/m³", "10–15 µg/m³", "5–10 µg/m³", "≤5 µg/m³"),
                    levels = c(">35 µg/m³", "25–35 µg/m³", "15–25 µg/m³", "10–15 µg/m³", "5–10 µg/m³", "≤5 µg/m³")),
  Reference2020 = Reference2020,
  Reference2050 = Reference2050,
  Leastcost2050 = Leastcost2050,
  Equity2050 = Equity2050
)

data_long <- results %>%
  pivot_longer(cols = -Category, names_to = "Scenario", values_to = "Percentage")

data_long$Scenario[data_long$Scenario == "Leastcost2050"] <- "Least-cost2050"
data_long$Scenario <- factor(data_long$Scenario,levels=c("Equity2050", "Least-cost2050", "Reference2050", "Reference2020"))

custom_colors <- c(
  "≤5 µg/m³" = "#98D9C1",
  "5–10 µg/m³" = "#5AADE6",
  "10–15 µg/m³" = "#FFE64D",
  "15–25 µg/m³" = "#FFAD33",
  "25–35 µg/m³" = "#FF6347",
  ">35 µg/m³" = "#8B0000"
)

WHO <- ggplot(data_long, aes(x = Scenario, y = Percentage, fill = Category)) +
  geom_bar(stat = "identity", position = "fill", width = 0.7) +
  coord_flip() +
  scale_fill_manual(values = rev(custom_colors),
                    guide = guide_legend(title = NULL, reverse = TRUE)) +
  labs(
    title = expression(PM[2.5] ~ "levels vis-à-vis WHO Guidelines"),
    fill = expression(PM[2.5] ~ "(µg/m³)"),
  ) +
  scale_y_continuous(
    expand = expansion(0), 
    labels = percent_format(accuracy = 1) 
  )+
  theme_bw() +
  theme(
    legend.position = "bottom",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size = 28),
    panel.background = element_blank(),
    plot.margin = margin(t = 20, r = 40, b = 30, l = 30, unit = "pt"),
    axis.text.x = element_text(color = "black", size = 28, margin = margin(t = 15, unit = "pt")),
    axis.text.y = element_text(color = "black", size = 28, margin = margin(r = 15, unit = "pt")),
    axis.title.y = element_blank(),
    axis.title.x =  element_blank())
print(WHO)

########## 

########## calculate population-weighted PM2.5 concentrations in 2020 and 2050 ########## 

global_all_PM <- read_csv("Health Impact Assessment/PM/pm25_by_country.csv")

global_all_PM.2 <- global_all_PM %>% dplyr::select(`Country Code` = ISO, REF2020, REF2050, Efficiency2050 = Cost2050, Equity2050 = Welfare2050)

pop <- combined_data %>% dplyr::select(Country,`Country Code`, Income = `Country Income Classification`, Pop2020 = `Pop2020(million)`, Pop2050 = `Pop2050(million)`)

weightedPM <- full_join(global_all_PM.2,pop,by=c("Country Code"))
weightedPM <- na.omit(weightedPM)

weighted_mean <- function(x, w) {
  sum(x * w, na.rm = TRUE) / sum(w, na.rm = TRUE)
}

result <- weightedPM %>%
  group_by(Income) %>%
  summarise(
    Weighted_Ref2020 = weighted_mean(REF2020, Pop2020),
    Weighted_Ref2050 = weighted_mean(REF2050, Pop2050),
    Weighted_Efficiency2050 = weighted_mean(Efficiency2050, Pop2050),
    Weighted_Equity2050 = weighted_mean(Equity2050, Pop2050)
  )

LMIC <- weightedPM %>%
  filter(Income != "High") %>%
  summarise(
    Weighted_Ref2020 = weighted_mean(REF2020, Pop2020),
    Weighted_Ref2050 = weighted_mean(REF2050, Pop2050),
    Weighted_Efficiency2050 = weighted_mean(Efficiency2050, Pop2050),
    Weighted_Equity2050 = weighted_mean(Equity2050, Pop2050)
  )

########## 

########## cumulative avoided deaths and death rate in 2050 ########## 

healthdata <- combined_data %>% dplyr::select(`Country`, `Country Code`, `region` = `Country Income Classification`,
                                             REF_2020 = `deaths_REF2020`, REF_2030=`deaths_REF2030`, REF_2050 = `deaths_REF2050`, 
                                             Efficiency_2020 = `deaths_REF2020`, Efficiency_2030 = `deaths_Efficiency2030`, Efficiency_2050 = `deaths_Efficiency2050`, 
                                             Equity_2020 = `deaths_REF2020`, Equity_2030 = `deaths_Equity2030`, Equity_2050 = `deaths_Equity2050`, 
                                             Pop2020 = `Pop2020(million)`, Pop2030 = `Pop2030(million)`, Pop2050 = `Pop2050(million)`)

healthdata$REF_2050total <- (healthdata$REF_2020 + healthdata$REF_2030) *11/2 + (healthdata$REF_2030 + healthdata$REF_2050) *21/2 - healthdata$REF_2030
healthdata$Efficiency_2050total <- (healthdata$Efficiency_2020 + healthdata$Efficiency_2030) *11/2 + (healthdata$Efficiency_2030 + healthdata$Efficiency_2050) *21/2 - healthdata$Efficiency_2030
healthdata$Equity_2050total <- (healthdata$Equity_2020 + healthdata$Equity_2030) *11/2 + (healthdata$Equity_2030 + healthdata$Equity_2050) *21/2 - healthdata$Equity_2030
healthdata$Pop_2050total <- (healthdata$Pop2020 + healthdata$Pop2030) *11/2 + (healthdata$Pop2030 + healthdata$Pop2050) *21/2 - healthdata$Pop2030

healthdata_cumulative <- healthdata %>% dplyr::select(region,REF_2050total,Efficiency_2050total,Equity_2050total,Pop_2050total) %>%
  group_by(`region`) %>% 
  summarise(`REF_2050total`=sum(`REF_2050total`), `Efficiency_2050total`=sum(`Efficiency_2050total`),`Equity_2050total`=sum(`Equity_2050total`),
            `Pop_2050total`=sum(`Pop_2050total`), .groups = "drop")

healthdata_cumulative$Avoid_Efficiency_2050total <- healthdata_cumulative$REF_2050total - healthdata_cumulative$Efficiency_2050total
healthdata_cumulative$Avoid_Equity_2050total <- healthdata_cumulative$REF_2050total - healthdata_cumulative$Equity_2050total

sum(healthdata_cumulative$Avoid_Efficiency_2050total)
sum(healthdata_cumulative$Avoid_Equity_2050total)

####### calculate 95% CI ranges 

upper_healthdata <- combined_data %>% dplyr::select(`Country`, `Country Code`, `region` = `Country Income Classification`,
                                              REF_2020 = `deaths_upper_REF2020`, REF_2030=`deaths_upper_REF2030`, REF_2050 = `deaths_upper_REF2050`, 
                                              Efficiency_2020 = `deaths_upper_REF2020`, Efficiency_2030 = `deaths_upper_Efficiency2030`, Efficiency_2050 = `deaths_upper_Efficiency2050`, 
                                              Equity_2020 = `deaths_upper_REF2020`, Equity_2030 = `deaths_upper_Equity2030`, Equity_2050 = `deaths_upper_Equity2050`, 
                                              Pop2020 = `Pop2020(million)`, Pop2030 = `Pop2030(million)`, Pop2050 = `Pop2050(million)`)

upper_healthdata$REF_2050total <- (upper_healthdata$REF_2020 + upper_healthdata$REF_2030) *11/2 + (upper_healthdata$REF_2030 + upper_healthdata$REF_2050) *21/2 - upper_healthdata$REF_2030
upper_healthdata$Efficiency_2050total <- (upper_healthdata$Efficiency_2020 + upper_healthdata$Efficiency_2030) *11/2 + (upper_healthdata$Efficiency_2030 + upper_healthdata$Efficiency_2050) *21/2 - upper_healthdata$Efficiency_2030
upper_healthdata$Equity_2050total <- (upper_healthdata$Equity_2020 + upper_healthdata$Equity_2030) *11/2 + (upper_healthdata$Equity_2030 + upper_healthdata$Equity_2050) *21/2 - upper_healthdata$Equity_2030
upper_healthdata$Pop_2050total <- (upper_healthdata$Pop2020 + upper_healthdata$Pop2030) *11/2 + (upper_healthdata$Pop2030 + upper_healthdata$Pop2050) *21/2 - upper_healthdata$Pop2030

upper_healthdata_cumulative <- upper_healthdata %>% dplyr::select(region,REF_2050total,Efficiency_2050total,Equity_2050total,Pop_2050total) %>%
  group_by(`region`) %>% 
  summarise(`REF_2050total`=sum(`REF_2050total`), `Efficiency_2050total`=sum(`Efficiency_2050total`),`Equity_2050total`=sum(`Equity_2050total`),
            `Pop_2050total`=sum(`Pop_2050total`), .groups = "drop")

upper_healthdata_cumulative$upper_Avoid_Efficiency_2050total <- upper_healthdata_cumulative$REF_2050total - upper_healthdata_cumulative$Efficiency_2050total
upper_healthdata_cumulative$upper_Avoid_Equity_2050total <- upper_healthdata_cumulative$REF_2050total - upper_healthdata_cumulative$Equity_2050total

sumupper_Efficiency <- sum(upper_healthdata_cumulative$upper_Avoid_Efficiency_2050total)
sumupper_Equity <- sum(upper_healthdata_cumulative$upper_Avoid_Equity_2050total)

lower_healthdata <- combined_data %>% dplyr::select(`Country`, `Country Code`, `region` = `Country Income Classification`,
                                                    REF_2020 = `deaths_lower_REF2020`, REF_2030=`deaths_lower_REF2030`, REF_2050 = `deaths_lower_REF2050`, 
                                                    Efficiency_2020 = `deaths_lower_REF2020`, Efficiency_2030 = `deaths_lower_Efficiency2030`, Efficiency_2050 = `deaths_lower_Efficiency2050`, 
                                                    Equity_2020 = `deaths_lower_REF2020`, Equity_2030 = `deaths_lower_Equity2030`, Equity_2050 = `deaths_lower_Equity2050`, 
                                                    Pop2020 = `Pop2020(million)`, Pop2030 = `Pop2030(million)`, Pop2050 = `Pop2050(million)`)

lower_healthdata$REF_2050total <- (lower_healthdata$REF_2020 + lower_healthdata$REF_2030) *11/2 + (lower_healthdata$REF_2030 + lower_healthdata$REF_2050) *21/2 - lower_healthdata$REF_2030
lower_healthdata$Efficiency_2050total <- (lower_healthdata$Efficiency_2020 + lower_healthdata$Efficiency_2030) *11/2 + (lower_healthdata$Efficiency_2030 + lower_healthdata$Efficiency_2050) *21/2 - lower_healthdata$Efficiency_2030
lower_healthdata$Equity_2050total <- (lower_healthdata$Equity_2020 + lower_healthdata$Equity_2030) *11/2 + (lower_healthdata$Equity_2030 + lower_healthdata$Equity_2050) *21/2 - lower_healthdata$Equity_2030
lower_healthdata$Pop_2050total <- (lower_healthdata$Pop2020 + lower_healthdata$Pop2030) *11/2 + (lower_healthdata$Pop2030 + lower_healthdata$Pop2050) *21/2 - lower_healthdata$Pop2030

lower_healthdata_cumulative <- lower_healthdata %>% dplyr::select(region,REF_2050total,Efficiency_2050total,Equity_2050total,Pop_2050total) %>%
  group_by(`region`) %>% 
  summarise(`REF_2050total`=sum(`REF_2050total`), `Efficiency_2050total`=sum(`Efficiency_2050total`),`Equity_2050total`=sum(`Equity_2050total`),
            `Pop_2050total`=sum(`Pop_2050total`), .groups = "drop")

lower_healthdata_cumulative$lower_Avoid_Efficiency_2050total <- lower_healthdata_cumulative$REF_2050total - lower_healthdata_cumulative$Efficiency_2050total
lower_healthdata_cumulative$lower_Avoid_Equity_2050total <- lower_healthdata_cumulative$REF_2050total - lower_healthdata_cumulative$Equity_2050total

sumlower_Efficiency <- sum(lower_healthdata_cumulative$lower_Avoid_Efficiency_2050total)
sumlower_Equity <- sum(lower_healthdata_cumulative$lower_Avoid_Equity_2050total)

data_long_2050health <- healthdata_cumulative %>% pivot_longer(cols = Avoid_Efficiency_2050total:Avoid_Equity_2050total, names_to = "scenario", values_to = "Value")
data_long_2050health$`region` <- factor(data_long_2050health$`region`,levels=c("Low", "Lower_Middle", "Upper_Middle", "High"))
data_long_2050health$scenario_num <- ifelse(data_long_2050health$scenario == "Avoid_Efficiency_2050total", "1", "2")
data_long_2050health$scenario_num <- as.numeric(data_long_2050health$scenario_num)

bar.health_all <- ggplot(data_long_2050health, aes(x = scenario_num, y = Value/1000000, fill = region), alpha = 0.75) +
  geom_bar(stat = "identity") +
  scale_y_continuous(limits = c(0, 25), breaks=seq(0, 25, 5), expand = expansion(0)) + 
  geom_segment(aes(x = 1, xend = 1, y = sumupper_Efficiency/1000000, yend = sumlower_Efficiency/1000000), size = 1) +
  geom_segment(aes(x = 2, xend = 2, y = sumupper_Equity/1000000, yend = sumlower_Equity/1000000), size = 1) + 
  theme_bw() +
  theme(
    legend.position = "right",
    legend.text = element_text(margin = margin(t = 5, b = 5, l=10)),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size = 40),
    panel.background = element_blank(),
    plot.margin = margin(t = 20, r = 30, b = 30, l = 30, unit = "pt"),
    axis.text.y = element_text(color = "black", size = 40, margin = margin(r = 15, unit = "pt")),
    axis.title.y = element_text(size = 40, margin = margin(r = 15, unit = "pt")),
    axis.text.x = element_blank(),
    axis.title.x = element_blank())+
  labs(x = "Scenario",
       y = "Cumulative avoided deaths (million)",
       fill = "Income group") +
  scale_fill_manual(values = c("Low" = "#B7410E",
                               "Lower_Middle" = "#FF7900",
                               "Upper_Middle" = "#FFBF00",
                               "High" = "#1E90FF"),
                    labels= c("Low","Lower-middle","Upper-middle", "High"))
print(bar.health_all)

bar.health_percapita <- ggplot() +
  geom_point(data = data_long_2050health, aes(x = scenario, y = Value/Pop_2050total, color = region),size = 11, shape = 21, stroke = 4, alpha = 0.75) +
  scale_y_continuous(limits = c(0, 150), breaks=seq(0, 150, 50), expand = expansion(0)) + 
  theme_bw() +
  theme(
    legend.position = "right",
    legend.text = element_text(margin = margin(t = 5, b = 5, l=10)),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size = 40),
    panel.background = element_blank(),
    plot.margin = margin(t = 20, r = 30, b = 30, l = 30, unit = "pt"),
    axis.text.x = element_blank(),
    axis.title.x = element_blank())+
  labs(x = "Scenario",
       y = "Cumulative avoided death rate (per million people) ",
       color = "Income group") +
  scale_color_manual(values = c("Low" = "#B7410E",
                                "Lower_Middle" = "#FF7900",
                                "Upper_Middle" = "#FFBF00",
                                "High" = "#1E90FF"),
                     labels= c("Low","Lower-middle","Upper-middle", "High"))
print(bar.health_percapita)

########## 

########################################################  


########################################################  Figure 3 Health Co-benefits VS Mitigation Cost  ########################################################  

data <- combined_data %>% dplyr::select(Country, `Country Code`, `region` = `Country Income Classification`, pop = `Pop2050(million)`,
                                          `deaths_REF2050`, deaths_Efficiency2050, deaths_Equity2050, 
                                          Cost_Efficiency_2050 = `MitigationCost_Efficiency2050 (2022millionUS$)`, Cost_Equity_2050 = `MitigationCost_Equity2050 (2022millionUS$)`)

data$Avoided_permillion_deaths_Efficiency_2050 <- (data$deaths_REF2050 - data$deaths_Efficiency2050)/data$pop
data$Avoided_permillion_deaths_Equity_2050 <- (data$deaths_REF2050 - data$deaths_Equity2050)/data$pop
data$percapita_Cost_Efficiency_2050 <- data$Cost_Efficiency_2050/data$pop
data$percapita_Cost_Equity_2050 <- data$Cost_Equity_2050/data$pop

data_High <- data %>% filter(region=="High") %>% dplyr::select(Country,`Country Code`, percapita_Cost_Efficiency_2050, percapita_Cost_Equity_2050, 
                                                               Avoided_permillion_deaths_Efficiency_2050, Avoided_permillion_deaths_Equity_2050)

data_High$costreduction <- data_High$percapita_Cost_Efficiency_2050 - data_High$percapita_Cost_Equity_2050

data_High_representative <- data_High %>% filter(`Country Code`== "USA" | `Country Code`== "DEU" | `Country Code`== "NOR" |
                                                   `Country Code`== "JPN" | `Country Code`== "AUS" | `Country Code`== "KOR" )
data_long <- data_High_representative %>%
  pivot_longer(
    cols = c("percapita_Cost_Efficiency_2050","percapita_Cost_Equity_2050","Avoided_permillion_deaths_Efficiency_2050","Avoided_permillion_deaths_Equity_2050"),
    names_to = c("Metric", "Scenario"),
    names_pattern = "(percapita_Cost|Avoided_permillion_deaths)_(.*)_2050",
    values_to = "Value"
  ) %>%
  pivot_wider(
    names_from = Metric,
    values_from = Value
  )
Fig.High <- ggplot(data_long) +
  geom_segment(
    data = data_long %>% tidyr::pivot_wider(names_from = Scenario, values_from = c(percapita_Cost, Avoided_permillion_deaths)),
    aes(
      x = Avoided_permillion_deaths_Efficiency,
      y = percapita_Cost_Efficiency,
      xend = Avoided_permillion_deaths_Equity,
      yend = percapita_Cost_Equity,
      color = Country
    ),
    arrow = arrow(type = "closed", length = unit(0.1, "inches")), linewidth = 1.5
  ) +
  scale_y_continuous(limits = c(0, 7035), breaks=seq(0, 7000, 1000), expand = expansion(0))+
  scale_x_continuous(limits = c(0, 150), breaks=seq(0, 150, 50), expand = expansion(0))+
  theme_bw() +
  theme(
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size = 28),
    panel.background = element_blank(),
    plot.margin = margin(t = 20, r = 30, b = 30, l = 30, unit = "pt"),
    axis.text.x = element_text(color = "black", size = 28, margin = margin(t = 15, unit = "pt")),
    axis.text.y = element_text(color = "black", size = 28, margin = margin(r = 15, unit = "pt")),
    axis.title.y = element_text(size = 28, margin = margin(r = 15, unit = "pt")),
    axis.title.x = element_text(size = 28, margin = margin(t = 15, unit = "pt"))) +
  labs(
    x = "Avoided deaths in 2050 \n (per million)",
    y = "Mitigation cost in 2050 \n (2022US$ per capita)"
  )
print(Fig.High)

data_Low <- data %>% filter(region=="Low") %>% dplyr::select(Country,`Country Code`, percapita_Cost_Efficiency_2050, percapita_Cost_Equity_2050, 
                                                               Avoided_permillion_deaths_Efficiency_2050, Avoided_permillion_deaths_Equity_2050)
data_Low_representative <- data_Low %>% filter(`Country Code`== "ETH" | `Country Code`== "AFG" | `Country Code`== "SOM" |
                                                   `Country Code`== "UGA" | `Country Code`== "SDN" | `Country Code`== "NER" )
data_long <- data_Low_representative %>%
  pivot_longer(
    cols = c("percapita_Cost_Efficiency_2050","percapita_Cost_Equity_2050","Avoided_permillion_deaths_Efficiency_2050","Avoided_permillion_deaths_Equity_2050"),
    names_to = c("Metric", "Scenario"),
    names_pattern = "(percapita_Cost|Avoided_permillion_deaths)_(.*)_2050",
    values_to = "Value"
  ) %>%
  pivot_wider(
    names_from = Metric,
    values_from = Value
  )
Fig.Low <- ggplot(data_long) +
  geom_segment(
    data = data_long %>% tidyr::pivot_wider(names_from = Scenario, values_from = c(percapita_Cost, Avoided_permillion_deaths)),
    aes(
      x = Avoided_permillion_deaths_Efficiency,
      y = percapita_Cost_Efficiency,
      xend = Avoided_permillion_deaths_Equity,
      yend = percapita_Cost_Equity,
      color = Country
    ),
    arrow = arrow(type = "closed", length = unit(0.1, "inches")), linewidth = 1.5
  ) +
  scale_y_continuous(limits = c(0, 50), breaks=seq(0, 50, 10), expand = expansion(0)) +
  scale_x_continuous(limits = c(0, 100), breaks=seq(0, 100, 50), expand = expansion(0)) +
  theme_bw() +
  theme(
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size = 28),
    panel.background = element_blank(),
    plot.margin = margin(t = 20, r = 30, b = 30, l = 30, unit = "pt"),
    axis.text.x = element_text(color = "black", size = 28, margin = margin(t = 15, unit = "pt")),
    axis.text.y = element_text(color = "black", size = 28, margin = margin(r = 15, unit = "pt")),
    axis.title.y = element_text(size = 28, margin = margin(r = 15, unit = "pt")),
    axis.title.x = element_text(size = 28, margin = margin(t = 15, unit = "pt"))) +
  labs(
    x = "Avoided deaths in 2050 \n (per million)",
    y = "Mitigation cost in 2050 \n (2022US$ per capita)"
  )
print(Fig.Low)

data_Lower_Middle <- data %>% filter(region=="Lower_Middle") %>% dplyr::select(Country,`Country Code`, percapita_Cost_Efficiency_2050, percapita_Cost_Equity_2050, 
                                                             Avoided_permillion_deaths_Efficiency_2050, Avoided_permillion_deaths_Equity_2050)
data_Lower_Middle_representative <- data_Lower_Middle %>% filter(`Country Code`== "LSO" | `Country Code`== "IND" | `Country Code`== "HND" |
                                                 `Country Code`== "MAR" | `Country Code`== "PHL" | `Country Code`== "UZB" )
data_long <- data_Lower_Middle_representative %>%
  pivot_longer(
    cols = c("percapita_Cost_Efficiency_2050","percapita_Cost_Equity_2050","Avoided_permillion_deaths_Efficiency_2050","Avoided_permillion_deaths_Equity_2050"),
    names_to = c("Metric", "Scenario"),
    names_pattern = "(percapita_Cost|Avoided_permillion_deaths)_(.*)_2050",
    values_to = "Value"
  ) %>%
  pivot_wider(
    names_from = Metric,
    values_from = Value
  )
Fig.Lower_Middle <- ggplot(data_long) +
  geom_segment(
    data = data_long %>% tidyr::pivot_wider(names_from = Scenario, values_from = c(percapita_Cost, Avoided_permillion_deaths)),
    aes(
      x = Avoided_permillion_deaths_Efficiency,
      y = percapita_Cost_Efficiency,
      xend = Avoided_permillion_deaths_Equity,
      yend = percapita_Cost_Equity,
      color = Country
    ),
    arrow = arrow(type = "closed", length = unit(0.1, "inches")), linewidth = 1.5
  ) +
  scale_y_continuous(limits = c(0, 250), breaks=seq(0, 250, 50), expand = expansion(0)) +
  scale_x_continuous(limits = c(0, 350), breaks=seq(0, 350, 50), expand = expansion(0)) +
  theme_bw() +
  theme(
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size = 28),
    panel.background = element_blank(),
    plot.margin = margin(t = 20, r = 30, b = 30, l = 30, unit = "pt"),
    axis.text.x = element_text(color = "black", size = 28, margin = margin(t = 15, unit = "pt")),
    axis.text.y = element_text(color = "black", size = 28, margin = margin(r = 15, unit = "pt")),
    axis.title.y = element_text(size = 28, margin = margin(r = 15, unit = "pt")),
    axis.title.x = element_text(size = 28, margin = margin(t = 15, unit = "pt"))) +
  labs(
    x = "Avoided deaths in 2050 \n (per million)",
    y = "Mitigation cost in 2050 \n (2022US$ per capita)"
  )
print(Fig.Lower_Middle)

data_Upper_Middle <- data %>% filter(region=="Upper_Middle") %>% dplyr::select(Country,`Country Code`, percapita_Cost_Efficiency_2050, percapita_Cost_Equity_2050, 
                                                                               Avoided_permillion_deaths_Efficiency_2050, Avoided_permillion_deaths_Equity_2050)
data_Upper_Middle_representative <- data_Upper_Middle %>% filter(`Country Code`== "CHN" | `Country Code`== "ZAF" | `Country Code`== "BLR" |
                                                                   `Country Code`== "MEX" | `Country Code`== "BRA" | `Country Code`== "MYS" )
data_long <- data_Upper_Middle_representative %>%
  pivot_longer(
    cols = c("percapita_Cost_Efficiency_2050","percapita_Cost_Equity_2050","Avoided_permillion_deaths_Efficiency_2050","Avoided_permillion_deaths_Equity_2050"),
    names_to = c("Metric", "Scenario"),
    names_pattern = "(percapita_Cost|Avoided_permillion_deaths)_(.*)_2050",
    values_to = "Value"
  ) %>%
  pivot_wider(
    names_from = Metric,
    values_from = Value
  )
Fig.Upper_Middle <- ggplot(data_long) +
  geom_segment(
    data = data_long %>% tidyr::pivot_wider(names_from = Scenario, values_from = c(percapita_Cost, Avoided_permillion_deaths)),
    aes(
      x = Avoided_permillion_deaths_Efficiency,
      y = percapita_Cost_Efficiency,
      xend = Avoided_permillion_deaths_Equity,
      yend = percapita_Cost_Equity,
      color = Country
    ),
    arrow = arrow(type = "closed", length = unit(0.1, "inches")), linewidth = 1.5
  ) +
  scale_y_continuous(limits = c(0, 700), breaks=seq(0, 700, 100), expand = expansion(0)) +
  scale_x_continuous(limits = c(0, 155), breaks=seq(0, 150, 50), expand = expansion(0)) +
  theme_bw() +
  theme(
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size = 28),
    panel.background = element_blank(),
    plot.margin = margin(t = 20, r = 30, b = 30, l = 30, unit = "pt"),
    axis.text.x = element_text(color = "black", size = 28, margin = margin(t = 15, unit = "pt")),
    axis.text.y = element_text(color = "black", size = 28, margin = margin(r = 15, unit = "pt")),
    axis.title.y = element_text(size = 28, margin = margin(r = 15, unit = "pt")),
    axis.title.x = element_text(size = 28, margin = margin(t = 15, unit = "pt"))) +
  labs(
    x = "Avoided deaths in 2050 \n (per million)",
    y = "Mitigation cost in 2050 \n (2022US$ per capita)"
  )
print(Fig.Upper_Middle)

########################################################  


########################################################  Figure 5 NPV maps ########################################################  

barplotdata <- data.frame(
  InequalityAversion = c(0.4, 0.9, 1.9, 2.4),
  WeightedNPVChange = c(-38.5, -11.1, 8.1, 10.5)
)
barplotdata.2 <- data.frame(
  InequalityAversion = c(1.4),
  WeightedNPVChange = c(2.0)
)
barplotdata_AQ <- data.frame(
  InequalityAversion = c(0.6, 1.1, 2.1, 2.6),
  WeightedNPVChange = c(-27.8, -0.4, 15.3, 15.1)
)
barplotdata.2_AQ <- data.frame(
  InequalityAversion = c(1.6),
  WeightedNPVChange = c(11.7)
)

Figure_bar <- ggplot() +
  geom_bar(data = barplotdata, aes(x = InequalityAversion, y = WeightedNPVChange), 
           stat = "identity", color = "black", fill = "yellowgreen", width = 0.2,) + 
  geom_bar(data = barplotdata.2, aes(x = InequalityAversion, y = WeightedNPVChange), 
           stat = "identity", fill = "red", width = 0.2) + 
  geom_bar_pattern(data = barplotdata_AQ, aes(x = InequalityAversion, y = WeightedNPVChange), 
           stat = "identity", color = "black", fill = "yellowgreen", width = 0.2, 
           pattern = "stripe", pattern_fill = "#3c3c3c", pattern_color = "yellowgreen", pattern_spacing = 0.02, pattern_size = 0.005) + 
  geom_bar_pattern(data = barplotdata.2_AQ, aes(x = InequalityAversion, y = WeightedNPVChange), 
           stat = "identity", color = "black", fill = "red", width = 0.2,
           pattern = "stripe", pattern_fill = "#3c3c3c", pattern_color = "red", pattern_spacing = 0.02, pattern_size = 0.005) + 
  geom_hline(yintercept = 0, color = "black") +        
  labs(
    x = "Inequality aversion",                        
    y = "Change in weighted NPV",                   
    title = ""                                        
  ) +
  scale_y_continuous(limits = c(-45, 20), breaks=seq(-40, 20, 10), labels = scales::label_percent(scale = 1), expand = expansion(0)) + 
  scale_x_continuous(limits = c(0.2, 2.8), breaks=seq(0.5, 2.5, 0.5), expand = expansion(0)) + 
  theme_bw() +
  theme(
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size = 24),
    panel.background = element_blank(),
    plot.margin = margin(t = 20, r = 30, b = 30, l = 30, unit = "pt"),
    axis.text.x = element_text(color = "black", size = 24, margin = margin(t = 15, unit = "pt")),
    axis.text.y = element_text(color = "black", size = 24, margin = margin(r = 15, unit = "pt")),
    axis.title.y = element_text(size = 24, margin = margin(r = 15, unit = "pt")),
    axis.title.x = element_text(size = 24, margin = margin(r = 20, unit = "pt"))) +
  annotate("text", x = 0.8, y = 18, label = "Positive % values indicate greater benefits", hjust = 0, size = 7, color = "grey40") +
  annotate("text", x = 0.3, y = -40, label = "Less concern for inequality", hjust = 0, size = 6, color = "darkorange") +
  annotate("text", x = 2.7, y = -40, label = "More concern for inequality", hjust = 1, size = 6, color = "blue") +
  annotate("segment", x = 0.25, xend = 2.75, y = -42.5, yend = -42.5, arrow = arrow(length = unit(0.2, "cm")), size = 1, color = "black") +
  annotate("segment", x = 2.75, xend = 0.25, y = -42.5, yend = -42.5, arrow = arrow(length = unit(0.2, "cm")), size = 1, color = "black")
print(Figure_bar)


countries <- st_read("Health Impact Assessment/World_Countries/World_Countries_Generalized.shp")
geo_info <- read_csv("Health Impact Assessment/PM/pm25_by_country.csv")
geo_info <- geo_info %>% dplyr::select(AFF_ISO,ISO)

NPV <- read_csv("Figures1-3,5/percent Change by Country.csv")
NPV.2 <- NPV %>% left_join(geo_info, by = "ISO")

world_NPV <- countries %>% left_join(NPV.2, by = "AFF_ISO")

world_NPV_eta_1.5 <- world_NPV %>%
  mutate(
    color_group = case_when(
      PercentChange_eta_1.5 < -100 ~ "< -100%",
      PercentChange_eta_1.5 >= -100 & PercentChange_eta_1.5 < -25 ~ "-100% ~ -25%",
      PercentChange_eta_1.5 >= -25 & PercentChange_eta_1.5 < 0 ~ "-25% ~ 0%",
      PercentChange_eta_1.5 >= 0 & PercentChange_eta_1.5 < 25 ~ "0% ~ 25%",
      PercentChange_eta_1.5 >= 25 & PercentChange_eta_1.5 <= 100 ~ "25% ~ 100%",
      PercentChange_eta_1.5 > 100 ~ "> 100%"
    )
  )
Fig_world_NPV_eta_1.5 <- ggplot(data = world_NPV_eta_1.5) +
  geom_sf(aes(fill = color_group)) +  
  scale_fill_manual(
    values = c(
      "< -100%" = "brown",
      "-100% ~ -25%" = "#ff7b00",
      "-25% ~ 0%" = "#ffb76b",
      "0% ~ 25%" = "#90e0ef",
      "25% ~ 100%" = "#0077b6",
      "> 100%" = "darkblue"
    ),
    breaks = c("> 100%", "25% ~ 100%", "0% ~ 25%", "-25% ~ 0%", "-100% ~ -25%", "< -100%"),
    labels = c("> 100%", "25% ~ 100%", "0% ~ 25%", "-25% ~ 0%", "-100% ~ -25%", "< -100%"),
    na.value = NA  
  ) +
  coord_sf(crs = "+proj=moll") +
  labs(title = "Least-cost to Equity", fill = "Percent Change") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 24, face = "bold"),
    legend.title = element_text(size = 20),
    legend.text = element_text(size = 18),
    legend.key.height = unit(1.2, "cm"),
    legend.key.width = unit(0.8, "cm")
  )
print(Fig_world_NPV_eta_1.5)


world_NPV_eta_1.5_AQ <- world_NPV %>%
  mutate(
    color_group = case_when(
      PercentChange_eta_1.5_AQ < -100 ~ "< -100%",
      PercentChange_eta_1.5_AQ >= -100 & PercentChange_eta_1.5_AQ < -25 ~ "-100% ~ -25%",
      PercentChange_eta_1.5_AQ >= -25 & PercentChange_eta_1.5_AQ < 0 ~ "-25% ~ 0%",
      PercentChange_eta_1.5_AQ >= 0 & PercentChange_eta_1.5_AQ < 25 ~ "0% ~ 25%",
      PercentChange_eta_1.5_AQ >= 25 & PercentChange_eta_1.5_AQ <= 100 ~ "25% ~ 100%",
      PercentChange_eta_1.5_AQ > 100 ~ "> 100%"
    )
  )
Fig_world_NPV_eta_1.5_AQ <- ggplot(data = world_NPV_eta_1.5_AQ) +
  geom_sf(aes(fill = color_group)) + 
  scale_fill_manual(
    values = c(
      "< -100%" = "brown",
      "-100% ~ -25%" = "#ff7b00",
      "-25% ~ 0%" = "#ffb76b",
      "0% ~ 25%" = "#90e0ef",
      "25% ~ 100%" = "#0077b6",
      "> 100%" = "darkblue"
    ),
    breaks = c("> 100%", "25% ~ 100%", "0% ~ 25%", "-25% ~ 0%", "-100% ~ -25%", "< -100%"),
    labels = c("> 100%", "25% ~ 100%", "0% ~ 25%", "-25% ~ 0%", "-100% ~ -25%", "< -100%"),
    na.value = NA  
  ) +
  coord_sf(crs = "+proj=moll") +
  labs(title = "Least-cost to Equity+AQ", fill = "Percent Change") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 24, face = "bold"),
    legend.title = element_text(size = 20),
    legend.text = element_text(size = 18),
    legend.key.height = unit(1.2, "cm"),
    legend.key.width = unit(0.8, "cm")
  )
print(Fig_world_NPV_eta_1.5_AQ)


########################################################  