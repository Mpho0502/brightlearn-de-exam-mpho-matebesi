--Name: brightlearn-de-exam-mpho-matebesi  
--Course: Data Engineering 
--Project Name: BrightLearn Data Warehouse Build 
--Project Code: BL-DE-EXAM-2026-07

--Business Analytical Queries

--BQ-04: Who are the top 10 loyalty customers ranked by total spend over the reporting period?

SELECT TOP 10
    c.[CustomerID],
    c.[customer_first_name],
    c.[customer_last_name],
    c.[customer_loyalty_tier],
    SUM(f.[transaction_amount]) AS TotalSpend
FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table] f
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_customer] c
    ON c.[CustomerID] = f.[CustomerID]
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_date] d
    ON f.[DateID] = d.[DateID]
WHERE d.[transaction_date] BETWEEN '2024-01-01' 
                           AND '2024-06-30' 
                           AND c.[customer_loyalty_tier] <> 'Unknown'  -- reporting period and loyalty customers only
GROUP BY c.[CustomerID],
         c.[customer_first_name],
         c.[customer_last_name],
         c.[customer_loyalty_tier]
ORDER BY TotalSpend DESC;

---------------------------------