-- 1. Create the database
CREATE DATABASE diabetes_proj_db;

-- 2. "Use" it so MySQL knows where to put your tables (CRUCIAL STEP)
USE diabetes_proj_db;

-- examine data
select * FROM medicare_dme_devices_supplies_by_supplier_and_service_2023 
-- select data_year, count(*) FROM medicare_dme_devices_supplies_by_supplier_and_service_2023 
-- group by data_year;
-- WHERE data_year = "2017"
LIMIT 10;

-- 3. Create table
CREATE TABLE dmepos_table (
    Suplr_NPI BIGINT, -- NPI is typically an 10-digit number
    Suplr_Prvdr_Last_Name_Org VARCHAR(255),
    Suplr_Prvdr_First_Name VARCHAR(255),
    Suplr_Prvdr_MI CHAR(1), -- Middle initial is usually one character
    Suplr_Prvdr_Crdntls VARCHAR(255),
    Suplr_Prvdr_Ent_Cd CHAR(1), -- Entity code 'I' (individual) or 'O' (organization)
    Suplr_Prvdr_St1 VARCHAR(255),
    Suplr_Prvdr_St2 VARCHAR(255),
    Suplr_Prvdr_City VARCHAR(255),
    Suplr_Prvdr_State_Abrvtn CHAR(2), -- 2-character state abbreviation
    Suplr_Prvdr_State_FIPS VARCHAR(2), -- FIPS codes are often string representations
    Suplr_Prvdr_Zip5 CHAR(5), -- 5-digit zip code
    Suplr_Prvdr_RUCA_Cat INT, -- Rural-Urban Commuting Area category
    Suplr_Prvdr_RUCA DECIMAL(4,2), -- RUCA codes are often decimals
    Suplr_Prvdr_RUCA_Desc VARCHAR(255),
    Suplr_Prvdr_Cntry CHAR(2), -- Country code
    Suplr_Prvdr_Spclty_Cd VARCHAR(10),
    Suplr_Prvdr_Spclty_Desc VARCHAR(255),
    Suplr_Prvdr_Spclty_Srce VARCHAR(255),
    RBCS_Lvl VARCHAR(10),
    RBCS_Id VARCHAR(10),
    RBCS_Des VARCHAR(255)
    -- You may need to add PRIMARY KEY or other constraints based on your data specifics
);

-- 4. Load data into table
-- Ensure 'local_infile' is enabled in your connection settings
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'Medicare_DME_Devices_Supplies_by_Supplier_and_Service_2023.csv'
INTO TABLE medicare_dme_devices_supplies_by_supplier_and_service_2023
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

-- 5. Add year into the current 2023 table
ALTER TABLE medicare_dme_devices_supplies_by_supplier_and_service_2023
ADD COLUMN data_year INT AFTER Suplr_NPI;

-- Fill it with 2023
SET SQL_SAFE_UPDATES = 0; -- without WHERE clause and safe updates off it will throw error 1175
UPDATE medicare_dme_devices_supplies_by_supplier_and_service_2023 
SET data_year = 2023;
SET SQL_SAFE_UPDATES = 1;


