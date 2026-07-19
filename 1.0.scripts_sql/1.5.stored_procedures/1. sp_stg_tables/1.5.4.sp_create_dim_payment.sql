--Create a stored procedure for dim payment in stg.
CREATE PROCEDURE [dbo].[sp_create_dim_payment]
AS
BEGIN
    SET NOCOUNT ON; --speeds up ETL process,stops server from countinng rows affected

    -- Create table if it does not exist
    IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[dim_payment]', 'U') IS NULL
    BEGIN
        CREATE TABLE [stg_bright_mart_sales].[dbo].[dim_payment](
            [PaymentID] INT IDENTITY(1, 1) PRIMARY KEY,
            [payment_method] VARCHAR(50) NULL,
            [load_date] DATETIME DEFAULT GETDATE()
        );
    END;

    -- Insert distinct values only if they do not already exist
    INSERT INTO [stg_bright_mart_sales].[dbo].[dim_payment] (
            [payment_method]
    )
    SELECT DISTINCT
            raw.[payment_method]
    FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] raw
    WHERE NOT EXISTS (
        SELECT 1 
        FROM [stg_bright_mart_sales].[dbo].[dim_payment] dim
        WHERE ISNULL(dim.[payment_method], '') = ISNULL(raw.[payment_method], '')
    );

    -- Show the dim payment table
    SELECT *
    FROM [stg_bright_mart_sales].[dbo].[dim_payment];
END;
GO
