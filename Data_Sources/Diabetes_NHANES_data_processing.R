# ============================================
# NHANES Data Import & Processing Pipeline
# ============================================
# Purpose: Import and merge NHANES survey data (2017-2023) for diabetes 
#          population analysis with proper survey weighting
#
# Data Source: CDC NHANES via nhanesA R package
# Survey Cycles: 2017-2018 (J), 2019-2020 (K), 2021-2023 (L)
#
# Key Features:
# - Automated survey weight handling (WTMEC2YR)
# - Multi-cycle data merging (demographics, diabetes, labs, medications)
# - Population-representative prevalence calculations (using survey weight)
#
# Reference: nhanesA package documentation
# https://cran.r-project.org/web/packages/nhanesA/vignettes/UsingSurveyWeights.html
# Author: Liaw
# Last Updated: 2025-03-06
# ============================================

# ============================================
# 1. SETUP & LIBRARIES
# ============================================
library(nhanesA) 
library(survey)
library(dplyr)
library(tidyr)
library(RSQLite)

# Install packages if not available
# install.packages(c("nhanesA", "survey", "dplyr", "RSQLite"))

# ============================================
# 2. DOWNLOAD & LABEL CYCLES (Demographics)
# ============================================

# Cycle I (2015-2016)
demo_i <- nhanes("DEMO_I") %>% 
  mutate(survey_year_label = "2015-2016", trend_year = 2016, survey_weight = WTMEC2YR)

# Cycle P (2017-March 2020)
demo_p <- nhanes("P_DEMO") %>% 
  mutate(survey_year_label = "2017-2020", trend_year = 2019, survey_weight = WTMECPRP)

# Cycle L (2021-2023)
demo_l <- nhanes("DEMO_L") %>% 
  mutate(survey_year_label = "2021-2023", trend_year = 2022, survey_weight = WTMEC2YR)

# Combine Demographics (The Anchor)
demo_all <- bind_rows(
  demo_i %>% select(SEQN, survey_year_label, trend_year, survey_weight, SDMVSTRA, SDMVPSU, RIDAGEYR, RIAGENDR, RIDRETH3),
  demo_p %>% select(SEQN, survey_year_label, trend_year, survey_weight, SDMVSTRA, SDMVPSU, RIDAGEYR, RIAGENDR, RIDRETH3),
  demo_l %>% select(SEQN, survey_year_label, trend_year, survey_weight, SDMVSTRA, SDMVPSU, RIDAGEYR, RIAGENDR, RIDRETH3)
)

# ============================================
# 3. MERGE ALL CYLCES INTO ONE DATAFRAME
# ============================================

# Combine Questionnaire (Diabetes), Lab (HbA1c), and Body Measures
diq_all <- bind_rows(nhanes("DIQ_I"), nhanes("P_DIQ"), nhanes("DIQ_L"))
ghb_all <- bind_rows(nhanes("GHB_I"), nhanes("P_GHB"), nhanes("GHB_L"))
bmx_all <- bind_rows(nhanes("BMX_I"), nhanes("P_BMX"), nhanes("BMX_L"))

# Prescription Drugs (Flagging specific meds to keep the data 1-row-per-person)
rx_raw <- bind_rows(nhanes("RXQ_RX_I"), nhanes("P_RXQ_RX"), nhanes("RXQ_RX_L"))

rx_flags <- rx_raw %>%
  group_by(SEQN) %>%
  summarize(
    takes_metformin = max(ifelse(grepl("METFORMIN", RXDDRUG, ignore.case = TRUE), 1, 0), na.rm = TRUE),
    takes_insulin = max(ifelse(grepl("INSULIN", RXDDRUG, ignore.case = TRUE), 1, 0), na.rm = TRUE)
  )

# ============================================
# 4.NHANES DATA MERGING & CLEANING
# ============================================

