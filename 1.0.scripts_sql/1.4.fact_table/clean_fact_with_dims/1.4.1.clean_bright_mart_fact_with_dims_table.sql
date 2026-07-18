--Create Fact Table with Dimension Foreign Keys
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table]', 'U') IS NULL
CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table](
    [SalesID]              INT IDENTITY(1, 1) PRIMARY KEY,
    -- Dimension Foreign Keys
    [StoreID]              INT NOT NULL,
    [CustomerID]           INT NOT NULL,
    [ProductID]            INT NOT NULL,
    [PaymentID]            INT NOT NULL,
    [DateID]               INT NOT NULL,
    -- Metrics / Financial Columns
    [unit_price]           DECIMAL(18, 2) NOT NULL, -- Converted to standard money/decimal format
    [cost_price]           DECIMAL(18, 2) NOT NULL,
    [qty]                  INT NOT NULL,            -- Converted to integer for whole items
    [line_amount]          DECIMAL(18, 2) NOT NULL,
    [stock_on_hand]        INT NOT NULL,
    [reorder_threshold]    INT NOT NULL,
    [transaction_amount]   DECIMAL(18, 2) NOT NULL, -- Keeps the negative number intact
    [transaction_discount] DECIMAL(18, 2) NOT NULL,
    [is_negative_value]    BIT NOT NULL,            -- 1 means True (Negative/Adjustment), 0 means False (Normal Sale)
    [load_date]            DATETIME DEFAULT GETDATE()
);

-- Populate Fact Table and prevent duplicate rows
INSERT INTO [stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table] ( 
    [StoreID], 
    [CustomerID], 
    [ProductID],
    [PaymentID], 
    [DateID], 
    [unit_price], 
    [cost_price], 
    [qty], 
    [line_amount], 
    [stock_on_hand], 
    [reorder_threshold], 
    [transaction_amount], 
    [transaction_discount],
    [is_negative_value]
) 
SELECT DISTINCT 
    -- Look up IDs or fallback to 1 (Unknown row index)
    COALESCE(d_store.StoreID, 1)     AS [StoreID],
    COALESCE(d_cust.CustomerID, 1)   AS [CustomerID],
    COALESCE(d_prod.ProductID, 1)    AS [ProductID],
    COALESCE(d_pay.PaymentID, 1)     AS [PaymentID],
    COALESCE(d_date.DateID, 1)       AS [DateID],
    -- Clean numeric metrics
    COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(src.[unit_price]), '')), 0.00)           AS [unit_price], 
    COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(src.[cost_price]), '')), 0.00)           AS [cost_price], 
    COALESCE(TRY_CONVERT(INT,            NULLIF(TRIM(src.[qty]), '')), 0)                     AS [qty], 
    COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(src.[line_amount]), '')), 0.00)          AS [line_amount], 
    COALESCE(TRY_CONVERT(INT,            NULLIF(TRIM(src.[stock_on_hand]), '')), 0)           AS [stock_on_hand], 
    COALESCE(TRY_CONVERT(INT,            NULLIF(TRIM(src.[reorder_threshold]), '')), 0)       AS [reorder_threshold], 
    COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(src.[transaction_amount]), '')), 0.00)   AS [transaction_amount], 
    COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(src.[transaction_discount]), '')), 0.00) AS [transaction_discount],
    
    -- Flag for negative values when 1 means True (Negative/Adjustment), 0 means False (Normal Sale)
    CASE WHEN COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(src.[transaction_amount]), '')), 0.00) < 0 
         THEN 1 ELSE 0 END AS [is_negative_value]

FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS src

-- Dimension Lookups via Left Joins
-- Clean dim store
LEFT JOIN [stg_bright_mart_sales].[dbo].[clean_dim_store] AS d_store
    ON d_store.[store_name]     = COALESCE(NULLIF(TRIM(src.[store_name]), ''), 'Unknown')
   AND d_store.[store_city]     = COALESCE(NULLIF(TRIM(src.[store_city]), ''), 'Unknown')
   AND d_store.[store_province] = COALESCE(NULLIF(TRIM(src.[store_province]), ''), 'Unknown')
   AND d_store.[store_region]   = COALESCE(NULLIF(TRIM(src.[store_region]), ''), 'Unknown')
   AND d_store.[store_manager]  = COALESCE(NULLIF(TRIM(src.[store_manager]), ''), 'Unknown')
   AND d_store.[cashier_name]   = COALESCE(NULLIF(TRIM(src.[cashier_name]), ''), 'Unknown')

