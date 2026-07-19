--Create Fact Table with Dimension Foreign Keys
IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table]', 'U') IS NULL
 CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table](
        [SalesID]              INT IDENTITY(1, 1) PRIMARY KEY,
    -- Dimension Foreign Keys
        [StoreID]              INT NOT NULL,
        [CustomerID]           INT NOT NULL,
        [ProductID]            INT NOT NULL,
        [PaymentID]            INT NOT NULL,
        [DateID]               INT NOT NULL,
    -- Metrics / Financial Columns
        [unit_price]           DECIMAL(18, 2) NOT NULL, 
        [cost_price]           DECIMAL(18, 2) NOT NULL,
        [qty]                  INT NOT NULL,           
        [line_amount]          DECIMAL(18, 2) NOT NULL,
        [stock_on_hand]        INT NOT NULL,
        [reorder_threshold]    INT NOT NULL,
        [transaction_amount]   DECIMAL(18, 2) NOT NULL, 
        [transaction_discount] DECIMAL(18, 2) NOT NULL,
        [is_negative_value]    BIT NOT NULL,            
        [load_date]            DATETIME DEFAULT GETDATE()
);

-- Insert distinct values into the table from clean data only if they do not already exist
INSERT INTO [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table] (
        [StoreID], 
        [CustomerID], 
        [ProductID],
        [PaymentID], 
        [DateID], 
        [unit_price],
        [cost_price],
        [qty],
        [line_amount],
        [stock_on_hand],
        [reorder_threshold],
        [transaction_amount],
        [transaction_discount],
        [is_negative_value]
)
SELECT DISTINCT
        cln.[StoreID], 
        cln.[CustomerID], 
        cln.[ProductID],
        cln.[PaymentID], 
        cln.[DateID], 
        cln.[unit_price],
        cln.[cost_price],
        cln.[qty],
        cln.[line_amount],
        cln.[stock_on_hand],
        cln.[reorder_threshold],
        cln.[transaction_amount],
        cln.[transaction_discount],
        cln.[is_negative_value]
FROM [stg_bright_mart_sales].[dbo].[clean_bright_mart_fact_table] cln
WHERE NOT EXISTS (
    SELECT 1 
    FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table] fact
    WHERE 
          ISNULL(fact.[StoreID], '')              = ISNULL(cln.[StoreID], '')
      AND ISNULL(fact.[CustomerID], '')           = ISNULL(cln.[CustomerID], '')
      AND ISNULL(fact.[ProductID], '')            = ISNULL(cln.[ProductID], '')
      AND ISNULL(fact.[PaymentID], '')            = ISNULL(cln.[PaymentID], '')
      AND ISNULL(fact.[DateID], '')               = ISNULL(cln.[DateID], '')
);

-- Show the dwh dim customer table
SELECT *
FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table];