-- Create table if it does not exist
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[dim_store]', 'U') IS NULL
    CREATE TABLE [stg_bright_mart_sales].[dbo].[dim_store](
        [StoreID] INT IDENTITY(1, 1) PRIMARY KEY,
        [store_name] [varchar](50) NULL,
	    [store_city] [varchar](50) NULL,
	    [store_province] [varchar](50) NULL,
	    [store_region] [varchar](50) NULL,
	    [store_manager] [varchar](50) NULL,
        [cashier_name] [varchar](50) NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );
GO

-- Insert distinct values only if they do not already exist
INSERT INTO [stg_bright_mart_sales].[dbo].[dim_store] (
        [store_name],
        [store_city],
        [store_province],
        [store_region],
        [store_manager],
        [cashier_name]
)
SELECT DISTINCT
        raw.[store_name],
        raw.[store_city],
        raw.[store_province],
        raw.[store_region],
        raw.[store_manager],
        raw.[cashier_name]
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] raw
WHERE NOT EXISTS (
    SELECT 1 
    FROM [stg_bright_mart_sales].[dbo].[dim_store] dim
    WHERE ISNULL(dim.[store_name], '')     = ISNULL(raw.[store_name], '')
      AND ISNULL(dim.[store_city], '')     = ISNULL(raw.[store_city], '')
      AND ISNULL(dim.[store_province], '') = ISNULL(raw.[store_province], '')
      AND ISNULL(dim.[store_region], '')   = ISNULL(raw.[store_region], '')
      AND ISNULL(dim.[store_manager], '')  = ISNULL(raw.[store_manager], '')
      AND ISNULL(dim.[cashier_name], '')   = ISNULL(raw.[cashier_name], '')
);

-- Show the dim store table
SELECT *
FROM [stg_bright_mart_sales].[dbo].[dim_store];