-- Clean dim customer
LEFT JOIN [stg_bright_mart_sales].[dbo].[clean_dim_customer] AS d_cust
    ON d_cust.[customer_first_name]   = COALESCE(NULLIF(TRIM(src.[customer_first_name]), ''), 'Unknown')
   AND d_cust.[customer_last_name]    = COALESCE(NULLIF(TRIM(src.[customer_last_name]), ''), 'Unknown')
   AND d_cust.[customer_email]        = COALESCE(NULLIF(TRIM(src.[customer_email]), ''), 'Unknown')
   AND d_cust.[customer_phone]        = COALESCE(NULLIF(TRIM(src.[customer_phone]), ''), 'Unknown')
   AND d_cust.[customer_city]         = COALESCE(NULLIF(TRIM(src.[customer_city]), ''), 'Unknown')
   AND d_cust.[customer_province]     = COALESCE(NULLIF(TRIM(src.[customer_province]), ''), 'Unknown')
   AND d_cust.[customer_loyalty_tier] = COALESCE(NULLIF(TRIM(src.[customer_loyalty_tier]), ''), 'Unknown')

-- Clean dim product
LEFT JOIN [stg_bright_mart_sales].[dbo].[clean_dim_product] AS d_prod
    ON d_prod.[supplier]     = COALESCE(NULLIF(TRIM(src.[supplier]), ''), 'Unknown')
   AND d_prod.[product_name] = COALESCE(NULLIF(TRIM(src.[product_name]), ''), 'Unknown')
   AND d_prod.[category]     = COALESCE(NULLIF(TRIM(src.[category]), ''), 'Unknown')
   AND d_prod.[sub_category] = COALESCE(NULLIF(TRIM(src.[sub_category]), ''), 'Unknown')
   AND d_prod.[sku]          = COALESCE(NULLIF(TRIM(src.[sku]), ''), 'Unknown')

-- Clean dim payment
LEFT JOIN [stg_bright_mart_sales].[dbo].[clean_dim_payment] AS d_pay
    ON d_pay.[payment_method] = COALESCE(NULLIF(TRIM(src.[payment_method]), ''), 'Unknown')

-- Clean dim date
LEFT JOIN [stg_bright_mart_sales].[dbo].[clean_dim_date] AS d_date
    ON d_date.[transaction_date] = COALESCE(TRY_CONVERT(DATE, src.[transaction_date]), '1900-01-01')
   AND d_date.[customer_since]   = COALESCE(TRY_CONVERT(DATE, src.[customer_since]), '1900-01-01')

-- Crtitical anti-duplication guard using WHERE NOT EXISTS and handling numeric conversions/NULLs
WHERE NOT EXISTS (
    SELECT 1 
    FROM [stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table] AS tgt
    WHERE tgt.[DateID]               = COALESCE(d_date.DateID, 1)
      AND tgt.[PaymentID]            = COALESCE(d_pay.PaymentID, 1)
      AND tgt.[ProductID]            = COALESCE(d_prod.ProductID, 1)
      AND tgt.[CustomerID]           = COALESCE(d_cust.CustomerID, 1)
      AND tgt.[StoreID]              = COALESCE(d_store.StoreID, 1)
      AND tgt.[unit_price]           = COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(src.[unit_price]), '')), 0.00)
      AND tgt.[cost_price]           = COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(src.[cost_price]), '')), 0.00)
      AND tgt.[qty]                  = COALESCE(TRY_CONVERT(INT,            NULLIF(TRIM(src.[qty]), '')), 0)
      AND tgt.[line_amount]          = COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(src.[line_amount]), '')), 0.00)
      AND tgt.[transaction_amount]   = COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(src.[transaction_amount]), '')), 0.00)
);