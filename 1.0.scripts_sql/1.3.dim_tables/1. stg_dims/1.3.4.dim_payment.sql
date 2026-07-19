-- Create table if it does not exist
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[dim_payment]', 'U') IS NULL

    CREATE TABLE [stg_bright_mart_sales].[dbo].[dim_payment](
        [PaymentID] INT IDENTITY(1, 1) PRIMARY KEY,
        [payment_method] [varchar](50) NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );
GO

-- Insert distinct values into the table from raw data only if they do not already exist
INSERT INTO [stg_bright_mart_sales].[dbo].[dim_payment] (
        [payment_method]
)
SELECT DISTINCT
        raw.[payment_method]
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] raw
WHERE NOT EXISTS (
    SELECT 1 
    FROM [stg_bright_mart_sales].[dbo].[dim_payment] dim
    WHERE ISNULL(dim.[payment_method], '') = ISNULL(raw.[payment_method], '')
);

-- Show the dim product table
SELECT *
FROM [stg_bright_mart_sales].[dbo].[dim_payment];