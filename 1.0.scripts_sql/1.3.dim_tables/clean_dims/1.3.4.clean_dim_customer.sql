--Recreate a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_customer]', 'U') IS NULL
    CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_customer](
        [CustomerID]            INT IDENTITY(1, 1) PRIMARY KEY,
        [customer_first_name]   VARCHAR(50) NOT NULL,
        [customer_last_name]    VARCHAR(50) NOT NULL,
        [customer_email]        VARCHAR(50) NOT NULL,
        [customer_phone]        VARCHAR(50) NOT NULL,
        [customer_city]         VARCHAR(50) NOT NULL,
        [customer_province]     VARCHAR(50) NOT NULL,
        [customer_loyalty_tier] VARCHAR(50) NOT NULL,
        [load_date]             DATETIME DEFAULT GETDATE()
    );

    -- Insert distinct values using WHERE NOT EXISTS and handling blanks/NULLs
INSERT INTO [stg_bright_mart_sales].[dbo].[clean_dim_customer] ( 
    [customer_first_name], 
    [customer_last_name], 
    [customer_email], 
    [customer_phone], 
    [customer_city], 
    [customer_province], 
    [customer_loyalty_tier] 
) 
SELECT DISTINCT 
    -- Clean whitespaces, catch empty blocks, and swap NULLs with 'Unknown'
    COALESCE(NULLIF(TRIM([customer_first_name]), ''), 'Unknown')   AS [customer_first_name], 
    COALESCE(NULLIF(TRIM([customer_last_name]), ''), 'Unknown')    AS [customer_last_name], 
    COALESCE(NULLIF(TRIM([customer_email]), ''), 'Unknown')        AS [customer_email], 
    COALESCE(NULLIF(TRIM([customer_phone]), ''), 'Unknown')        AS [customer_phone], 
    COALESCE(NULLIF(TRIM([customer_city]), ''), 'Unknown')         AS [customer_city], 
    COALESCE(NULLIF(TRIM([customer_province]), ''), 'Unknown')     AS [customer_province], 
    COALESCE(NULLIF(TRIM([customer_loyalty_tier]), ''), 'Unknown') AS [customer_loyalty_tier] 
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS srd
WHERE ([customer_first_name] IS NOT NULL OR 
       [customer_last_name] IS NOT NULL OR 
       [customer_email] IS NOT NULL OR 
       [customer_phone] IS NOT NULL OR 
       [customer_city] IS NOT NULL OR 
       [customer_province] IS NOT NULL OR 
       [customer_loyalty_tier] IS NOT NULL)
  AND NOT EXISTS (
      SELECT 1 
      FROM [stg_bright_mart_sales].[dbo].[clean_dim_customer] AS cdc
      WHERE cdc.[customer_first_name]   = COALESCE(NULLIF(TRIM(srd.[customer_first_name]), ''), 'Unknown')
        AND cdc.[customer_last_name]    = COALESCE(NULLIF(TRIM(srd.[customer_last_name]), ''), 'Unknown')
        AND cdc.[customer_email]        = COALESCE(NULLIF(TRIM(srd.[customer_email]), ''), 'Unknown')
        AND cdc.[customer_phone]        = COALESCE(NULLIF(TRIM(srd.[customer_phone]), ''), 'Unknown')
        AND cdc.[customer_city]         = COALESCE(NULLIF(TRIM(srd.[customer_city]), ''), 'Unknown')
        AND cdc.[customer_province]     = COALESCE(NULLIF(TRIM(srd.[customer_province]), ''), 'Unknown')
        AND cdc.[customer_loyalty_tier] = COALESCE(NULLIF(TRIM(srd.[customer_loyalty_tier]), ''), 'Unknown')
  );

