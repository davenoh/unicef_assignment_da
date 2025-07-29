# UNICEF Consultancy Assessment

## 📋 Position the Candidiate Applied
- Learning and Skills Data Analyst Consultant – Req. #581598
- Household Survey Data Analyst Consultant – Req. #581656
- Administrative Data Analyst – Req. #581696
- Microdata Harmonization Consultant – Req. #581699
 
## 🗂️ Overview
This repository contains all scripts, raw data, and documents necessary to reproduce the analysis for estimating the population-weighted coverage of **Antenatal care (ANC4)** and **Skilled birth attendance (SBA)**. 

------------------------------------------------------------------------

## 📁 Repository Structure
<pre lang="markdown"> 
unicef_assignment_da/
 ├── _scripts/
 ├── 01_raw/
 ├── 02_data_processed/
 ├── 03_out/
 ├── 04_document/
 ├── master.log
 ├── user_profile
 ├── run_project
 └── README.md
 </pre>
------------------------------------------------------------------------

## 📝 Purposes of Each Folder and File

- `_scripts/`: Contains the main codebase for data processing, analysis, and reporting as well as 
    * `_setup_project.py`: Sets up the project by generating the necessary folders and empty file shells. It also writes initial content into `user_profile` and `run_project`.
    * `master.do`: Master Stata script that runs `01_cleaning_export.do` and `02_report.stmd` in sequence.
    * `01_cleaning_export.do`: Imports, cleans, and merges data. Also generates a figure used in the final report.
    * `02_report.stmd`: Produces the final HTML report. Includes summary text and embeds the exported figure from the previous step.

- `01_raw/`: Stores the original raw data files.
    * `MNCH_2018-2022.xlsx`: Downloaded two key health service indicator (ANC4 and SBA) from the UNICEF Global Data Repository [`LINK`](https://data.unicef.org/resources/data_explorer/unicef_f/?ag=UNICEF&df=GLOBAL_DATAFLOW&ver=1.0&dq=.MNCH_ANC4+MNCH_SAB.&startPeriod=2018&endPeriod=2022) at the country level for the years **2018–2022**.
    * `On-track and off-track countries.xlsx`: Under-five mortality classification provided by UNICEF D&A Education Team
    * `WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx`: Population data provided by UNICEF D&A Education Team
- `02_data_processed/`: Contains cleaned and merged datasets used for analysis.
    * `country_anc4sba.dta`: A cleaned dataset created from **MNCH_2018-2022.xlsx**, containing antenatal care (ANC4) and skilled birth attendance (SBA) indicators.
    * `country_population.dta`: A cleaned dataset derived from **WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx**, containing country-level population statistics.
    * `country_u5mr_status.dta`: A cleaned dataset based on **On-track and off-track countries.xlsx**, indicating under-5 mortality rate (U5MR) target status.
    * `country_merged.dta`: A merged dataset combining `country_anc4sba.dta`, `country_population.dta`, and `country_u5mr_status.dta` for analysis.
- `03_out/`: Contains a visualization comparing coverage for on-track vs. off-track countries
- `04_document/`: Contains the final HTML report.
- `master_log`: A Stata log file that records all console output from running `master.do`, useful for debugging and verifying execution.
- `user_profile`: A configuration file that stores machine-independent settings, enabling reproducible execution across different systems.
- `run_project`: A script that executes the entire workflow end-to-end, from data processing to HTML report generation.

---

## ▶️ How to Reproduce the Analysis

To reproduce the analysis, follow the steps below:

1. **Update `user_profile`**  
   Open the `user_profile` file in a text editor and revise the following line based on:
   - The **Stata version** installed on your machine (e.g., StataIC, StataMP)
   - The **location** of the Stata application on your system

   Example:
   ```bash
   STATA_CMD="/Applications/Stata/StataIC.app/Contents/MacOS/StataIC"

2. **Run the Project**  
   Once the `user_profile` is correctly configured, you can reproduce the full workflow by:

   - Simply **double-click** the `run_project` script
   - Or, execute the `run_project` script via the terminal:

     ```bash
     bash run_project
     ```

     Alternatively, if the `run_project` script has execute permissions and the current directory is set correctly, you can also run:

     ```bash
     ./run_project
     ```


This will 
- Run the data cleaning and processing data
- Generate necessary intermediate files
- Export a visualization as a png file
- Produce the final HTML report with summary findings and the visual


