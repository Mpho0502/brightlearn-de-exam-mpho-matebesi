--Create a stored procedure for dwh dim date in dwh.
CREATE OR ALTER PROCEDURE [dbo].[sp_load_dwh_dim_date]
AS
BEGIN
    SET NOCOUNT ON; --speeds up ETL process,stops server from countinng rows affected

    -- Create table if it does not exist
    IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_dim_date]', 'U') IS NULL
    BEGIN
        CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_dim_date](
            [DateID] INT IDENTITY(1, 1) PRIMARY KEY,
            [transaction_date] DATE NOT NULL,      
            [customer_since]   DATE NOT NULL,       
            [load_date]        DATETIME DEFAULT GETDATE()
        );
    END;

    -- Insert distinct values only if they do not already exist
    INSERT INTO [dwh_bright_mart_sales].[dbo].[dwh_dim_date] (
            [transaction_date],
            [customer_since]
    )
    SELECT DISTINCT
            cln.[transaction_date],
            cln.[customer_since]
    FROM [stg_bright_mart_sales].[dbo].[clean_dim_date] cln
    WHERE NOT EXISTS (
        SELECT 1 
        FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_date] dim
        WHERE ISNULL(CONVERT(VARCHAR(10), dim.[transaction_date], 120), '') 
              = ISNULL(CONVERT(VARCHAR(10), cln.[transaction_date], 120), '')
          AND ISNULL(CONVERT(VARCHAR(10), dim.[customer_since], 120), '')   
              = ISNULL(CONVERT(VARCHAR(10), cln.[customer_since], 120), '')
    );

    -- Show the dwh dim date table
    SELECT *
    FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_date];
END;
GO
