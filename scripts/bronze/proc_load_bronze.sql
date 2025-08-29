/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the COPY command to load data from CSV files to bronze tables.
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN
    -- ===================== CRM Tables =====================

    -- crm_cust_info
    TRUNCATE TABLE bronze.crm_cust_info;
    COPY bronze.crm_cust_info 
    FROM 'C:/Users/laadr/Desktop/sqldwpro/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' 
    WITH (FORMAT csv, HEADER true);

    -- crm_prd_info
    TRUNCATE TABLE bronze.crm_prd_info;
    COPY bronze.crm_prd_info 
    FROM 'C:/Users/laadr/Desktop/sqldwpro/sql-data-warehouse-project/datasets/source_crm/prd_info.csv' 
    WITH (FORMAT csv, HEADER true);

    -- crm_sales_details
    TRUNCATE TABLE bronze.crm_sales_details;
    COPY bronze.crm_sales_details 
    FROM 'C:/Users/laadr/Desktop/sqldwpro/sql-data-warehouse-project/datasets/source_crm/sales_details.csv' 
    WITH (FORMAT csv, HEADER true);

    -- ===================== ERP Tables =====================

    -- erp_loc_a101
    TRUNCATE TABLE bronze.erp_loc_a101;
    COPY bronze.erp_loc_a101 
    FROM 'C:/Users/laadr/Desktop/sqldwpro/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv' 
    WITH (FORMAT csv, HEADER true);

    -- erp_cust_az12
    TRUNCATE TABLE bronze.erp_cust_az12;
    COPY bronze.erp_cust_az12 
    FROM 'C:/Users/laadr/Desktop/sqldwpro/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv' 
    WITH (FORMAT csv, HEADER true);

    -- erp_px_cat_g1v2
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    COPY bronze.erp_px_cat_g1v2 
    FROM 'C:/Users/laadr/Desktop/sqldwpro/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv' 
    WITH (FORMAT csv, HEADER true);

END;
$$;
