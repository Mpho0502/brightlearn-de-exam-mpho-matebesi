--Create a stored procedure for dim product in stg.
CREATE OR ALTER PROCEDURE [dbo].[sp_create_dim_product]
AS
BEGIN
    SET NOCOUNT ON; --speeds up ETL process,stops server from countinng rows affected

    -- Create table if it does not exist
    IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[dim_product]', 'U') IS NULL
    BEGIN
        CREATE TABLE [stg_bright_mart_sales].[dbo].[dim_product](
            [ProductID] INT IDENTITY(1, 1) PRIMARY KEY,
            [supplier]      VARCHAR(50) NULL,
            [product_name]  VARCHAR(50) NULL,
            [category]      VARCHAR(50) NULL,
            [sub_category]  VARCHAR(50) NULL,
            [sku]           VARCHAR(50) NULL,
            [load_date] DATETIME DEFAULT GETDATE()
        );
    END;

    -- Insert distinct values only if they do not already exist
    INSERT INTO [stg_bright_mart_sales].[dbo].[dim_product] (
            [supplier],
            [product_name],
            [category],
            [sub_category],
            [sku]
    )
    SELECT DISTINCT
            raw.[supplier],
            raw.[product_name],
            raw.[category],
            raw.[sub_category],
            raw.[sku]
    FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] raw
    WHERE NOT EXISTS (
        SELECT 1 
        FROM [stg_bright_mart_sales].[dbo].[dim_product] dim
        WHERE ISNULL(dim.[supplier], '')     = ISNULL(raw.[supplier], '')
          AND ISNULL(dim.[product_name], '') = ISNULL(raw.[product_name], '')
          AND ISNULL(dim.[category], '')     = ISNULL(raw.[category], '')
          AND ISNULL(dim.[sub_category], '') = ISNULL(raw.[sub_category], '')
          AND ISNULL(dim.[sku], '')          = ISNULL(raw.[sku], '')
    );

    -- Show the dim product table
    SELECT *
    FROM [stg_bright_mart_sales].[dbo].[dim_product];
END;
GO

