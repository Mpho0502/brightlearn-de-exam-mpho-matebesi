-- Create a table with proper DATE data types 
IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_dim_date]', 'U') IS NULL
    CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_dim_date](
        [DateID] INT IDENTITY(1, 1) PRIMARY KEY,
        [transaction_date] DATE NULL,      
        [customer_since] DATE NULL,       
        [load_date] DATETIME DEFAULT GETDATE()
);

