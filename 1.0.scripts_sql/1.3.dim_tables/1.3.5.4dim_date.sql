-- Create table if it does not exist
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[dim_date]', 'U') IS NULL

    CREATE TABLE [stg_bright_mart_sales].[dbo].[dim_date](
        [DateID] INT IDENTITY(1, 1) PRIMARY KEY,
        [transaction_date] [varchar](50) NULL,
        [customer_since] [varchar](50) NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );
GO