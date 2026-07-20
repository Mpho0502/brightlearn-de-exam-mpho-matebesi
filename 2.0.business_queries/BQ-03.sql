--Name: brightlearn-de-exam-mpho-matebesi  
--Course: Data Engineering 
--Project Name: BrightLearn Data Warehouse Build 
--Project Code: BL-DE-EXAM-2026-07

--Business Analytical Queries

--BQ-03: What is the month-over-month revenue growth rate across all stores combined?

WITH MonthlyRevenue AS (
    SELECT 
        DATENAME(MONTH, d.[transaction_date]) AS month_name,
        MONTH(d.[transaction_date]) AS month_number,
        SUM([transaction_amount]) AS total_revenue
    FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table] f
    JOIN [dwh_bright_mart_sales].[dbo].[dwh_dim_date] d
        ON f.DateID = d.DateID
    WHERE d.[transaction_date] BETWEEN '2024-01-01' AND '2024-06-30'
    GROUP BY DATENAME(MONTH, d.[transaction_date]), MONTH(d.[transaction_date])
)
SELECT 
    month_name,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month_number) AS prev_month_revenue,
    CASE 
        WHEN LAG(total_revenue) OVER (ORDER BY month_number) = 0 THEN NULL
        ELSE ROUND(
            ((total_revenue - LAG(total_revenue) OVER (ORDER BY month_number)) 
              / LAG(total_revenue) OVER (ORDER BY month_number)) * 100, 2
        )
    END AS growth_rate_percent
FROM MonthlyRevenue
ORDER BY month_number;
---------------------------------
