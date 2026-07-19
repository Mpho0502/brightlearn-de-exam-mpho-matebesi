--Create a stored procedure for the dwh Bright Mart fact table in dwh.
CREATE OR ALTER PROCEDURE [dbo].[sp_load_dwh_bright_mart_fact_table]
AS
BEGIN
    SET NOCOUNT ON; --speeds up ETL process,stops server from countinng rows affected

    -- Create fact table with dimension foreign keys if it does not exist
    IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table]', 'U') IS NULL
    BEGIN
        CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table](
            [SalesID]              INT IDENTITY(1, 1) PRIMARY KEY,
            [StoreID]              INT NOT NULL,
            [CustomerID]           INT NOT NULL,
            [ProductID]            INT NOT NULL,
            [PaymentID]            INT NOT NULL,
            [DateID]               INT NOT NULL,
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
    END;

    -- Insert distinct values only if they do not already exist
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
        WHERE fact.[StoreID]    = cln.[StoreID]
          AND fact.[CustomerID] = cln.[CustomerID]
          AND fact.[ProductID]  = cln.[ProductID]
          AND fact.[PaymentID]  = cln.[PaymentID]
          AND fact.[DateID]     = cln.[DateID]
          AND fact.[unit_price] = cln.[unit_price]
          AND fact.[cost_price] = cln.[cost_price]
          AND fact.[qty]        = cln.[qty]
          AND fact.[line_amount]= cln.[line_amount]
          AND fact.[transaction_amount] = cln.[transaction_amount]
    );

    -- Show the warehouse fact table
    SELECT *
    FROM [dwh_bright_mart_sales].[dbo].[dwh_bright_mart_fact_table];
END;
GO
