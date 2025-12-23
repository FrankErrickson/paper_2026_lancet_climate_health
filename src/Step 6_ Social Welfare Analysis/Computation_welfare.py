# -*- coding: utf-8 -*-
"""
Created on Mon Nov  4 06:54:04 2024

@author: ferranna
"""

import numpy as np
import pandas as pd


def get_data(scenario):
    if scenario=="reference_mean":
        damages_energy = pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/give_energy_REFERENCE_mean.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/give_agriculture_REFERENCE_mean.csv').set_index('time')
        mitigation = 0
        ccdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/give_excess_deaths_REFERENCE_mean.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/gcam_deaths_REFERENCE_mean.csv').set_index('time')
    
    elif scenario=="reference_5th":
        damages_energy = pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/give_energy_REFERENCE_5th.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/give_agriculture_REFERENCE_5th.csv').set_index('time')
        mitigation = 0
        ccdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/give_excess_deaths_REFERENCE_5th.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/gcam_deaths_REFERENCE_5th.csv').set_index('time')
            
    elif scenario=="reference_95th":
        damages_energy = pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/give_energy_REFERENCE_95th.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/give_agriculture_REFERENCE_95th.csv').set_index('time')
        mitigation = 0
        ccdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/give_excess_deaths_REFERENCE_95th.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/reference_scenario/gcam_deaths_REFERENCE_95th.csv').set_index('time')
       
    
    elif scenario=="impacts":
        damages_energy = pd.read_csv('data_for_swf_analysis/impacts_scenario/give_energy_IMPACTS.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis/impacts_scenario/give_agriculture_IMPACTS.csv').set_index('time')
        mitigation=pd.read_csv('data_for_swf_analysis/impacts_scenario/gcam_mitigation_costs_IMPACTS.csv').set_index('Year')
        ccdeaths=pd.read_csv('data_for_swf_analysis/impacts_scenario/give_excess_deaths_IMPACTS.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis/impacts_scenario/gcam_deaths_IMPACTS.csv').set_index('Year')
        
        
    elif scenario=="efficiency_mean":
        damages_energy = pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/give_energy_EFFICIENCY_mean.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/give_agriculture_EFFICIENCY_mean.csv').set_index('time')
        mitigation=pd.read_csv('data_for_swf_analysis/efficiency_scenario/gcam_mitigation_costs_EFFICIENCY.csv').set_index('Year')
        ccdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/give_excess_deaths_EFFICIENCY_mean.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/gcam_deaths_EFFICIENCY_mean.csv').set_index('time')
    
    elif scenario=="efficiency_5th":
        damages_energy = pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/give_energy_EFFICIENCY_5th.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/give_agriculture_EFFICIENCY_5th.csv').set_index('time')
        mitigation=pd.read_csv('data_for_swf_analysis/efficiency_scenario/gcam_mitigation_costs_EFFICIENCY.csv').set_index('Year')
        ccdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/give_excess_deaths_EFFICIENCY_5th.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/gcam_deaths_EFFICIENCY_5th.csv').set_index('time')
     
    elif scenario=="efficiency_95th":
        damages_energy = pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/give_energy_EFFICIENCY_95th.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/give_agriculture_EFFICIENCY_95th.csv').set_index('time')
        mitigation=pd.read_csv('data_for_swf_analysis/efficiency_scenario/gcam_mitigation_costs_EFFICIENCY.csv').set_index('Year')
        ccdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/give_excess_deaths_EFFICIENCY_95th.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/efficiency_scenario/gcam_deaths_EFFICIENCY_95th.csv').set_index('time')
       
    elif scenario=="equity_mean":
        damages_energy = pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/give_energy_EQUITY_mean.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/give_agriculture_EQUITY_mean.csv').set_index('time')
        mitigation=pd.read_csv('data_for_swf_analysis/equity_scenario/gcam_mitigation_costs_EQUITY.csv').set_index('Year')
        ccdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/give_excess_deaths_EQUITY_mean.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/gcam_deaths_EQUITY_mean.csv').set_index('time')
    
    elif scenario=="equity_5th":
        damages_energy = pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/give_energy_EQUITY_5th.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/give_agriculture_EQUITY_5th.csv').set_index('time')
        mitigation=pd.read_csv('data_for_swf_analysis/equity_scenario/gcam_mitigation_costs_EQUITY.csv').set_index('Year')
        ccdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/give_excess_deaths_EQUITY_5th.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/gcam_deaths_EQUITY_5th.csv').set_index('time')
    
    elif scenario=="equity_95th":
        damages_energy = pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/give_energy_EQUITY_95th.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/give_agriculture_EQUITY_95th.csv').set_index('time')
        mitigation=pd.read_csv('data_for_swf_analysis/equity_scenario/gcam_mitigation_costs_EQUITY.csv').set_index('Year')
        ccdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/give_excess_deaths_EQUITY_95th.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis_uncertainty/equity_scenario/gcam_deaths_EQUITY_95th.csv').set_index('time')
    
    
    else:
        damages_energy = pd.read_csv('data_for_swf_analysis/equity_scenario/give_energy_EQUITY.csv').set_index('time')
        damages_agriculture = pd.read_csv('data_for_swf_analysis/equity_scenario/give_agriculture_EQUITY.csv').set_index('time')
        mitigation=pd.read_csv('data_for_swf_analysis/equity_scenario/gcam_mitigation_costs_EQUITY.csv').set_index('Year')
        ccdeaths=pd.read_csv('data_for_swf_analysis/equity_scenario/give_excess_deaths_EQUITY.csv').set_index('time')
        airdeaths=pd.read_csv('data_for_swf_analysis/equity_scenario/gcam_deaths_EQUITY.csv').set_index('Year')
    
    return damages_energy,damages_agriculture,mitigation,ccdeaths,airdeaths


#Total GDP in millions
gdp=pd.read_csv('data_for_swf_analysis/gcam_gdp.csv').set_index('Year')

#Population in millions:
pop=pd.read_csv('data_for_swf_analysis/gcam_population.csv').set_index('Year')

#GDP per capita
gdp_pc=gdp/pop


#Country income groups:
income_groups=pd.read_csv('data_for_swf_analysis/gcam_country_income_groups.csv')

low_income=income_groups[income_groups["Country Income Classification"] == "Low"]["Country Code"].values
lower_middle_income=income_groups[income_groups["Country Income Classification"] == "Lower_Middle"]["Country Code"].values
upper_middle_income=income_groups[income_groups["Country Income Classification"] == "Upper_Middle"]["Country Code"].values
high_income=income_groups[income_groups["Country Income Classification"] == "High"]["Country Code"].values


##### Compute VSL
#VSL
#alpha: VSL reference/income reference
#el: elasticity of VSL to income
#y0: income reference
def VSL(alpha,el,y0,y):
    vsl=(alpha*(y/y0)**(el-1)*y)/1000000
    return vsl

gdp_US=gdp_pc["USA"].loc[2030]
vsl=VSL(alpha=160,el=1,y0=gdp_US,y=gdp_pc)  #(VSL in million)

###### Costs and benefits compared to reference scenario (in million)

mean=["efficiency_mean","equity_mean"]
fifth=["efficiency_5th","equity_5th"]
nfifth=["efficiency_95th","equity_95th"]

def outcomes(scenario):
    mitigation=get_data(scenario)[2]
    
    if scenario in mean:
        damages=(get_data("reference_mean")[0]+get_data("reference_mean")[1])-\
            (get_data(scenario)[0]+get_data(scenario)[1])
        ccdeaths=vsl*(get_data("reference_mean")[3]-get_data(scenario)[3])     
        airdeaths=vsl*(get_data("reference_mean")[4]-get_data(scenario)[4])     
        
        tot_deaths=(get_data("reference_mean")[4]-get_data(scenario)[4])+(get_data("reference_mean")[3]-get_data(scenario)[3])
        ccd=(get_data("reference_mean")[3]-get_data(scenario)[3])
        aird=(get_data("reference_mean")[4]-get_data(scenario)[4])
    
    elif scenario in fifth:
        damages=(get_data("reference_5th")[0]+get_data("reference_5th")[1])-\
            (get_data(scenario)[0]+get_data(scenario)[1])
        ccdeaths=vsl*(get_data("reference_5th")[3]-get_data(scenario)[3])     
        airdeaths=vsl*(get_data("reference_5th")[4]-get_data(scenario)[4])     
        
        tot_deaths=(get_data("reference_5th")[4]-get_data(scenario)[4])+(get_data("reference_5th")[3]-get_data(scenario)[3])
        ccd=(get_data("reference_5th")[3]-get_data(scenario)[3])
        aird=(get_data("reference_5th")[4]-get_data(scenario)[4])
    
    else:
        damages=(get_data("reference_95th")[0]+get_data("reference_95th")[1])-\
            (get_data(scenario)[0]+get_data(scenario)[1])
        ccdeaths=vsl*(get_data("reference_95th")[3]-get_data(scenario)[3])     
        airdeaths=vsl*(get_data("reference_95th")[4]-get_data(scenario)[4])     
        
        tot_deaths=(get_data("reference_95th")[4]-get_data(scenario)[4])+(get_data("reference_95th")[3]-get_data(scenario)[3])
        ccd=(get_data("reference_95th")[3]-get_data(scenario)[3])
        aird=(get_data("reference_95th")[4]-get_data(scenario)[4])
    
    net_benefits=-mitigation+damages+ccdeaths+airdeaths
    
    return mitigation,damages,ccdeaths,airdeaths,net_benefits,tot_deaths,ccd,aird


def outcomes_group(scenario):
    
    m=pd.concat([-np.sum(outcomes(scenario)[0][low_income],1),-np.sum(outcomes(scenario)[0][lower_middle_income],1),\
           -np.sum(outcomes(scenario)[0][upper_middle_income],1),-np.sum(outcomes(scenario)[0][high_income],1)],axis=1)
 
    m.rename(columns={0: "LI",
                            1: "LMI",
                            2: "UMI",
                            3: "HI"},
                   inplace=True)
    
    dam=pd.concat([np.sum(outcomes(scenario)[1][low_income],1),np.sum(outcomes(scenario)[1][lower_middle_income],1),\
           np.sum(outcomes(scenario)[1][upper_middle_income],1),np.sum(outcomes(scenario)[1][high_income],1)],axis=1)
 
    dam.rename(columns={0: "LI",
                            1: "LMI",
                            2: "UMI",
                            3: "HI"},
                   inplace=True)
    
    ccd=pd.concat([np.sum(outcomes(scenario)[2][low_income],1),np.sum(outcomes(scenario)[2][lower_middle_income],1),\
           np.sum(outcomes(scenario)[2][upper_middle_income],1),np.sum(outcomes(scenario)[2][high_income],1)],axis=1)
 
    ccd.rename(columns={0: "LI",
                            1: "LMI",
                            2: "UMI",
                            3: "HI"},
                   inplace=True)
    aird=pd.concat([np.sum(outcomes(scenario)[3][low_income],1),np.sum(outcomes(scenario)[3][lower_middle_income],1),\
           np.sum(outcomes(scenario)[3][upper_middle_income],1),np.sum(outcomes(scenario)[3][high_income],1)],axis=1)
 
    aird.rename(columns={0: "LI",
                            1: "LMI",
                            2: "UMI",
                            3: "HI"},
                   inplace=True)
    
    nb=pd.concat([np.sum(outcomes(scenario)[4][low_income],1),np.sum(outcomes(scenario)[4][lower_middle_income],1),\
           np.sum(outcomes(scenario)[4][upper_middle_income],1),np.sum(outcomes(scenario)[4][high_income],1)],axis=1)
 
    nb.rename(columns={0: "LI",
                            1: "LMI",
                            2: "UMI",
                            3: "HI"},
                   inplace=True)
    
    td=pd.concat([np.sum(outcomes(scenario)[5][low_income],1),np.sum(outcomes(scenario)[5][lower_middle_income],1),\
           np.sum(outcomes(scenario)[5][upper_middle_income],1),np.sum(outcomes(scenario)[5][high_income],1)],axis=1)
 
    td.rename(columns={0: "LI",
                            1: "LMI",
                            2: "UMI",
                            3: "HI"},
                   inplace=True)
    
    v=pd.concat([np.sum(vsl[low_income],axis=1)/len(low_income),np.sum(vsl[lower_middle_income],axis=1)/len(lower_middle_income),\
           np.sum(vsl[upper_middle_income],axis=1)/len(upper_middle_income),np.sum(vsl[high_income],axis=1)/len(high_income)],axis=1)
 
    v.rename(columns={0: "LI",
                            1: "LMI",
                            2: "UMI",
                            3: "HI"},
                   inplace=True)
    
    return m,dam,ccd,aird,nb,td,v

#Save results by income group

outcomes_eq_mean=outcomes_group("equity_mean")
outcomes_eq_mean[0].to_csv('results/equity/mitigation_EQUITY.csv')
outcomes_eq_mean[1].to_csv('results/equity/damages_averted_EQUITY_mean.csv')
outcomes_eq_mean[2].to_csv('results/equity/value_climate_deaths_averted_EQUITY_mean.csv')
outcomes_eq_mean[3].to_csv('results/equity/value_air_deaths_averted_EQUITY_mean.csv')
outcomes_eq_mean[4].to_csv('results/equity/net_benefits_EQUITY_mean.csv')
outcomes_eq_mean[5].to_csv('results/equity/deaths_averted_EQUITY_mean.csv')
#outcomes_eq_mean[6].to_csv('results/vsl.csv')

outcomes_eq_5th=outcomes_group("equity_5th")
outcomes_eq_5th[1].to_csv('results/equity/damages_averted_EQUITY_5th.csv')
outcomes_eq_5th[2].to_csv('results/equity/value_climate_deaths_averted_EQUITY_5th.csv')
outcomes_eq_5th[3].to_csv('results/equity/value_air_deaths_averted_EQUITY_5th.csv')
outcomes_eq_5th[4].to_csv('results/equity/net_benefits_EQUITY_5th.csv')
outcomes_eq_5th[5].to_csv('results/equity/deaths_averted_EQUITY_5th.csv')

