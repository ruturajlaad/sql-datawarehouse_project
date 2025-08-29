INSERT INTO silver.erp_cust_az12(
    cid,
    bdate,
    gen
)

SELECT 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid FROM 4)
     ELSE cid 
END as cid,

CASE WHEN bdate> CURRENT_DATE then NULL
     Else bdate
END as bdate,

CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
     WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
     ELSE 'N/A'
END as gen
FROM bronze.erp_cust_az12


