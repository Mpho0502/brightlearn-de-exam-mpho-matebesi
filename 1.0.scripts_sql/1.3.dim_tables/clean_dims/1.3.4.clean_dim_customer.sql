--Recreate a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_customer]', 'U') IS NULL
    CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_customer](
        [CustomerID]            INT IDENTITY(1, 1) PRIMARY KEY,
        [customer_first_name]   VARCHAR(50) NOT NULL,
        [customer_last_name]    VARCHAR(50) NOT NULL,
        [customer_email]        VARCHAR(50) NOT NULL,
        [customer_phone]        VARCHAR(50) NOT NULL,
        [customer_city]         VARCHAR(50) NOT NULL,
        [customer_province]     VARCHAR(50) NOT NULL,
        [customer_loyalty_tier] VARCHAR(50) NOT NULL,
        [load_date]             DATETIME DEFAULT GETDATE()
    );

