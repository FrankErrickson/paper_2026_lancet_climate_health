using CSV
using DataFrames
using Mimi
using MimiGIVE
using Query
using Random

# Load GCAM emissions data for four scenarios.
gcam_co2_reference = DataFrame(CSV.File(joinpath("data", "gcam_emissions", "interpolated_emissions", "interpolated_co2_REFERENCE.csv")))
gcam_co2_equity = DataFrame(CSV.File(joinpath("data", "gcam_emissions", "interpolated_emissions", "interpolated_co2_EQUITY.csv")))
gcam_co2_efficiency = DataFrame(CSV.File(joinpath("data", "gcam_emissions", "interpolated_emissions", "interpolated_co2_EFFICIENCY.csv")))
gcam_co2_impacts = DataFrame(CSV.File(joinpath("data", "gcam_emissions", "interpolated_emissions", "interpolated_co2_IMPACTS.csv")))

gcam_other_ghg_reference = DataFrame(CSV.File(joinpath("data", "gcam_emissions", "interpolated_emissions", "interpolated_nonco2_gases_REFERENCE.csv")))
gcam_other_ghg_equity = DataFrame(CSV.File(joinpath("data", "gcam_emissions", "interpolated_emissions", "interpolated_nonco2_gases_EQUITY.csv")))
gcam_other_ghg_efficiency = DataFrame(CSV.File(joinpath("data", "gcam_emissions", "interpolated_emissions", "interpolated_nonco2_gases_EFFICIENCY.csv")))
gcam_other_ghg_impacts = DataFrame(CSV.File(joinpath("data", "gcam_emissions", "interpolated_emissions", "interpolated_nonco2_gases_IMPACTS.csv")))

# Extract array for other well-mixed GHGs from GIVE under the SSP2-RCP45 scenario.
give = MimiGIVE.get_model(socioeconomics_source = :SSP, SSP_scenario = "SSP245")
run(give)
give_other_ghg_raw = give[:other_ghg_cycles, :emiss_other_ghg]

# Get names for other GHGs.
give_other_ghg_names = dim_keys(give, :other_ghg)

# Load the GCAM results raw data and create country list.
gcam_raw = DataFrame(CSV.File("results/gcam_combined_data.csv"))
gcam_countries = gcam_raw[:, "Country Code"]

# Get country list for GIVE.
give_countries = dim_keys(give, :country)

# Find countries common to both models (to subset GIVE damage results so models match).
shared_countries = intersect(give_countries, gcam_countries)


# ----------------------------------------------------
# Replace SSP245 values with GCAM non-CO2 gas values.
# ----------------------------------------------------

# Create copies of GIVE other GHG arrays to swap in GCAM values.
give_other_ghg_reference = deepcopy(give_other_ghg_raw)
give_other_ghg_equity = deepcopy(give_other_ghg_raw)
give_other_ghg_efficiency = deepcopy(give_other_ghg_raw)
give_other_ghg_impacts = deepcopy(give_other_ghg_raw)

# ----- C2F6 ----- #
c2f6_ind = findfirst(x->x=="C2F6", give_other_ghg_names)
give_other_ghg_reference[:,c2f6_ind] = gcam_other_ghg_reference[!,"c2f6"]
give_other_ghg_equity[:,c2f6_ind] = gcam_other_ghg_equity[!,"c2f6"]
give_other_ghg_efficiency[:,c2f6_ind] = gcam_other_ghg_efficiency[!,"c2f6"]
give_other_ghg_impacts[:,c2f6_ind] = gcam_other_ghg_impacts[!,"c2f6"]

# ----- CF4 ----- #
cf4_ind = findfirst(x->x=="CF4", give_other_ghg_names)
give_other_ghg_reference[:,cf4_ind] = gcam_other_ghg_reference[!,"c2f6"]
give_other_ghg_equity[:,cf4_ind] = gcam_other_ghg_equity[!,"c2f6"]
give_other_ghg_efficiency[:,cf4_ind] = gcam_other_ghg_efficiency[!,"c2f6"]
give_other_ghg_impacts[:,cf4_ind] = gcam_other_ghg_impacts[!,"c2f6"]

