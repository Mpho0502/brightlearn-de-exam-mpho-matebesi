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
