# Data Collection Guide 
(Publicly available data)

---

## 1. Medicare Durable Medical Equipment, Devices & Supplies
- A series of datasets that provide information on Durable Medical Equipment, Prosthetics, Orthotics and Supplies (DMEPOS) services provided to Original Medicare (fee-for-service) Part B (Medical Insurance) beneficiaries by physicians and other healthcare professionals
- URL: https://data.cms.gov/provider-summary-by-type-of-service/medicare-durable-medical-equipment-devices-supplies
- Key variables/ datapoints
  - Medicare spending on diabetes devices
  - Number of beneficiaries
  - Geographic distribution
  - Average costs per beneficiary


---

## 2. Medicare Part D Spending
- Information on spending for drugs prescribed to Medicare beneficiaries enrolled in Part D (Prescription Drug Coverage) by physicians and other health care providers
- URL: https://data.cms.gov/summary-statistics-on-use-and-payments/medicare-medicaid-spending-by-drug/medicare-part-d-spending-by-drug
- Dashboard URL: https://data.cms.gov/tools/medicare-part-d-drug-spending-dashboard
- Key variables/ datapoints:
  - Average spending per dosage
  - Total spending
  - Total beneficiaries
  - Average spending per beneficiary
  
---

## 3. CDC NHANES - Population Demographics
- National Health and Nutrition Examination Survey (NHANES), a nationwide survey carried out each year, including interview and lab tests
- Relevant variables for diabetes:
  - Diabetes prevalence by age, race, income
  - HbA1c levels by demographics
  - Geographic regions
  - Health outcomes
- 2 methods to get it
  1. Manual download from : https://wwwn.cdc.gov/nchs/nhanes/
  2. Import and download using R with nhanesA R package
- Key Variables:
  - `DIQ010` - Doctor told you have diabetes
  - `DIQ050` - Taking insulin now
  - `LBXGH` - Glycohemoglobin (HbA1c) %
  - `RIDAGEYR` - Age in years
  - `RIAGENDR` - Gender
  - `INDFMPIR` - Family poverty income ratio

