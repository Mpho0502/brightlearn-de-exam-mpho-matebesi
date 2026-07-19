--Create a stored procedure for dwh dim customer in dwh.
CREATE OR ALTER PROCEDURE [dbo].[sp_load_dwh_dim_customer]
AS
BEGIN
    SET NOCOUNT ON; --speeds up ETL process,stops server from countinng rows affected

    -- Create table if it does not exist
    IF OBJECT_ID('[dwh_bright_mart_sales].[dbo].[dwh_dim_customer]', 'U') IS NULL
    BEGIN
        CREATE TABLE [dwh_bright_mart_sales].[dbo].[dwh_dim_customer](
            [CustomerID]            INT IDENTITY(1, 1) PRIMARY KEY,
            [customer_first_name]   VARCHAR(50) NOT NULL,
            [customer_last_name]    VARCHAR(50) NOT NULL,
            [customer_email]        VARCHAR(50) NOT NULL,
            [customer_phone]        VARCHAR(50) NOT NULL,
            [customer_city]         VARCHAR(50) NOT NULL,
            [customer_province]     VARCHAR(50) NOT NULL,
            [customer_loyalty_tier] VARCHAR(50) NOT NULL,
            [load_date]             DATETIME DEFAULT GETDATE()
        );
    END;

    -- Insert distinct values only if they do not already exist
    INSERT INTO [dwh_bright_mart_sales].[dbo].[dwh_dim_customer] (
            [customer_first_name],
            [customer_last_name],
            [customer_email],
            [customer_phone],
            [customer_city],
            [customer_province],
            [customer_loyalty_tier]
    )
    SELECT DISTINCT
            cln.[customer_first_name],
            cln.[customer_last_name],
            cln.[customer_email],
            cln.[customer_phone],
            cln.[customer_city],
            cln.[customer_province],
            cln.[customer_loyalty_tier]
    FROM [stg_bright_mart_sales].[dbo].[clean_dim_customer] cln
    WHERE NOT EXISTS (
        SELECT 1 
        FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_customer] dim
        WHERE ISNULL(dim.[customer_first_name], '')   = ISNULL(cln.[customer_first_name], '')
          AND ISNULL(dim.[customer_last_name], '')    = ISNULL(cln.[customer_last_name], '')
          AND ISNULL(dim.[customer_email], '')        = ISNULL(cln.[customer_email], '')
          AND ISNULL(dim.[customer_phone], '')        = ISNULL(cln.[customer_phone], '')
          AND ISNULL(dim.[customer_city], '')         = ISNULL(cln.[customer_city], '')
          AND ISNULL(dim.[customer_province], '')     = ISNULL(cln.[customer_province], '')
          AND ISNULL(dim.[customer_loyalty_tier], '') = ISNULL(cln.[customer_loyalty_tier], '')
    );

    -- Show the dwh dim customer table
    SELECT *
    FROM [dwh_bright_mart_sales].[dbo].[dwh_dim_customer];
END;
GO