# ----- HFC125 ----- #
hfc125_ind = findfirst(x->x=="HFC125", give_other_ghg_names)
give_other_ghg_reference[:,hfc125_ind] = gcam_other_ghg_reference[!,"hfc125"]
give_other_ghg_equity[:,hfc125_ind] = gcam_other_ghg_equity[!,"hfc125"]
give_other_ghg_efficiency[:,hfc125_ind] = gcam_other_ghg_efficiency[!,"hfc125"]
give_other_ghg_impacts[:,hfc125_ind] = gcam_other_ghg_impacts[!,"hfc125"]

# ----- HFC134a ----- #
hfc134a_ind = findfirst(x->x=="HFC134a", give_other_ghg_names)
give_other_ghg_reference[:,hfc134a_ind] = gcam_other_ghg_reference[!,"hfc134a"]
give_other_ghg_equity[:,hfc134a_ind] = gcam_other_ghg_equity[!,"hfc134a"]
give_other_ghg_efficiency[:,hfc134a_ind] = gcam_other_ghg_efficiency[!,"hfc134a"]
give_other_ghg_impacts[:,hfc134a_ind] = gcam_other_ghg_impacts[!,"hfc134a"]

# ----- HFC143a ----- #
hfc143a_ind = findfirst(x->x=="HFC143a", give_other_ghg_names)
give_other_ghg_reference[:,hfc143a_ind] = gcam_other_ghg_reference[!,"hfc143a"]
give_other_ghg_equity[:,hfc143a_ind] = gcam_other_ghg_equity[!,"hfc143a"]
give_other_ghg_efficiency[:,hfc143a_ind] = gcam_other_ghg_efficiency[!,"hfc143a"]
give_other_ghg_impacts[:,hfc143a_ind] = gcam_other_ghg_impacts[!,"hfc143a"]

# ----- HFC227ea ----- #
hfc227ea_ind = findfirst(x->x=="HFC227ea", give_other_ghg_names)
give_other_ghg_reference[:,hfc227ea_ind] = gcam_other_ghg_reference[!,"hfc227ea"]
give_other_ghg_equity[:,hfc227ea_ind] = gcam_other_ghg_equity[!,"hfc227ea"]
give_other_ghg_efficiency[:,hfc227ea_ind] = gcam_other_ghg_efficiency[!,"hfc227ea"]
give_other_ghg_impacts[:,hfc227ea_ind] = gcam_other_ghg_impacts[!,"hfc227ea"]

# ----- HFC23 ----- #
hfc23_ind = findfirst(x->x=="HFC23", give_other_ghg_names)
give_other_ghg_reference[:,hfc23_ind] = gcam_other_ghg_reference[!,"hfc23"]
give_other_ghg_equity[:,hfc23_ind] = gcam_other_ghg_equity[!,"hfc23"]
give_other_ghg_efficiency[:,hfc23_ind] = gcam_other_ghg_efficiency[!,"hfc23"]
give_other_ghg_impacts[:,hfc23_ind] = gcam_other_ghg_impacts[!,"hfc23"]

# ----- HFC245fa ----- #
hfc245fa_ind = findfirst(x->x=="HFC245fa", give_other_ghg_names)
give_other_ghg_reference[:,hfc245fa_ind] = gcam_other_ghg_reference[!,"hfc245fa"]
give_other_ghg_equity[:,hfc245fa_ind] = gcam_other_ghg_equity[!,"hfc245fa"]
give_other_ghg_efficiency[:,hfc245fa_ind] = gcam_other_ghg_efficiency[!,"hfc245fa"]
give_other_ghg_impacts[:,hfc245fa_ind] = gcam_other_ghg_impacts[!,"hfc245fa"]

# ----- HFC32 ----- #
hfc32_ind = findfirst(x->x=="HFC32", give_other_ghg_names)
give_other_ghg_reference[:,hfc32_ind] = gcam_other_ghg_reference[!,"hfc32"]
give_other_ghg_equity[:,hfc32_ind] = gcam_other_ghg_equity[!,"hfc32"]
give_other_ghg_efficiency[:,hfc32_ind] = gcam_other_ghg_efficiency[!,"hfc32"]
give_other_ghg_impacts[:,hfc32_ind] = gcam_other_ghg_impacts[!,"hfc32"]

