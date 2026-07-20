--Name: brightlearn-de-exam-mpho-matebesi  
--Course: Data Engineering 
--Project Name: BrightLearn Data Warehouse Build 
--Project Code: BL-DE-EXAM-2026-07

--Business Analytical Queries

--BQ-06: What is the average transaction value broken down by customer loyalty tier (Bronze, Silver, Gold)?

SELECT 
    c.[customer_loyalty_tier],
    COUNT (f.[SalesID]) AS TotalTransactions,
    AVG(f.[transaction_amount]) AS AvgTransactionValue
FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table] f
JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_customer] c
    ON c.[CustomerID] = f.[CustomerID]
WHERE c.[customer_loyalty_tier] IN ('Bronze', 'Silver', 'Gold')
GROUP BY c.[customer_loyalty_tier]
ORDER BY AvgTransactionValue DESC;

---------------------------------
