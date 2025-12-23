library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(tidyverse)
library(stringr)

setwd("D:/08 GCAM/global-project output database/Mitigation cost/")


######### Export data from database

library(rgcam)

## non CO2 by region 
for (one in c("cost","Impact","Welfare")){
  for (two in c("20constraint","30constraint","40constraint","50constraint","60constraint","70constraint","80constraint","90constraint")) {
    name <- paste0(one,"_",two)
    ## retrieve data from database
    conn <- localDBConn('/glade/work/jshiwang/GCAM/gcam-core-gcam-v7.0/output/',name)  # database route
    prj <- addScenario(conn, '/glade/work/jshiwang/GCAM/gcam-core-gcam-v7.0/output/mitigation_cost_Lancet/test_temp_nonCO2.dat', name, # temporary store 
                       '/glade/work/jshiwang/GCAM/gcam-core-gcam-v7.0/output/mitigation_cost_Lancet/mitigation_cost.xml') # query XML file route
    prj <- loadProject('/glade/work/jshiwang/GCAM/gcam-core-gcam-v7.0/output/mitigation_cost_Lancet/test_temp_nonCO2.dat')
    scenarios <- listScenarios(prj)
    queries <- listQueries(prj, name)
    CO2_price <- getQuery(prj, 'CO2 prices')  # query name
    CO2_emission <- getQuery(prj, 'CO2 emissions by region')  # query name
  }
}

write.csv(CO2_price,"/glade/work/jshiwang/GCAM/gcam-core-gcam-v7.0/output/mitigation_cost_Lancet/CO2_price.csv")
write.csv(CO2_emission,"/glade/work/jshiwang/GCAM/gcam-core-gcam-v7.0/output/mitigation_cost_Lancet/CO2_emission.csv")

######### Clean and Select data 

carbon_price <- read_csv("CO2_price.csv")
carbon_price <- subset(carbon_price, !grepl("FUG", market))
carbon_price <- subset(carbon_price, !grepl("LUC", market))
carbon_price <- subset(carbon_price, !grepl("TOTAL", market))

carbon_price <- carbon_price %>% filter(year==2030 | year==2050 |year==2100) %>%
  dplyr::select(scenario,`market`,`year`,`value`)
carbon_price.2 <- pivot_wider(carbon_price, names_from = year, values_from = value)

carbon_price_original <- read_xlsx("mitigationcost_original.xlsx", sheet = 1)
carbon_price_original <- carbon_price_original %>% dplyr::select(scenario,`market`,`2030`,`2050`,`2100`)
carbon_price_original <- subset(carbon_price_original, !grepl("FUG", market))
carbon_price_original <- subset(carbon_price_original, !grepl("LUC", market))
carbon_price_original <- subset(carbon_price_original, !grepl("TOTAL", market))

carbon_price_all <- rbind(carbon_price_original,carbon_price.2)

data_long <- pivot_longer(carbon_price_all, cols = c('2030', '2050', '2100'), names_to = 'year', values_to = 'value')
data_long$year_scenario <- paste(data_long$year, data_long$scenario, sep = "_")
data_long <- data_long %>% dplyr::select(year_scenario, market, value)
carbon_price_all.2 <- pivot_wider(data_long, names_from = year_scenario, values_from = value)
region_column <- carbon_price_all.2$market
carbon_price_all.3 <- carbon_price_all.2[, -which(names(carbon_price_all.2) == "market")]
carbon_price_all.3 <- carbon_price_all.3 %>% dplyr::select(order(colnames(carbon_price_all.3)))
carbon_price_all.3 <- cbind(region = region_column, carbon_price_all.3)
write_csv(carbon_price_all.3,"carbon_price_all.csv")


CO2_original <- read_xlsx("mitigationcost_original.xlsx", sheet = 2)
CO2_original <- CO2_original %>% dplyr::select(scenario,`region`,`2030`,`2050`, `2100`)

CO2 <- read_csv("CO2_emission.csv")
CO2 <- CO2 %>% filter(year==2030 | year==2050 |year==2100) %>%
  dplyr::select(scenario,`region`,`year`,`value`)
CO2.2 <- pivot_wider(CO2, names_from = year, values_from = value)

CO2_all <- rbind(CO2_original,CO2.2)