# Merge all datasets
df_master <- demo_all %>%
  left_join(diq_all, by = "SEQN") %>%
  left_join(ghb_all, by = "SEQN") %>%
  left_join(bmx_all, by = "SEQN") %>%
  left_join(rx_flags, by = "SEQN") %>%
  
  # Select and rename columns
  select(
    # Survey design variables
    patient_id = SEQN,
    survey_strata = SDMVSTRA,
    survey_psu = SDMVPSU,
    survey_weight = survey_weight,
    survey_year = coalesce(survey_year, survey_year.x),  # Handle joined column names
    
    # Demographics
    age = RIDAGEYR,
    gender = RIAGENDR,
    race = RIDRETH3,
    
    # Diabetes diagnosis & treatment
    diabetes_dx = DIQ010,
    age_at_diagnosis = DID040,
    taking_insulin = DIQ050,
    
    # Lab values
    hba1c = LBXGH,
    
    # Physical measures
    weight_kg = BMXWT,
    height_cm = BMXHT,
    bmi = BMXBMI,
    
    # Medication flags (from rx_flags join)
    takes_metformin,
    takes_insulin
  ) %>%
  
  # Create categorical variables for Tableau
  mutate(
    # Age groups
    age_group = case_when(
      age < 18 ~ "0-17",
      age < 25 ~ "18-24",
      age < 35 ~ "25-34",
      age < 45 ~ "35-44",
      age < 55 ~ "45-54",
      age < 65 ~ "55-64",
      TRUE ~ "65+"
    ),
    
    # Diabetes status (readable labels)
    diabetes_status = case_when(
      diabetes_dx == 1 ~ "Yes",
      diabetes_dx == 2 ~ "No",
      diabetes_dx == 3 ~ "Borderline",
      TRUE ~ "Don't Know"
    ),
    
    # Gender labels
    gender_label = case_when(
      gender == 1 ~ "Male",
      gender == 2 ~ "Female",
      TRUE ~ "Other"
    ),
    
    # Race/ethnicity labels
    race_label = case_when(
      race == 1 ~ "Mexican American",
      race == 2 ~ "Other Hispanic",
      race == 3 ~ "Non-Hispanic White",
      race == 4 ~ "Non-Hispanic Black",
      race == 6 ~ "Non-Hispanic Asian",
      TRUE ~ "Other/Multi"
    ),
    
    # Clinical diabetes status (includes undiagnosed)
    diabetes_clinical = case_when(
      diabetes_status == "Yes" ~ "Diagnosed",
      hba1c >= 6.5 ~ "Undiagnosed",
      hba1c >= 5.7 ~ "Prediabetic",
      TRUE ~ "Normal"
    ),
    
    # Treatment category
    treatment_category = case_when(
      takes_insulin == 1 & takes_metformin == 1 ~ "Combination Therapy",
      takes_insulin == 1 ~ "Insulin Only",
      takes_metformin == 1 ~ "Metformin Only",
      diabetes_status == "Yes" ~ "No Medication Reported",
      TRUE ~ "Not Applicable"
    )
  ) %>%
  
  # Replace NA in medication flags with 0
  mutate(across(c(takes_metformin, takes_insulin), ~replace_na(., 0))) %>%
  
  # Filter valid records
  filter(!is.na(survey_weight))

# ============================================
# 5. SURVEY DESIGN & ANALYSIS
# ============================================

nhanes_design <- svydesign(
  id = ~strata_psu, 
  strata = ~survey_strata, 
  weights = ~survey_weight, 
  data = df_master, 
  nest = TRUE
)
    
# Weighted HbA1c Trend
hba1c_trend <- svyby(~hba1c, ~trend_year, nhanes_design, svymean, na.rm=TRUE)

patient_data <- df %>%
  mutate(
    weighted_count = survey_weight / sum(survey_weight, na.rm = TRUE) * nrow(df)
  ) %>%
  select(patient_id, age_group, gender, diabetes_status, hba1c, bmi, weighted_count)

# ============================================
# 6. EXPORT TO CSV
# ============================================

write.csv(df_master, "nhanes_final_tableau_ready.csv", row.names = FALSE)
write.csv(hba1c_trend, "nhanes_hba1c_trend_summary.csv", row.names = FALSE)
write.csv(patient_data, "nhanes_patient_data.csv", row.names = FALSE)

print("CSV export completed")

# ============================================
# 7. EXPORT TO SQLite (Optional)
# ============================================

con <- dbConnect(RSQLite::SQLite(), "nhanes_diabetes.db")

dbWriteTable(con, "diabetes_prevalence", prevalence_by_age, overwrite = TRUE)
dbWriteTable(con, "hba1c_summary", hba1c_by_age, overwrite = TRUE)
dbWriteTable(con, "patient_details", patient_data, overwrite = TRUE)

dbDisconnect(con)

print("Data exported to SQL db successfully!")
