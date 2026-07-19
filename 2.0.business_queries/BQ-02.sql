--Name: brightlearn-de-exam-mpho-matebesi  
--Course: Data Engineering 
--Project Name: BrightLearn Data Warehouse Build 
--Project Code: BL-DE-EXAM-2026-07

--Business Analytical Queries

--BQ-02: What was the total revenue per store, broken down by month, for the January–June 2026 period?

SELECT
    s.[store_name],
    FORMAT(d.[transaction_date], 'yyyy-MM') AS year_month,
    SUM([transaction_amount]) AS total_revenue
FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table] f
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_store] s
    ON f.[StoreID] = s.[StoreID]
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_date] d
    ON f.[DateID] = d.[DateID]
WHERE d.transaction_date BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY s.[store_name], FORMAT(d.[transaction_date], 'yyyy-MM')
ORDER BY s.[store_name], year_month DESC;