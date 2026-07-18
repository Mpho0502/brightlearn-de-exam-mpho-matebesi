--Recreate a table with proper DATE data types instead of VARCHAR
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table]', 'U') IS NULL
CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table](
        [SalesID]              INT IDENTITY(1, 1) PRIMARY KEY,
        [unit_price]           DECIMAL(18, 2) NOT NULL, -- Converted to standard money/decimal format
        [cost_price]           DECIMAL(18, 2) NOT NULL,
        [qty]                  INT NOT NULL,            -- Converted to integer for whole items
        [line_amount]          DECIMAL(18, 2) NOT NULL,
        [stock_on_hand]        INT NOT NULL,
        [reorder_threshold]    INT NOT NULL,
        [transaction_amount]   DECIMAL(18, 2) NOT NULL,
        [transaction_discount] DECIMAL(18, 2) NOT NULL,
        [is_negative_value]    BIT NOT NULL,            -- 1 means True (Negative/Adjustment), 0 means False (Normal Sale)
        [load_date]            DATETIME DEFAULT GETDATE()
    );

    -- Insert distinct values using WHERE NOT EXISTS and handling numeric conversions/NULLs
INSERT INTO [stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table] ( 
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
    -- TRY_CONVERT safely converts text to numbers. If it's a blank or non-numeric string, it returns NULL.
    -- COALESCE then catches those NULLs and replaces them with a clean 0 or 0.00 fallback.
    COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM([unit_price]), '')), 0.00)           AS [unit_price], 
    COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM([cost_price]), '')), 0.00)           AS [cost_price], 
    COALESCE(TRY_CONVERT(INT,            NULLIF(TRIM([qty]), '')), 0)                     AS [qty], 
    COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM([line_amount]), '')), 0.00)          AS [line_amount], 
    COALESCE(TRY_CONVERT(INT,            NULLIF(TRIM([stock_on_hand]), '')), 0)           AS [stock_on_hand], 
    COALESCE(TRY_CONVERT(INT,            NULLIF(TRIM([reorder_threshold]), '')), 0)       AS [reorder_threshold], 
    COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM([transaction_amount]), '')), 0.00)   AS [transaction_amount], 
    COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM([transaction_discount]), '')), 0.00) AS [transaction_discount],
     -- Evaluate the converted metric. If it falls below zero, set the flag to 1
    CASE WHEN COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM([transaction_amount]), '')), 0.00) < 0 
         THEN 1 ELSE 0 END AS [is_negative_value]
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS srd
WHERE ([unit_price] IS NOT NULL OR 
       [cost_price] IS NOT NULL OR 
       [qty] IS NOT NULL OR 
       [line_amount] IS NOT NULL)
  AND NOT EXISTS (
      SELECT 1 
      FROM [stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table] AS cft
      WHERE cft.[unit_price]           = COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(srd.[unit_price]), '')), 0.00)
        AND cft.[cost_price]           = COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(srd.[cost_price]), '')), 0.00)
        AND cft.[qty]                  = COALESCE(TRY_CONVERT(INT,            NULLIF(TRIM(srd.[qty]), '')), 0)
        AND cft.[line_amount]          = COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(srd.[line_amount]), '')), 0.00)
        AND cft.[stock_on_hand]        = COALESCE(TRY_CONVERT(INT,            NULLIF(TRIM(srd.[stock_on_hand]), '')), 0)
        AND cft.[reorder_threshold]    = COALESCE(TRY_CONVERT(INT,            NULLIF(TRIM(srd.[reorder_threshold]), '')), 0)
        AND cft.[transaction_amount]   = COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(srd.[transaction_amount]), '')), 0.00)
        AND cft.[transaction_discount] = COALESCE(TRY_CONVERT(DECIMAL(18, 2), NULLIF(TRIM(srd.[transaction_discount]), '')), 0.00)
  );

  -- Show the clean table to verify the data types and contents 
SELECT * FROM [stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table];