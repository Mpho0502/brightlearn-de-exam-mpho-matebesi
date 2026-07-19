--Create a stored procedure for clean dim store in stg.
CREATE OR ALTER PROCEDURE [dbo].[sp_load_clean_dim_product]
AS
BEGIN
    SET NOCOUNT ON; --speeds up ETL process,stops server from countinng rows affected

    -- Recreate table with proper data types if it does not exist
    IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_product]', 'U') IS NULL
    BEGIN
        CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_product](
            [ProductID]    INT IDENTITY(1, 1) PRIMARY KEY,
            [supplier]     VARCHAR(50) NOT NULL,
            [product_name] VARCHAR(50) NOT NULL,
            [category]     VARCHAR(50) NOT NULL,
            [sub_category] VARCHAR(50) NOT NULL,
            [sku]          VARCHAR(50) NOT NULL,
            [load_date]    DATETIME DEFAULT GETDATE()
        );
    END;

    -- Insert distinct cleaned values only if they do not already exist
    INSERT INTO [stg_bright_mart_sales].[dbo].[clean_dim_product] ( 
            [supplier], 
            [product_name], 
            [category], 
            [sub_category],
            [sku] 
    ) 
    SELECT DISTINCT 
        COALESCE(NULLIF(TRIM(raw.[supplier]), ''), 'Unknown')     AS [supplier], 
        COALESCE(NULLIF(TRIM(raw.[product_name]), ''), 'Unknown') AS [product_name], 
        COALESCE(NULLIF(TRIM(raw.[category]), ''), 'Unknown')     AS [category], 
        COALESCE(NULLIF(TRIM(raw.[sub_category]), ''), 'Unknown') AS [sub_category], 
        COALESCE(NULLIF(TRIM(raw.[sku]), ''), 'Unknown')          AS [sku] 
    FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS raw
    WHERE (raw.[supplier] IS NOT NULL OR 
           raw.[product_name] IS NOT NULL OR 
           raw.[category] IS NOT NULL OR 
           raw.[sub_category] IS NOT NULL OR 
           raw.[sku] IS NOT NULL)
      AND NOT EXISTS (
          SELECT 1 
          FROM [stg_bright_mart_sales].[dbo].[clean_dim_product] AS cdp
          WHERE cdp.[supplier]     = COALESCE(NULLIF(TRIM(raw.[supplier]), ''), 'Unknown')
            AND cdp.[product_name] = COALESCE(NULLIF(TRIM(raw.[product_name]), ''), 'Unknown')
            AND cdp.[category]     = COALESCE(NULLIF(TRIM(raw.[category]), ''), 'Unknown')
            AND cdp.[sub_category] = COALESCE(NULLIF(TRIM(raw.[sub_category]), ''), 'Unknown')
            AND cdp.[sku]          = COALESCE(NULLIF(TRIM(raw.[sku]), ''), 'Unknown')
      );

    -- Show the clean table
    SELECT *
    FROM [stg_bright_mart_sales].[dbo].[clean_dim_product];
END;
GO

