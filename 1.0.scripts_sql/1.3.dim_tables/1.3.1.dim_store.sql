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

-- Insert distinct values into the table from raw data
INSERT INTO [stg_bright_mart_sales].[dbo].[dim_store] (
        [store_name],
        [store_city],
        [store_province],
        [store_region],
        [store_manager],
        [cashier_name]
)
SELECT DISTINCT
        [store_name],
        [store_city],
        [store_province],
        [store_region],
        [store_manager],
        [cashier_name]
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data];