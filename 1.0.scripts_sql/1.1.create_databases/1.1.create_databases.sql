-- Create pc_sales_stg if it does not exist
IF DB_ID('stg_bright_mart_sales') IS NULL
    CREATE DATABASE stg_bright_mart_sales;
GO

-- Create pc_sales_dwh if it does not exist
IF DB_ID('dwh_bright_mart_sales') IS NULL
    CREATE DATABASE dwh_bright_mart_sales;
GO