data_long <- pivot_longer(CO2_all, cols = c('2030', '2050', '2100'), names_to = 'year', values_to = 'value')
data_long$year_scenario <- paste(data_long$year, data_long$scenario, sep = "_")
data_long <- data_long %>% dplyr::select(year_scenario, region, value)
CO2_all.2 <- pivot_wider(data_long, names_from = year_scenario, values_from = value)

region_column <- CO2_all.2$region
CO2_all.3 <- CO2_all.2[, -which(names(CO2_all.2) == "region")]
CO2_all.3 <- CO2_all.3 %>% dplyr::select(order(colnames(CO2_all.3)))
CO2_all.3 <- cbind(region = region_column, CO2_all.3)
write_csv(CO2_all.3,"CO2_all.csv")


######### Calculate mitigation cost 

CO2 <- read_csv("CO2_all.csv")
price <- read_csv("carbon_price_all.csv")
mitigation_cost <- CO2[,1]

CO2_Cost_2030 <- CO2 %>% dplyr::select(`region`,`2030_Reference`, `2030_cost_30constraint`, `2030_cost_70constraint`,`2030_Cost`)
r1 <- CO2_Cost_2030$`2030_Reference` - CO2_Cost_2030$`2030_cost_30constraint`
r2 <- CO2_Cost_2030$`2030_Reference` - CO2_Cost_2030$`2030_cost_70constraint`
r3 <- CO2_Cost_2030$`2030_Reference` - CO2_Cost_2030$`2030_Cost`
Price_Cost_2030 <- price %>% dplyr::select(`region`,`2030_cost_30constraint`, `2030_cost_70constraint`,`2030_Cost`)
cols <- c("2030_cost_30constraint", "2030_cost_70constraint", "2030_Cost") 
Price_Cost_2030[cols] <- lapply(Price_Cost_2030[cols], function(x) x[1])
Price_Cost_2030 <- Price_Cost_2030[-1,]
t1 <- Price_Cost_2030$`2030_cost_30constraint`
t2 <- Price_Cost_2030$`2030_cost_70constraint`
t3 <- Price_Cost_2030$`2030_Cost`
mitigation_cost$Efficiency2030 <- mapply(function(r1, r2, r3, t1, t2, t3) {
  if (r3 < 0) {
    return(0)
  } else if (r2 < 0 | r1 < 0 | r2 < r1 | r3 < r1 | r3 < r2) {
    return(0.5 * r3 * t3)
  } else {
    return(0.5 * (r1 * t1 + (r2 - r1) * (t1 + t2) + (r3 - r2) * (t2 + t3)))
  }
}, r1, r2, r3, t1, t2, t3)

CO2_Cost_2050 <- CO2 %>% dplyr::select(`region`,`2050_Reference`, `2050_cost_30constraint`, `2050_cost_70constraint`,`2050_Cost`)
r1 <- CO2_Cost_2050$`2050_Reference` - CO2_Cost_2050$`2050_cost_30constraint`
r2 <- CO2_Cost_2050$`2050_Reference` - CO2_Cost_2050$`2050_cost_70constraint`
r3 <- CO2_Cost_2050$`2050_Reference` - CO2_Cost_2050$`2050_Cost`
Price_Cost_2050 <- price %>% dplyr::select(`region`,`2050_cost_30constraint`, `2050_cost_70constraint`,`2050_Cost`)
cols <- c("2050_cost_30constraint", "2050_cost_70constraint", "2050_Cost") 
Price_Cost_2050[cols] <- lapply(Price_Cost_2050[cols], function(x) x[1])
Price_Cost_2050 <- Price_Cost_2050[-1,]
t1 <- Price_Cost_2050$`2050_cost_30constraint`
t2 <- Price_Cost_2050$`2050_cost_70constraint`
t3 <- Price_Cost_2050$`2050_Cost`
mitigation_cost$Efficiency2050 <- mapply(function(r1, r2, r3, t1, t2, t3) {
  if (r3 < 0) {
    return(0)
  } else if (r2 < 0 | r1 < 0 | r2 < r1 | r3 < r1 | r3 < r2) {
    return(0.5 * r3 * t3)
  } else {
    return(0.5 * (r1 * t1 + (r2 - r1) * (t1 + t2) + (r3 - r2) * (t2 + t3)))
  }
}, r1, r2, r3, t1, t2, t3)