outcomes_eq_95th=outcomes_group("equity_95th")
outcomes_eq_95th[1].to_csv('results/equity/damages_averted_EQUITY_95th.csv')
outcomes_eq_95th[2].to_csv('results/equity/value_climate_deaths_averted_EQUITY_95th.csv')
outcomes_eq_95th[3].to_csv('results/equity/value_air_deaths_averted_EQUITY_95th.csv')
outcomes_eq_95th[4].to_csv('results/equity/net_benefits_EQUITY_95th.csv')
outcomes_eq_95th[5].to_csv('results/equity/deaths_averted_EQUITY_95th.csv')



outcomes_eff_mean=outcomes_group("efficiency_mean")
outcomes_eff_mean[0].to_csv('results/efficiency/mitigation_EFFICIENCY.csv')
outcomes_eff_mean[1].to_csv('results/efficiency/damages_averted_EFFICIENCY_mean.csv')
outcomes_eff_mean[2].to_csv('results/efficiency/value_climate_deaths_averted_EFFICIENCY_mean.csv')
outcomes_eff_mean[3].to_csv('results/efficiency/value_air_deaths_averted_EFFICIENCY_mean.csv')
outcomes_eff_mean[4].to_csv('results/efficiency/net_benefits_EFFICIENCY_mean.csv')
outcomes_eff_mean[5].to_csv('results/efficiency/deaths_averted_EFFICIENCY_mean.csv')

outcomes_eff_5th=outcomes_group("efficiency_5th")
outcomes_eff_5th[1].to_csv('results/efficiency/damages_averted_EFFICIENCY_5th.csv')
outcomes_eff_5th[2].to_csv('results/efficiency/value_climate_deaths_averted_EFFICIENCY_5th.csv')
outcomes_eff_5th[3].to_csv('results/efficiency/value_air_deaths_averted_EFFICIENCY_5th.csv')
outcomes_eff_5th[4].to_csv('results/efficiency/net_benefits_EFFICIENCY_5th.csv')
outcomes_eff_5th[5].to_csv('results/efficiency/deaths_averted_EFFICIENCY_5th.csv')

outcomes_eff_95th=outcomes_group("efficiency_95th")
outcomes_eff_95th[1].to_csv('results/efficiency/damages_averted_EFFICIENCY_95th.csv')
outcomes_eff_95th[2].to_csv('results/efficiency/value_climate_deaths_averted_EFFICIENCY_95th.csv')
outcomes_eff_95th[3].to_csv('results/efficiency/value_air_deaths_averted_EFFICIENCY_95th.csv')
outcomes_eff_95th[4].to_csv('results/efficiency/net_benefits_EFFICIENCY_95th.csv')
outcomes_eff_95th[5].to_csv('results/efficiency/deaths_averted_EFFICIENCY_95th.csv')




##############################################################
## Computation of present discounted value (reference year is 2030)

time=np.array(np.arange(0,2101-2030,1))

#discount rate of global per-capita income
def discount_rate(rho,eta):
    r=rho*(time)+eta*np.log(np.sum(gdp,1)/np.sum(gdp.loc[2030]))-\
        eta*np.log(np.sum(pop,1)/np.sum(pop.loc[2030]))
    return r

#equity weight: w*g
def weight(eta):
    g=(np.sum(gdp,1)/np.sum(pop,1))**(eta) 
    w=(gdp_pc)**(-eta)
    return w,g



#equity-weighted net present value by income group:
def NPV_eq(scenario,group,rho,eta): 
    r=discount_rate(rho=rho,eta=eta)
    d=np.exp(-r) #discount factor
    x_ben=weight(eta)[0]*outcomes(scenario)[4] #weighted net benefits, by country and time
    x_mit=weight(eta)[0]*outcomes(scenario)[0] #weighted mitigation costs
    x_dam=weight(eta)[0]*outcomes(scenario)[1] #weighted climate damages
    x_ccd=weight(eta)[0]*outcomes(scenario)[2] #weighted value of cc deaths
    x_aird=weight(eta)[0]*outcomes(scenario)[3] #weighted value of air deaths
    
    if group=="low":
        ben=weight(eta)[1]*np.sum(x_ben[low_income],1) #sum of weighted net benefits in low-income countries
        mit=-weight(eta)[1]*np.sum(x_mit[low_income],1)
        dam=weight(eta)[1]*np.sum(x_dam[low_income],1)
        ccd=weight(eta)[1]*np.sum(x_ccd[low_income],1)
        aird=weight(eta)[1]*np.sum(x_aird[low_income],1)
        
        
    elif group=="lower middle":
        ben=weight(eta)[1]*np.sum(x_ben[lower_middle_income],1)
        mit=-weight(eta)[1]*np.sum(x_mit[lower_middle_income],1)
        dam=weight(eta)[1]*np.sum(x_dam[lower_middle_income],1)
        ccd=weight(eta)[1]*np.sum(x_ccd[lower_middle_income],1)
        aird=weight(eta)[1]*np.sum(x_aird[lower_middle_income],1)
        
        
    elif group=="upper middle":
        ben=weight(eta)[1]*np.sum(x_ben[upper_middle_income],1)
        mit=-weight(eta)[1]*np.sum(x_mit[upper_middle_income],1)
        dam=weight(eta)[1]*np.sum(x_dam[upper_middle_income],1)
        ccd=weight(eta)[1]*np.sum(x_ccd[upper_middle_income],1)
        aird=weight(eta)[1]*np.sum(x_aird[upper_middle_income],1)
        
        
    elif group=="high":
        ben=weight(eta)[1]*np.sum(x_ben[high_income],1)
        mit=-weight(eta)[1]*np.sum(x_mit[high_income],1)
        dam=weight(eta)[1]*np.sum(x_dam[high_income],1)
        ccd=weight(eta)[1]*np.sum(x_ccd[high_income],1)
        aird=weight(eta)[1]*np.sum(x_aird[high_income],1)
        
      
    
    else:
        ben=weight(eta)[1]*np.sum(x_ben,1)
        mit=-weight(eta)[1]*np.sum(x_mit,1)
        dam=weight(eta)[1]*np.sum(x_dam,1)
        ccd=weight(eta)[1]*np.sum(x_ccd,1)
        aird=weight(eta)[1]*np.sum(x_aird,1)
        
        
    npv_ben=np.sum(d*ben)
    npv_mit=np.sum(d*mit)
    npv_dam=np.sum(d*dam)
    npv_ccd=np.sum(d*ccd)
    npv_aird=np.sum(d*aird)
    
    
    return ben,npv_ben,npv_mit,npv_dam,npv_ccd,npv_aird,d,mit,dam,ccd,aird


#Unweighted net present value by income group:
def NPV_(scenario,group,rho,eta):
    r=discount_rate(rho=rho,eta=eta)
    d=np.exp(-r)
    x_ben=outcomes(scenario)[4]
    x_mit=outcomes(scenario)[0]
    x_dam=outcomes(scenario)[1]
    x_ccd=outcomes(scenario)[2]
    x_aird=outcomes(scenario)[3]
    if group=="low":
        ben=np.sum(x_ben[low_income],1)
        npv_ben=np.sum(d*ben)
        npv_mit=-np.sum(d*np.sum(x_mit[low_income],1))
        npv_dam=np.sum(d*np.sum(x_dam[low_income],1))
        npv_ccd=np.sum(d*np.sum(x_ccd[low_income],1))
        npv_aird=np.sum(d*np.sum(x_aird[low_income],1))
    elif group=="lower middle":
        ben=np.sum(x_ben[lower_middle_income],1)
        npv_ben=np.sum(d*ben)
        npv_mit=-np.sum(d*np.sum(x_mit[lower_middle_income],1))
        npv_dam=np.sum(d*np.sum(x_dam[lower_middle_income],1))
        npv_ccd=np.sum(d*np.sum(x_ccd[lower_middle_income],1))
        npv_aird=np.sum(d*np.sum(x_aird[lower_middle_income],1))
    elif group=="upper middle":
        ben=np.sum(x_ben[upper_middle_income],1)
        npv_ben=np.sum(d*ben)
        npv_mit=-np.sum(d*np.sum(x_mit[upper_middle_income],1))
        npv_dam=np.sum(d*np.sum(x_dam[upper_middle_income],1))
        npv_ccd=np.sum(d*np.sum(x_ccd[upper_middle_income],1))
        npv_aird=np.sum(d*np.sum(x_aird[upper_middle_income],1))
    elif group=="high":
        ben=np.sum(x_ben[high_income],1)
        npv_ben=np.sum(d*ben)
        npv_mit=-np.sum(d*np.sum(x_mit[high_income],1))
        npv_dam=np.sum(d*np.sum(x_dam[high_income],1))
        npv_ccd=np.sum(d*np.sum(x_ccd[high_income],1))
        npv_aird=np.sum(d*np.sum(x_aird[high_income],1))
    else:
        ben=np.sum(x_ben,1)
        npv_ben=np.sum(d*ben)
        npv_mit=-np.sum(d*np.sum(x_mit,1))
        npv_dam=np.sum(d*np.sum(x_dam,1))
        npv_ccd=np.sum(d*np.sum(x_ccd,1))
        npv_aird=np.sum(d*np.sum(x_aird,1))
    return ben,npv_ben,npv_mit,npv_dam,npv_ccd,npv_aird



#Unweighted net present value with uniform VSL by income group:
def NPV_uniform(scenario,group,rho,eta):
    r=discount_rate(rho=rho,eta=eta) 
    d=np.exp(-r)
    vsl_u=VSL(alpha=160,el=1,y0=gdp_US,y=np.sum(gdp,1)/np.sum(pop,1))
    x_mit=outcomes(scenario)[0]
    x_dam=outcomes(scenario)[1]
    x_ccd=outcomes(scenario)[6]
    x_aird=outcomes(scenario)[7]
    if group=="low":
        npv_mit=-np.sum(d*np.sum(x_mit[low_income],1))
        npv_dam=np.sum(d*np.sum(x_dam[low_income],1))
        npv_ccd=np.sum(d*vsl_u*np.sum(x_ccd[low_income],1))
        npv_aird=np.sum(d*vsl_u*np.sum(x_aird[low_income],1))
        ben=vsl_u*np.sum(x_aird[low_income],1)+vsl_u*np.sum(x_ccd[low_income],1)+np.sum(x_dam[low_income],1)-np.sum(x_mit[low_income],1)
        npv_ben=np.sum(d*ben)
    elif group=="lower middle":
        npv_mit=-np.sum(d*np.sum(x_mit[lower_middle_income],1))
        npv_dam=np.sum(d*np.sum(x_dam[lower_middle_income],1))
        npv_ccd=np.sum(d*vsl_u*np.sum(x_ccd[lower_middle_income],1))
        npv_aird=np.sum(d*vsl_u*np.sum(x_aird[lower_middle_income],1))
        ben=vsl_u*np.sum(x_aird[lower_middle_income],1)+vsl_u*np.sum(x_ccd[lower_middle_income],1)+np.sum(x_dam[lower_middle_income],1)-np.sum(x_mit[lower_middle_income],1)
        npv_ben=np.sum(d*ben)
    elif group=="upper middle":
        npv_mit=-np.sum(d*np.sum(x_mit[upper_middle_income],1))
        npv_dam=np.sum(d*np.sum(x_dam[upper_middle_income],1))
        npv_ccd=np.sum(d*vsl_u*np.sum(x_ccd[upper_middle_income],1))
        npv_aird=np.sum(d*vsl_u*np.sum(x_aird[upper_middle_income],1))
        ben=vsl_u*np.sum(x_aird[upper_middle_income],1)+vsl_u*np.sum(x_ccd[upper_middle_income],1)+np.sum(x_dam[upper_middle_income],1)-np.sum(x_mit[upper_middle_income],1)
        npv_ben=np.sum(d*ben)
    elif group=="high":
        npv_mit=-np.sum(d*np.sum(x_mit[high_income],1))
        npv_dam=np.sum(d*np.sum(x_dam[high_income],1))
        npv_ccd=np.sum(d*vsl_u*np.sum(x_ccd[high_income],1))
        npv_aird=np.sum(d*vsl_u*np.sum(x_aird[high_income],1))
        ben=vsl_u*np.sum(x_aird[high_income],1)+vsl_u*np.sum(x_ccd[high_income],1)+np.sum(x_dam[high_income],1)-np.sum(x_mit[high_income],1)
        npv_ben=np.sum(d*ben)
    else:        
        npv_mit=-np.sum(d*np.sum(x_mit,1))
        npv_dam=np.sum(d*np.sum(x_dam,1))
        npv_ccd=np.sum(d*vsl_u*np.sum(x_ccd,1))
        npv_aird=np.sum(d*vsl_u*np.sum(x_aird,1))
        ben=vsl_u*np.sum(x_aird,1)+vsl_u*np.sum(x_ccd,1)+np.sum(x_dam,1)-np.sum(x_mit,1)
        npv_ben=np.sum(d*ben)
    return ben,npv_ben,npv_mit,npv_dam,npv_ccd,npv_aird


