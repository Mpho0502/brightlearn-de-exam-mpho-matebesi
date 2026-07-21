--Name: brightlearn-de-exam-mpho-matebesi  
--Course: Data Engineering 
--Project Name: BrightLearn Data Warehouse Build 
--Project Code: BL-DE-EXAM-2026-07

--Business Analytical Queries

--BQ-08: 	Based on the June 2024 inventory snapshot embedded in the source data, which store-product combinations currently have stock levels below their reorder threshold?

SELECT 
    s.[StoreID],
    s.[store_name],
    p.[product_name],
    f.[stock_on_hand],
    f.[reorder_threshold],
    d.[transaction_date],
    (f.[reorder_threshold]- f.[stock_on_hand]) AS [UnitsBelowReorderLevel]
FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table] f
INNER JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_store] s 
    ON f.[StoreID]   = s.[StoreID]
INNER JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_product] p 
    ON f.[ProductID] = p.[ProductID]
INNER JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_date] d
    ON f.[DateID]    = d.[DateID]
WHERE (d.[transaction_date]) BETWEEN '2024-06-01' AND '2024-06-30'
  AND f.[stock_on_hand] < f.[reorder_threshold]
ORDER BY s.[store_name], p.[product_name] DESC;

---------------------------------
