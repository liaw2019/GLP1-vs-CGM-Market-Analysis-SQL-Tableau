-- ============================================
-- NHANES DIABETES ANALYSIS
-- ============================================

USE diabetes_proj_db;

-- ============================================
-- MAIN ANALYTICS VIEW
-- ============================================

CREATE OR REPLACE VIEW v_nhanes_diabetes_analytics AS
SELECT 
    -- Identifiers & Survey Design
    SEQN AS patient_id,
    survey_year_label AS survey_cycle,
    trend_year,
    survey_weight AS weight_mec_2yr,
    SDMVSTRA AS survey_strata,
    SDMVPSU AS survey_psu,

    -- Demographics
    RIDAGEYR AS age,
    CASE
        WHEN RIDAGEYR < 18 THEN '0-17'
        WHEN RIDAGEYR BETWEEN 18 AND 24 THEN '18-24'
        WHEN RIDAGEYR BETWEEN 25 AND 34 THEN '25-34'
        WHEN RIDAGEYR BETWEEN 35 AND 44 THEN '35-44'
        WHEN RIDAGEYR BETWEEN 45 AND 54 THEN '45-54'
        WHEN RIDAGEYR BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    
    CASE WHEN RIAGENDR = 1 THEN 'Male' 
         WHEN RIAGENDR = 2 THEN 'Female' 
         ELSE 'Other' END AS gender,
         
    CASE 
        WHEN RIDRETH3 = 1 THEN 'Mexican American'
        WHEN RIDRETH3 = 2 THEN 'Other Hispanic'
        WHEN RIDRETH3 = 3 THEN 'Non-Hispanic White'
        WHEN RIDRETH3 = 4 THEN 'Non-Hispanic Black'
        WHEN RIDRETH3 = 6 THEN 'Non-Hispanic Asian'
        ELSE 'Other/Multi'
    END AS race_ethnicity,
    
    -- Diabetes Status
    DIQ010 AS diabetes_diagnosis,
    DID040 AS age_at_diagnosis,
    LBXGH AS hba1c_pct,
    
    CASE 
        WHEN UPPER(DIQ010) = 'YES' THEN 'Diagnosed'
        WHEN LBXGH >= 6.5 THEN 'Undiagnosed'
        WHEN LBXGH BETWEEN 5.7 AND 6.49 THEN 'Prediabetic'
        ELSE 'Normal'
    END AS diabetes_clinical_status,

    -- Physical Measures
    BMXWT AS body_weight_kg,
    BMXHT AS body_height_cm,
    BMXBMI AS body_mass_index,
    BMXWAIST AS waist_circumference_cm,

    -- Medications
    takes_metformin,
    takes_insulin,
    
    CASE 
        WHEN takes_insulin = 1 AND takes_metformin = 1 THEN 'Combination Therapy'
        WHEN takes_insulin = 1 THEN 'Insulin Only'
        WHEN takes_metformin = 1 THEN 'Metformin Only'
        WHEN UPPER(DIQ010) = 'YES' THEN 'No Medication Reported'
        ELSE 'Not Applicable'
    END AS treatment_category,
    
    -- Pre-calculated for Tableau weighted averages
    (LBXGH * survey_weight) AS weighted_hba1c_numerator
    
FROM nhanes_final_tableau_ready;

-- ============================================
-- EXPORT TO CSV
-- ============================================

SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nhanes_diabetes_analytics.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
FROM v_nhanes_diabetes_analytics;

-- ============================================
-- KEY ANALYSIS QUERIES (For Dashboard/Validation)
-- ============================================

-- 1. Diabetes Prevalence by Year (Weighted - Diagnosed + Undiagnosed)
SELECT 
    trend_year,
    ROUND(SUM(CASE WHEN UPPER(diabetes_diagnosis) = 'YES' THEN weight_mec_2yr ELSE 0 END) / 1000000, 1) AS diagnosed_millions,
    ROUND(SUM(CASE WHEN UPPER(diabetes_diagnosis) != 'YES' AND hba1c_pct >= 6.5 THEN weight_mec_2yr ELSE 0 END) / 1000000, 1) AS undiagnosed_millions,
    ROUND((SUM(CASE WHEN UPPER(diabetes_diagnosis) = 'YES' OR hba1c_pct >= 6.5 THEN weight_mec_2yr ELSE 0 END) / SUM(weight_mec_2yr)) * 100, 1) AS total_prevalence_pct
FROM v_nhanes_diabetes_analytics
GROUP BY trend_year
ORDER BY trend_year;

-- 2. Weighted Average HbA1c by Year (All Population)
SELECT 
    trend_year,
    ROUND(SUM(hba1c_pct * weight_mec_2yr) / SUM(weight_mec_2yr), 2) AS weighted_avg_hba1c
FROM v_nhanes_diabetes_analytics
WHERE hba1c_pct IS NOT NULL
GROUP BY trend_year
ORDER BY trend_year;

-- 3. Weighted Average HbA1c by Year (Diabetics Only)
SELECT 
    trend_year,
    ROUND(SUM(hba1c_pct * weight_mec_2yr) / SUM(weight_mec_2yr), 2) AS weighted_avg_hba1c_diabetic
FROM v_nhanes_diabetes_analytics
WHERE UPPER(diabetes_diagnosis) = 'YES' AND hba1c_pct IS NOT NULL
GROUP BY trend_year
ORDER BY trend_year;

-- 4. Age Group Distribution (Weighted Population %)
SELECT 
    age_group, 
    ROUND((SUM(weight_mec_2yr) / (SELECT SUM(weight_mec_2yr) FROM v_nhanes_diabetes_analytics)) * 100, 1) AS weighted_pop_pct
FROM v_nhanes_diabetes_analytics
GROUP BY age_group
ORDER BY age_group;

-- 5. Treatment Status Impact on HbA1c (Diagnosed Diabetics)
SELECT 
    diabetes_diagnosis,
    CASE WHEN takes_insulin = 1 OR takes_metformin = 1 THEN 'On Medication' ELSE 'No Medication' END AS treatment_status,
    ROUND(AVG(hba1c_pct), 2) AS avg_hba1c,
    COUNT(*) AS sample_size
FROM v_nhanes_diabetes_analytics
WHERE UPPER(diabetes_diagnosis) = 'YES'
GROUP BY diabetes_diagnosis, treatment_status;

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check sample sizes by year
SELECT trend_year, COUNT(*) as total_records,
       COUNT(CASE WHEN diabetes_diagnosis = 'Yes' THEN 1 END) as diagnosed_diabetics
FROM v_nhanes_diabetes_analytics
GROUP BY trend_year;

-- Check clinical status distribution
SELECT diabetes_clinical_status, COUNT(*) as count
FROM v_nhanes_diabetes_analytics
GROUP BY diabetes_clinical_status;