#NPV by country:
def NPV_country(scenario,rho,eta):
    r=discount_rate(rho=rho,eta=eta)
    d=np.exp(-r) #discount factor
    x_ben=weight(eta)[0]*outcomes(scenario)[4] #weighted net benefits, by country and time
    x_mit=weight(eta)[0]*outcomes(scenario)[0] #weighted mitigation costs, by country and time
    x_air=weight(eta)[0]*outcomes(scenario)[3] #weighted air cobenefits, by country and time
    x_dam=weight(eta)[0]*outcomes(scenario)[1]+weight(eta)[0]*outcomes(scenario)[2] #weighted climate damages, by country and time
    
    func = lambda x: np.asarray(x) * np.asarray(weight(eta)[1]*d)
    B=x_ben.apply(func)
    M=x_mit.apply(func)
    A=x_air.apply(func)
    D=x_dam.apply(func)
       
    npv=np.sum(B,0)
    mit_2050=outcomes(scenario)[0].iloc[20] #mitigation costs in 2050
    co_ben_2050=outcomes(scenario)[3].iloc[20] #health co-benefits in 2050
    x_mit=weight(eta)[0]*outcomes(scenario)[0] #weighted mitigation costs, by country and time 
    x_air=weight(eta)[0]*outcomes(scenario)[3] #weighted health co-benefits, by country and time
    
    npv_mit_2050=np.sum(M.iloc[0:21],0)
    npv_mit=np.sum(M,0)
    npv_air_2050=np.sum(A.iloc[0:21],0)
    npv_air=np.sum(A,0)
    return npv,mit_2050,co_ben_2050,npv_mit_2050,npv_air_2050,npv_mit,npv_air,B,M,A,D


#################################
#Discount factor in benchmark scenario:
year=np.array(np.arange(2030,2101,1))
r=discount_rate(rho=0.01,eta=1.5)
d=np.exp(-r)
d.to_csv('results/discount_factor.csv')

###########################################################
## Discounted net benefits in benchmark scenario, total and by component

#s=NPV_eq("efficiency","tot",0.01,1.5)[1:6]/np.sum(pop.loc[2030])
s_mean=NPV_eq("efficiency_mean","tot",0.01,1.5)[1:6]
s1_mean=NPV_eq("efficiency_mean","low",0.01,1.5)[1:6]
s2_mean=NPV_eq("efficiency_mean","lower middle",0.01,1.5)[1:6]
s3_mean=NPV_eq("efficiency_mean","upper middle",0.01,1.5)[1:6]
s4_mean=NPV_eq("efficiency_mean","high",0.01,1.5)[1:6]


ds_mean=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s_mean,
    "LI": s1_mean,
    "LMI": s2_mean,
    "UMI": s3_mean,
    "HI": s4_mean})

ds_mean.to_csv('results/efficiency/npv_equity_weighted_EFFICIENCY_mean.csv')

s_5th=NPV_eq("efficiency_5th","tot",0.01,1.5)[1:6]
s1_5th=NPV_eq("efficiency_5th","low",0.01,1.5)[1:6]
s2_5th=NPV_eq("efficiency_5th","lower middle",0.01,1.5)[1:6]
s3_5th=NPV_eq("efficiency_5th","upper middle",0.01,1.5)[1:6]
s4_5th=NPV_eq("efficiency_5th","high",0.01,1.5)[1:6]


ds_5th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s_5th,
    "LI": s1_5th,
    "LMI": s2_5th,
    "UMI": s3_5th,
    "HI": s4_5th})

ds_5th.to_csv('results/efficiency/npv_equity_weighted_EFFICIENCY_5th.csv')


s_95th=NPV_eq("efficiency_95th","tot",0.01,1.5)[1:6]
s1_95th=NPV_eq("efficiency_95th","low",0.01,1.5)[1:6]
s2_95th=NPV_eq("efficiency_95th","lower middle",0.01,1.5)[1:6]
s3_95th=NPV_eq("efficiency_95th","upper middle",0.01,1.5)[1:6]
s4_95th=NPV_eq("efficiency_95th","high",0.01,1.5)[1:6]


ds_95th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s_95th,
    "LI": s1_95th,
    "LMI": s2_95th,
    "UMI": s3_95th,
    "HI": s4_95th})

ds_95th.to_csv('results/efficiency/npv_equity_weighted_EFFICIENCY_95th.csv')




#per-capita
s_pc_mean=NPV_eq("efficiency_mean","tot",0.01,1.5)[1:6]/np.sum(pop.loc[2030])
s1_pc_mean=NPV_eq("efficiency_mean","low",0.01,1.5)[1:6]/np.sum(pop[low_income].loc[2030])
s2_pc_mean=NPV_eq("efficiency_mean","lower middle",0.01,1.5)[1:6]/np.sum(pop[lower_middle_income].loc[2030])
s3_pc_mean=NPV_eq("efficiency_mean","upper middle",0.01,1.5)[1:6]/np.sum(pop[upper_middle_income].loc[2030])
s4_pc_mean=NPV_eq("efficiency_mean","high",0.01,1.5)[1:6]/np.sum(pop[high_income].loc[2030])

ds_pc_mean=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s_pc_mean,
    "LI": s1_pc_mean,
    "LMI": s2_pc_mean,
    "UMI": s3_pc_mean,
    "HI": s4_pc_mean})

ds_pc_mean.to_csv('results/efficiency/npv_equity_weighted_EFFICIENCY_pc_mean.csv')

s_pc_5th=NPV_eq("efficiency_5th","tot",0.01,1.5)[1:6]/np.sum(pop.loc[2030])
s1_pc_5th=NPV_eq("efficiency_5th","low",0.01,1.5)[1:6]/np.sum(pop[low_income].loc[2030])
s2_pc_5th=NPV_eq("efficiency_5th","lower middle",0.01,1.5)[1:6]/np.sum(pop[lower_middle_income].loc[2030])
s3_pc_5th=NPV_eq("efficiency_5th","upper middle",0.01,1.5)[1:6]/np.sum(pop[upper_middle_income].loc[2030])
s4_pc_5th=NPV_eq("efficiency_5th","high",0.01,1.5)[1:6]/np.sum(pop[high_income].loc[2030])

ds_pc_5th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s_pc_5th,
    "LI": s1_pc_5th,
    "LMI": s2_pc_5th,
    "UMI": s3_pc_5th,
    "HI": s4_pc_5th})

ds_pc_5th.to_csv('results/efficiency/npv_equity_weighted_EFFICIENCY_pc_5th.csv')

s_pc_95th=NPV_eq("efficiency_95th","tot",0.01,1.5)[1:6]/np.sum(pop.loc[2030])
s1_pc_95th=NPV_eq("efficiency_95th","low",0.01,1.5)[1:6]/np.sum(pop[low_income].loc[2030])
s2_pc_95th=NPV_eq("efficiency_95th","lower middle",0.01,1.5)[1:6]/np.sum(pop[lower_middle_income].loc[2030])
s3_pc_95th=NPV_eq("efficiency_95th","upper middle",0.01,1.5)[1:6]/np.sum(pop[upper_middle_income].loc[2030])
s4_pc_95th=NPV_eq("efficiency_95th","high",0.01,1.5)[1:6]/np.sum(pop[high_income].loc[2030])

ds_pc_95th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s_pc_95th,
    "LI": s1_pc_95th,
    "LMI": s2_pc_95th,
    "UMI": s3_pc_95th,
    "HI": s4_pc_95th})

ds_pc_95th.to_csv('results/efficiency/npv_equity_weighted_EFFICIENCY_pc_95th.csv')





#as a share of 2030 GDP
s_gdp_mean=NPV_eq("efficiency_mean","tot",0.01,1.5)[1:6]/np.sum(gdp.loc[2030])
s1_gdp_mean=NPV_eq("efficiency_mean","low",0.01,1.5)[1:6]/np.sum(gdp[low_income].loc[2030])
s2_gdp_mean=NPV_eq("efficiency_mean","lower middle",0.01,1.5)[1:6]/np.sum(gdp[lower_middle_income].loc[2030])
s3_gdp_mean=NPV_eq("efficiency_mean","upper middle",0.01,1.5)[1:6]/np.sum(gdp[upper_middle_income].loc[2030])
s4_gdp_mean=NPV_eq("efficiency_mean","high",0.01,1.5)[1:6]/np.sum(gdp[high_income].loc[2030])

ds_gdp_mean=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s_gdp_mean,
    "LI": s1_gdp_mean,
    "LMI": s2_gdp_mean,
    "UMI": s3_gdp_mean,
    "HI": s4_gdp_mean})

ds_gdp_mean.to_csv('results/efficiency/npv_equity_weighted_EFFICIENCY_gdp_mean.csv')

s_gdp_5th=NPV_eq("efficiency_5th","tot",0.01,1.5)[1:6]/np.sum(gdp.loc[2030])
s1_gdp_5th=NPV_eq("efficiency_5th","low",0.01,1.5)[1:6]/np.sum(gdp[low_income].loc[2030])
s2_gdp_5th=NPV_eq("efficiency_5th","lower middle",0.01,1.5)[1:6]/np.sum(gdp[lower_middle_income].loc[2030])
s3_gdp_5th=NPV_eq("efficiency_5th","upper middle",0.01,1.5)[1:6]/np.sum(gdp[upper_middle_income].loc[2030])
s4_gdp_5th=NPV_eq("efficiency_5th","high",0.01,1.5)[1:6]/np.sum(gdp[high_income].loc[2030])

ds_gdp_5th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s_gdp_5th,
    "LI": s1_gdp_5th,
    "LMI": s2_gdp_5th,
    "UMI": s3_gdp_5th,
    "HI": s4_gdp_5th})

ds_gdp_5th.to_csv('results/efficiency/npv_equity_weighted_EFFICIENCY_gdp_5th.csv')

s_gdp_95th=NPV_eq("efficiency_95th","tot",0.01,1.5)[1:6]/np.sum(gdp.loc[2030])
s1_gdp_95th=NPV_eq("efficiency_95th","low",0.01,1.5)[1:6]/np.sum(gdp[low_income].loc[2030])
s2_gdp_95th=NPV_eq("efficiency_95th","lower middle",0.01,1.5)[1:6]/np.sum(gdp[lower_middle_income].loc[2030])
s3_gdp_95th=NPV_eq("efficiency_95th","upper middle",0.01,1.5)[1:6]/np.sum(gdp[upper_middle_income].loc[2030])
s4_gdp_95th=NPV_eq("efficiency_95th","high",0.01,1.5)[1:6]/np.sum(gdp[high_income].loc[2030])

ds_gdp_95th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s_gdp_95th,
    "LI": s1_gdp_95th,
    "LMI": s2_gdp_95th,
    "UMI": s3_gdp_95th,
    "HI": s4_gdp_95th})

ds_gdp_95th.to_csv('results/efficiency/npv_equity_weighted_EFFICIENCY_gdp_95th.csv')


su_mean=NPV_uniform("efficiency_mean","tot",0.01,1.5)[1:6]
su1_mean=NPV_uniform("efficiency_mean","low",0.01,1.5)[1:6]
su2_mean=NPV_uniform("efficiency_mean","lower middle",0.01,1.5)[1:6]
su3_mean=NPV_uniform("efficiency_mean","upper middle",0.01,1.5)[1:6]
su4_mean=NPV_uniform("efficiency_mean","high",0.01,1.5)[1:6]


dsu_mean=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": su_mean,
    "LI": su1_mean,
    "LMI": su2_mean,
    "UMI": su3_mean,
    "HI": su4_mean})

dsu_mean.to_csv('results/efficiency/npv_uniform_VSL_EFFICIENCY_mean.csv')


su_5th=NPV_uniform("efficiency_5th","tot",0.01,1.5)[1:6]
su1_5th=NPV_uniform("efficiency_5th","low",0.01,1.5)[1:6]
su2_5th=NPV_uniform("efficiency_5th","lower middle",0.01,1.5)[1:6]
su3_5th=NPV_uniform("efficiency_5th","upper middle",0.01,1.5)[1:6]
su4_5th=NPV_uniform("efficiency_5th","high",0.01,1.5)[1:6]


dsu_5th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": su_5th,
    "LI": su1_5th,
    "LMI": su2_5th,
    "UMI": su3_5th,
    "HI": su4_5th})

dsu_5th.to_csv('results/efficiency/npv_uniform_VSL_EFFICIENCY_5th.csv')

su_95th=NPV_uniform("efficiency_95th","tot",0.01,1.5)[1:6]
su1_95th=NPV_uniform("efficiency_95th","low",0.01,1.5)[1:6]
su2_95th=NPV_uniform("efficiency_95th","lower middle",0.01,1.5)[1:6]
su3_95th=NPV_uniform("efficiency_95th","upper middle",0.01,1.5)[1:6]
su4_95th=NPV_uniform("efficiency_95th","high",0.01,1.5)[1:6]


dsu_95th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": su_95th,
    "LI": su1_95th,
    "LMI": su2_95th,
    "UMI": su3_95th,
    "HI": su4_95th})

dsu_95th.to_csv('results/efficiency/npv_uniform_VSL_EFFICIENCY_95th.csv')



s__mean=NPV_("efficiency_mean","tot",0.01,1.5)[1:6]
s1__mean=NPV_("efficiency_mean","low",0.01,1.5)[1:6]
s2__mean=NPV_("efficiency_mean","lower middle",0.01,1.5)[1:6]
s3__mean=NPV_("efficiency_mean","upper middle",0.01,1.5)[1:6]
s4__mean=NPV_("efficiency_mean","high",0.01,1.5)[1:6]


d_s_mean=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s__mean,
    "LI": s1__mean,
    "LMI": s2__mean,
    "UMI": s3__mean,
    "HI": s4__mean})

d_s_mean.to_csv('results/efficiency/npv_no_weights_EFFICIENCY_mean.csv')

s__5th=NPV_("efficiency_5th","tot",0.01,1.5)[1:6]
s1__5th=NPV_("efficiency_5th","low",0.01,1.5)[1:6]
s2__5th=NPV_("efficiency_5th","lower middle",0.01,1.5)[1:6]
s3__5th=NPV_("efficiency_5th","upper middle",0.01,1.5)[1:6]
s4__5th=NPV_("efficiency_5th","high",0.01,1.5)[1:6]


d_s_5th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s__5th,
    "LI": s1__5th,
    "LMI": s2__5th,
    "UMI": s3__5th,
    "HI": s4__5th})

d_s_5th.to_csv('results/efficiency/npv_no_weights_EFFICIENCY_5th.csv')

