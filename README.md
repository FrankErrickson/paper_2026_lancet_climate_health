# Replication Code for Energy and Health: Global Climate Policy and the Future of Air Quality Co-Benefits in LMICs.

This repository contains the replication code for Scovronick et al. 2026, which compares different global CO<sub>2</sub> mitigation approaches, considering avoided climate harms, health co-benefits from air quality improvements, and policy costs, while ranking them based on equity preferences across generations and income groups.

## Overview
The work integrates outputs from multiple models and data sources, including:
* GCAM (Global Change Assessment Model) for climate and emissions scenarios as well as CO<sub>2</sub> mitigation costs.
* GEOS-Chem for regional air quality modeling.
* GIVE (Greenhouse Gas Impact Value Estimator) for estimating the climate benefits of climate damages and mitigation actions.

## Folder Structure
The repository is organized into several directories corresponding to the key analysis steps described in the paper:
* <ins>Step 1: Scenario Development (GCAM).</ins>
This folder contains the configuration files and modified XMLs to set up the key scenarios used in the analysis. The GCAM model (version 7.0) is required for this step.
* <ins>Step 2: Air Quality Modeling (Emission Downscale and GEOS-Chem).</ins>
This folder contains:
   * Outputs of regional emissions from the GCAM runs. 
   * Code to process these emissions and transform them into gridded inputs for GEOS-Chem.
   * The GEOS-Chem model for air quality simulations.
   * Gridded PM2.5 concentration outputs for further analysis.
* <ins>Step 3: Health Impact Assessment.</ins>
This folder includes R scripts used to estimate PM2.5-attributable deaths for each scenario and year. Relevant data files are also provided.
* <ins>Step 4: Climate Benefits (GIVE Model).</ins>
This folder contains Julia scripts for estimating climate benefits from the GIVE model (developed under RFF's Social Cost of Carbon Initiative).
* <ins>Step 5: Mitigation Costs (GCAM).</ins>
This folder contains configuration files to run GCAM for obtaining marginal abatement curves and R scripts to calculate mitigation costs associated with each scenario.
* <ins>Step 6: Social Welfare Analysis.</ins>
Folder for social welfare analysis scripts.
* <ins>Step 7: Air Quality Policy Costs.</ins>
Contains the original marginal cost curve from the GAINS model and an R script to calculate the air quality policy costs.
* <ins>Step 8: Figures.</ins>
Includes R scripts to generate the key figures presented in the main text of the paper.

## Requirements
To replicate the analysis, you'll need the following software:
* GCAM (Global Change Assessment Model) v7.0.
* R.
* RStudio (optional but recommended for R script execution).
* Julia (version 1.6 recommended for GIVE).
* Anaconda (for DSCIM module).
