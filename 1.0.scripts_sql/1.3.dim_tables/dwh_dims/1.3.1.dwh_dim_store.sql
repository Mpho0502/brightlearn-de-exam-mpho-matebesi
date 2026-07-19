--Create a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_dim_store]', 'U') IS NULL
    CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_dim_store](
        [StoreID]        INT IDENTITY(1, 1) PRIMARY KEY,
        [store_name]     VARCHAR(50) NOT NULL,
        [store_city]     VARCHAR(50) NOT NULL,
        [store_province] VARCHAR(50) NOT NULL,
        [store_region]   VARCHAR(50) NOT NULL,
        [store_manager]  VARCHAR(50) NOT NULL,
        [cashier_name]   VARCHAR(50) NOT NULL,
        [load_date]      DATETIME DEFAULT GETDATE()
    );

