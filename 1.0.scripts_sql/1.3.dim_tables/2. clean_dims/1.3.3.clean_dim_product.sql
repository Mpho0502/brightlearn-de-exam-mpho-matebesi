--Recreate a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_product]', 'U') IS NULL
    CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_product](
        [ProductID]    INT IDENTITY(1, 1) PRIMARY KEY,
        [supplier]     VARCHAR(50) NOT NULL,
        [product_name] VARCHAR(50) NOT NULL,
        [category]     VARCHAR(50) NOT NULL,
        [sub_category] VARCHAR(50) NOT NULL,
        [sku]          VARCHAR(50) NOT NULL,
        [load_date]    DATETIME DEFAULT GETDATE()
    );

    --Insert distinct values using WHERE NOT EXISTS and handling NULLs
INSERT INTO [stg_bright_mart_sales].[dbo].[clean_dim_product] ( 
        [supplier], 
        [product_name], 
        [category], 
        [sub_category],
        [sku] 
) 
SELECT DISTINCT 
    -- NULLIF turns empty spaces '' into NULL, then COALESCE turns NULL into 'Unknown'
    COALESCE(NULLIF(TRIM([supplier]), ''), 'Unknown')     AS [supplier], 
    COALESCE(NULLIF(TRIM([product_name]), ''), 'Unknown') AS [product_name], 
    COALESCE(NULLIF(TRIM([category]), ''), 'Unknown')     AS [category], 
    COALESCE(NULLIF(TRIM([sub_category]), ''), 'Unknown') AS [sub_category], 
    COALESCE(NULLIF(TRIM([sku]), ''), 'Unknown')          AS [sku] 
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS srd
WHERE ([supplier] IS NOT NULL OR 
       [product_name] IS NOT NULL OR 
       [category] IS NOT NULL OR 
       [sub_category] IS NOT NULL OR 
       [sku] IS NOT NULL)
AND NOT EXISTS (
      SELECT 1 
      FROM [stg_bright_mart_sales].[dbo].[clean_dim_product] AS cdp
      WHERE cdp.[supplier]     = COALESCE(NULLIF(TRIM(srd.[supplier]), ''), 'Unknown')
        AND cdp.[product_name] = COALESCE(NULLIF(TRIM(srd.[product_name]), ''), 'Unknown')
        AND cdp.[category]     = COALESCE(NULLIF(TRIM(srd.[category]), ''), 'Unknown')
        AND cdp.[sub_category] = COALESCE(NULLIF(TRIM(srd.[sub_category]), ''), 'Unknown')
        AND cdp.[sku]          = COALESCE(NULLIF(TRIM(srd.[sku]), ''), 'Unknown')
  );

  -- Show the clean table to verify the data types and contents 
  SELECT * FROM [stg_bright_mart_sales].[dbo].[clean_dim_product];
