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
CAST(sls_ord_num AS VARCHAR(50)) AS sls_ord_num,
CAST(sls_prd_key AS VARCHAR(50)) AS sls_prd_key,
CAST(sls_cust_id AS INT) AS sls_cust_id,
CASE
    WHEN sls_order_dt = '0' OR LENGTH(sls_order_dt) != 8 THEN NULL
    ELSE TO_DATE(sls_order_dt, 'YYYYMMDD')
END as sls_order_dt,

CASE
    WHEN sls_ship_dt = '0' OR LENGTH(sls_ship_dt) != 8 THEN NULL
    ELSE TO_DATE(sls_ship_dt, 'YYYYMMDD')
END as sls_ship_dt,

CASE
    WHEN sls_due_dt = '0' OR LENGTH(sls_due_dt) != 8 THEN NULL
    ELSE TO_DATE(sls_due_dt, 'YYYYMMDD')
END as sls_due_dt,
CAST(
    CASE 
        WHEN sls_sales IS NULL 
             OR CAST(sls_sales AS INT) <= 0 
             OR CAST(sls_sales AS INT) != CAST(sls_quantity AS INT) * ABS(CAST(sls_price AS INT)) 
        THEN CAST(sls_quantity AS INT) * ABS(CAST(sls_price AS INT)) 
        ELSE CAST(sls_sales AS INT) 
    END 
AS INT) AS sls_sales,

CAST(sls_quantity AS INT) AS sls_quantity,

CAST(
    CASE 
        WHEN sls_price IS NULL 
             OR CAST(sls_price AS INT) <= 0 
        THEN CAST(sls_sales AS INT) / NULLIF(CAST(sls_quantity AS INT), 0) 
        ELSE CAST(sls_price AS INT) 
    END 
AS INT) AS sls_price



FROM bronze.crm_sales_details

