--Create a stored procedure for clean dim date in stg.
CREATE OR ALTER PROCEDURE [dbo].[sp_load_clean_dim_date]
AS
BEGIN
    SET NOCOUNT ON;  --speeds up ETL process,stops server from countinng rows affected

    -- Recreate table with proper DATE data types if it does not exist
    IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_date]', 'U') IS NULL
    BEGIN
        CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_date](
            [DateID] INT IDENTITY(1, 1) PRIMARY KEY,
            [transaction_date] DATE NOT NULL,      -- Converted to DATE type
            [customer_since]   DATE NOT NULL,      -- Converted to DATE type
            [load_date]        DATETIME DEFAULT GETDATE()
        );
    END;

    -- Insert distinct cleaned values only if they do not already exist
    INSERT INTO [stg_bright_mart_sales].[dbo].[clean_dim_date] ( 
            [transaction_date], 
            [customer_since] 
    ) 
    SELECT DISTINCT 
        COALESCE(TRY_CONVERT(DATE, raw.[transaction_date]), '1900-01-01') AS [transaction_date], 
        COALESCE(TRY_CONVERT(DATE, raw.[customer_since]), '1900-01-01')   AS [customer_since] 
    FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS raw
    WHERE (raw.[transaction_date] IS NOT NULL OR 
           raw.[customer_since] IS NOT NULL)
      AND NOT EXISTS (
          SELECT 1 
          FROM [stg_bright_mart_sales].[dbo].[clean_dim_date] AS cdd
          WHERE cdd.[transaction_date] = COALESCE(TRY_CONVERT(DATE, raw.[transaction_date]), '1900-01-01')
            AND cdd.[customer_since]   = COALESCE(TRY_CONVERT(DATE, raw.[customer_since]), '1900-01-01')
      );

    -- Show the clean table
    SELECT *
    FROM [stg_bright_mart_sales].[dbo].[clean_dim_date];
END;
GO