s__95th=NPV_("efficiency_95th","tot",0.01,1.5)[1:6]
s1__95th=NPV_("efficiency_95th","low",0.01,1.5)[1:6]
s2__95th=NPV_("efficiency_95th","lower middle",0.01,1.5)[1:6]
s3__95th=NPV_("efficiency_95th","upper middle",0.01,1.5)[1:6]
s4__95th=NPV_("efficiency_95th","high",0.01,1.5)[1:6]


d_s_95th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": s__95th,
    "LI": s1__95th,
    "LMI": s2__95th,
    "UMI": s3__95th,
    "HI": s4__95th})

d_s_95th.to_csv('results/efficiency/npv_no_weights_EFFICIENCY_95th.csv')








ss_mean=NPV_eq("equity_mean","tot",0.01,1.5)[1:6]
ss1_mean=NPV_eq("equity_mean","low",0.01,1.5)[1:6]
ss2_mean=NPV_eq("equity_mean","lower middle",0.01,1.5)[1:6]
ss3_mean=NPV_eq("equity_mean","upper middle",0.01,1.5)[1:6]
ss4_mean=NPV_eq("equity_mean","high",0.01,1.5)[1:6]


dss_mean=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss_mean,
    "LI": ss1_mean,
    "LMI": ss2_mean,
    "UMI": ss3_mean,
    "HI": ss4_mean})

dss_mean.to_csv('results/equity/npv_equity_weighted_EQUITY_mean.csv')

ss_5th=NPV_eq("equity_5th","tot",0.01,1.5)[1:6]
ss1_5th=NPV_eq("equity_5th","low",0.01,1.5)[1:6]
ss2_5th=NPV_eq("equity_5th","lower middle",0.01,1.5)[1:6]
ss3_5th=NPV_eq("equity_5th","upper middle",0.01,1.5)[1:6]
ss4_5th=NPV_eq("equity_5th","high",0.01,1.5)[1:6]


dss_5th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss_5th,
    "LI": ss1_5th,
    "LMI": ss2_5th,
    "UMI": ss3_5th,
    "HI": ss4_5th})

dss_5th.to_csv('results/equity/npv_equity_weighted_EQUITY_5th.csv')

ss_95th=NPV_eq("equity_95th","tot",0.01,1.5)[1:6]
ss1_95th=NPV_eq("equity_95th","low",0.01,1.5)[1:6]
ss2_95th=NPV_eq("equity_95th","lower middle",0.01,1.5)[1:6]
ss3_95th=NPV_eq("equity_95th","upper middle",0.01,1.5)[1:6]
ss4_95th=NPV_eq("equity_95th","high",0.01,1.5)[1:6]


dss_95th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss_95th,
    "LI": ss1_95th,
    "LMI": ss2_95th,
    "UMI": ss3_95th,
    "HI": ss4_95th})

dss_95th.to_csv('results/equity/npv_equity_weighted_EQUITY_95th.csv')





#per-capita
ss_pc_mean=NPV_eq("equity_mean","tot",0.01,1.5)[1:6]/np.sum(pop.loc[2030])
ss1_pc_mean=NPV_eq("equity_mean","low",0.01,1.5)[1:6]/np.sum(pop[low_income].loc[2030])
ss2_pc_mean=NPV_eq("equity_mean","lower middle",0.01,1.5)[1:6]/np.sum(pop[lower_middle_income].loc[2030])
ss3_pc_mean=NPV_eq("equity_mean","upper middle",0.01,1.5)[1:6]/np.sum(pop[upper_middle_income].loc[2030])
ss4_pc_mean=NPV_eq("equity_mean","high",0.01,1.5)[1:6]/np.sum(pop[high_income].loc[2030])

dss_pc_mean=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss_pc_mean,
    "LI": ss1_pc_mean,
    "LMI": ss2_pc_mean,
    "UMI": ss3_pc_mean,
    "HI": ss4_pc_mean})

dss_pc_mean.to_csv('results/equity/npv_equity_weighted_EQUITY_pc_mean.csv')

ss_pc_5th=NPV_eq("equity_5th","tot",0.01,1.5)[1:6]/np.sum(pop.loc[2030])
ss1_pc_5th=NPV_eq("equity_5th","low",0.01,1.5)[1:6]/np.sum(pop[low_income].loc[2030])
ss2_pc_5th=NPV_eq("equity_5th","lower middle",0.01,1.5)[1:6]/np.sum(pop[lower_middle_income].loc[2030])
ss3_pc_5th=NPV_eq("equity_5th","upper middle",0.01,1.5)[1:6]/np.sum(pop[upper_middle_income].loc[2030])
ss4_pc_5th=NPV_eq("equity_5th","high",0.01,1.5)[1:6]/np.sum(pop[high_income].loc[2030])

dss_pc_5th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss_pc_5th,
    "LI": ss1_pc_5th,
    "LMI": ss2_pc_5th,
    "UMI": ss3_pc_5th,
    "HI": ss4_pc_5th})

dss_pc_5th.to_csv('results/equity/npv_equity_weighted_EQUITY_pc_5th.csv')

ss_pc_95th=NPV_eq("equity_95th","tot",0.01,1.5)[1:6]/np.sum(pop.loc[2030])
ss1_pc_95th=NPV_eq("equity_95th","low",0.01,1.5)[1:6]/np.sum(pop[low_income].loc[2030])
ss2_pc_95th=NPV_eq("equity_95th","lower middle",0.01,1.5)[1:6]/np.sum(pop[lower_middle_income].loc[2030])
ss3_pc_95th=NPV_eq("equity_95th","upper middle",0.01,1.5)[1:6]/np.sum(pop[upper_middle_income].loc[2030])
ss4_pc_95th=NPV_eq("equity_95th","high",0.01,1.5)[1:6]/np.sum(pop[high_income].loc[2030])

dss_pc_95th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss_pc_95th,
    "LI": ss1_pc_95th,
    "LMI": ss2_pc_95th,
    "UMI": ss3_pc_95th,
    "HI": ss4_pc_95th})

dss_pc_95th.to_csv('results/equity/npv_equity_weighted_EQUITY_pc_95th.csv')




#as a share of 2030 gdp
ss_gdp_mean=NPV_eq("equity_mean","tot",0.01,1.5)[1:6]/np.sum(gdp.loc[2030])
ss1_gdp_mean=NPV_eq("equity_mean","low",0.01,1.5)[1:6]/np.sum(gdp[low_income].loc[2030])
ss2_gdp_mean=NPV_eq("equity_mean","lower middle",0.01,1.5)[1:6]/np.sum(gdp[lower_middle_income].loc[2030])
ss3_gdp_mean=NPV_eq("equity_mean","upper middle",0.01,1.5)[1:6]/np.sum(gdp[upper_middle_income].loc[2030])
ss4_gdp_mean=NPV_eq("equity_mean","high",0.01,1.5)[1:6]/np.sum(gdp[high_income].loc[2030])

dss_gdp_mean=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss_gdp_mean,
    "LI": ss1_gdp_mean,
    "LMI": ss2_gdp_mean,
    "UMI": ss3_gdp_mean,
    "HI": ss4_gdp_mean})

dss_gdp_mean.to_csv('results/equity/npv_equity_weighted_EQUITY_gdp_mean.csv')

ss_gdp_5th=NPV_eq("equity_5th","tot",0.01,1.5)[1:6]/np.sum(gdp.loc[2030])
ss1_gdp_5th=NPV_eq("equity_5th","low",0.01,1.5)[1:6]/np.sum(gdp[low_income].loc[2030])
ss2_gdp_5th=NPV_eq("equity_5th","lower middle",0.01,1.5)[1:6]/np.sum(gdp[lower_middle_income].loc[2030])
ss3_gdp_5th=NPV_eq("equity_5th","upper middle",0.01,1.5)[1:6]/np.sum(gdp[upper_middle_income].loc[2030])
ss4_gdp_5th=NPV_eq("equity_5th","high",0.01,1.5)[1:6]/np.sum(gdp[high_income].loc[2030])

dss_gdp_5th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss_gdp_5th,
    "LI": ss1_gdp_5th,
    "LMI": ss2_gdp_5th,
    "UMI": ss3_gdp_5th,
    "HI": ss4_gdp_5th})

dss_gdp_5th.to_csv('results/equity/npv_equity_weighted_EQUITY_gdp_5th.csv')

ss_gdp_95th=NPV_eq("equity_95th","tot",0.01,1.5)[1:6]/np.sum(gdp.loc[2030])
ss1_gdp_95th=NPV_eq("equity_95th","low",0.01,1.5)[1:6]/np.sum(gdp[low_income].loc[2030])
ss2_gdp_95th=NPV_eq("equity_95th","lower middle",0.01,1.5)[1:6]/np.sum(gdp[lower_middle_income].loc[2030])
ss3_gdp_95th=NPV_eq("equity_95th","upper middle",0.01,1.5)[1:6]/np.sum(gdp[upper_middle_income].loc[2030])
ss4_gdp_95th=NPV_eq("equity_95th","high",0.01,1.5)[1:6]/np.sum(gdp[high_income].loc[2030])

dss_gdp_95th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss_gdp_95th,
    "LI": ss1_gdp_95th,
    "LMI": ss2_gdp_95th,
    "UMI": ss3_gdp_95th,
    "HI": ss4_gdp_95th})

dss_gdp_95th.to_csv('results/equity/npv_equity_weighted_EQUITY_gdp_95th.csv')





ssu_mean=NPV_uniform("equity_mean","tot",0.01,1.5)[1:6]
ssu1_mean=NPV_uniform("equity_mean","low",0.01,1.5)[1:6]
ssu2_mean=NPV_uniform("equity_mean","lower middle",0.01,1.5)[1:6]
ssu3_mean=NPV_uniform("equity_mean","upper middle",0.01,1.5)[1:6]
ssu4_mean=NPV_uniform("equity_mean","high",0.01,1.5)[1:6]


dssu_mean=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ssu_mean,
    "LI": ssu1_mean,
    "LMI": ssu2_mean,
    "UMI": ssu3_mean,
    "HI": ssu4_mean})

dssu_mean.to_csv('results/equity/npv_uniform_VSL_EQUITY_mean.csv')

ssu_5th=NPV_uniform("equity_5th","tot",0.01,1.5)[1:6]
ssu1_5th=NPV_uniform("equity_5th","low",0.01,1.5)[1:6]
ssu2_5th=NPV_uniform("equity_5th","lower middle",0.01,1.5)[1:6]
ssu3_5th=NPV_uniform("equity_5th","upper middle",0.01,1.5)[1:6]
ssu4_5th=NPV_uniform("equity_5th","high",0.01,1.5)[1:6]


dssu_5th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ssu_5th,
    "LI": ssu1_5th,
    "LMI": ssu2_5th,
    "UMI": ssu3_5th,
    "HI": ssu4_5th})

dssu_5th.to_csv('results/equity/npv_uniform_VSL_EQUITY_5th.csv')

ssu_95th=NPV_uniform("equity_95th","tot",0.01,1.5)[1:6]
ssu1_95th=NPV_uniform("equity_95th","low",0.01,1.5)[1:6]
ssu2_95th=NPV_uniform("equity_95th","lower middle",0.01,1.5)[1:6]
ssu3_95th=NPV_uniform("equity_95th","upper middle",0.01,1.5)[1:6]
ssu4_95th=NPV_uniform("equity_95th","high",0.01,1.5)[1:6]


dssu_95th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ssu_95th,
    "LI": ssu1_95th,
    "LMI": ssu2_95th,
    "UMI": ssu3_95th,
    "HI": ssu4_95th})

dssu_95th.to_csv('results/equity/npv_uniform_VSL_EQUITY_95th.csv')






ss__mean=NPV_("equity_mean","tot",0.01,1.5)[1:6]
ss1__mean=NPV_("equity_mean","low",0.01,1.5)[1:6]
ss2__mean=NPV_("equity_mean","lower middle",0.01,1.5)[1:6]
ss3__mean=NPV_("equity_mean","upper middle",0.01,1.5)[1:6]
ss4__mean=NPV_("equity_mean","high",0.01,1.5)[1:6]


ds_s_mean=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss__mean,
    "LI": ss1__mean,
    "LMI": ss2__mean,
    "UMI": ss3__mean,
    "HI": ss4__mean})

ds_s_mean.to_csv('results/equity/npv_no_weights_EQUITY_mean.csv')

ss__5th=NPV_("equity_5th","tot",0.01,1.5)[1:6]
ss1__5th=NPV_("equity_5th","low",0.01,1.5)[1:6]
ss2__5th=NPV_("equity_5th","lower middle",0.01,1.5)[1:6]
ss3__5th=NPV_("equity_5th","upper middle",0.01,1.5)[1:6]
ss4__5th=NPV_("equity_5th","high",0.01,1.5)[1:6]


ds_s_5th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss__5th,
    "LI": ss1__5th,
    "LMI": ss2__5th,
    "UMI": ss3__5th,
    "HI": ss4__5th})

ds_s_5th.to_csv('results/equity/npv_no_weights_EQUITY_5th.csv')

ss__95th=NPV_("equity_95th","tot",0.01,1.5)[1:6]
ss1__95th=NPV_("equity_95th","low",0.01,1.5)[1:6]
ss2__95th=NPV_("equity_95th","lower middle",0.01,1.5)[1:6]
ss3__95th=NPV_("equity_95th","upper middle",0.01,1.5)[1:6]
ss4__95th=NPV_("equity_95th","high",0.01,1.5)[1:6]


ds_s_95th=pd.DataFrame({"Component": ["Net benefits","Mitigation costs","Climate damages","Climate deaths","Air pollution deaths"],
    "Total": ss__95th,
    "LI": ss1__95th,
    "LMI": ss2__95th,
    "UMI": ss3__95th,
    "HI": ss4__95th})