# ----- HFC43-10 ----- #
hfc43_10_ind = findfirst(x->x=="HFC43_10", give_other_ghg_names)
give_other_ghg_reference[:,hfc43_10_ind] = gcam_other_ghg_reference[!,"hfc43_10"]
give_other_ghg_equity[:,hfc43_10_ind] = gcam_other_ghg_equity[!,"hfc43_10"]
give_other_ghg_efficiency[:,hfc43_10_ind] = gcam_other_ghg_efficiency[!,"hfc43_10"]
give_other_ghg_impacts[:,hfc43_10_ind] = gcam_other_ghg_impacts[!,"hfc43_10"]

# ----- SF6 ----- #
sf6_ind = findfirst(x->x=="SF6", give_other_ghg_names)
give_other_ghg_reference[:,sf6_ind] = gcam_other_ghg_reference[!,"sf6"]
give_other_ghg_equity[:,sf6_ind] = gcam_other_ghg_equity[!,"sf6"]
give_other_ghg_efficiency[:,sf6_ind] = gcam_other_ghg_efficiency[!,"sf6"]
give_other_ghg_impacts[:,sf6_ind] = gcam_other_ghg_impacts[!,"sf6"]


# Create an instance of MimiGIVE with SSP2-RCP45 scenarios.
give_reference = MimiGIVE.get_model(socioeconomics_source = :SSP, SSP_scenario = "SSP245")
give_equity = MimiGIVE.get_model(socioeconomics_source = :SSP, SSP_scenario = "SSP245")
give_efficiency = MimiGIVE.get_model(socioeconomics_source = :SSP, SSP_scenario = "SSP245")
give_impacts = MimiGIVE.get_model(socioeconomics_source = :SSP, SSP_scenario = "SSP245")


# ----------------------------------------------------
# Greenhouse Gases Set For Single Components
# ----------------------------------------------------

# ----- CO₂ ----- #
update_param!(give_reference, :co2_emissions_identity, :input_co2, gcam_co2_reference[!,"co2_total"])
update_param!(give_equity, :co2_emissions_identity, :input_co2, gcam_co2_equity[!,"co2_total"])

# ----- CH₄ ----- #
update_param!(give_reference, :ch4_emissions_identity, :input_ch4, gcam_other_ghg_reference[!,"ch4"])
update_param!(give_equity, :ch4_emissions_identity, :input_ch4, gcam_other_ghg_equity[!,"ch4"])

# ----- N₂O ----- #
update_param!(give_reference, :n2o_emissions_identity, :input_n2o, gcam_other_ghg_reference[!,"n2o"])
update_param!(give_equity, :n2o_emissions_identity, :input_n2o, gcam_other_ghg_equity[!,"n2o"])


# ------------------------------------------------------
# Greenhouse Gasses Shared Across Multiple Components
# ------------------------------------------------------

# ----- SOx ----- #
update_param!(give_reference, :ch4_cycle, :fossil_emiss_CH₄, gcam_other_ghg_reference[!,"ch4"])
update_param!(give_equity, :ch4_cycle, :fossil_emiss_CH₄, gcam_other_ghg_equity[!,"ch4"])
update_param!(give_efficiency, :ch4_cycle, :fossil_emiss_CH₄, gcam_other_ghg_efficiency[!,"ch4"])
update_param!(give_impacts, :ch4_cycle, :fossil_emiss_CH₄, gcam_other_ghg_impacts[!,"ch4"])

# ----- Black Carbon ----- #
update_param!(give_reference, :BC_emiss, gcam_other_ghg_reference[!,"bc"])
update_param!(give_equity, :BC_emiss, gcam_other_ghg_equity[!,"bc"])
update_param!(give_efficiency, :BC_emiss, gcam_other_ghg_efficiency[!,"bc"])
update_param!(give_impacts, :BC_emiss, gcam_other_ghg_impacts[!,"bc"])

# ----- Organic Carbon ----- #
update_param!(give_reference, :OC_emiss, gcam_other_ghg_reference[!,"oc"])
update_param!(give_equity, :OC_emiss, gcam_other_ghg_equity[!,"oc"])
update_param!(give_efficiency, :OC_emiss, gcam_other_ghg_efficiency[!,"oc"])
update_param!(give_impacts, :OC_emiss, gcam_other_ghg_impacts[!,"oc"])

