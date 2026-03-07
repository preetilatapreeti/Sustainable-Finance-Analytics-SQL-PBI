-- View the first 10 rows to understnad the structure
SELECT *
FROM
   Sustainability_Project.company_esg_financial_dataset
   LIMIT 10;
   
-- Check for missing values in critical columns
SELECT COUNT(*)
FROM Sustainability_Project.company_esg_financial_dataset
WHERE Revenue IS NULL OR ESG_Overall IS NULL;

CREATE OR REPLACE VIEW v_esg_business_insights AS
SELECT
     CompanyID,
     CompanyName,
     Industry,
     Region,
-- Basic Math; calculating profit
	Revenue,
    (Revenue * (ProfitMargin /100)) AS Calculated_Profit,
-- Feature Engineering; Categorizing ESG Scores
     ESG_Overall,
     CASE 
     WHEN ESG_Overall >= 70 THEN "ESG_Leader"
     WHEN ESG_Overall BETWEEN 40 AND 69 THEN "Average_Performer"
     ELSE 'High Risk / Laggard'
     END AS Sustainability_Status,
-- Environmental Impact Metric
     CarbonEmissions,
     (CarbonEmissions / Revenue) AS Carbon_Intensity -- Emissions Per Dollar Earned
     FROM Sustainability_Project.company_esg_financial_dataset;

SELECT 
    Industry,
    ROUND(AVG(ESG_Overall), 2) AS Avg_ESG_Score,
    ROUND(AVG(Carbon_intensity), 4) AS Average_Carbon_Intensity,
    SUM(Revenue) AS Total_Industry_Revenue
FROM v_esg_business_insights
GROUP BY Industry
ORDER BY Avg_ESG_Score DESC;

SELECT * FROM Sustainability_Project.v_esg_business_insights