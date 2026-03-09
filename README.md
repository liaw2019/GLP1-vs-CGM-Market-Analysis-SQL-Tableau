# The Modern Diabetes Landscape: GLP-1 vs CGM Market Analysis
**Tools**: SQL | Tableau | R

**An end-to-end SQL &amp; Tableau analysis  tracking the shift from traditional blood glucose monitoring to continuous glucose monitoring (CGM) devices alongside GLP-1 medication adoption**

[Tableau public link](https://public.tableau.com/views/DiabetesGLPproject/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Project Overview: The Modern Diabetes Landscape
This project analyzes changes in diabetes care within the Medicare population using CMS public datasets (2016-2023). The analysis examines two parallel trends: the rapid growth of GLP-1 medications (like Ozempic and Trulicity) and the adoption of continuous glucose monitoring (CGM) devices.

Using CMS Open Data (2016-2023), this study tracks how spending has transitioned from traditional blood glucose monitoring (fingersticks) toward high-cost continuous glucose monitoring (CGM) devices in alignment with the increased adoption of GLP-1 therapeutics.

### Key Business Insights:
- **The $9B Surge**: GLP-1 spending (led by Ozempic and Trulicity) has scaled exponentially, reflecting a massive therapeutic expansion into cardiovascular and obesity-related benefits.
- **Hardware Convergence**: While traditional glucose monitoring is declining, "Modern CGM" utilization is rising, showing a strategic synergy between drug therapy and real-time data monitoring.
- **Geographic Variance**: Regional adoption shows significant "hotspots" in the Southeast and Northeast, identifying areas with higher-than-average market penetration and potential clinical need.

### Technical Highlights:
- **Data Integration**: Merged multi-year Medicare Part D drug spending, DMEPOS device claims, and NHANES population health data using R and SQL.
- **Standardization**: Applied CMS standardized payment amounts to account for geographic cost differences and enable year-over-year comparisons.
- **Visualization**: Built Tableau dashboards showing spending trends, beneficiary counts, and geographic distribution for stakeholder analysis.

### Data Sources:
- Medicare Part D Prescription Drug Spending (2014-2023)
- Medicare DMEPOS Device Claims (2016-2023)
- CDC NHANES Survey Data (2017-2023)

**License**: This project is licensed under the MIT License
