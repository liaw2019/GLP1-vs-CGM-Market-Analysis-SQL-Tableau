# Data Collection Guide 
(Publicly available data)

---

## 1. Medicare Durable Medical Equipment, Devices & Supplies (DMEPOS)

**Description:** Information on Durable Medical Equipment, Prosthetics, Orthotics and Supplies (DMEPOS) services provided to Original Medicare (fee-for-service) Part B beneficiaries.

**URL:** https://data.cms.gov/provider-summary-by-type-of-service/medicare-durable-medical-equipment-devices-supplies

**Key Variables:**
- Medicare spending on diabetes devices (CGM, insulin pumps, BGM supplies)
- Number of beneficiaries by device type
- Geographic distribution (state, city, rural/urban)
- Average costs per beneficiary
- HCPCS codes for device categorization

**Years Used in Analysis:** 2016-2023

---

## 2. Medicare Part D Prescription Drug Spending

**Description:** Information on prescription drug spending for Medicare beneficiaries enrolled in Part D (Prescription Drug Coverage).

**URL:** https://data.cms.gov/summary-statistics-on-use-and-payments/medicare-medicaid-spending-by-drug/medicare-part-d-spending-by-drug

**Dashboard:** https://data.cms.gov/tools/medicare-part-d-drug-spending-dashboard

**Key Variables:**
- Brand name and generic name
- Total spending per drug
- Total beneficiaries
- Average spending per beneficiary
- Average spending per dosage unit

**Years Used in Analysis:** 2014-2023

**Note:** Used to track GLP-1 medication trends (Ozempic, Mounjaro, Trulicity, etc.)

---

## 3. CDC NHANES - Population Health & Demographics

**Description:** National Health and Nutrition Examination Survey (NHANES), a nationwide survey combining interviews and physical examinations/lab tests.

**Method 1 (manual download):** https://wwwn.cdc.gov/nchs/nhanes/

**Method 2 (import datasets using R):** Used `nhanesA` R package for programmatic data retrieval
- **Benefits:** Automated downloads, consistent variable naming across cycles, no manual SAS file conversion
- **Script:** `Diabetes_NHANES_data_processing.R`
- **Reference:** [nhanesA Survey Weights Vignette](https://cran.r-project.org/web/packages/nhanesA/vignettes/UsingSurveyWeights.html)

**Survey Cycles Used:** 2017-2018 (J), 2019-2020 (K), 2021-2023 (L)

**Key Variables:**
- **Diabetes Diagnosis:** `DIQ010` - Doctor told you have diabetes
- **Treatment:** `DIQ050` - Taking insulin now
- **Lab Results:** `LBXGH` - Glycohemoglobin (HbA1c) %
- **Demographics:** `RIDAGEYR` (Age), `RIAGENDR` (Gender), `RIDRETH3` (Race/ethnicity)
- **Socioeconomic:** `INDFMPIR` - Family poverty income ratio
- **Survey Design:** `WTMEC2YR` (Survey weight), `SDMVSTRA` (Strata), `SDMVPSU` (PSU)

**Key Datasets:**
- DEMO (Demographics)
- DIQ (Diabetes Questionnaire)
- GHB (Glycohemoglobin)
- BMX (Body Measurements)
- RXQ (Prescription Medications)

---
