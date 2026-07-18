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
    [DateID], 
    [PaymentID], 
    [ProductID], 
    [CustomerID], 
    [StoreID],
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
    COALESCE(d_date.DateID, 1)       AS [DateID],
    COALESCE(d_pay.PaymentID, 1)     AS [PaymentID],
    COALESCE(d_prod.ProductID, 1)    AS [ProductID],
    COALESCE(d_cust.CustomerID, 1)   AS [CustomerID],
    COALESCE(d_store.StoreID, 1)     AS [StoreID],

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
