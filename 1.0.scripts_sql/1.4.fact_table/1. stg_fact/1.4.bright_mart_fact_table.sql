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

-- Insert distinct values into the table from raw data only if they do not already exist
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
        raw.[unit_price],
        raw.[cost_price],
        raw.[qty],
        raw.[line_amount],
        raw.[stock_on_hand],
        raw.[reorder_threshold],
        raw.[transaction_amount],
        raw.[transaction_discount]
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] raw
WHERE NOT EXISTS (
    SELECT 1 
    FROM [stg_bright_mart_sales].[dbo].[bright_mart_fact_table] fact
    WHERE ISNULL(fact.[unit_price], '')           = ISNULL(raw.[unit_price], '')
      AND ISNULL(fact.[cost_price], '')           = ISNULL(raw.[cost_price], '')
      AND ISNULL(fact.[qty], '')                  = ISNULL(raw.[qty], '')
      AND ISNULL(fact.[line_amount], '')          = ISNULL(raw.[line_amount], '')
      AND ISNULL(fact.[stock_on_hand], '')        = ISNULL(raw.[stock_on_hand], '')
      AND ISNULL(fact.[reorder_threshold], '')    = ISNULL(raw.[reorder_threshold], '')
      AND ISNULL(fact.[transaction_amount], '')   = ISNULL(raw.[transaction_amount], '')
      AND ISNULL(fact.[transaction_discount], '') = ISNULL(raw.[transaction_discount], '')
);

-- Show the dim customer table
SELECT *
FROM [stg_bright_mart_sales].[dbo].[bright_mart_fact_table];

