INSERT into silver.crm_cust_info(
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
case 
    WHEN upper(trim(cst_marital_status)) = 'M' then 'Married'
    WHEN upper(trim(cst_marital_status)) = 'S' then 'Single'
    ELSE 'N/A'
end cst_marital_status,
case 
    WHEN upper(trim(cst_gndr)) = 'M' then 'Male'
    WHEN upper(trim(cst_gndr)) = 'F' then 'Female'
    ELSE 'N/A'
end cst_gndr,
cst_create_date
from(
    select *,
row_number() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag
 from bronze.crm_cust_info
where cst_id is NOT NULL
) where flag =1
)