# ----- CO ----- #
update_param!(give_reference, :CO_emiss, gcam_other_ghg_reference[!,"co"])
update_param!(give_equity, :CO_emiss, gcam_other_ghg_equity[!,"co"])
update_param!(give_efficiency, :CO_emiss, gcam_other_ghg_efficiency[!,"co"])
update_param!(give_impacts, :CO_emiss, gcam_other_ghg_impacts[!,"co"])

# ----- NMVOC ----- #
update_param!(give_reference, :NMVOC_emiss, gcam_other_ghg_reference[!,"nmvoc"])
update_param!(give_equity, :NMVOC_emiss, gcam_other_ghg_equity[!,"nmvoc"])
update_param!(give_efficiency, :NMVOC_emiss, gcam_other_ghg_efficiency[!,"nmvoc"])
update_param!(give_impacts, :NMVOC_emiss, gcam_other_ghg_impacts[!,"nmvoc"])

# ----- NH₃ ----- #
update_param!(give_reference, :NH3_emiss, gcam_other_ghg_reference[!,"nh3"])
update_param!(give_equity, :NH3_emiss, gcam_other_ghg_equity[!,"nh3"])
update_param!(give_efficiency, :NH3_emiss, gcam_other_ghg_efficiency[!,"nh3"])
update_param!(give_impacts, :NH3_emiss, gcam_other_ghg_impacts[!,"nh3"])

# ----- NOx ----- #
update_param!(give_reference, :NOx_emiss, gcam_other_ghg_reference[!,"nox"])
update_param!(give_equity, :NOx_emiss, gcam_other_ghg_equity[!,"nox"])
update_param!(give_efficiency, :NOx_emiss, gcam_other_ghg_efficiency[!,"nox"])
update_param!(give_impacts, :NOx_emiss, gcam_other_ghg_impacts[!,"nox"])

# ----- Land Use CO₂ ----- #
update_param!(give_reference, :landuse_emiss, gcam_co2_reference[!,"co2_landuse"])
update_param!(give_equity, :landuse_emiss, gcam_co2_equity[!,"co2_landuse"])
update_param!(give_efficiency, :landuse_emiss, gcam_co2_efficiency[!,"co2_landuse"])
update_param!(give_impacts, :landuse_emiss, gcam_co2_impacts[!,"co2_landuse"])

# ----- Other Well-Mixd Greenhouse Gases ----- #
update_param!(give_reference, :emiss_other_ghg, give_other_ghg_reference)
update_param!(give_equity, :emiss_other_ghg, give_other_ghg_equity)
update_param!(give_efficiency, :emiss_other_ghg, give_other_ghg_efficiency)
update_param!(give_impacts, :emiss_other_ghg, give_other_ghg_impacts)


# Create a list of variables to save from GIVE Monte Carlo with GCAM emissions.
save_list = [(:DamageAggregator, :damage_ag_countries),
(:DamageAggregator, :damage_energy),
(:CromarMortality, :mortality_costs),
(:CromarMortality, :excess_deaths)]

# Number of trials to run
n_runs = 1000

# Set the same seed as used in Rennert et al. 2022
rennert_seed = 24523438

# Run Monte Carlo with Rennert et al. seed.
Random.seed!(rennert_seed); mcs_reference = MimiGIVE.run_mcs(trials=n_runs, save_list=save_list, m=give_reference);
Random.seed!(rennert_seed); mcs_equity = MimiGIVE.run_mcs(trials=n_runs, save_list=save_list, m=give_equity);
Random.seed!(rennert_seed); mcs_efficiency = MimiGIVE.run_mcs(trials=n_runs, save_list=save_list, m=give_efficiency);
Random.seed!(rennert_seed); mcs_impacts = MimiGIVE.run_mcs(trials=n_runs, save_list=save_list, m=give_impacts);

###################################################################
# Subset damages from 2030-2100 & countries common to GCAM + GIVE
###################################################################

# --- Agriculture --- #
agriculture_raw_reference = getdataframe(mcs_reference, :DamageAggregator, :damage_ag_countries) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)
agriculture_raw_equity = getdataframe(mcs_equity, :DamageAggregator, :damage_ag_countries) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)
agriculture_raw_efficiency = getdataframe(mcs_efficiency, :DamageAggregator, :damage_ag_countries) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)
agriculture_raw_impacts = getdataframe(mcs_impacts, :DamageAggregator, :damage_ag_countries) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)

