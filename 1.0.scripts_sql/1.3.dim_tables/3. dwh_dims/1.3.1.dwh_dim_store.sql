--Create a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_dim_store]', 'U') IS NULL
    CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_dim_store](
        [StoreID]        INT IDENTITY(1, 1) PRIMARY KEY,
        [store_name]     VARCHAR(50) NOT NULL,
        [store_city]     VARCHAR(50) NOT NULL,
        [store_province] VARCHAR(50) NOT NULL,
        [store_region]   VARCHAR(50) NOT NULL,
        [store_manager]  VARCHAR(50) NOT NULL,
        [cashier_name]   VARCHAR(50) NOT NULL,
        [load_date]      DATETIME DEFAULT GETDATE()
    );

-- Insert distinct values only if they do not already exist
INSERT INTO [dwh_bright_mart_sales].[dbo].[dwh_dim_store] (
        [store_name],
        [store_city],
        [store_province],
        [store_region],
        [store_manager],
        [cashier_name]
)
SELECT DISTINCT
        cln.[store_name],
        cln.[store_city],
        cln.[store_province],
        cln.[store_region],
        cln.[store_manager],
        cln.[cashier_name]
FROM [stg_bright_mart_sales].[dbo].[clean_dim_store] cln
WHERE NOT EXISTS (
    SELECT 1 
    FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_store] dim
    WHERE ISNULL(dim.[store_name], '')     = ISNULL(cln.[store_name], '')
      AND ISNULL(dim.[store_city], '')     = ISNULL(cln.[store_city], '')
      AND ISNULL(dim.[store_province], '') = ISNULL(cln.[store_province], '')
      AND ISNULL(dim.[store_region], '')   = ISNULL(cln.[store_region], '')
      AND ISNULL(dim.[store_manager], '')  = ISNULL(cln.[store_manager], '')
      AND ISNULL(dim.[cashier_name], '')   = ISNULL(cln.[cashier_name], '')
);

-- Show the dwh dim store table
SELECT *
FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_store];