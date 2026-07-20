--Name: brightlearn-de-exam-mpho-matebesi  
--Course: Data Engineering 
--Project Name: BrightLearn Data Warehouse Build 
--Project Code: BL-DE-EXAM-2026-07

--Business Analytical Queries

--BQ-07: What is the total quantity sold per product category, per store, for the reporting period?

SELECT 
    s.[StoreID],
    s.[store_name],
    p.[category],
    SUM(f.[qty]) AS TotalQuantitySold,
    COUNT([SalesID]) AS TotalSalesTransactions
FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table] f
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_store] s
    ON s.[StoreID] = f.[StoreID]
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_date] d
    ON f.[DateID] = d.[DateID] 
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_product] p
    ON f.[ProductID] = p.[ProductID]
WHERE d.[transaction_date] BETWEEN '2024-01-01' 
                           AND '2024-06-30' -- reporting period
                           AND p.[category] <> 'Unknown'
GROUP BY s.[StoreID], s.[store_name], p.[category]
ORDER BY s.[store_name], p.[category] DESC;

---------------------------------
