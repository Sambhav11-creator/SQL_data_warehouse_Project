insert into silver.erp_cust_az12(
    cid,
    bdate,
    gen
)
SELECT
    case when cid like 'NAS%' then substring(cid,4,len(cid))
         else cid
    end as cid,
    case when bdate>getdate() then null
        else bdate
    end as bdate,
    case 
         when UPPER(trim(gen)) in ('F', 'Female') then 'Female'
	     when UPPER(trim(gen)) in ('M', 'Male') then 'Male'
	     else 'N/A'
    end as gen
FROM bronze.erp_cust_az12