-- FILE 2016
LOAD DATA LOCAL INFILE  'C:/Users/81707/Documents/005 personal project/Diabetes GLP project/Datasets/DMEPOS device data/Medicare_DME_Devices_Supplies_by_Supplier_and_Service_2016/Medicare_DME_Devices_Supplies_by_Supplier_and_Service_2016.csv'
INTO TABLE medicare_dme_devices_supplies_by_supplier_and_service_2023
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Suplr_NPI, 
Suplr_Prvdr_Last_Name_Org,
Suplr_Prvdr_First_Name,
Suplr_Prvdr_MI,
Suplr_Prvdr_Crdntls,
Suplr_Prvdr_Ent_Cd,
Suplr_Prvdr_St1,
Suplr_Prvdr_St2,
Suplr_Prvdr_City,
Suplr_Prvdr_State_Abrvtn,
Suplr_Prvdr_State_FIPS,
Suplr_Prvdr_Zip5,
Suplr_Prvdr_RUCA_Cat,
Suplr_Prvdr_RUCA,
Suplr_Prvdr_RUCA_Desc,
Suplr_Prvdr_Cntry,
Suplr_Prvdr_Spclty_Cd,
Suplr_Prvdr_Spclty_Desc,
Suplr_Prvdr_Spclty_Srce,
RBCS_Lvl,
RBCS_Id,
RBCS_Desc,
HCPCS_Cd,
HCPCS_Desc,
Suplr_Rentl_Ind,
Tot_Suplr_Benes,
Tot_Suplr_Clms,
Tot_Suplr_Srvcs,
Avg_Suplr_Sbmtd_Chrg,
Avg_Suplr_Mdcr_Alowd_Amt,
Avg_Suplr_Mdcr_Pymt_Amt,
Avg_Suplr_Mdcr_Stdzd_Amt)
SET data_year = 2016;

-- FILE 2017 -- must list column names in csv file, in order to let file read in correctly
LOAD DATA LOCAL INFILE  'Medicare_DME_Devices_Supplies_by_Supplier_and_Service_2017.csv'
INTO TABLE medicare_dme_devices_supplies_by_supplier_and_service_2023
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Suplr_NPI, 
Suplr_Prvdr_Last_Name_Org,
Suplr_Prvdr_First_Name,
Suplr_Prvdr_MI,
Suplr_Prvdr_Crdntls,
Suplr_Prvdr_Ent_Cd,
Suplr_Prvdr_St1,
Suplr_Prvdr_St2,
Suplr_Prvdr_City,
Suplr_Prvdr_State_Abrvtn,
Suplr_Prvdr_State_FIPS,
Suplr_Prvdr_Zip5,
Suplr_Prvdr_RUCA_Cat,
Suplr_Prvdr_RUCA,
Suplr_Prvdr_RUCA_Desc,
Suplr_Prvdr_Cntry,
Suplr_Prvdr_Spclty_Cd,
Suplr_Prvdr_Spclty_Desc,
Suplr_Prvdr_Spclty_Srce,
RBCS_Lvl,
RBCS_Id,
RBCS_Desc,
HCPCS_Cd,
HCPCS_Desc,
Suplr_Rentl_Ind,
Tot_Suplr_Benes,
Tot_Suplr_Clms,
Tot_Suplr_Srvcs,
Avg_Suplr_Sbmtd_Chrg,
Avg_Suplr_Mdcr_Alowd_Amt,
Avg_Suplr_Mdcr_Pymt_Amt,
Avg_Suplr_Mdcr_Stdzd_Amt)
SET data_year = 2017;

-- FILE 2018
LOAD DATA LOCAL INFILE  'Medicare_DME_Devices_Supplies_by_Supplier_and_Service_2018.csv'
INTO TABLE medicare_dme_devices_supplies_by_supplier_and_service_2023
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Suplr_NPI, 
Suplr_Prvdr_Last_Name_Org,
Suplr_Prvdr_First_Name,
Suplr_Prvdr_MI,
Suplr_Prvdr_Crdntls,
Suplr_Prvdr_Ent_Cd,
Suplr_Prvdr_St1,
Suplr_Prvdr_St2,
Suplr_Prvdr_City,
Suplr_Prvdr_State_Abrvtn,
Suplr_Prvdr_State_FIPS,
Suplr_Prvdr_Zip5,
Suplr_Prvdr_RUCA_Cat,
Suplr_Prvdr_RUCA,
Suplr_Prvdr_RUCA_Desc,
Suplr_Prvdr_Cntry,
Suplr_Prvdr_Spclty_Cd,
Suplr_Prvdr_Spclty_Desc,
Suplr_Prvdr_Spclty_Srce,
RBCS_Lvl,
RBCS_Id,
RBCS_Desc,
HCPCS_Cd,
HCPCS_Desc,
Suplr_Rentl_Ind,
Tot_Suplr_Benes,
Tot_Suplr_Clms,
Tot_Suplr_Srvcs,
Avg_Suplr_Sbmtd_Chrg,
Avg_Suplr_Mdcr_Alowd_Amt,
Avg_Suplr_Mdcr_Pymt_Amt,
Avg_Suplr_Mdcr_Stdzd_Amt)
SET data_year = 2018;

