--Create Fact Table with Dimension Foreign Keys
IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table]', 'U') IS NULL
CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table](
    [SalesID]              INT IDENTITY(1, 1) PRIMARY KEY,
    -- Dimension Foreign Keys
    [StoreID]              INT NOT NULL,
    [CustomerID]           INT NOT NULL,
    [ProductID]            INT NOT NULL,
    [PaymentID]            INT NOT NULL,
    [DateID]               INT NOT NULL,
    -- Metrics / Financial Columns
    [unit_price]           DECIMAL(18, 2) NOT NULL, -- Converted to standard money/decimal format
    [cost_price]           DECIMAL(18, 2) NOT NULL,
    [qty]                  INT NOT NULL,            -- Converted to integer for whole items
    [line_amount]          DECIMAL(18, 2) NOT NULL,
    [stock_on_hand]        INT NOT NULL,
    [reorder_threshold]    INT NOT NULL,
    [transaction_amount]   DECIMAL(18, 2) NOT NULL, -- Keeps the negative number intact
    [transaction_discount] DECIMAL(18, 2) NOT NULL,
    [is_negative_value]    BIT NOT NULL,            -- 1 means True (Negative/Adjustment), 0 means False (Normal Sale)
    [load_date]            DATETIME DEFAULT GETDATE()
);

