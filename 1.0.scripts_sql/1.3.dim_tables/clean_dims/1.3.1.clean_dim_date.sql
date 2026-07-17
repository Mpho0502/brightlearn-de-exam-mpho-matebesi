-- Recreate a table with proper DATE data types instead of VARCHAR
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_date]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_date](
        [DateID] INT IDENTITY(1, 1) PRIMARY KEY,
        [transaction_date] DATE NULL,      -- Converted to DATE type
        [customer_since] DATE NULL,        -- Converted to DATE type
        [load_date] DATETIME DEFAULT GETDATE()
    );
END; 