-- FILE 2019
LOAD DATA LOCAL INFILE  'Medicare_DME_Devices_Supplies_by_Supplier_and_Service_2019.csv'
INTO TABLE medicare_dme_devices_supplies_by_supplier_and_service_2023
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Suplr_NPI, 
Suplr_Prvdr_Last_Name_Org,
Suplr_Prvdr_First_Name,
Suplr_Prvdr_MI,
Suplr_Prvdr_Crdntls,
Suplr_Prvdr_Ent_Cd,
Suplr_Prvdr_St1,
Suplr_Prvdr_St2,
Suplr_Prvdr_City,
Suplr_Prvdr_State_Abrvtn,
Suplr_Prvdr_State_FIPS,
Suplr_Prvdr_Zip5,
Suplr_Prvdr_RUCA_Cat,
Suplr_Prvdr_RUCA,
Suplr_Prvdr_RUCA_Desc,
Suplr_Prvdr_Cntry,
Suplr_Prvdr_Spclty_Cd,
Suplr_Prvdr_Spclty_Desc,
Suplr_Prvdr_Spclty_Srce,
RBCS_Lvl,
RBCS_Id,
RBCS_Desc,
HCPCS_Cd,
HCPCS_Desc,
Suplr_Rentl_Ind,
Tot_Suplr_Benes,
Tot_Suplr_Clms,
Tot_Suplr_Srvcs,
Avg_Suplr_Sbmtd_Chrg,
Avg_Suplr_Mdcr_Alowd_Amt,
Avg_Suplr_Mdcr_Pymt_Amt,
Avg_Suplr_Mdcr_Stdzd_Amt)
SET data_year = 2019;

-- FILE 2020
LOAD DATA LOCAL INFILE  'Medicare_DME_Devices_Supplies_by_Supplier_and_Service_2020.csv'
INTO TABLE medicare_dme_devices_supplies_by_supplier_and_service_2023
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Suplr_NPI, 
Suplr_Prvdr_Last_Name_Org,
Suplr_Prvdr_First_Name,
Suplr_Prvdr_MI,
Suplr_Prvdr_Crdntls,
Suplr_Prvdr_Ent_Cd,
Suplr_Prvdr_St1,
Suplr_Prvdr_St2,
Suplr_Prvdr_City,
Suplr_Prvdr_State_Abrvtn,
Suplr_Prvdr_State_FIPS,
Suplr_Prvdr_Zip5,
Suplr_Prvdr_RUCA_Cat,
Suplr_Prvdr_RUCA,
Suplr_Prvdr_RUCA_Desc,
Suplr_Prvdr_Cntry,
Suplr_Prvdr_Spclty_Cd,
Suplr_Prvdr_Spclty_Desc,
Suplr_Prvdr_Spclty_Srce,
RBCS_Lvl,
RBCS_Id,
RBCS_Desc,
HCPCS_Cd,
HCPCS_Desc,
Suplr_Rentl_Ind,
Tot_Suplr_Benes,
Tot_Suplr_Clms,
Tot_Suplr_Srvcs,
Avg_Suplr_Sbmtd_Chrg,
Avg_Suplr_Mdcr_Alowd_Amt,
Avg_Suplr_Mdcr_Pymt_Amt,
Avg_Suplr_Mdcr_Stdzd_Amt)
SET data_year = 2020;

