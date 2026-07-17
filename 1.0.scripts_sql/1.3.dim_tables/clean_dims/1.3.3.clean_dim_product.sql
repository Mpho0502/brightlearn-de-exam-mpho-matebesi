--Recreate a table with proper DATE data types set to NOT NULL
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_product]', 'U') IS NULL
    CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_product](
        [ProductID]    INT IDENTITY(1, 1) PRIMARY KEY,
        [supplier]     VARCHAR(50) NOT NULL,
        [product_name] VARCHAR(50) NOT NULL,
        [category]     VARCHAR(50) NOT NULL,
        [sub_category] VARCHAR(50) NOT NULL,
        [sku]          VARCHAR(50) NOT NULL,
        [load_date]    DATETIME DEFAULT GETDATE()
    );
