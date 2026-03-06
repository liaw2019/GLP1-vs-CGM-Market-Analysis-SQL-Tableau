-- ============================================
-- MEDICARE PART D - 10 YEAR ANALYSIS VIEWS
-- ============================================

-- STEP 1: Rename tables (run once after GUI import)
ALTER TABLE `medicare part d 2019-2023 spending utilization - cleaned` 
RENAME TO `medicare_d_spending_2019_2023`;

ALTER TABLE `medicare part d 2019-2023 manufacturer summary` 
RENAME TO `medicare_d_manufacturer_spend_2019_2023`;

-- STEP 2: Fix column names (run once)
ALTER TABLE medicare_d_spending_2019_2023
CHANGE COLUMN `Brand Name` `Brand_Name` TEXT,
CHANGE COLUMN `Generic Name` `Generic_Name` TEXT;

ALTER TABLE medicare_d_spending_2014_2018
CHANGE COLUMN `Brand Name` `Brand_Name` TEXT,
CHANGE COLUMN `Generic Name` `Generic_Name` TEXT;

-- ============================================
-- VIEW 1: Complete 10-Year Spending & Beneficiaries
-- ============================================
CREATE OR REPLACE VIEW v_medicare_part_d_10yr AS
SELECT 
    COALESCE(t1.Brand_Name, t2.Brand_Name) AS Brand_Name,
    COALESCE(t1.Generic_Name, t2.Generic_Name) AS Generic_Name,
    
    -- Spending 2014-2023
    t2.`2014_Total Spending`, t2.`2015_Total Spending`, 
    t2.`2016_Total Spending`, t2.`2017_Total Spending`, t2.`2018_Total Spending`,
    t1.`2019_Total Spending`, t1.`2020_Total Spending`, 
    t1.`2021_Total Spending`, t1.`2022_Total Spending`, t1.`2023_Total Spending`,
    
    -- Beneficiaries 2014-2023
    t2.`2014_Total Beneficiaries`, t2.`2015_Total Beneficiaries`,
    t2.`2016_Total Beneficiaries`, t2.`2017_Total Beneficiaries`, t2.`2018_Total Beneficiaries`,
    t1.`2019_Total Beneficiaries`, t1.`2020_Total Beneficiaries`,
    t1.`2021_Total Beneficiaries`, t1.`2022_Total Beneficiaries`, t1.`2023_Total Beneficiaries`

FROM medicare_d_spending_2019_2023 t1
LEFT JOIN medicare_d_spending_2014_2018 t2 
    ON t1.Brand_Name = t2.Brand_Name 
    AND t1.Generic_Name = t2.Generic_Name;

-- ============================================
-- VIEW 2: GLP-1 Drugs Only (For Your Project)
-- ============================================
CREATE OR REPLACE VIEW v_glp1_drugs_10yr AS
SELECT * 
FROM v_medicare_part_d_10yr
WHERE Brand_Name IN (
    'Ozempic', 'Wegovy', 'Rybelsus',      -- Semaglutide
    'Trulicity',                           -- Dulaglutide
    'Victoza', 'Saxenda',                  -- Liraglutide
    'Mounjaro', 'Zepbound',                -- Tirzepatide
    'Byetta', 'Bydureon'                   -- Exenatide
);

-- ============================================
-- EXPORT TO CSV (Optional)
-- ============================================

-- All drugs 10-year
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicare_part_d_10yr_all.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
FROM v_medicare_part_d_10yr;

-- GLP-1 only
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicare_part_d_10yr_glp1.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
FROM v_glp1_drugs_10yr;

-- ============================================
-- QUICK VERIFICATION QUERIES
-- ============================================

-- Check GLP-1 drug count
SELECT COUNT(*) as glp1_drug_count FROM v_glp1_drugs_10yr;

-- See 2023 top spenders
SELECT Brand_Name, Generic_Name, `2023_Total Spending`, `2023_Total Beneficiaries`
FROM v_glp1_drugs_10yr
ORDER BY CAST(REPLACE(`2023_Total Spending`, '$', '') AS DECIMAL) DESC
LIMIT 10;
