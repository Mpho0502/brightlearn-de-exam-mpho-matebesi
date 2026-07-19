--Create a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_dim_payment]', 'U') IS NULL
    CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_dim_payment](
        [PaymentID]      INT IDENTITY(1, 1) PRIMARY KEY,
        [payment_method] VARCHAR(50) NOT NULL, 
        [load_date]      DATETIME DEFAULT GETDATE()
 );

-- Insert distinct values into the table from raw data only if they do not already exist
INSERT INTO [dwh_bright_mart_sales].[dbo].[dwh_dim_payment](
        [payment_method]
)
SELECT DISTINCT
        cln.[payment_method]
FROM [stg_bright_mart_sales].[dbo].[clean_dim_payment] cln
WHERE NOT EXISTS (
    SELECT 1 
    FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_payment] dim
    WHERE ISNULL(dim.[payment_method], '') = ISNULL(cln.[payment_method], '')
);

-- Show the dwh dim product table
SELECT *
FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_payment];
