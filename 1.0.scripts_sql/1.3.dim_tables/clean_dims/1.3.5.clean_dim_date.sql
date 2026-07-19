-- Recreate a table with proper DATE data types instead of VARCHAR
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_date]', 'U') IS NULL
    CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_date](
        [DateID] INT IDENTITY(1, 1) PRIMARY KEY,
        [transaction_date] DATE NULL,      -- Converted to DATE type
        [customer_since] DATE NULL,        -- Converted to DATE type
        [load_date] DATETIME DEFAULT GETDATE()
);

-- Insert rows using WHERE NOT EXISTS to prevent duplicates across multiple execution runs
INSERT INTO [stg_bright_mart_sales].[dbo].[clean_dim_date] ( 
    [transaction_date], 
    [customer_since] 
) 
SELECT DISTINCT 
    -- If conversion fails or raw data is NULL, fallback to a default '1900-01-01' date 
    COALESCE(TRY_CONVERT(DATE, [transaction_date]), '1900-01-01') AS [transaction_date], 
    COALESCE(TRY_CONVERT(DATE, [customer_since]), '1900-01-01') AS [customer_since] 
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS srd
WHERE ([transaction_date] IS NOT NULL OR [customer_since] IS NOT NULL)
  AND NOT EXISTS (
      SELECT 1 
      FROM [stg_bright_mart_sales].[dbo].[clean_dim_date] AS cdd
      WHERE cdd.[transaction_date] = COALESCE(TRY_CONVERT(DATE, srd.[transaction_date]), '1900-01-01')
        AND cdd.[customer_since]   = COALESCE(TRY_CONVERT(DATE, srd.[customer_since]), '1900-01-01')
  );

-- Show the clean table to verify the data types and contents 
SELECT *
FROM [stg_bright_mart_sales].[dbo].[clean_dim_date];
