# The Modern Diabetes Landscape: GLP-1 vs CGM Market Analysis
**Tools**: SQL | Tableau | R

**An end-to-end SQL &amp; Tableau analysis  tracking the shift from traditional blood glucose monitoring to continuous glucose monitoring (CGM) devices alongside GLP-1 medication adoption**

[Tableau public link](https://public.tableau.com/views/DiabetesGLPproject/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Project Overview: The Modern Diabetes Landscape
This project analyzes changes in diabetes care within the Medicare population using CMS public datasets (2016-2023). The analysis examines two parallel trends: the rapid growth of GLP-1 medications (like Ozempic and Trulicity) and the adoption of continuous glucose monitoring (CGM) devices.

Using CMS Open Data (2016-2023), this study tracks how spending has transitioned from traditional blood glucose monitoring (fingersticks) toward high-cost continuous glucose monitoring (CGM) devices in alignment with the increased adoption of GLP-1 therapeutics.

### Strategic Observation: GLP-1 & CGM Convergent Ecosystem
- **Drivers of Therapeutic Expansio**: The rapid acceleration in GLP-1 expenditure through 2023 reflects increased patient volume, driven by the expansion of FDA-approved indications for Type 2 diabetes management and widespread adoption across diverse patient cohorts.
- **Synergistic Growth Correlation**: GLP-1 spending and CGM spending exhibit a strong positive correlation, signaling a shift toward "dual-modality" metabolic management, where pharmaceutical therapy and real-time digital monitoring are increasingly used in tandem.
- **Market Maturity & "White Space" Opportunity**: A rising per-beneficiary spending despite a decline in total beneficiary counts might sugest a structural shift toward more sophisticated, premium-tier technologies, potentially reflecting a shift in the patient mix toward those requiring more comprehensive metabolic management.
 
With CGM spending currently accounting for less than 3% of GLP-1 expenditure, this segment represents significant untapped "white space" for further integration as real-time metabolic monitoring becomes standard practice alongside GLP-1 therapy.

### Technical Highlights:
- **Data Integration**: Merged multi-year Medicare Part D drug spending, DMEPOS device claims, and NHANES population health data using R and SQL.
- **Standardization**: Applied CMS standardized payment amounts to account for geographic cost differences and enable year-over-year comparisons.
- **Visualization**: Built Tableau dashboards showing spending trends, beneficiary counts, and geographic distribution for stakeholder analysis.

### Data Sources:
- Medicare Part D Prescription Drug Spending (2014-2023)
- Medicare DMEPOS Device Claims (2016-2023)
- CDC NHANES Survey Data (2017-2023)

**License**: This project is licensed under the MIT License