# --- Energy --- #
energy_raw_reference = getdataframe(mcs_reference, :DamageAggregator, :damage_energy) |> @filter(_.time >= 2030 && _.time <= 2100 && _.energy_countries in shared_countries)
energy_raw_equity = getdataframe(mcs_equity, :DamageAggregator, :damage_energy) |> @filter(_.time >= 2030 && _.time <= 2100 && _.energy_countries in shared_countries)
energy_raw_efficiency = getdataframe(mcs_efficiency, :DamageAggregator, :damage_energy) |> @filter(_.time >= 2030 && _.time <= 2100 && _.energy_countries in shared_countries)
energy_raw_impacts = getdataframe(mcs_impacts, :DamageAggregator, :damage_energy) |> @filter(_.time >= 2030 && _.time <= 2100 && _.energy_countries in shared_countries)

# --- Monetized Deaths --- #
monetized_deaths_raw_reference = getdataframe(mcs_reference, :CromarMortality, :mortality_costs) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)
monetized_deaths_raw_equity = getdataframe(mcs_equity, :CromarMortality, :mortality_costs) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)
monetized_deaths_raw_efficiency = getdataframe(mcs_efficiency, :CromarMortality, :mortality_costs) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)
monetized_deaths_raw_impacts = getdataframe(mcs_impacts, :CromarMortality, :mortality_costs) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)

# --- Excess Deaths --- #
excess_deaths_raw_reference = getdataframe(mcs_reference, :CromarMortality, :excess_deaths) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)
excess_deaths_raw_equity = getdataframe(mcs_equity, :CromarMortality, :excess_deaths) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)
excess_deaths_raw_efficiency = getdataframe(mcs_efficiency, :CromarMortality, :excess_deaths) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)
excess_deaths_raw_impacts = getdataframe(mcs_impacts, :CromarMortality, :excess_deaths) |> @filter(_.time >= 2030 && _.time <= 2100 && _.country in shared_countries)


#####################################
# Group/sum damages across countries
#####################################

# --- Agriculture --- #
agriculture_reference =  agriculture_raw_reference |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.damage_ag_countries)}) |> DataFrame
agriculture_equity =  agriculture_raw_equity |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.damage_ag_countries)}) |> DataFrame
agriculture_efficiency =  agriculture_raw_efficiency |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.damage_ag_countries)}) |> DataFrame
agriculture_impacts =  agriculture_raw_impacts |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.damage_ag_countries)}) |> DataFrame

# --- Energy --- #
energy_reference =  energy_raw_reference |> @groupby({_.time, _.energy_countries}) |> @map({key(_)..., damages = sum(_.damage_energy)}) |> DataFrame
energy_equity =  energy_raw_equity |> @groupby({_.time, _.energy_countries}) |> @map({key(_)..., damages = sum(_.damage_energy)}) |> DataFrame
energy_efficiency =  energy_raw_efficiency |> @groupby({_.time, _.energy_countries}) |> @map({key(_)..., damages = sum(_.damage_energy)}) |> DataFrame
energy_impacts =  energy_raw_impacts |> @groupby({_.time, _.energy_countries}) |> @map({key(_)..., damages = sum(_.damage_energy)}) |> DataFrame

# --- Monetized Deaths --- #
monetized_deaths_reference =  monetized_deaths_raw_reference |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.mortality_costs)}) |> DataFrame
monetized_deaths_equity =  monetized_deaths_raw_equity |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.mortality_costs)}) |> DataFrame
monetized_deaths_efficiency =  monetized_deaths_raw_efficiency |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.mortality_costs)}) |> DataFrame
monetized_deaths_impacts =  monetized_deaths_raw_impacts |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.mortality_costs)}) |> DataFrame

# --- Excess Deaths --- #
excess_deaths_reference =  excess_deaths_raw_reference |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.excess_deaths)}) |> DataFrame
excess_deaths_equity =  excess_deaths_raw_equity |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.excess_deaths)}) |> DataFrame
excess_deaths_efficiency =  excess_deaths_raw_efficiency |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.excess_deaths)}) |> DataFrame
excess_deaths_impacts =  excess_deaths_raw_impacts |> @groupby({_.time, _.country}) |> @map({key(_)..., damages = sum(_.excess_deaths)}) |> DataFrame


