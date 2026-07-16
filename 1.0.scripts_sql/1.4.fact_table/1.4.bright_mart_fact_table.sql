-- Create table if it does not exist
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[bright_mart_fact_table]', 'U') IS NULL

    CREATE TABLE [stg_bright_mart_sales].[dbo].[bright_mart_fact_table](
        [SalesID] INT IDENTITY(1, 1) PRIMARY KEY,
		[unit_price] [varchar](50) NULL,
		[cost_price] [varchar](50) NULL,
		[qty] [varchar](50) NULL,
		[line_amount] [varchar](50) NULL,
		[stock_on_hand] [varchar](50) NULL,
		[reorder_threshold] [varchar](50) NULL,
		[transaction_amount] [varchar](50) NULL,
		[transaction_discount] [varchar](50) NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );
GO

-- Insert distinct values into the table from raw data
INSERT INTO [stg_bright_mart_sales].[dbo].[bright_mart_fact_table] (
        [unit_price],
		[cost_price],
		[qty],
		[line_amount],
		[stock_on_hand],
		[reorder_threshold],
		[transaction_amount],
		[transaction_discount]
)
SELECT DISTINCT
        [unit_price],
		[cost_price],
		[qty],
		[line_amount],
		[stock_on_hand],
		[reorder_threshold],
		[transaction_amount],
		[transaction_discount]
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data];


