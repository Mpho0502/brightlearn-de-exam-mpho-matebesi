-- Create table if it does not exist
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[dim_payment]', 'U') IS NULL

    CREATE TABLE [stg_bright_mart_sales].[dbo].[dim_payment](
        [PaymentID] INT IDENTITY(1, 1) PRIMARY KEY,
        [payment_method] [varchar](50) NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );
GO
