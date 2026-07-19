--Create a stored procedure for clean dim payment in stg.
CREATE OR ALTER PROCEDURE [dbo].[sp_load_clean_dim_payment]
AS
BEGIN
    SET NOCOUNT ON;  --speeds up ETL process,stops server from countinng rows affected

    -- Recreate table with proper data types if it does not exist
    IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[clean_dim_payment]', 'U') IS NULL
    BEGIN
        CREATE TABLE [stg_bright_mart_sales].[dbo].[clean_dim_payment](
            [PaymentID]      INT IDENTITY(1, 1) PRIMARY KEY,
            [payment_method] VARCHAR(50) NOT NULL,
            [load_date]      DATETIME DEFAULT GETDATE()
        );
    END;

    -- Insert distinct cleaned values only if they do not already exist
    INSERT INTO [stg_bright_mart_sales].[dbo].[clean_dim_payment] ( 
            [payment_method] 
    ) 
    SELECT DISTINCT 
        COALESCE(NULLIF(TRIM(raw.[payment_method]), ''), 'Unknown') AS [payment_method] 
    FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] AS raw
    WHERE raw.[payment_method] IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM [stg_bright_mart_sales].[dbo].[clean_dim_payment] AS cdp
          WHERE cdp.[payment_method] = COALESCE(NULLIF(TRIM(raw.[payment_method]), ''), 'Unknown')
      );

    -- Show the clean table
    SELECT *
    FROM [stg_bright_mart_sales].[dbo].[clean_dim_payment];
END;
GO
