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
DECLARE 
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP := clock_timestamp();
    batch_end_time TIMESTAMP;
BEGIN
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

    -- ===================== CRM Tables =====================
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------------------------';

    -- crm_cust_info
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_cust_info;
    RAISE NOTICE '>> Truncated: bronze.crm_cust_info';
    EXECUTE format(
        'COPY bronze.crm_cust_info FROM %L WITH (FORMAT csv, HEADER true)',
        'C:/sql/dwh_project/datasets/source_crm/cust_info.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Loaded bronze.crm_cust_info in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- crm_prd_info
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_prd_info;
    EXECUTE format(
        'COPY bronze.crm_prd_info FROM %L WITH (FORMAT csv, HEADER true)',
        'C:/sql/dwh_project/datasets/source_crm/prd_info.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Loaded bronze.crm_prd_info in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- crm_sales_details
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_sales_details;
    EXECUTE format(
        'COPY bronze.crm_sales_details FROM %L WITH (FORMAT csv, HEADER true)',
        'C:/sql/dwh_project/datasets/source_crm/sales_details.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Loaded bronze.crm_sales_details in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- ===================== ERP Tables =====================
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------------------------';

    -- erp_loc_a101
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_loc_a101;
    EXECUTE format(
        'COPY bronze.erp_loc_a101 FROM %L WITH (FORMAT csv, HEADER true)',
        'C:/sql/dwh_project/datasets/source_erp/loc_a101.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Loaded bronze.erp_loc_a101 in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- erp_cust_az12
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_cust_az12;
    EXECUTE format(
        'COPY bronze.erp_cust_az12 FROM %L WITH (FORMAT csv, HEADER true)',
        'C:/sql/dwh_project/datasets/source_erp/cust_az12.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Loaded bronze.erp_cust_az12 in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- erp_px_cat_g1v2
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    EXECUTE format(
        'COPY bronze.erp_px_cat_g1v2 FROM %L WITH (FORMAT csv, HEADER true)',
        'C:/sql/dwh_project/datasets/source_erp/px_cat_g1v2.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Loaded bronze.erp_px_cat_g1v2 in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- ===================== Completion =====================
    batch_end_time := clock_timestamp();
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Loading Bronze Layer Completed';
    RAISE NOTICE '   - Total Duration: % seconds', EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '==========================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==========================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE NOTICE '==========================================';
END;
$$;
