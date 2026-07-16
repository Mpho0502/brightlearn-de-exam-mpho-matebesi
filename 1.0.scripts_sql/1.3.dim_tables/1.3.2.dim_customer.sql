-- Create table if it does not exist
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[dim_customer]', 'U') IS NULL

    CREATE TABLE [stg_bright_mart_sales].[dbo].[dim_customer](
        [CustomerID] INT IDENTITY(1, 1) PRIMARY KEY,
        [customer_first_name] [varchar](50) NULL,
		[customer_last_name] [varchar](50) NULL,
		[customer_email] [varchar](50) NULL,
		[customer_phone] [varchar](50) NULL,
		[customer_city] [varchar](50) NULL,
		[customer_province] [varchar](50) NULL,
		[customer_loyalty_tier] [varchar](50) NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );
GO

-- Insert distinct values into the table from raw data
INSERT INTO [stg_bright_mart_sales].[dbo].[dim_customer] (
        [customer_first_name],
		[customer_last_name],
		[customer_email],
		[customer_phone],
		[customer_city],
		[customer_province],
		[customer_loyalty_tier]
)
SELECT DISTINCT
        [customer_first_name],
		[customer_last_name],
		[customer_email],
		[customer_phone],
		[customer_city],
		[customer_province],
		[customer_loyalty_tier]
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data];
