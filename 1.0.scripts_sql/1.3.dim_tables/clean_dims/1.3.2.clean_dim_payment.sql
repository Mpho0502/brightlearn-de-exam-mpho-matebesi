-- Recreate a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_payment]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_payment](
        [PaymentID]      INT IDENTITY(1, 1) PRIMARY KEY,
        [payment_method] VARCHAR(50) NOT NULL, --  set to provide a fallback
        [load_date]      DATETIME DEFAULT GETDATE()
    );
END;
GO

