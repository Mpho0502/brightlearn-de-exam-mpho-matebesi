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

