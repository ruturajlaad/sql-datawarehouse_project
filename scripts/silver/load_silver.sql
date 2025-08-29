/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This procedure loads transformed/cleansed data from Bronze into Silver schema.
    Steps:
      - Truncates Silver tables
      - Inserts transformed records from Bronze
===============================================================================
*/

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Silver Layer Started';
    RAISE NOTICE '================================================';

    -- ===================== CRM Tables =====================
    RAISE NOTICE '>> Truncating and Loading: silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;

    INSERT INTO silver.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE 
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            ELSE 'N/A'
        END AS cst_marital_status,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            ELSE 'N/A'
        END AS cst_gndr,
        cst_create_date
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) t
    WHERE flag = 1;

    RAISE NOTICE '>> Loaded: silver.crm_cust_info';

    -- crm_prd_info
    RAISE NOTICE '>> Truncating and Loading: silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info;

    INSERT INTO silver.crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT 
        prd_id,
        REPLACE(SUBSTRING(prd_key FROM 1 FOR 5), '-', '_') AS cat_id,
        SUBSTRING(prd_key FROM 7) AS prd_key,
        prd_nm,
        COALESCE(prd_cost, 0) AS prd_cost,
        CASE UPPER(TRIM(prd_line))
            WHEN 'R' THEN 'Road'
            WHEN 'S' THEN 'Other Sales'
            WHEN 'M' THEN 'Mountain'
            WHEN 'T' THEN 'Touring'
            ELSE 'N/A'
        END AS prd_line,
        CAST(prd_start_dt AS DATE) AS prd_start_dt,
        CAST(
            LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) 
            - INTERVAL '1 day' AS DATE
        ) AS prd_end_dt
    FROM bronze.crm_prd_info;

    RAISE NOTICE '>> Loaded: silver.crm_prd_info';

    -- crm_sales_details
    RAISE NOTICE '>> Truncating and Loading: silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details;

    INSERT INTO silver.crm_sales_details (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id::INT,
        CASE 
            WHEN sls_order_dt = '0' OR LENGTH(sls_order_dt) != 8 THEN NULL
            ELSE TO_DATE(sls_order_dt, 'YYYYMMDD')
        END AS sls_order_dt,
        CASE 
            WHEN sls_ship_dt = '0' OR LENGTH(sls_ship_dt) != 8 THEN NULL
            ELSE TO_DATE(sls_ship_dt, 'YYYYMMDD')
        END AS sls_ship_dt,
        CASE 
            WHEN sls_due_dt = '0' OR LENGTH(sls_due_dt) != 8 THEN NULL
            ELSE TO_DATE(sls_due_dt, 'YYYYMMDD')
        END AS sls_due_dt,
        CASE 
            WHEN sls_sales IS NULL OR sls_sales::INT <= 0 
                 OR sls_sales::INT != sls_quantity::INT * ABS(sls_price::INT)
            THEN sls_quantity::INT * ABS(sls_price::INT)
            ELSE sls_sales::INT
        END AS sls_sales,
        sls_quantity::INT,
        CASE 
            WHEN sls_price IS NULL OR sls_price::INT <= 0
            THEN (sls_sales::INT / NULLIF(sls_quantity::INT, 0))
            ELSE sls_price::INT
        END AS sls_price
    FROM bronze.crm_sales_details;

    RAISE NOTICE '>> Loaded: silver.crm_sales_details';

    -- erp_cust_az12
    RAISE NOTICE '>> Truncating and Loading: silver.erp_cust_az12';
    TRUNCATE TABLE silver.erp_cust_az12;

    INSERT INTO silver.erp_cust_az12 (
        cid,
        bdate,
        gen
    )
    SELECT
        CASE 
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid FROM 4)
            ELSE cid
        END AS cid,
        CASE 
            WHEN bdate > CURRENT_DATE THEN NULL
            ELSE bdate
        END AS bdate,
        CASE 
            WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
            ELSE 'N/A'
        END AS gen
    FROM bronze.erp_cust_az12;

    RAISE NOTICE '>> Loaded: silver.erp_cust_az12';

    -- erp_loc_a101
    RAISE NOTICE '>> Truncating and Loading: silver.erp_loc_a101';
    TRUNCATE TABLE silver.erp_loc_a101;

    INSERT INTO silver.erp_loc_a101 (
        cid,
        cntry
    )
    SELECT
        REPLACE(cid, '-', '') AS cid,
        CASE 
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
            ELSE TRIM(COALESCE(cntry, 'N/A'))
        END AS cntry
    FROM bronze.erp_loc_a101;

    RAISE NOTICE '>> Loaded: silver.erp_loc_a101';

    -- erp_px_cat_g1v2
    RAISE NOTICE '>> Truncating and Loading: silver.erp_px_cat_g1v2';
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    INSERT INTO silver.erp_px_cat_g1v2 (
        id,
        cat,
        subcat,
        maintenance
    )
    SELECT
        id,
        cat,
        subcat,
        maintenance
    FROM bronze.erp_px_cat_g1v2;

    RAISE NOTICE '>> Loaded: silver.erp_px_cat_g1v2';

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Silver Layer Load Completed';
    RAISE NOTICE '================================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==============================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE NOTICE '==============================================';
END;
$$;