-- FILE 2021
LOAD DATA LOCAL INFILE  'Medicare_DME_Devices_Supplies_by_Supplier_and_Service_2021.csv'
INTO TABLE medicare_dme_devices_supplies_by_supplier_and_service_2023
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Suplr_NPI, 
Suplr_Prvdr_Last_Name_Org,
Suplr_Prvdr_First_Name,
Suplr_Prvdr_MI,
Suplr_Prvdr_Crdntls,
Suplr_Prvdr_Ent_Cd,
Suplr_Prvdr_St1,
Suplr_Prvdr_St2,
Suplr_Prvdr_City,
Suplr_Prvdr_State_Abrvtn,
Suplr_Prvdr_State_FIPS,
Suplr_Prvdr_Zip5,
Suplr_Prvdr_RUCA_Cat,
Suplr_Prvdr_RUCA,
Suplr_Prvdr_RUCA_Desc,
Suplr_Prvdr_Cntry,
Suplr_Prvdr_Spclty_Cd,
Suplr_Prvdr_Spclty_Desc,
Suplr_Prvdr_Spclty_Srce,
RBCS_Lvl,
RBCS_Id,
RBCS_Desc,
HCPCS_Cd,
HCPCS_Desc,
Suplr_Rentl_Ind,
Tot_Suplr_Benes,
Tot_Suplr_Clms,
Tot_Suplr_Srvcs,
Avg_Suplr_Sbmtd_Chrg,
Avg_Suplr_Mdcr_Alowd_Amt,
Avg_Suplr_Mdcr_Pymt_Amt,
Avg_Suplr_Mdcr_Stdzd_Amt)
SET data_year = 2021;

-- FILE 2022
LOAD DATA LOCAL INFILE  'Medicare_DME_Devices_Supplies_by_Supplier_and_Service_2022.csv'
INTO TABLE medicare_dme_devices_supplies_by_supplier_and_service_2023
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Suplr_NPI, 
Suplr_Prvdr_Last_Name_Org,
Suplr_Prvdr_First_Name,
Suplr_Prvdr_MI,
Suplr_Prvdr_Crdntls,
Suplr_Prvdr_Ent_Cd,
Suplr_Prvdr_St1,
Suplr_Prvdr_St2,
Suplr_Prvdr_City,
Suplr_Prvdr_State_Abrvtn,
Suplr_Prvdr_State_FIPS,
Suplr_Prvdr_Zip5,
Suplr_Prvdr_RUCA_Cat,
Suplr_Prvdr_RUCA,
Suplr_Prvdr_RUCA_Desc,
Suplr_Prvdr_Cntry,
Suplr_Prvdr_Spclty_Cd,
Suplr_Prvdr_Spclty_Desc,
Suplr_Prvdr_Spclty_Srce,
RBCS_Lvl,
RBCS_Id,
RBCS_Desc,
HCPCS_Cd,
HCPCS_Desc,
Suplr_Rentl_Ind,
Tot_Suplr_Benes,
Tot_Suplr_Clms,
Tot_Suplr_Srvcs,
Avg_Suplr_Sbmtd_Chrg,
Avg_Suplr_Mdcr_Alowd_Amt,
Avg_Suplr_Mdcr_Pymt_Amt,
Avg_Suplr_Mdcr_Stdzd_Amt)
SET data_year = 2022;

