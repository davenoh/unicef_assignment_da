THIS IS TO BE EIDTED FURTHER

Please add the positions you applied for in the final output and your readme. Please do not include your name.
    Learning and Skills Data Analyst Consultant – Req. #581598
    Household Survey Data Analyst Consultant – Req. #581656
    Administrative Data Analyst – Req. #581696
    Microdata Harmonization Consultant – Req. #581699

📝 README file:
    Describe the structure of your repository
    Explain the purpose of each folder and file
    Include instructions on how to reproduce your analysis


# Health Services Coverage Analysis

## Objective
This project calculates the **population-weighted coverage** of two health services:
- **ANC4**: % of women (15–49) with at least 4 antenatal care visits
- **SBA**: % of deliveries attended by skilled personnel  
For countries categorized as **on-track** or **off-track** in achieving under-five mortality targets (2022).

## Repository Structure
- `data/`: Contains input datasets in `.dta` format.
- `scripts/`: Contains Stata `.do` files to clean data and perform analysis.
- `output/`: Stores final tables, logs, and summary reports.
- `user_profile`: Environment setup instructions to ensure reproducibility.
- `run_project`: Master script to run the full analysis in one step.

## Reproducibility Instructions

1. Ensure Stata is installed and added to your system PATH.
2. Clone this repo:
   ```bash
   git clone <your-github-link>
   cd <repo-name>