################################################
# Average damages across GIVE parameter samples
################################################

# --- Agriculture --- #
agriculture_reference.avg_damages = agriculture_reference.damages ./ n_runs
agriculture_equity.avg_damages = agriculture_equity.damages ./ n_runs
agriculture_efficiency.avg_damages = agriculture_efficiency.damages ./ n_runs
agriculture_impacts.avg_damages = agriculture_impacts.damages ./ n_runs

# --- Energy --- #
energy_reference.avg_damages = energy_reference.damages ./ n_runs
energy_equity.avg_damages = energy_equity.damages ./ n_runs
energy_efficiency.avg_damages = energy_efficiency.damages ./ n_runs
energy_impacts.avg_damages = energy_impacts.damages ./ n_runs

# --- Monetized Deaths --- #
monetized_deaths_reference.avg_damages = monetized_deaths_reference.damages ./ n_runs
monetized_deaths_equity.avg_damages = monetized_deaths_equity.damages ./ n_runs
monetized_deaths_efficiency.avg_damages = monetized_deaths_efficiency.damages ./ n_runs
monetized_deaths_impacts.avg_damages = monetized_deaths_impacts.damages ./ n_runs

# --- Excess Deaths --- #
excess_deaths_reference.avg_damages = excess_deaths_reference.damages ./ n_runs
excess_deaths_equity.avg_damages = excess_deaths_equity.damages ./ n_runs
excess_deaths_efficiency.avg_damages = excess_deaths_efficiency.damages ./ n_runs
excess_deaths_impacts.avg_damages = excess_deaths_impacts.damages ./ n_runs


######################################################
# Adjust damages units and convert to 2022 US dollars
#####################################################

# Set term to adjust dollar values from $US 2005 to 2022 (using same data from Rennert et al; https://apps.bea.gov/iTable/?reqid=19&step=3&isuri=1&select_all_years=0&nipa_table_list=13&series=a&first_year=1995&last_year=2022&scale=-99&categories=survey&thetable=)
inflate_2005_to_2022 = 1.4471773995782

# --- Agriculture --- #
# Adjust agriculture units from $billions => $millions and 2005 => 2022 dollars to match GCAM units.
agriculture_reference.avg_damages_adjusted = agriculture_reference.avg_damages .* 1000 .* inflate_2005_to_2022
agriculture_equity.avg_damages_adjusted = agriculture_equity.avg_damages .* 1000 .* inflate_2005_to_2022
agriculture_efficiency.avg_damages_adjusted = agriculture_efficiency.avg_damages .* 1000 .* inflate_2005_to_2022
agriculture_impacts.avg_damages_adjusted = agriculture_impacts.avg_damages .* 1000 .* inflate_2005_to_2022

# --- Energy --- #
# Adjust energy units from $billions => $millions and 2005 => 2022 dollars to match GCAM units.
energy_reference.avg_damages_adjusted = energy_reference.avg_damages .* 1e3 .* inflate_2005_to_2022
energy_equity.avg_damages_adjusted = energy_equity.avg_damages .* 1e3 .* inflate_2005_to_2022
energy_efficiency.avg_damages_adjusted = energy_efficiency.avg_damages .* 1e3 .* inflate_2005_to_2022
energy_impacts.avg_damages_adjusted = energy_impacts.avg_damages .* 1e3 .* inflate_2005_to_2022


# --- Monetized Deaths --- #
# Adjust monetized deaths units from $dollars => $millions and 2005 => 2022 dollars to match GCAM units.
monetized_deaths_reference.avg_damages_adjusted = monetized_deaths_reference.avg_damages ./ 1e6 .* inflate_2005_to_2022
monetized_deaths_equity.avg_damages_adjusted = monetized_deaths_equity.avg_damages ./ 1e6 .* inflate_2005_to_2022
monetized_deaths_efficiency.avg_damages_adjusted = monetized_deaths_efficiency.avg_damages ./ 1e6 .* inflate_2005_to_2022
monetized_deaths_impacts.avg_damages_adjusted = monetized_deaths_impacts.avg_damages ./ 1e6 .* inflate_2005_to_2022

