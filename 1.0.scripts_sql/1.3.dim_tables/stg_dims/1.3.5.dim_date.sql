-- Create table if it does not exist
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[dim_date]', 'U') IS NULL

    CREATE TABLE [stg_bright_mart_sales].[dbo].[dim_date](
        [DateID] INT IDENTITY(1, 1) PRIMARY KEY,
        [transaction_date] [varchar](50) NULL,
        [customer_since] [varchar](50) NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );
GO

-- Insert distinct values into the table from raw data only if they do not already exist
INSERT INTO [stg_bright_mart_sales].[dbo].[dim_date] (
        [transaction_date],
        [customer_since]
)
SELECT DISTINCT
        raw.[transaction_date],
        raw.[customer_since]
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] raw
WHERE NOT EXISTS (
    SELECT 1 
    FROM [stg_bright_mart_sales].[dbo].[dim_date] dim
    WHERE ISNULL(dim.[transaction_date], '') = ISNULL(raw.[transaction_date], '')
      AND ISNULL(dim.[customer_since], '')    = ISNULL(raw.[customer_since], '')
);

-- Show the dim date table
SELECT *
FROM [stg_bright_mart_sales].[dbo].[dim_date];

