--Name: brightlearn-de-exam-mpho-matebesi  
--Course: Data Engineering 
--Project Name: BrightLearn Data Warehouse Build 
--Project Code: BL-DE-EXAM-2026-07

--Business Analytical Queries

--BQ-05: Which registered loyalty customers have not made a purchase since 28 April 2024? These customers must be flagged for a targeted win-back campaign.

SELECT 
    c.[CustomerID],
    c.[customer_first_name],
    c.[customer_last_name],
    c.[customer_loyalty_tier],
    MAX(d.[transaction_date]) AS LastPurchaseDate,
    CASE 
        WHEN MAX(d.[transaction_date]) < '2024-04-28' THEN 'Win-Back Target'
        ELSE 'Active'
    END AS CampaignFlag
FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table] f
LEFT JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_customer] c 
    ON c.CustomerID = f.CustomerID
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_date] d 
    ON f.[DateID] = d.[DateID]
WHERE c.[customer_loyalty_tier] IS NOT NULL
  AND c.[customer_loyalty_tier] <> 'Unknown'
GROUP BY 
    c.[CustomerID],
    c.[customer_first_name],
    c.[customer_last_name],
    c.[customer_loyalty_tier]
HAVING MAX(d.[transaction_date]) < '2024-04-28'
ORDER BY LastPurchaseDate DESC;

---------------------------------