ds_s_95th.to_csv('results/equity/npv_no_weights_EQUITY_95th.csv')

###################################################
## Equity-weighted benefits over time

#eta=1.5
Ben_t_mean=NPV_eq("efficiency_mean","tot",0.01,1.5)[0]
Ben_LI_mean=NPV_eq("efficiency_mean","low",0.01,1.5)[0]
Ben_LMI_mean=NPV_eq("efficiency_mean","lower middle",0.01,1.5)[0]
Ben_UMI_mean=NPV_eq("efficiency_mean","upper middle",0.01,1.5)[0]
Ben_HI_mean=NPV_eq("efficiency_mean","high",0.01,1.5)[0]

df_ben_eq_mean=pd.DataFrame({"Total": Ben_t_mean,
                     "LI": Ben_LI_mean,
                     "LMI": Ben_LMI_mean,
                     "UMI": Ben_UMI_mean,
                     "HI": Ben_HI_mean})

df_ben_eq_mean.to_csv('results/efficiency/period_equity_weighted_benefits_15_EFFICIENCY_mean.csv')

Ben_t_5th=NPV_eq("efficiency_5th","tot",0.01,1.5)[0]
Ben_LI_5th=NPV_eq("efficiency_5th","low",0.01,1.5)[0]
Ben_LMI_5th=NPV_eq("efficiency_5th","lower middle",0.01,1.5)[0]
Ben_UMI_5th=NPV_eq("efficiency_5th","upper middle",0.01,1.5)[0]
Ben_HI_5th=NPV_eq("efficiency_5th","high",0.01,1.5)[0]

df_ben_eq_5th=pd.DataFrame({"Total": Ben_t_5th,
                     "LI": Ben_LI_5th,
                     "LMI": Ben_LMI_5th,
                     "UMI": Ben_UMI_5th,
                     "HI": Ben_HI_5th})

df_ben_eq_5th.to_csv('results/efficiency/period_equity_weighted_benefits_15_EFFICIENCY_5th.csv')

Ben_t_95th=NPV_eq("efficiency_95th","tot",0.01,1.5)[0]
Ben_LI_95th=NPV_eq("efficiency_95th","low",0.01,1.5)[0]
Ben_LMI_95th=NPV_eq("efficiency_95th","lower middle",0.01,1.5)[0]
Ben_UMI_95th=NPV_eq("efficiency_95th","upper middle",0.01,1.5)[0]
Ben_HI_95th=NPV_eq("efficiency_95th","high",0.01,1.5)[0]

df_ben_eq_95th=pd.DataFrame({"Total": Ben_t_95th,
                     "LI": Ben_LI_95th,
                     "LMI": Ben_LMI_95th,
                     "UMI": Ben_UMI_95th,
                     "HI": Ben_HI_95th})

df_ben_eq_95th.to_csv('results/efficiency/period_equity_weighted_benefits_15_EFFICIENCY_95th.csv')




