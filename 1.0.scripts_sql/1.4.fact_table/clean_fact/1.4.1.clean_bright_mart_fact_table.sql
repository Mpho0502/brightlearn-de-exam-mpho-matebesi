--Recreate a table with proper DATE data types instead of VARCHAR
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table]', 'U') IS NULL
CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table](
        [SalesID]              INT IDENTITY(1, 1) PRIMARY KEY,
        [unit_price]           DECIMAL(18, 2) NOT NULL, -- Converted to standard money/decimal format
        [cost_price]           DECIMAL(18, 2) NOT NULL,
        [qty]                  INT NOT NULL,            -- Converted to integer for whole items
        [line_amount]          DECIMAL(18, 2) NOT NULL,
        [stock_on_hand]        INT NOT NULL,
        [reorder_threshold]    INT NOT NULL,
        [transaction_amount]   DECIMAL(18, 2) NOT NULL,
        [transaction_discount] DECIMAL(18, 2) NOT NULL,
        [is_negative_value]    BIT NOT NULL,            -- 1 means True (Negative/Adjustment), 0 means False (Normal Sale)
        [load_date]            DATETIME DEFAULT GETDATE()
    );
