--check for nulls or duplicates in primary key 
--expectation : No result 

select cst_id,count(*) 
from silver.crm_cust_info
group by cst_id
having COUNT(*)>1 or cst_id is null


-- check for unwanted spaces 
select cst_firstname
from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname)

select cst_lastname
from silver.crm_cust_info
where cst_lastname != TRIM(cst_lastname)

select cst_gender
from silver.crm_cust_info
where cst_gender!=trim(cst_gender)

select * from bronze.erp_px_cat_g1v2
where cat!= trim(cat) or subcat!=TRIM(subcat) or maintenance!=trim(maintenance)

--Data standardization & consistency checks
select distinct cst_gender
from silver.crm_cust_info

select distinct gen ,
case when UPPER(trim(gen)) in ('F', 'Female') then 'Female'
	 when UPPER(trim(gen)) in ('M', 'Male') then 'Male'
	 else 'N/A'
end as gen
from bronze.erp_cust_az12

select distinct maintenance 
	from bronze.erp_px_cat_g1v2

--check for invalid date orders
select *
from silver.crm_prd_info
where prd_end_dt<prd_start_dt


-- check for invalid dates 
select 
nullif(sls_due_dt,0) sls_due_dt
from bronze.crm_sales_details
where sls_due_dt <= 0 or len(sls_due_dt)!=8

--check for invalid date orders
select *
from bronze.crm_sales_details
where sls_order_dt>sls_ship_dt or sls_order_dt> sls_due_dt

-- check data consistency : between sales,quantity and price 
-- >> Sales=quantity*price
-- >> values must not be NULL,zero or negative.
select distinct
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity*sls_price 
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <=0 or sls_quantity <=0 or sls_price <=0 

-- Identify out-of-range dates
select distinct bdate 
from bronze.erp_cust_az12
where bdate < '1924-01-01' or bdate > getdate()


select cst_key from silver.crm_cust_info
select distinct cntry
from bronze.erp_loc_a101
order by cntry