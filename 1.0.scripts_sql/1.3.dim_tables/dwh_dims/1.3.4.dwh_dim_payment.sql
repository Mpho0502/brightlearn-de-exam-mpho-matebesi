--Create a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_dim_payment]', 'U') IS NULL
    CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_dim_payment](
        [PaymentID]      INT IDENTITY(1, 1) PRIMARY KEY,
        [payment_method] VARCHAR(50) NOT NULL, 
        [load_date]      DATETIME DEFAULT GETDATE()
 );