#per-capita, 2030 pop
Ben_t_pc_mean=NPV_eq("efficiency_mean","tot",0.01,1.5)[0]/np.sum(pop.loc[2030])
Ben_LI_pc_mean=NPV_eq("efficiency_mean","low",0.01,1.5)[0]/np.sum(pop[low_income].loc[2030])
Ben_LMI_pc_mean=NPV_eq("efficiency_mean","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income].loc[2030])
Ben_UMI_pc_mean=NPV_eq("efficiency_mean","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income].loc[2030])
Ben_HI_pc_mean=NPV_eq("efficiency_mean","high",0.01,1.5)[0]/np.sum(pop[high_income].loc[2030])

df_ben_eq_pc_mean=pd.DataFrame({"Total": Ben_t_pc_mean,
                     "LI": Ben_LI_pc_mean,
                     "LMI": Ben_LMI_pc_mean,
                     "UMI": Ben_UMI_pc_mean,
                     "HI": Ben_HI_pc_mean})

df_ben_eq_pc_mean.to_csv('results/efficiency/period_equity_weighted_benefits_15_EFFICIENCY_pc_mean.csv')

Ben_t_pc_5th=NPV_eq("efficiency_5th","tot",0.01,1.5)[0]/np.sum(pop.loc[2030])
Ben_LI_pc_5th=NPV_eq("efficiency_5th","low",0.01,1.5)[0]/np.sum(pop[low_income].loc[2030])
Ben_LMI_pc_5th=NPV_eq("efficiency_5th","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income].loc[2030])
Ben_UMI_pc_5th=NPV_eq("efficiency_5th","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income].loc[2030])
Ben_HI_pc_5th=NPV_eq("efficiency_5th","high",0.01,1.5)[0]/np.sum(pop[high_income].loc[2030])

df_ben_eq_pc_5th=pd.DataFrame({"Total": Ben_t_pc_5th,
                     "LI": Ben_LI_pc_5th,
                     "LMI": Ben_LMI_pc_5th,
                     "UMI": Ben_UMI_pc_5th,
                     "HI": Ben_HI_pc_5th})

df_ben_eq_pc_5th.to_csv('results/efficiency/period_equity_weighted_benefits_15_EFFICIENCY_pc_5th.csv')

Ben_t_pc_95th=NPV_eq("efficiency_95th","tot",0.01,1.5)[0]/np.sum(pop.loc[2030])
Ben_LI_pc_95th=NPV_eq("efficiency_95th","low",0.01,1.5)[0]/np.sum(pop[low_income].loc[2030])
Ben_LMI_pc_95th=NPV_eq("efficiency_95th","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income].loc[2030])
Ben_UMI_pc_95th=NPV_eq("efficiency_95th","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income].loc[2030])
Ben_HI_pc_95th=NPV_eq("efficiency_95th","high",0.01,1.5)[0]/np.sum(pop[high_income].loc[2030])

df_ben_eq_pc_95th=pd.DataFrame({"Total": Ben_t_pc_95th,
                     "LI": Ben_LI_pc_95th,
                     "LMI": Ben_LMI_pc_95th,
                     "UMI": Ben_UMI_pc_95th,
                     "HI": Ben_HI_pc_95th})

df_ben_eq_pc_95th.to_csv('results/efficiency/period_equity_weighted_benefits_15_EFFICIENCY_pc_95th.csv')





#per-capita, yearly pop
Ben_t_pc1_mean=NPV_eq("efficiency_mean","tot",0.01,1.5)[0]/np.sum(pop,1)
Ben_LI_pc1_mean=NPV_eq("efficiency_mean","low",0.01,1.5)[0]/np.sum(pop[low_income],1)
Ben_LMI_pc1_mean=NPV_eq("efficiency_mean","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income],1)
Ben_UMI_pc1_mean=NPV_eq("efficiency_mean","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income],1)
Ben_HI_pc1_mean=NPV_eq("efficiency_mean","high",0.01,1.5)[0]/np.sum(pop[high_income],1)

df_ben_eq_pc1_mean=pd.DataFrame({"Total": Ben_t_pc1_mean,
                     "LI": Ben_LI_pc1_mean,
                     "LMI": Ben_LMI_pc1_mean,
                     "UMI": Ben_UMI_pc1_mean,
                     "HI": Ben_HI_pc1_mean})

df_ben_eq_pc1_mean.to_csv('results/efficiency/period_equity_weighted_benefits_15_EFFICIENCY_pc1_mean.csv')

Ben_t_pc1_5th=NPV_eq("efficiency_5th","tot",0.01,1.5)[0]/np.sum(pop,1)
Ben_LI_pc1_5th=NPV_eq("efficiency_5th","low",0.01,1.5)[0]/np.sum(pop[low_income],1)
Ben_LMI_pc1_5th=NPV_eq("efficiency_5th","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income],1)
Ben_UMI_pc1_5th=NPV_eq("efficiency_5th","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income],1)
Ben_HI_pc1_5th=NPV_eq("efficiency_5th","high",0.01,1.5)[0]/np.sum(pop[high_income],1)

df_ben_eq_pc1_5th=pd.DataFrame({"Total": Ben_t_pc1_5th,
                     "LI": Ben_LI_pc1_5th,
                     "LMI": Ben_LMI_pc1_5th,
                     "UMI": Ben_UMI_pc1_5th,
                     "HI": Ben_HI_pc1_5th})

df_ben_eq_pc1_5th.to_csv('results/efficiency/period_equity_weighted_benefits_15_EFFICIENCY_pc1_5th.csv')

Ben_t_pc1_95th=NPV_eq("efficiency_95th","tot",0.01,1.5)[0]/np.sum(pop,1)
Ben_LI_pc1_95th=NPV_eq("efficiency_95th","low",0.01,1.5)[0]/np.sum(pop[low_income],1)
Ben_LMI_pc1_95th=NPV_eq("efficiency_95th","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income],1)
Ben_UMI_pc1_95th=NPV_eq("efficiency_95th","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income],1)
Ben_HI_pc1_95th=NPV_eq("efficiency_95th","high",0.01,1.5)[0]/np.sum(pop[high_income],1)

df_ben_eq_pc1_95th=pd.DataFrame({"Total": Ben_t_pc1_95th,
                     "LI": Ben_LI_pc1_95th,
                     "LMI": Ben_LMI_pc1_95th,
                     "UMI": Ben_UMI_pc1_95th,
                     "HI": Ben_HI_pc1_95th})

df_ben_eq_pc1_95th.to_csv('results/efficiency/period_equity_weighted_benefits_15_EFFICIENCY_pc1_95th.csv')




#eta=1
Ben_t1_mean=NPV_eq("efficiency_mean","tot",0.01,1)[0]
Ben_LI1_mean=NPV_eq("efficiency_mean","low",0.01,1)[0]
Ben_LMI1_mean=NPV_eq("efficiency_mean","lower middle",0.01,1)[0]
Ben_UMI1_mean=NPV_eq("efficiency_mean","upper middle",0.01,1)[0]
Ben_HI1_mean=NPV_eq("efficiency_mean","high",0.01,1)[0]

df_ben_eq1_mean=pd.DataFrame({"Total": Ben_t1_mean,
                     "LI": Ben_LI1_mean,
                     "LMI": Ben_LMI1_mean,
                     "UMI": Ben_UMI1_mean,
                     "HI": Ben_HI1_mean})

df_ben_eq1_mean.to_csv('results/efficiency/period_equity_weighted_benefits_1_EFFICIENCY_mean.csv')

Ben_t1_5th=NPV_eq("efficiency_5th","tot",0.01,1)[0]
Ben_LI1_5th=NPV_eq("efficiency_5th","low",0.01,1)[0]
Ben_LMI1_5th=NPV_eq("efficiency_5th","lower middle",0.01,1)[0]
Ben_UMI1_5th=NPV_eq("efficiency_5th","upper middle",0.01,1)[0]
Ben_HI1_5th=NPV_eq("efficiency_5th","high",0.01,1)[0]

df_ben_eq1_5th=pd.DataFrame({"Total": Ben_t1_5th,
                     "LI": Ben_LI1_5th,
                     "LMI": Ben_LMI1_5th,
                     "UMI": Ben_UMI1_5th,
                     "HI": Ben_HI1_5th})

df_ben_eq1_5th.to_csv('results/efficiency/period_equity_weighted_benefits_1_EFFICIENCY_5th.csv')

Ben_t1_95th=NPV_eq("efficiency_95th","tot",0.01,1)[0]
Ben_LI1_95th=NPV_eq("efficiency_95th","low",0.01,1)[0]
Ben_LMI1_95th=NPV_eq("efficiency_95th","lower middle",0.01,1)[0]
Ben_UMI1_95th=NPV_eq("efficiency_95th","upper middle",0.01,1)[0]
Ben_HI1_95th=NPV_eq("efficiency_95th","high",0.01,1)[0]

df_ben_eq1_95th=pd.DataFrame({"Total": Ben_t1_95th,
                     "LI": Ben_LI1_95th,
                     "LMI": Ben_LMI1_95th,
                     "UMI": Ben_UMI1_95th,
                     "HI": Ben_HI1_95th})

df_ben_eq1_95th.to_csv('results/efficiency/period_equity_weighted_benefits_1_EFFICIENCY_95th.csv')





#eta=2
Ben_t2_mean=NPV_eq("efficiency_mean","tot",0.01,2)[0]
Ben_LI2_mean=NPV_eq("efficiency_mean","low",0.01,2)[0]
Ben_LMI2_mean=NPV_eq("efficiency_mean","lower middle",0.01,2)[0]
Ben_UMI2_mean=NPV_eq("efficiency_mean","upper middle",0.01,2)[0]
Ben_HI2_mean=NPV_eq("efficiency_mean","high",0.01,2)[0]

df_ben_eq2_mean=pd.DataFrame({"Total": Ben_t2_mean,
                     "LI": Ben_LI2_mean,
                     "LMI": Ben_LMI2_mean,
                     "UMI": Ben_UMI2_mean,
                     "HI": Ben_HI2_mean})

df_ben_eq2_mean.to_csv('results/efficiency/period_equity_weighted_benefits_2_EFFICIENCY_mean.csv')

Ben_t2_5th=NPV_eq("efficiency_5th","tot",0.01,2)[0]
Ben_LI2_5th=NPV_eq("efficiency_5th","low",0.01,2)[0]
Ben_LMI2_5th=NPV_eq("efficiency_5th","lower middle",0.01,2)[0]
Ben_UMI2_5th=NPV_eq("efficiency_5th","upper middle",0.01,2)[0]
Ben_HI2_5th=NPV_eq("efficiency_5th","high",0.01,2)[0]

df_ben_eq2_5th=pd.DataFrame({"Total": Ben_t2_5th,
                     "LI": Ben_LI2_5th,
                     "LMI": Ben_LMI2_5th,
                     "UMI": Ben_UMI2_5th,
                     "HI": Ben_HI2_5th})

df_ben_eq2_5th.to_csv('results/efficiency/period_equity_weighted_benefits_2_EFFICIENCY_5th.csv')

Ben_t2_95th=NPV_eq("efficiency_95th","tot",0.01,2)[0]
Ben_LI2_95th=NPV_eq("efficiency_95th","low",0.01,2)[0]
Ben_LMI2_95th=NPV_eq("efficiency_95th","lower middle",0.01,2)[0]
Ben_UMI2_95th=NPV_eq("efficiency_95th","upper middle",0.01,2)[0]
Ben_HI2_95th=NPV_eq("efficiency_95th","high",0.01,2)[0]

df_ben_eq2_95th=pd.DataFrame({"Total": Ben_t2_95th,
                     "LI": Ben_LI2_95th,
                     "LMI": Ben_LMI2_95th,
                     "UMI": Ben_UMI2_95th,
                     "HI": Ben_HI2_95th})

df_ben_eq2_95th.to_csv('results/efficiency/period_equity_weighted_benefits_2_EFFICIENCY_95th.csv')





Benu_t_mean=NPV_uniform("efficiency_mean","tot",0.01,1.5)[0]
Benu_LI_mean=NPV_uniform("efficiency_mean","low",0.01,1.5)[0]
Benu_LMI_mean=NPV_uniform("efficiency_mean","lower middle",0.01,1.5)[0]
Benu_UMI_mean=NPV_uniform("efficiency_mean","upper middle",0.01,1.5)[0]
Benu_HI_mean=NPV_uniform("efficiency_mean","high",0.01,1.5)[0]

df_ben_u_mean=pd.DataFrame({"Total": Benu_t_mean,
                     "LI": Benu_LI_mean,
                     "LMI": Benu_LMI_mean,
                     "UMI": Benu_UMI_mean,
                     "HI": Benu_HI_mean})

df_ben_u_mean.to_csv('results/efficiency/period_uniform_VSL_benefit_EFFICIENCY_mean.csv')

Benu_t_5th=NPV_uniform("efficiency_5th","tot",0.01,1.5)[0]
Benu_LI_5th=NPV_uniform("efficiency_5th","low",0.01,1.5)[0]
Benu_LMI_5th=NPV_uniform("efficiency_5th","lower middle",0.01,1.5)[0]
Benu_UMI_5th=NPV_uniform("efficiency_5th","upper middle",0.01,1.5)[0]
Benu_HI_5th=NPV_uniform("efficiency_5th","high",0.01,1.5)[0]

df_ben_u_5th=pd.DataFrame({"Total": Benu_t_5th,
                     "LI": Benu_LI_5th,
                     "LMI": Benu_LMI_5th,
                     "UMI": Benu_UMI_5th,
                     "HI": Benu_HI_5th})

df_ben_u_5th.to_csv('results/efficiency/period_uniform_VSL_benefit_EFFICIENCY_5th.csv')

Benu_t_95th=NPV_uniform("efficiency_95th","tot",0.01,1.5)[0]
Benu_LI_95th=NPV_uniform("efficiency_95th","low",0.01,1.5)[0]
Benu_LMI_95th=NPV_uniform("efficiency_95th","lower middle",0.01,1.5)[0]
Benu_UMI_95th=NPV_uniform("efficiency_95th","upper middle",0.01,1.5)[0]
Benu_HI_95th=NPV_uniform("efficiency_95th","high",0.01,1.5)[0]

df_ben_u_95th=pd.DataFrame({"Total": Benu_t_95th,
                     "LI": Benu_LI_95th,
                     "LMI": Benu_LMI_95th,
                     "UMI": Benu_UMI_95th,
                     "HI": Benu_HI_95th})

df_ben_u_95th.to_csv('results/efficiency/period_uniform_VSL_benefit_EFFICIENCY_95th.csv')






#eta=1.5
Ben1_t_mean=NPV_eq("equity_mean","tot",0.01,1.5)[0]
Ben1_LI_mean=NPV_eq("equity_mean","low",0.01,1.5)[0]
Ben1_LMI_mean=NPV_eq("equity_mean","lower middle",0.01,1.5)[0]
Ben1_UMI_mean=NPV_eq("equity_mean","upper middle",0.01,1.5)[0]
Ben1_HI_mean=NPV_eq("equity_mean","high",0.01,1.5)[0]

df_ben1_eq_mean=pd.DataFrame({"Total": Ben1_t_mean,
                     "LI": Ben1_LI_mean,
                     "LMI": Ben1_LMI_mean,
                     "UMI": Ben1_UMI_mean,
                     "HI": Ben1_HI_mean})

df_ben1_eq_mean.to_csv('results/equity/period_equity_weighted_benefits_15_EQUITY_mean.csv')

Ben1_t_5th=NPV_eq("equity_5th","tot",0.01,1.5)[0]
Ben1_LI_5th=NPV_eq("equity_5th","low",0.01,1.5)[0]
Ben1_LMI_5th=NPV_eq("equity_5th","lower middle",0.01,1.5)[0]
Ben1_UMI_5th=NPV_eq("equity_5th","upper middle",0.01,1.5)[0]
Ben1_HI_5th=NPV_eq("equity_5th","high",0.01,1.5)[0]

df_ben1_eq_5th=pd.DataFrame({"Total": Ben1_t_5th,
                     "LI": Ben1_LI_5th,
                     "LMI": Ben1_LMI_5th,
                     "UMI": Ben1_UMI_5th,
                     "HI": Ben1_HI_5th})

df_ben1_eq_5th.to_csv('results/equity/period_equity_weighted_benefits_15_EQUITY_5th.csv')

Ben1_t_95th=NPV_eq("equity_95th","tot",0.01,1.5)[0]
Ben1_LI_95th=NPV_eq("equity_95th","low",0.01,1.5)[0]
Ben1_LMI_95th=NPV_eq("equity_95th","lower middle",0.01,1.5)[0]
Ben1_UMI_95th=NPV_eq("equity_95th","upper middle",0.01,1.5)[0]
Ben1_HI_95th=NPV_eq("equity_95th","high",0.01,1.5)[0]

df_ben1_eq_95th=pd.DataFrame({"Total": Ben1_t_95th,
                     "LI": Ben1_LI_95th,
                     "LMI": Ben1_LMI_95th,
                     "UMI": Ben1_UMI_95th,
                     "HI": Ben1_HI_95th})

df_ben1_eq_95th.to_csv('results/equity/period_equity_weighted_benefits_15_EQUITY_95th.csv')






#per-capita, 2030 pop
Ben1_t_pc_mean=NPV_eq("equity_mean","tot",0.01,1.5)[0]/np.sum(pop.loc[2030])
Ben1_LI_pc_mean=NPV_eq("equity_mean","low",0.01,1.5)[0]/np.sum(pop[low_income].loc[2030])
Ben1_LMI_pc_mean=NPV_eq("equity_mean","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income].loc[2030])
Ben1_UMI_pc_mean=NPV_eq("equity_mean","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income].loc[2030])
Ben1_HI_pc_mean=NPV_eq("equity_mean","high",0.01,1.5)[0]/np.sum(pop[high_income].loc[2030])

df_ben1_eq_pc_mean=pd.DataFrame({"Total": Ben1_t_pc_mean,
                     "LI": Ben1_LI_pc_mean,
                     "LMI": Ben1_LMI_pc_mean,
                     "UMI": Ben1_UMI_pc_mean,
                     "HI": Ben1_HI_pc_mean})

df_ben1_eq_pc_mean.to_csv('results/equity/period_equity_weighted_benefits_15_EQUITY_pc_mean.csv')

Ben1_t_pc_5th=NPV_eq("equity_5th","tot",0.01,1.5)[0]/np.sum(pop.loc[2030])
Ben1_LI_pc_5th=NPV_eq("equity_5th","low",0.01,1.5)[0]/np.sum(pop[low_income].loc[2030])
Ben1_LMI_pc_5th=NPV_eq("equity_5th","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income].loc[2030])
Ben1_UMI_pc_5th=NPV_eq("equity_5th","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income].loc[2030])
Ben1_HI_pc_5th=NPV_eq("equity_5th","high",0.01,1.5)[0]/np.sum(pop[high_income].loc[2030])

df_ben1_eq_pc_5th=pd.DataFrame({"Total": Ben1_t_pc_5th,
                     "LI": Ben1_LI_pc_5th,
                     "LMI": Ben1_LMI_pc_5th,
                     "UMI": Ben1_UMI_pc_5th,
                     "HI": Ben1_HI_pc_5th})

df_ben1_eq_pc_5th.to_csv('results/equity/period_equity_weighted_benefits_15_EQUITY_pc_5th.csv')

Ben1_t_pc_95th=NPV_eq("equity_95th","tot",0.01,1.5)[0]/np.sum(pop.loc[2030])
Ben1_LI_pc_95th=NPV_eq("equity_95th","low",0.01,1.5)[0]/np.sum(pop[low_income].loc[2030])
Ben1_LMI_pc_95th=NPV_eq("equity_95th","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income].loc[2030])
Ben1_UMI_pc_95th=NPV_eq("equity_95th","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income].loc[2030])
Ben1_HI_pc_95th=NPV_eq("equity_95th","high",0.01,1.5)[0]/np.sum(pop[high_income].loc[2030])

df_ben1_eq_pc_95th=pd.DataFrame({"Total": Ben1_t_pc_95th,
                     "LI": Ben1_LI_pc_95th,
                     "LMI": Ben1_LMI_pc_95th,
                     "UMI": Ben1_UMI_pc_95th,
                     "HI": Ben1_HI_pc_95th})

df_ben1_eq_pc_95th.to_csv('results/equity/period_equity_weighted_benefits_15_EQUITY_pc_95th.csv')





#per-capita, yearly pop
Ben1_t_pc1_mean=NPV_eq("equity_mean","tot",0.01,1.5)[0]/np.sum(pop,1)
Ben1_LI_pc1_mean=NPV_eq("equity_mean","low",0.01,1.5)[0]/np.sum(pop[low_income],1)
Ben1_LMI_pc1_mean=NPV_eq("equity_mean","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income],1)
Ben1_UMI_pc1_mean=NPV_eq("equity_mean","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income],1)
Ben1_HI_pc1_mean=NPV_eq("equity_mean","high",0.01,1.5)[0]/np.sum(pop[high_income],1)

df_ben1_eq_pc1_mean=pd.DataFrame({"Total": Ben1_t_pc1_mean,
                     "LI": Ben1_LI_pc1_mean,
                     "LMI": Ben1_LMI_pc1_mean,
                     "UMI": Ben1_UMI_pc1_mean,
                     "HI": Ben1_HI_pc1_mean})

df_ben1_eq_pc1_mean.to_csv('results/equity/period_equity_weighted_benefits_15_EQUITY_pc1_mean.csv')

Ben1_t_pc1_5th=NPV_eq("equity_5th","tot",0.01,1.5)[0]/np.sum(pop,1)
Ben1_LI_pc1_5th=NPV_eq("equity_5th","low",0.01,1.5)[0]/np.sum(pop[low_income],1)
Ben1_LMI_pc1_5th=NPV_eq("equity_5th","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income],1)
Ben1_UMI_pc1_5th=NPV_eq("equity_5th","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income],1)
Ben1_HI_pc1_5th=NPV_eq("equity_5th","high",0.01,1.5)[0]/np.sum(pop[high_income],1)

df_ben1_eq_pc1_5th=pd.DataFrame({"Total": Ben1_t_pc1_5th,
                     "LI": Ben1_LI_pc1_5th,
                     "LMI": Ben1_LMI_pc1_5th,
                     "UMI": Ben1_UMI_pc1_5th,
                     "HI": Ben1_HI_pc1_5th})

df_ben1_eq_pc1_5th.to_csv('results/equity/period_equity_weighted_benefits_15_EQUITY_pc1_5th.csv')

Ben1_t_pc1_95th=NPV_eq("equity_95th","tot",0.01,1.5)[0]/np.sum(pop,1)
Ben1_LI_pc1_95th=NPV_eq("equity_95th","low",0.01,1.5)[0]/np.sum(pop[low_income],1)
Ben1_LMI_pc1_95th=NPV_eq("equity_95th","lower middle",0.01,1.5)[0]/np.sum(pop[lower_middle_income],1)
Ben1_UMI_pc1_95th=NPV_eq("equity_95th","upper middle",0.01,1.5)[0]/np.sum(pop[upper_middle_income],1)
Ben1_HI_pc1_95th=NPV_eq("equity_95th","high",0.01,1.5)[0]/np.sum(pop[high_income],1)

df_ben1_eq_pc1_95th=pd.DataFrame({"Total": Ben1_t_pc1_95th,
                     "LI": Ben1_LI_pc1_95th,
                     "LMI": Ben1_LMI_pc1_95th,
                     "UMI": Ben1_UMI_pc1_95th,
                     "HI": Ben1_HI_pc1_95th})

df_ben1_eq_pc1_95th.to_csv('results/equity/period_equity_weighted_benefits_15_EQUITY_pc1_95th.csv')




#eta=1
Ben1_t1_mean=NPV_eq("equity_mean","tot",0.01,1)[0]
Ben1_LI1_mean=NPV_eq("equity_mean","low",0.01,1)[0]
Ben1_LMI1_mean=NPV_eq("equity_mean","lower middle",0.01,1)[0]
Ben1_UMI1_mean=NPV_eq("equity_mean","upper middle",0.01,1)[0]
Ben1_HI1_mean=NPV_eq("equity_mean","high",0.01,1)[0]

df_ben1_eq1_mean=pd.DataFrame({"Total": Ben1_t1_mean,
                     "LI": Ben1_LI1_mean,
                     "LMI": Ben1_LMI1_mean,
                     "UMI": Ben1_UMI1_mean,
                     "HI": Ben1_HI1_mean})

df_ben1_eq1_mean.to_csv('results/equity/period_equity_weighted_benefits_1_EQUITY_mean.csv')

Ben1_t1_5th=NPV_eq("equity_5th","tot",0.01,1)[0]
Ben1_LI1_5th=NPV_eq("equity_5th","low",0.01,1)[0]
Ben1_LMI1_5th=NPV_eq("equity_5th","lower middle",0.01,1)[0]
Ben1_UMI1_5th=NPV_eq("equity_5th","upper middle",0.01,1)[0]
Ben1_HI1_5th=NPV_eq("equity_5th","high",0.01,1)[0]

df_ben1_eq1_5th=pd.DataFrame({"Total": Ben1_t1_5th,
                     "LI": Ben1_LI1_5th,
                     "LMI": Ben1_LMI1_5th,
                     "UMI": Ben1_UMI1_5th,
                     "HI": Ben1_HI1_5th})

df_ben1_eq1_5th.to_csv('results/equity/period_equity_weighted_benefits_1_EQUITY_5th.csv')

Ben1_t1_95th=NPV_eq("equity_95th","tot",0.01,1)[0]
Ben1_LI1_95th=NPV_eq("equity_95th","low",0.01,1)[0]
Ben1_LMI1_95th=NPV_eq("equity_95th","lower middle",0.01,1)[0]
Ben1_UMI1_95th=NPV_eq("equity_95th","upper middle",0.01,1)[0]
Ben1_HI1_95th=NPV_eq("equity_95th","high",0.01,1)[0]

df_ben1_eq1_95th=pd.DataFrame({"Total": Ben1_t1_95th,
                     "LI": Ben1_LI1_95th,
                     "LMI": Ben1_LMI1_95th,
                     "UMI": Ben1_UMI1_95th,
                     "HI": Ben1_HI1_95th})

df_ben1_eq1_95th.to_csv('results/equity/period_equity_weighted_benefits_1_EQUITY_95th.csv')






#eta=2
Ben1_t2_mean=NPV_eq("equity_mean","tot",0.01,2)[0]
Ben1_LI2_mean=NPV_eq("equity_mean","low",0.01,2)[0]
Ben1_LMI2_mean=NPV_eq("equity_mean","lower middle",0.01,2)[0]
Ben1_UMI2_mean=NPV_eq("equity_mean","upper middle",0.01,2)[0]
Ben1_HI2_mean=NPV_eq("equity_mean","high",0.01,2)[0]

df_ben1_eq2_mean=pd.DataFrame({"Total": Ben1_t2_mean,
                     "LI": Ben1_LI2_mean,
                     "LMI": Ben1_LMI2_mean,
                     "UMI": Ben1_UMI2_mean,
                     "HI": Ben1_HI2_mean})

df_ben1_eq2_mean.to_csv('results/equity/period_equity_weighted_benefits_2_EQUITY_mean.csv')

Ben1_t2_5th=NPV_eq("equity_5th","tot",0.01,2)[0]
Ben1_LI2_5th=NPV_eq("equity_5th","low",0.01,2)[0]
Ben1_LMI2_5th=NPV_eq("equity_5th","lower middle",0.01,2)[0]
Ben1_UMI2_5th=NPV_eq("equity_5th","upper middle",0.01,2)[0]
Ben1_HI2_5th=NPV_eq("equity_5th","high",0.01,2)[0]

df_ben1_eq2_5th=pd.DataFrame({"Total": Ben1_t2_5th,
                     "LI": Ben1_LI2_5th,
                     "LMI": Ben1_LMI2_5th,
                     "UMI": Ben1_UMI2_5th,
                     "HI": Ben1_HI2_5th})

df_ben1_eq2_5th.to_csv('results/equity/period_equity_weighted_benefits_2_EQUITY_5th.csv')

Ben1_t2_95th=NPV_eq("equity_95th","tot",0.01,2)[0]
Ben1_LI2_95th=NPV_eq("equity_95th","low",0.01,2)[0]
Ben1_LMI2_95th=NPV_eq("equity_95th","lower middle",0.01,2)[0]
Ben1_UMI2_95th=NPV_eq("equity_95th","upper middle",0.01,2)[0]
Ben1_HI2_95th=NPV_eq("equity_95th","high",0.01,2)[0]

df_ben1_eq2_95th=pd.DataFrame({"Total": Ben1_t2_95th,
                     "LI": Ben1_LI2_95th,
                     "LMI": Ben1_LMI2_95th,
                     "UMI": Ben1_UMI2_95th,
                     "HI": Ben1_HI2_95th})

df_ben1_eq2_95th.to_csv('results/equity/period_equity_weighted_benefits_2_EQUITY_95th.csv')






Benu1_t_mean=NPV_uniform("equity_mean","tot",0.01,1.5)[0]
Benu1_LI_mean=NPV_uniform("equity_mean","low",0.01,1.5)[0]
Benu1_LMI_mean=NPV_uniform("equity_mean","lower middle",0.01,1.5)[0]
Benu1_UMI_mean=NPV_uniform("equity_mean","upper middle",0.01,1.5)[0]
Benu1_HI_mean=NPV_uniform("equity_mean","high",0.01,1.5)[0]

df_ben_u1_mean=pd.DataFrame({"Total": Benu1_t_mean,
                     "LI": Benu1_LI_mean,
                     "LMI": Benu1_LMI_mean,
                     "UMI": Benu1_UMI_mean,
                     "HI": Benu1_HI_mean})

df_ben_u1_mean.to_csv('results/equity/period_uniform_VSL_benefit_EQUITY_mean.csv')

Benu1_t_5th=NPV_uniform("equity_5th","tot",0.01,1.5)[0]
Benu1_LI_5th=NPV_uniform("equity_5th","low",0.01,1.5)[0]
Benu1_LMI_5th=NPV_uniform("equity_5th","lower middle",0.01,1.5)[0]
Benu1_UMI_5th=NPV_uniform("equity_5th","upper middle",0.01,1.5)[0]
Benu1_HI_5th=NPV_uniform("equity_5th","high",0.01,1.5)[0]

df_ben_u1_5th=pd.DataFrame({"Total": Benu1_t_5th,
                     "LI": Benu1_LI_5th,
                     "LMI": Benu1_LMI_5th,
                     "UMI": Benu1_UMI_5th,
                     "HI": Benu1_HI_5th})

df_ben_u1_5th.to_csv('results/equity/period_uniform_VSL_benefit_EQUITY_5th.csv')

Benu1_t_95th=NPV_uniform("equity_95th","tot",0.01,1.5)[0]
Benu1_LI_95th=NPV_uniform("equity_95th","low",0.01,1.5)[0]
Benu1_LMI_95th=NPV_uniform("equity_95th","lower middle",0.01,1.5)[0]
Benu1_UMI_95th=NPV_uniform("equity_95th","upper middle",0.01,1.5)[0]
Benu1_HI_95th=NPV_uniform("equity_95th","high",0.01,1.5)[0]

df_ben_u1_95th=pd.DataFrame({"Total": Benu1_t_95th,
                     "LI": Benu1_LI_95th,
                     "LMI": Benu1_LMI_95th,
                     "UMI": Benu1_UMI_95th,
                     "HI": Benu1_HI_95th})

df_ben_u1_95th.to_csv('results/equity/period_uniform_VSL_benefit_EQUITY_95th.csv')







#############################################
#Equity-weighted mitigation costs over time

#eta=1.5
Mit_t_mean=NPV_eq("efficiency_mean","tot",0.01,1.5)[7]
Mit_LI_mean=NPV_eq("efficiency_mean","low",0.01,1.5)[7]
Mit_LMI_mean=NPV_eq("efficiency_mean","lower middle",0.01,1.5)[7]
Mit_UMI_mean=NPV_eq("efficiency_mean","upper middle",0.01,1.5)[7]
Mit_HI_mean=NPV_eq("efficiency_mean","high",0.01,1.5)[7]

df_mit_eq_mean=pd.DataFrame({"Total": Mit_t_mean,
                     "LI": Mit_LI_mean,
                     "LMI": Mit_LMI_mean,
                     "UMI": Mit_UMI_mean,
                     "HI": Mit_HI_mean})

df_mit_eq_mean.to_csv('results/efficiency/period_equity_weighted_mitigation_15_EFFICIENCY_mean.csv')

Mit_t_5th=NPV_eq("efficiency_5th","tot",0.01,1.5)[7]
Mit_LI_5th=NPV_eq("efficiency_5th","low",0.01,1.5)[7]
Mit_LMI_5th=NPV_eq("efficiency_5th","lower middle",0.01,1.5)[7]
Mit_UMI_5th=NPV_eq("efficiency_5th","upper middle",0.01,1.5)[7]
Mit_HI_5th=NPV_eq("efficiency_5th","high",0.01,1.5)[7]

df_mit_eq_5th=pd.DataFrame({"Total": Mit_t_5th,
                     "LI": Mit_LI_5th,
                     "LMI": Mit_LMI_5th,
                     "UMI": Mit_UMI_5th,
                     "HI": Mit_HI_5th})

df_mit_eq_5th.to_csv('results/efficiency/period_equity_weighted_mitigation_15_EFFICIENCY_5th.csv')

Mit_t_95th=NPV_eq("efficiency_95th","tot",0.01,1.5)[7]
Mit_LI_95th=NPV_eq("efficiency_95th","low",0.01,1.5)[7]
Mit_LMI_95th=NPV_eq("efficiency_95th","lower middle",0.01,1.5)[7]
Mit_UMI_95th=NPV_eq("efficiency_95th","upper middle",0.01,1.5)[7]
Mit_HI_95th=NPV_eq("efficiency_95th","high",0.01,1.5)[7]

df_mit_eq_95th=pd.DataFrame({"Total": Mit_t_95th,
                     "LI": Mit_LI_95th,
                     "LMI": Mit_LMI_95th,
                     "UMI": Mit_UMI_95th,
                     "HI": Mit_HI_95th})

df_mit_eq_95th.to_csv('results/efficiency/period_equity_weighted_mitigation_15_EFFICIENCY_95th.csv')





Mit1_t_mean=NPV_eq("equity_mean","tot",0.01,1.5)[7]
Mit1_LI_mean=NPV_eq("equity_mean","low",0.01,1.5)[7]
Mit1_LMI_mean=NPV_eq("equity_mean","lower middle",0.01,1.5)[7]
Mit1_UMI_mean=NPV_eq("equity_mean","upper middle",0.01,1.5)[7]
Mit1_HI_mean=NPV_eq("equity_mean","high",0.01,1.5)[7]

df_mit1_eq_mean=pd.DataFrame({"Total": Mit1_t_mean,
                     "LI": Mit1_LI_mean,
                     "LMI": Mit1_LMI_mean,
                     "UMI": Mit1_UMI_mean,
                     "HI": Mit1_HI_mean})

df_mit1_eq_mean.to_csv('results/equity/period_equity_weighted_mitigation_15_EQUITY_mean.csv')

Mit1_t_5th=NPV_eq("equity_5th","tot",0.01,1.5)[7]
Mit1_LI_5th=NPV_eq("equity_5th","low",0.01,1.5)[7]
Mit1_LMI_5th=NPV_eq("equity_5th","lower middle",0.01,1.5)[7]
Mit1_UMI_5th=NPV_eq("equity_5th","upper middle",0.01,1.5)[7]
Mit1_HI_5th=NPV_eq("equity_5th","high",0.01,1.5)[7]

df_mit1_eq_5th=pd.DataFrame({"Total": Mit1_t_5th,
                     "LI": Mit1_LI_5th,
                     "LMI": Mit1_LMI_5th,
                     "UMI": Mit1_UMI_5th,
                     "HI": Mit1_HI_5th})

df_mit1_eq_5th.to_csv('results/equity/period_equity_weighted_mitigation_15_EQUITY_5th.csv')

Mit1_t_95th=NPV_eq("equity_95th","tot",0.01,1.5)[7]
Mit1_LI_95th=NPV_eq("equity_95th","low",0.01,1.5)[7]
Mit1_LMI_95th=NPV_eq("equity_95th","lower middle",0.01,1.5)[7]
Mit1_UMI_95th=NPV_eq("equity_95th","upper middle",0.01,1.5)[7]
Mit1_HI_95th=NPV_eq("equity_95th","high",0.01,1.5)[7]

df_mit1_eq_95th=pd.DataFrame({"Total": Mit1_t_95th,
                     "LI": Mit1_LI_95th,
                     "LMI": Mit1_LMI_95th,
                     "UMI": Mit1_UMI_95th,
                     "HI": Mit1_HI_95th})

df_mit1_eq_95th.to_csv('results/equity/period_equity_weighted_mitigation_15_EQUITY_95th.csv')






#Equity-weighted climate damages over time
Dam_t_mean=NPV_eq("efficiency_mean","tot",0.01,1.5)[8]
Dam_LI_mean=NPV_eq("efficiency_mean","low",0.01,1.5)[8]
Dam_LMI_mean=NPV_eq("efficiency_mean","lower middle",0.01,1.5)[8]
Dam_UMI_mean=NPV_eq("efficiency_mean","upper middle",0.01,1.5)[8]
Dam_HI_mean=NPV_eq("efficiency_mean","high",0.01,1.5)[8]

df_dam_eq_mean=pd.DataFrame({"Total": Dam_t_mean,
                     "LI": Dam_LI_mean,
                     "LMI": Dam_LMI_mean,
                     "UMI": Dam_UMI_mean,
                     "HI": Dam_HI_mean})

df_dam_eq_mean.to_csv('results/efficiency/period_equity_weighted_damages_15_EFFICIENCY_mean.csv')

Dam_t_5th=NPV_eq("efficiency_5th","tot",0.01,1.5)[8]
Dam_LI_5th=NPV_eq("efficiency_5th","low",0.01,1.5)[8]
Dam_LMI_5th=NPV_eq("efficiency_5th","lower middle",0.01,1.5)[8]
Dam_UMI_5th=NPV_eq("efficiency_5th","upper middle",0.01,1.5)[8]
Dam_HI_5th=NPV_eq("efficiency_5th","high",0.01,1.5)[8]

df_dam_eq_5th=pd.DataFrame({"Total": Dam_t_5th,
                     "LI": Dam_LI_5th,
                     "LMI": Dam_LMI_5th,
                     "UMI": Dam_UMI_5th,
                     "HI": Dam_HI_5th})

df_dam_eq_5th.to_csv('results/efficiency/period_equity_weighted_damages_15_EFFICIENCY_5th.csv')


Dam_t_95th=NPV_eq("efficiency_95th","tot",0.01,1.5)[8]
Dam_LI_95th=NPV_eq("efficiency_95th","low",0.01,1.5)[8]
Dam_LMI_95th=NPV_eq("efficiency_95th","lower middle",0.01,1.5)[8]
Dam_UMI_95th=NPV_eq("efficiency_95th","upper middle",0.01,1.5)[8]
Dam_HI_95th=NPV_eq("efficiency_95th","high",0.01,1.5)[8]

df_dam_eq_95th=pd.DataFrame({"Total": Dam_t_95th,
                     "LI": Dam_LI_95th,
                     "LMI": Dam_LMI_95th,
                     "UMI": Dam_UMI_95th,
                     "HI": Dam_HI_95th})

df_dam_eq_95th.to_csv('results/efficiency/period_equity_weighted_damages_15_EFFICIENCY_95th.csv')






Dam1_t=NPV_eq("equity","tot",0.01,1.5)[8]
Dam1_LI=NPV_eq("equity","low",0.01,1.5)[8]
Dam1_LMI=NPV_eq("equity","lower middle",0.01,1.5)[8]
Dam1_UMI=NPV_eq("equity","upper middle",0.01,1.5)[8]
Dam1_HI=NPV_eq("equity","high",0.01,1.5)[8]

df_dam1_eq=pd.DataFrame({"Total": Dam1_t,
                     "LI": Dam1_LI,
                     "LMI": Dam1_LMI,
                     "UMI": Dam1_UMI,
                     "HI": Dam1_HI})

df_dam1_eq.to_csv('results/equity/period_equity_weighted_damages_15_EQUITY.csv')


#Equity-weighted climate deaths over time
Ccd_t=NPV_eq("efficiency","tot",0.01,1.5)[9]
Ccd_LI=NPV_eq("efficiency","low",0.01,1.5)[9]
Ccd_LMI=NPV_eq("efficiency","lower middle",0.01,1.5)[9]
Ccd_UMI=NPV_eq("efficiency","upper middle",0.01,1.5)[9]
Ccd_HI=NPV_eq("efficiency","high",0.01,1.5)[9]

df_ccd_eq=pd.DataFrame({"Total": Ccd_t,
                     "LI": Ccd_LI,
                     "LMI": Ccd_LMI,
                     "UMI": Ccd_UMI,
                     "HI": Ccd_HI})

df_ccd_eq.to_csv('results/efficiency/period_equity_weighted_climate_deaths_15_EFFICIENCY.csv')


Ccd1_t=NPV_eq("equity","tot",0.01,1.5)[9]
Ccd1_LI=NPV_eq("equity","low",0.01,1.5)[9]
Ccd1_LMI=NPV_eq("equity","lower middle",0.01,1.5)[9]
Ccd1_UMI=NPV_eq("equity","upper middle",0.01,1.5)[9]
Ccd1_HI=NPV_eq("equity","high",0.01,1.5)[9]

df_ccd1_eq=pd.DataFrame({"Total": Ccd1_t,
                     "LI": Ccd1_LI,
                     "LMI": Ccd1_LMI,
                     "UMI": Ccd1_UMI,
                     "HI": Ccd1_HI})

df_ccd1_eq.to_csv('results/equity/period_equity_weighted_climate_deaths_15_EQUITY.csv')



#Equity-weighted air deaths over time
Ad_t=NPV_eq("efficiency","tot",0.01,1.5)[10]
Ad_LI=NPV_eq("efficiency","low",0.01,1.5)[10]
Ad_LMI=NPV_eq("efficiency","lower middle",0.01,1.5)[10]
Ad_UMI=NPV_eq("efficiency","upper middle",0.01,1.5)[10]
Ad_HI=NPV_eq("efficiency","high",0.01,1.5)[10]

df_aird_eq=pd.DataFrame({"Total": Ad_t,
                     "LI": Ad_LI,
                     "LMI": Ad_LMI,
                     "UMI": Ad_UMI,
                     "HI": Ad_HI})

df_aird_eq.to_csv('results/efficiency/period_equity_weighted_air_deaths_15_EFFICIENCY.csv')


Ad1_t=NPV_eq("equity","tot",0.01,1.5)[10]
Ad1_LI=NPV_eq("equity","low",0.01,1.5)[10]
Ad1_LMI=NPV_eq("equity","lower middle",0.01,1.5)[10]
Ad1_UMI=NPV_eq("equity","upper middle",0.01,1.5)[10]
Ad1_HI=NPV_eq("equity","high",0.01,1.5)[10]

df_aird1_eq=pd.DataFrame({"Total": Ad1_t,
                     "LI": Ad1_LI,
                     "LMI": Ad1_LMI,
                     "UMI": Ad1_UMI,
                     "HI": Ad1_HI})

df_aird1_eq.to_csv('results/equity/period_equity_weighted_air_deaths_15_EQUITY.csv')





#########################
## Average equity weight by country group
y_LI=np.sum(gdp[low_income],1)/np.sum(pop[low_income],1)
y_LMI=np.sum(gdp[lower_middle_income],1)/np.sum(pop[lower_middle_income],1)
y_UMI=np.sum(gdp[upper_middle_income],1)/np.sum(pop[upper_middle_income],1)
y_HI=np.sum(gdp[high_income],1)/np.sum(pop[high_income],1)

w_LI=weight(1.5)[1]*(y_LI)**(-1.5)
w_LMI=weight(1.5)[1]*(y_LMI)**(-1.5)
w_UMI=weight(1.5)[1]*(y_UMI)**(-1.5)
w_HI=weight(1.5)[1]*(y_HI)**(-1.5)

df_w=pd.DataFrame({"LI": w_LI,
                     "LMI": w_LMI,
                     "UMI": w_UMI,
                     "HI": w_HI})

df_w.to_csv('results/weights.csv')




##############
## Varying normative parameters; total net benefits
eta_range=np.arange(0,3.5,0.5)
rho_range=np.array([0.001,0.005,0.01,0.015,0.02,0.05])

sol_eq=np.zeros((len(eta_range),len(rho_range)))
sol_ef=np.zeros((len(eta_range),len(rho_range)))
for i in range(len(eta_range)):
    for j in range(len(rho_range)):
        eta=eta_range[i]
        rho=rho_range[j]
        sol_ef[i,j]=NPV_eq('efficiency','tot',rho,eta)[1]
        sol_eq[i,j]=NPV_eq('equity','tot',rho,eta)[1]


df_sol_ef=pd.DataFrame({"eta": ["0", "0.5", "1", '1.5', '2', '2.5','3'],
                        "rho=0.1%": sol_ef[:,0],
                        "rho=0.5%": sol_ef[:,1],
                        "rho=1%": sol_ef[:,2],
                        "rho=1.5%": sol_ef[:,3],
                       "rho=2%": sol_ef[:,4],
                       "rho=5%": sol_ef[:,5]})


df_sol_eq=pd.DataFrame({"eta": ["0","0.5", "1", '1.5', '2', '2.5','3'],
                        "rho=0.1%": sol_eq[:,0],
                        "rho=0.5%": sol_eq[:,1],
                        "rho=1%": sol_eq[:,2],
                        "rho=1.5%": sol_eq[:,3],
                        "rho=2%": sol_eq[:,4],
                        "rho=5%": sol_eq[:,5]})

df_sol_eq.to_csv('results/equity/sensitivity_EQUITY.csv')
df_sol_ef.to_csv('results/efficiency/sensitivity_EFFICIENCY.csv')


#########################################################
## Results by country


df_c_ef=pd.DataFrame({"eta=1": NPV_country('efficiency',0.01,1)[0],
                      "eta=1.5": NPV_country('efficiency',0.01,1.5)[0],
                      "eta=2": NPV_country('efficiency',0.01,2)[0],
                      "eta=2.5": NPV_country('efficiency',0.01,2.5)[0],
                      "eta=3": NPV_country('efficiency',0.01,3)[0]})


df_c_eq=pd.DataFrame({"eta=1": NPV_country('equity',0.01,1)[0],
                      "eta=1.5": NPV_country('equity',0.01,1.5)[0],
                      "eta=2": NPV_country('equity',0.01,2)[0],
                      "eta=2.5": NPV_country('equity',0.01,2.5)[0],
                      "eta=3": NPV_country('equity',0.01,3)[0]})


df_c_eq.to_csv('results/equity/country_results_EQUITY.csv')
df_c_ef.to_csv('results/efficiency/country_results_EFFICIENCY.csv')
 
D=pd.DataFrame({"mitigation_2050": NPV_country('efficiency',0.01,1.5)[1],
                "health_coben_2050": NPV_country('efficiency',0.01,1.5)[2],
                "discounted_mit_up_to_2050": NPV_country('efficiency',0.01,1.5)[3],
                "discounted_health_coben_up_to_2050": NPV_country('efficiency',0.01,1.5)[4],
                "discounted_mit": NPV_country('efficiency',0.01,1.5)[5],
                "discounted_health_coben": NPV_country('efficiency',0.01,1.5)[6]})

D1=pd.DataFrame({"mitigation_2050": NPV_country('equity',0.01,1.5)[1],
                "health_coben_2050": NPV_country('equity',0.01,1.5)[2],
                "discounted_mit_up_to_2050": NPV_country('equity',0.01,1.5)[3],
                "discounted_health_coben_up_to_2050": NPV_country('equity',0.01,1.5)[4],
                "discounted_mit": NPV_country('equity',0.01,1.5)[5],
                "discounted_health_coben": NPV_country('equity',0.01,1.5)[6]})


D1.to_csv('results/equity/additional_country_results_EQUITY.csv')
D.to_csv('results/efficiency/additional_country_results_EFFICIENCY.csv')
 

Res_c_eff=NPV_country('efficiency',0.01,1.5)
Res_c_eq=NPV_country('equity',0.01,1.5)


Res_c_eq[7].to_csv('results/equity/country_netbenefits_EQUITY.csv')
Res_c_eq[8].to_csv('results/equity/country_mitigation_EQUITY.csv')
Res_c_eq[10].to_csv('results/equity/country_cdamages_EQUITY.csv')
Res_c_eq[9].to_csv('results/equity/country_aircobenefits_EQUITY.csv')


Res_c_eff[8].to_csv('results/efficiency/country_mitigation_EFFICIENCY.csv')
Res_c_eff[7].to_csv('results/efficiency/country_netbenefits_EFFICIENCY.csv')
Res_c_eff[10].to_csv('results/efficiency/country_cdamages_EFFICIENCY.csv')
Res_c_eff[9].to_csv('results/efficiency/country_aircobenefits_EFFICIENCY.csv')



###############################################################
#Air quality scenario

mitigation=outcomes("equity_mean")[0]
damages=outcomes("equity_mean")[1]
ccdeaths=outcomes("equity_mean")[2]
airdeaths=pd.concat([outcomes("equity_mean")[3],outcomes("efficiency_mean")[3]]).max(level=0)
cost=pd.read_csv('data_for_swf_analysis/policy_costs.csv').set_index('Year') #costs in million 2015 Euro
   

#average exchange rate in 2015: 1euro=1.11USD
#1USD in 2015 = $1.23 in 2022

cost=cost*1.11*1.23 #million 2022 USD

net_benefits=-mitigation+damages+ccdeaths+airdeaths-cost

def NPV_air(group,rho,eta): 
    r=discount_rate(rho=rho,eta=eta)
    d=np.exp(-r) #discount factor
    x_ben=weight(eta)[0]*net_benefits #weighted net benefits, by country and time
    if group=="low":
        ben=weight(eta)[1]*np.sum(x_ben[low_income],1) #sum of weighted net benefits in low-income countries
        
    elif group=="lower middle":
        ben=weight(eta)[1]*np.sum(x_ben[lower_middle_income],1)
        
    elif group=="upper middle":
        ben=weight(eta)[1]*np.sum(x_ben[upper_middle_income],1)
        
    elif group=="high":
        ben=weight(eta)[1]*np.sum(x_ben[high_income],1)
        
    else:
        ben=weight(eta)[1]*np.sum(x_ben,1)
        
        
    npv_ben=np.sum(d*ben)
    
    func = lambda x: np.asarray(x) * np.asarray(weight(eta)[1]*d)
    B=x_ben.apply(func)
    npv=np.sum(B,0)
    
    return npv_ben, npv




df_air=pd.DataFrame({"eta=1": NPV_air('tot',0.01,1)[1],
                      "eta=1.5": NPV_air('tot',0.01,1.5)[1],
                      "eta=2": NPV_air('tot',0.01,2)[1],
                      "eta=2.5": NPV_air('tot',0.01,2.5)[1],
                      "eta=3": NPV_air('tot',0.01,3)[1]})


df_air.to_csv('results/country_results_EQUITY_AIR.csv')



sol_air=np.zeros((len(eta_range),len(rho_range)))
for i in range(len(eta_range)):
    for j in range(len(rho_range)):
        eta=eta_range[i]
        rho=rho_range[j]
        sol_air[i,j]=NPV_air('tot',rho,eta)[0]
        
df_sol_air=pd.DataFrame({"eta": ["0","0.5", "1", '1.5', '2', '2.5','3'],
                        "rho=0.1%": sol_air[:,0],
                        "rho=0.5%": sol_air[:,1],
                        "rho=1%": sol_air[:,2],
                        "rho=1.5%": sol_air[:,3],
                        "rho=2%": sol_air[:,4],
                        "rho=5%": sol_air[:,5]})

df_sol_air.to_csv('results/sensitivity_AIR.csv')

