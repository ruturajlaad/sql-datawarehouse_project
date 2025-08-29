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
REPLACE(SUBSTRING(prd_key FROM 1 FOR 5),'-','_')as cat_id,
SUBSTRING(prd_key FROM 7 FOR LENGTH(prd_key)) AS prd_key,

prd_nm,
COALESCE(prd_cost, 0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
    WHEN 'R' THEN 'Road'
    WHEN 'S' THEN 'Other Sales'
    WHEN 'M' THEN 'Mountain'
    WHEN 'T' THEN 'Touring'
    ELSE 'N/A'
END as prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day' AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;
