--Create a stored procedure for dwh dim product in dwh.
CREATE OR ALTER PROCEDURE [dbo].[sp_load_dwh_dim_product]
AS
BEGIN
    SET NOCOUNT ON; --speeds up ETL process,stops server from countinng rows affected

    -- Create table if it does not exist
    IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_dim_product]', 'U') IS NULL
    BEGIN
        CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_dim_product](
            [ProductID]    INT IDENTITY(1, 1) PRIMARY KEY,
            [supplier]     VARCHAR(50) NOT NULL,
            [product_name] VARCHAR(50) NOT NULL,
            [category]     VARCHAR(50) NOT NULL,
            [sub_category] VARCHAR(50) NOT NULL,
            [sku]          VARCHAR(50) NOT NULL,
            [load_date]    DATETIME DEFAULT GETDATE()
        );
    END;

    -- Insert distinct values only if they do not already exist
    INSERT INTO [dwh_bright_mart_sales].[dbo].[dwh_dim_product] (
            [supplier],
            [product_name],
            [category],
            [sub_category],
            [sku]
    )
    SELECT DISTINCT
            cln.[supplier],
            cln.[product_name],
            cln.[category],
            cln.[sub_category],
            cln.[sku]
    FROM [stg_bright_mart_sales].[dbo].[clean_dim_product] cln
    WHERE NOT EXISTS (
        SELECT 1 
        FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_product] dim
        WHERE ISNULL(dim.[supplier], '')     = ISNULL(cln.[supplier], '')
          AND ISNULL(dim.[product_name], '') = ISNULL(cln.[product_name], '')
          AND ISNULL(dim.[category], '')     = ISNULL(cln.[category], '')
          AND ISNULL(dim.[sub_category], '') = ISNULL(cln.[sub_category], '')
          AND ISNULL(dim.[sku], '')          = ISNULL(cln.[sku], '')
    );

    -- Show the dwh dim product table
    SELECT *
    FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_product];
END;
GO