CO2_Cost_2100 <- CO2 %>% dplyr::select(`region`,`2100_Reference`, `2100_cost_30constraint`, `2100_cost_70constraint`,`2100_Cost`)
r1 <- CO2_Cost_2100$`2100_Reference` - CO2_Cost_2100$`2100_cost_30constraint`
r2 <- CO2_Cost_2100$`2100_Reference` - CO2_Cost_2100$`2100_cost_70constraint`
r3 <- CO2_Cost_2100$`2100_Reference` - CO2_Cost_2100$`2100_Cost`
Price_Cost_2100 <- price %>% dplyr::select(`region`,`2100_cost_30constraint`, `2100_cost_70constraint`,`2100_Cost`)
cols <- c("2100_cost_30constraint", "2100_cost_70constraint", "2100_Cost") 
Price_Cost_2100[cols] <- lapply(Price_Cost_2100[cols], function(x) x[1])
Price_Cost_2100 <- Price_Cost_2100[-1,]
t1 <- Price_Cost_2100$`2100_cost_30constraint`
t2 <- Price_Cost_2100$`2100_cost_70constraint`
t3 <- Price_Cost_2100$`2100_Cost`
mitigation_cost$Efficiency2100 <- mapply(function(r1, r2, r3, t1, t2, t3) {
  if (r3 < 0) {
    return(0)
  } else if (r2 < 0 | r1 < 0 | r2 < r1 | r3 < r1 | r3 < r2) {
    return(0.5 * r3 * t3)
  } else {
    return(0.5 * (r1 * t1 + (r2 - r1) * (t1 + t2) + (r3 - r2) * (t2 + t3)))
  }
}, r1, r2, r3, t1, t2, t3)


CO2_Welfare_2030 <- CO2 %>% dplyr::select(`region`,`2030_Reference`, `2030_Welfare_30constraint`, `2030_Welfare_70constraint`,`2030_Welfare`)
r1 <- CO2_Welfare_2030$`2030_Reference` - CO2_Welfare_2030$`2030_Welfare_30constraint`
r2 <- CO2_Welfare_2030$`2030_Reference` - CO2_Welfare_2030$`2030_Welfare_70constraint`
r3 <- CO2_Welfare_2030$`2030_Reference` - CO2_Welfare_2030$`2030_Welfare`
Price_Welfare_2030 <- price %>% dplyr::select(`region`,`2030_Welfare_30constraint`, `2030_Welfare_70constraint`,`2030_Welfare`)
Price_Welfare_2030 <- Price_Welfare_2030[-1,]
t1 <- Price_Welfare_2030$`2030_Welfare_30constraint`
t2 <- Price_Welfare_2030$`2030_Welfare_70constraint`
t3 <- Price_Welfare_2030$`2030_Welfare`
mitigation_cost$Equity2030 <- mapply(function(r1, r2, r3, t1, t2, t3) {
  if (r3 < 0) {
    return(0)
  } else if (r2 < 0 | r1 < 0 | r2 < r1 | r3 < r1 | r3 < r2) {
    return(0.5 * r3 * t3)
  } else {
    return(0.5 * (r1 * t1 + (r2 - r1) * (t1 + t2) + (r3 - r2) * (t2 + t3)))
  }
}, r1, r2, r3, t1, t2, t3)

CO2_Welfare_2050 <- CO2 %>% dplyr::select(`region`,`2050_Reference`, `2050_Welfare_30constraint`, `2050_Welfare_70constraint`,`2050_Welfare`)
r1 <- CO2_Welfare_2050$`2050_Reference` - CO2_Welfare_2050$`2050_Welfare_30constraint`
r2 <- CO2_Welfare_2050$`2050_Reference` - CO2_Welfare_2050$`2050_Welfare_70constraint`
r3 <- CO2_Welfare_2050$`2050_Reference` - CO2_Welfare_2050$`2050_Welfare`
Price_Welfare_2050 <- price %>% dplyr::select(`region`,`2050_Welfare_30constraint`, `2050_Welfare_70constraint`,`2050_Welfare`)
Price_Welfare_2050 <- Price_Welfare_2050[-1,]
t1 <- Price_Welfare_2050$`2050_Welfare_30constraint`
t2 <- Price_Welfare_2050$`2050_Welfare_70constraint`
t3 <- Price_Welfare_2050$`2050_Welfare`
mitigation_cost$Equity2050 <- mapply(function(r1, r2, r3, t1, t2, t3) {
  if (r3 < 0) {
    return(0)
  } else if (r2 < 0 | r1 < 0 | r2 < r1 | r3 < r1 | r3 < r2) {
    return(0.5 * r3 * t3)
  } else {
    return(0.5 * (r1 * t1 + (r2 - r1) * (t1 + t2) + (r3 - r2) * (t2 + t3)))
  }
}, r1, r2, r3, t1, t2, t3)