# --- Excess Deaths --- #

# No unit changes required for excess deaths (already in persons/year).



#################################################
# Unstack damages to be in Year x Country arrays
#################################################

# --- Agriculture --- #
agriculture_reference_array = unstack(agriculture_reference, :time, :country, :avg_damages_adjusted)
agriculture_equity_array = unstack(agriculture_equity, :time, :country, :avg_damages_adjusted)
agriculture_efficiency_array = unstack(agriculture_efficiency, :time, :country, :avg_damages_adjusted)
agriculture_impacts_array = unstack(agriculture_impacts, :time, :country, :avg_damages_adjusted)


# --- Energy --- #
energy_reference_array = unstack(energy_reference, :time, :energy_countries, :avg_damages_adjusted)
energy_equity_array = unstack(energy_equity, :time, :energy_countries, :avg_damages_adjusted)
energy_efficiency_array = unstack(energy_efficiency, :time, :energy_countries, :avg_damages_adjusted)
energy_impacts_array = unstack(energy_impacts, :time, :energy_countries, :avg_damages_adjusted)


# --- Monetized Deaths --- #
monetized_deaths_reference_array = unstack(monetized_deaths_reference, :time, :country, :avg_damages_adjusted)
monetized_deaths_equity_array = unstack(monetized_deaths_equity, :time, :country, :avg_damages_adjusted)
monetized_deaths_efficiency_array = unstack(monetized_deaths_efficiency, :time, :country, :avg_damages_adjusted)
monetized_deaths_impacts_array = unstack(monetized_deaths_impacts, :time, :country, :avg_damages_adjusted)


# --- Excess Deaths --- #
excess_deaths_reference_array = unstack(excess_deaths_reference, :time, :country, :avg_damages)
excess_deaths_equity_array = unstack(excess_deaths_equity, :time, :country, :avg_damages)
excess_deaths_efficiency_array = unstack(excess_deaths_efficiency, :time, :country, :avg_damages)
excess_deaths_impacts_array = unstack(excess_deaths_impacts, :time, :country, :avg_damages)


#################
# Save results.
#################


# --- Agriculture --- #
CSV.write(joinpath("results", "data_for_swf_analysis", "reference_scenario", "give_agriculture_REFERENCE.csv"), agriculture_reference_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "equity_scenario", "give_agriculture_EQUITY.csv"), agriculture_equity_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "efficiency_scenario", "give_agriculture_EFFICIENCY.csv"), agriculture_efficiency_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "impacts_scenario", "give_agriculture_IMPACTS.csv"), agriculture_impacts_array)

# --- Energy --- #
CSV.write(joinpath("results", "data_for_swf_analysis", "reference_scenario", "give_energy_REFERENCE.csv"), energy_reference_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "equity_scenario", "give_energy_EQUITY.csv"), energy_equity_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "efficiency_scenario", "give_energy_EFFICIENCY.csv"), energy_efficiency_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "impacts_scenario", "give_energy_IMPACTS.csv"), energy_impacts_array)


# --- Monetized Deaths --- #
CSV.write(joinpath("results", "data_for_swf_analysis", "reference_scenario", "give_monetized_deaths_REFERENCE.csv"), monetized_deaths_reference_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "equity_scenario", "give_monetized_deaths_EQUITY.csv"), monetized_deaths_equity_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "efficiency_scenario", "give_monetized_deaths_EFFICIENCY.csv"), monetized_deaths_efficiency_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "impacts_scenario", "give_monetized_deaths_IMPACTS.csv"), monetized_deaths_impacts_array)


# --- Excess Deaths --- #
CSV.write(joinpath("results", "data_for_swf_analysis", "reference_scenario", "give_excess_deaths_REFERENCE.csv"), excess_deaths_reference_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "equity_scenario", "give_excess_deaths_EQUITY.csv"), excess_deaths_equity_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "efficiency_scenario", "give_excess_deaths_EFFICIENCY.csv"), excess_deaths_efficiency_array)
CSV.write(joinpath("results", "data_for_swf_analysis", "impacts_scenario", "give_excess_deaths_IMPACTS.csv"), excess_deaths_impacts_array)

# END
