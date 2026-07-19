--Create a stored procedure for dim customer in stg.
CREATE  OR ALTER PROCEDURE [dbo].[sp_create_dim_customer]
AS
BEGIN
    SET NOCOUNT ON; --speeds up ETL process,stops server from countinng rows affected

    -- Create table if it does not exist
    IF OBJECT_ID('[stg_bright_mart_sales].[dbo].[dim_customer]', 'U') IS NULL
    BEGIN
        CREATE TABLE [stg_bright_mart_sales].[dbo].[dim_customer](
            [CustomerID] INT IDENTITY(1, 1) PRIMARY KEY,
            [customer_first_name]   VARCHAR(50) NULL,
            [customer_last_name]    VARCHAR(50) NULL,
            [customer_email]        VARCHAR(50) NULL,
            [customer_phone]        VARCHAR(50) NULL,
            [customer_city]         VARCHAR(50) NULL,
            [customer_province]     VARCHAR(50) NULL,
            [customer_loyalty_tier] VARCHAR(50) NULL,
            [load_date] DATETIME DEFAULT GETDATE()
        );
    END;

    -- Insert distinct values only if they do not already exist
    INSERT INTO [stg_bright_mart_sales].[dbo].[dim_customer] (
            [customer_first_name],
            [customer_last_name],
            [customer_email],
            [customer_phone],
            [customer_city],
            [customer_province],
            [customer_loyalty_tier]
    )
    SELECT DISTINCT
            raw.[customer_first_name],
            raw.[customer_last_name],
            raw.[customer_email],
            raw.[customer_phone],
            raw.[customer_city],
            raw.[customer_province],
            raw.[customer_loyalty_tier]
    FROM [stg_bright_mart_sales].[dbo].[bright_mart_raw_data] raw
    WHERE NOT EXISTS (
        SELECT 1 
        FROM [stg_bright_mart_sales].[dbo].[dim_customer] dim
        WHERE ISNULL(dim.[customer_first_name], '')   = ISNULL(raw.[customer_first_name], '')
          AND ISNULL(dim.[customer_last_name], '')    = ISNULL(raw.[customer_last_name], '')
          AND ISNULL(dim.[customer_email], '')        = ISNULL(raw.[customer_email], '')
          AND ISNULL(dim.[customer_phone], '')        = ISNULL(raw.[customer_phone], '')
          AND ISNULL(dim.[customer_city], '')         = ISNULL(raw.[customer_city], '')
          AND ISNULL(dim.[customer_province], '')     = ISNULL(raw.[customer_province], '')
          AND ISNULL(dim.[customer_loyalty_tier], '') = ISNULL(raw.[customer_loyalty_tier], '')
    );

    -- Show the dim customer table
    SELECT *
    FROM [stg_bright_mart_sales].[dbo].[dim_customer];
END;
GO
