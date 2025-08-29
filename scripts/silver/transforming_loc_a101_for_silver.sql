INSERT INTO silver.erp_loc_a101(
    cid,
    cntry
)

SELECT 
REPLACE(cid,'-','')as cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
     WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
     ELSE TRIM(cntry)
END as cntry
FROM bronze.erp_loc_a101

