--Name: brightlearn-de-exam-mpho-matebesi  
--Course: Data Engineering 
--Project Name: BrightLearn Data Warehouse Build 
--Project Code: BL-DE-EXAM-2026-07

--Business Analytical Queries

--BQ-01:	What were the top 5 best-selling products by total revenue between January and June 2026?

SELECT TOP 5
    p.[product_name],
    SUM(f.[transaction_amount]) AS total_revenue
FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table] f
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_product] p
    ON f.[ProductID] = p.[ProductID]
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_date] d
    ON f.[DateID] = d.[DateID]
WHERE d.[transaction_date] BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY p.[product_name]
ORDER BY total_revenue DESC;