-- ##################  CREATE View   ##############################
CREATE OR REPLACE VIEW dmepos_diabetes_analysis_view AS
SELECT 
    -- Basic Identifiers
    data_year,
    HCPCS_Cd AS Device_ID,
    HCPCS_Desc AS Device_Name,
    Suplr_Prvdr_Last_Name_Org AS Supplier_name,
    Suplr_Prvdr_State_Abrvtn AS State,
    Suplr_Prvdr_City AS City,
    
    -- Volume and Usage Metrics
    Tot_Suplr_Benes AS Total_Beneficiaries,
    Tot_Suplr_Clms AS Total_Claims,
    Tot_Suplr_Srvcs AS Total_Services_Provided,
    
    -- Financial Metrics
    -- Tot_Suplr_Mdcr_Alowd_Amt AS Total_Medicare_Allowed,
    Avg_Suplr_Mdcr_Alowd_Amt AS Avg_Allowed_Per_Unit,
    -- Calculating Total Spending - SUM must followed by group by clause
    Avg_Suplr_Mdcr_Alowd_Amt * Tot_Suplr_Srvcs AS total_allowed_spending,
    
    -- Standardized Spending (better for YoY comparison) - to compensate cost difference between rural and city areas
    Avg_Suplr_Mdcr_Stdzd_Amt * Tot_Suplr_Srvcs AS total_standardized_spending,
	
    -- Geography info
    -- 2. Mail-Order vs. Local Classification
    -- If a single NPI is serving thousands of patients, it's a National Hub
    CASE 
        WHEN Tot_Suplr_Benes > 5000 THEN 'National Mail-Order'
        ELSE 'Regional/Local'
    END AS Supplier_Distribution_Type,
    
    
    -- Total allowed amount = average allowed amount * total services
	  -- avg allowed amount = what Medicare actually agreed to pay for one unit of that code; total services = total no. of units provided
    -- Helpful Categories for Tableau (Handy for color-coding!)
    CASE 
        WHEN HCPCS_Cd IN ('E2103', 'E2102', 'A4239', 'A4238', 'K0553', 'K0554') THEN 'Modern CGM' -- eg. Dexcom G6, FreeStyle Libre
        WHEN HCPCS_Cd IN ('E0784', 'A9274','A4224', 'A4225') THEN 'Insulin Pumps'
        WHEN HCPCS_Cd IN ('A4253', 'A4259', 'E0607', 'A4258', 'A4271') THEN 'Traditional BGM (fingersticks)'
        ELSE 'Other Diabetes Supply'
    END AS Tech_Category
FROM medicare_dme_devices_supplies_by_supplier_and_service_2023
WHERE (
    -- Direct HCPCS Matches for Glucose Monitors & Pumps
    HCPCS_Cd IN (
        'E2103', 'E2102', 'A4239', 'A4238', 'K0553', 'K0554', -- CGMs
        'E0784', 'A9274', 'A4224', 'A4225', -- insulin pumps
        'A4253', 'A4259', 'E0607', 'A4258', 'A4271' -- Strips, Lancets, BGM
    )
    OR HCPCS_Desc LIKE '%GLUCOSE%'
    OR HCPCS_Desc LIKE '%INSULIN%'
)
-- Remove low-volume outliers or data errors
AND Tot_Suplr_Clms > 0;

-- Export to CSV 
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dmepos_diabetes_analysis_cleaned.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM dmepos_diabetes_analysis_view;



-- Which code to focus: 
-- A4239 (monthly sensors/ transmitters), E2103 initiation of new CGM therapy
-- High-Tech CGMs: Codes like E2103 and A4239 are the "modern" way to manage diabetes. You want to see if these are rising alongside GLP-1 drugs.
-- Traditional Supplies: A4253 (Test Strips) and A4259 (Lancets) are the "old school" finger-prick method. Your hypothesis is that as GLP-1s and CGMs rise, these manual supplies should drop
-- CGM Equipment (The Hardware)
-- - E2103: Non-adjunctive CGM receiver (used to make treatment decisions without a fingerstick).
-- - E2102: Adjunctive CGM receiver (requires a fingerstick to confirm readings before taking action).
-- - K0554: Receiver for a CGM system (this was an older code often used before the transition to the E-series).

-- CGM Supplies (The Recurring Costs)
-- These codes cover the sensors and transmitters required to actually use the system. This is where the OIG found the largest potential for savings.
-- - A4239: Supply allowance for a non-adjunctive CGM (includes all sensors and transmitters).
-- - A4238: Supply allowance for an adjunctive CGM.
-- - K0553: Supply allowance for a therapeutic CGM system (older code).

CREATE VIEW dmepos_diabetes_analysis_view_aggregated AS
SELECT data_year, tech_category, SUM(Total_Beneficiaries), sum(Total_Claims), sum(total_standardized_spending)
FROM dmepos_diabetes_analysis_view
GROUP BY data_year, tech_category;

-- Export to CSV 
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dmepos_diabetes_analysis_aggregated_cleaned.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM dmepos_diabetes_analysis_view_aggregated;
