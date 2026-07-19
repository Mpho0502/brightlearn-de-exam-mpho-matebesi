-- Create a table with proper DATE data types 
IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_dim_date]', 'U') IS NULL
    CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_dim_date](
        [DateID] INT IDENTITY(1, 1) PRIMARY KEY,
        [transaction_date] DATE NULL,      
        [customer_since] DATE NULL,       
        [load_date] DATETIME DEFAULT GETDATE()
);

-- Insert distinct values into the table from raw data only if they do not already exist
INSERT INTO [dwh_bright_mart_sales].[dbo].[dwh_dim_date] (
        [transaction_date],
        [customer_since]
)
SELECT DISTINCT
        cln.[transaction_date],
        cln.[customer_since]
FROM [stg_bright_mart_sales].[dbo].[clean_dim_date] cln
WHERE NOT EXISTS (
    SELECT 1 
    FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_date] dim
    WHERE ISNULL(dim.[transaction_date], '') = ISNULL(cln.[transaction_date], '')
      AND ISNULL(dim.[customer_since], '')   = ISNULL(cln.[customer_since], '')
);

-- Show the dwh dim date table
SELECT *
FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_date];