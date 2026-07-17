--Recreate a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_store]', 'U') IS NULL
    CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_store](
        [StoreID]        INT IDENTITY(1, 1) PRIMARY KEY,
        [store_name]     VARCHAR(50) NOT NULL,
        [store_city]     VARCHAR(50) NOT NULL,
        [store_province] VARCHAR(50) NOT NULL,
        [store_region]   VARCHAR(50) NOT NULL,
        [store_manager]  VARCHAR(50) NOT NULL,
        [cashier_name]   VARCHAR(50) NOT NULL,
        [load_date]      DATETIME DEFAULT GETDATE()
    );

--Insert distinct values using WHERE NOT EXISTS and handling blanks/NULLs
INSERT INTO [stg_bright_mart_sales].[dbo].[clean_dim_store] ( 
    [store_name], 
    [store_city], 
    [store_province], 
    [store_region], 
    [store_manager], 
    [cashier_name] 
) 
SELECT DISTINCT 
    -- Clean whitespaces, catch empty blocks, and swap NULLs with 'Unknown'
    COALESCE(NULLIF(TRIM([store_name]), ''), 'Unknown')     AS [store_name], 
    COALESCE(NULLIF(TRIM([store_city]), ''), 'Unknown')     AS [store_city], 
    COALESCE(NULLIF(TRIM([store_province]), ''), 'Unknown') AS [store_province], 
    COALESCE(NULLIF(TRIM([store_region]), ''), 'Unknown')   AS [store_region], 
    COALESCE(NULLIF(TRIM([store_manager]), ''), 'Unknown')  AS [store_manager], 
    COALESCE(NULLIF(TRIM([cashier_name]), ''), 'Unknown')   AS [cashier_name] 
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS srd
WHERE ([store_name] IS NOT NULL OR 
       [store_city] IS NOT NULL OR 
       [store_province] IS NOT NULL OR 
       [store_region] IS NOT NULL OR 
       [store_manager] IS NOT NULL OR 
       [cashier_name] IS NOT NULL)
AND NOT EXISTS (
      SELECT 1 
      FROM [stg_bright_mart_sales].[dbo].[clean_dim_store] AS cds
      WHERE cds.[store_name]     = COALESCE(NULLIF(TRIM(srd.[store_name]), ''), 'Unknown')
        AND cds.[store_city]     = COALESCE(NULLIF(TRIM(srd.[store_city]), ''), 'Unknown')
        AND cds.[store_province] = COALESCE(NULLIF(TRIM(srd.[store_province]), ''), 'Unknown')
        AND cds.[store_region]   = COALESCE(NULLIF(TRIM(srd.[store_region]), ''), 'Unknown')
        AND cds.[store_manager]  = COALESCE(NULLIF(TRIM(srd.[store_manager]), ''), 'Unknown')
        AND cds.[cashier_name]   = COALESCE(NULLIF(TRIM(srd.[cashier_name]), ''), 'Unknown')
  );
  
--Show the clean table to verify the data types and contents 
SELECT * FROM [stg_bright_mart_sales].[dbo].[clean_dim_store];

