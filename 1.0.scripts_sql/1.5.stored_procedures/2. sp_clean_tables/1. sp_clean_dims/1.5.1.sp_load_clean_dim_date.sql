--Create a stored procedure for clean dim store in stg.
CREATE OR ALTER PROCEDURE [dbo].[sp_load_clean_dim_store]
AS
BEGIN
    SET NOCOUNT ON; --speeds up ETL process,stops server from countinng rows affected

    -- Recreate table with proper data types if it does not exist
    IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_store]', 'U') IS NULL
    BEGIN
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
    END;

    -- Insert distinct cleaned values only if they do not already exist
    INSERT INTO [stg_bright_mart_sales].[dbo].[clean_dim_store] ( 
        [store_name], 
        [store_city], 
        [store_province], 
        [store_region], 
        [store_manager], 
        [cashier_name] 
    ) 
    SELECT DISTINCT 
        COALESCE(NULLIF(TRIM(raw.[store_name]), ''), 'Unknown')     AS [store_name], 
        COALESCE(NULLIF(TRIM(raw.[store_city]), ''), 'Unknown')     AS [store_city], 
        COALESCE(NULLIF(TRIM(raw.[store_province]), ''), 'Unknown') AS [store_province], 
        COALESCE(NULLIF(TRIM(raw.[store_region]), ''), 'Unknown')   AS [store_region], 
        COALESCE(NULLIF(TRIM(raw.[store_manager]), ''), 'Unknown')  AS [store_manager], 
        COALESCE(NULLIF(TRIM(raw.[cashier_name]), ''), 'Unknown')   AS [cashier_name] 
    FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS raw
    WHERE (raw.[store_name] IS NOT NULL OR 
           raw.[store_city] IS NOT NULL OR 
           raw.[store_province] IS NOT NULL OR 
           raw.[store_region] IS NOT NULL OR 
           raw.[store_manager] IS NOT NULL OR
           raw.[cashier_name] IS NOT NULL)
      AND NOT EXISTS (
          SELECT 1 
          FROM [stg_bright_mart_sales].[dbo].[clean_dim_store] AS cds
          WHERE cds.[store_name]     = COALESCE(NULLIF(TRIM(raw.[store_name]), ''), 'Unknown')
            AND cds.[store_city]     = COALESCE(NULLIF(TRIM(raw.[store_city]), ''), 'Unknown')
            AND cds.[store_province] = COALESCE(NULLIF(TRIM(raw.[store_province]), ''), 'Unknown')
            AND cds.[store_region]   = COALESCE(NULLIF(TRIM(raw.[store_region]), ''), 'Unknown')
            AND cds.[store_manager]  = COALESCE(NULLIF(TRIM(raw.[store_manager]), ''), 'Unknown')
            AND cds.[cashier_name]   = COALESCE(NULLIF(TRIM(raw.[cashier_name]), ''), 'Unknown')
      );

    -- Show the clean table
    SELECT *
    FROM [stg_bright_mart_sales].[dbo].[clean_dim_store];
END;
GO