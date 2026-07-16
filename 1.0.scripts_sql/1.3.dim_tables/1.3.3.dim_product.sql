-- Create table if it does not exist
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[dim_product]', 'U') IS NULL

    CREATE TABLE [stg_bright_mart_sales].[dbo].[dim_product](
        [ProductID] INT IDENTITY(1, 1) PRIMARY KEY,
        [supplier] [varchar](50) NULL,
		[product_name] [varchar](50) NULL,
	    [category] [varchar](50) NULL,
	    [sub_category] [varchar](50) NULL,
	    [sku] [varchar](50) NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );
GO

-- Insert distinct values into the table from raw data
INSERT INTO [stg_bright_mart_sales].[dbo].[dim_product] (
		[supplier],
		[product_name],
	    [category],
	    [sub_category],
	    [sku]
)
SELECT DISTINCT
        [supplier],
		[product_name],
	    [category],
	    [sub_category],
	    [sku]
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data];