CO2_Welfare_2100 <- CO2 %>% dplyr::select(`region`,`2100_Reference`, `2100_Welfare_30constraint`, `2100_Welfare_70constraint`,`2100_Welfare`)
r1 <- CO2_Welfare_2100$`2100_Reference` - CO2_Welfare_2100$`2100_Welfare_30constraint`
r2 <- CO2_Welfare_2100$`2100_Reference` - CO2_Welfare_2100$`2100_Welfare_70constraint`
r3 <- CO2_Welfare_2100$`2100_Reference` - CO2_Welfare_2100$`2100_Welfare`
Price_Welfare_2100 <- price %>% dplyr::select(`region`,`2100_Welfare_30constraint`, `2100_Welfare_70constraint`,`2100_Welfare`)
Price_Welfare_2100 <- Price_Welfare_2100[-1,]
t1 <- Price_Welfare_2100$`2100_Welfare_30constraint`
t2 <- Price_Welfare_2100$`2100_Welfare_70constraint`
t3 <- Price_Welfare_2100$`2100_Welfare`
mitigation_cost$Equity2100 <- mapply(function(r1, r2, r3, t1, t2, t3) {
  if (r3 < 0) {
    return(0)
  } else if (r2 < 0 | r1 < 0 | r2 < r1 | r3 < r1 | r3 < r2) {
    return(0.5 * r3 * t3)
  } else {
    return(0.5 * (r1 * t1 + (r2 - r1) * (t1 + t2) + (r3 - r2) * (t2 + t3)))
  }
}, r1, r2, r3, t1, t2, t3)


######### Downscale to country level

GDP_2022 <- read_csv("GDP_matching.csv")    #### GDP 2022 : https://databank.worldbank.org/reports.aspx?source=2&series=NY.GDP.MKTP.CD&country=#

mitigationcost_country <- GDP_2022 %>% full_join(mitigation_cost, by = c("GCAMRegion" = "region"))

GDP_GCAM_projection <- read_csv("GDP_GCAM_projection.csv")
mitigation_cost$GDP2030 <- GDP_GCAM_projection$`2030`
mitigation_cost$GDP2050 <- GDP_GCAM_projection$`2050`
mitigation_cost$GDP2100 <- GDP_GCAM_projection$`2100`

taiwan_data <- mitigationcost_country %>% filter(GCAMRegion == "Taiwan") # Group Taiwan data to China
china_data <- mitigationcost_country %>% filter(GCAMRegion == "China")
if(nrow(taiwan_data) > 0){
  mitigationcost_country <- mitigationcost_country %>%
    mutate(across(6:14, ~ ifelse(GCAMRegion == "China", . + taiwan_data[[cur_column()]], .)))
  mitigationcost_country <- mitigationcost_country %>% filter(GCAMRegion != "Taiwan")
}
mitigationcost_country <- mitigationcost_country %>%      # Calculate the GDP proportion of each country relative to its GCAM region
  group_by(GCAMRegion) %>%
  mutate(factor = `2022 [YR2022]` / sum(`2022 [YR2022]`)) %>%
  ungroup()

mitigationcost_country[,6:14] <- mitigationcost_country[,6:14]*mitigationcost_country$factor
mitigationcost_country[,6:14] <- mitigationcost_country[,6:14]*2.24  ### trasfer 1990 US dollar to 2022 level

mitigationcost_country[, 6:14] <- lapply(mitigationcost_country[, 6:14], function(x) {
  x <- round(x, 0)    
  x <- ifelse(x < 0, 0, x)  
  return(x)
})
colnames(mitigationcost_country)[6:14] <- paste0("MitigationCost_", colnames(mitigationcost_country)[6:14]," (2022millionUS$)")
colnames(mitigationcost_country)[12:14] <- paste0(colnames(mitigationcost_country)[12:14]," (2022millionUS$)")

write_csv(mitigationcost_country,"mitigationcost.csv")

############

