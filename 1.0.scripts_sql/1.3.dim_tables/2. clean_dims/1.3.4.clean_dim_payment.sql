-- Recreate a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_payment]', 'U') IS NULL
    CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_payment](
        [PaymentID]      INT IDENTITY(1, 1) PRIMARY KEY,
        [payment_method] VARCHAR(50) NOT NULL, --  set to provide a fallback
        [load_date]      DATETIME DEFAULT GETDATE()
 );

-- Insert distinct values using WHERE NOT EXISTS and handling NULLs
INSERT INTO [stg_bright_mart_sales].[dbo].[clean_dim_payment] ( 
        [payment_method] 
) 
SELECT DISTINCT 
    -- If the payment method is missing or NULL, fallback to an 'Unknown' placeholder
    COALESCE([payment_method], 'Unknown') AS [payment_method] 
FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS srd
WHERE  [payment_method] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 
      FROM [stg_bright_mart_sales].[dbo].[clean_dim_payment] AS cdp
      WHERE cdp.[payment_method] = COALESCE(srd.[payment_method], 'Unknown')
);

-- Show the clean table to verify the data types and contents 
SELECT * FROM [stg_bright_mart_sales].[dbo].[clean_dim_payment];
