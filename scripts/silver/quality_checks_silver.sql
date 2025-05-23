

-- Quality Check: <silver> Table

use DataWareHouse;

-- Quality Check: <crm_cust_info>
-- Check for NULL or duplicate values in the Primary Key
-- Expectation: No Result
select cst_id,count(*)
from silver.crm_cust_info 
group by cst_id
having count(*) > 1 or cst_id is null;


select *
from silver.crm_cust_info
where cst_id = 29449;


-- Selecting only the latest information by ranking individual data based on date
select * from (
select * , row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
from silver.crm_cust_info
)t where flag_last != 1;


-- Checking for unwanted spaces
-- Expectation: No results
select cst_firstname 
from silver.crm_cust_info
where cst_firstname!= trim(cst_firstname);

-- Checking for unwanted spaces
-- Expectation: No results
select cst_gndr 
from silver.crm_cust_info
where cst_gndr!= trim(cst_gndr);


-- Checking for unwanted spaces
-- Expectation: No results
select cst_lastname 
from silver.crm_cust_info
where cst_lastname!= trim(cst_lastname);

-- Checking what's in the cst_marital_status
select distinct cst_marital_status 
from silver.crm_cust_info;
-- Checking what's in the cst_lastname
select distinct cst_gndr
from silver.crm_cust_info;

-----------------------------------------------------------------
-- Quality Check: <crm_prd_info>
select * from bronze.crm_prd_info;
-- Check for NULL or duplicate values in the Primary Key
-- Expectation: No Result
select prd_id, count(*)
from silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null;

-- Preprocessing & checking if the cat_id in crm_prd_info matches that in bronze.crm_sales_details
select 
prd_id,
replace(substring(prd_key,1,5),'-','_')as cat_id,
substring(prd_key,7,len(prd_key)) as prd_key,
prd_nm,
prd_cost,
prd_start_dt,
prd_end_dt 
from bronze.crm_prd_info
where substring(prd_key,7,len(prd_key)) not in
(select sls_prd_key from bronze.crm_sales_details);

-- Checking for unwanted spaces
-- Expectation: No results
select * 
from silver.crm_prd_info
where trim(prd_nm)!=prd_nm;

-- Checking for negative or null price in prd_cost
-- Expectation: No results
select *
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null;

-- Data Standardization and Consistency
select distinct prd_line 
from silver.crm_prd_info;

-- Check for Invalid Date Orders
select *
from silver.crm_prd_info
where prd_end_dt<prd_start_dt;

-- Check the silver.crm_prd_info table
select * from
silver.crm_prd_info;

-----------------------------------------------------------------
-- Quality Check: <crm_sales_details>
select * from bronze.crm_sales_details;

-- Checking for unwanted spaces
select * 
from silver.crm_sales_details 
where trim(sls_ord_num)!=sls_ord_num;

-- Checking whether sls_prd_keys exist which are not in prd_key in crm_prd_info
select * from bronze.crm_sales_details
where sls_prd_key not in
(select prd_key from silver.crm_prd_info)

-- Dates are in integer format , checking the integrity of the date columns
select * 
from silver.crm_sales_details
where sls_order_dt is null or len(sls_order_dt)<8 or sls_order_dt<=0;

-- Checking where the sls_order_dt > sls_ship_dt or > sls_due_dt
select * 
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt> sls_due_dt;

-- Checking whether sls_sales x sls_quantity = sls_price
select 
sls_quantity,
case when sls_sales is null or sls_sales<=0 or sls_sales!=sls_quantity * abs(sls_price)
	then sls_quantity*abs(sls_price)
	else sls_sales
end sls_sales,

case when sls_price is null or sls_price<=0 
	then sls_sales/nullif(sls_quantity,0)
	else sls_price
end sls_price

from silver.crm_sales_details
where sls_quantity*sls_price != sls_sales 
or sls_quantity<=0 or sls_sales<=0 or sls_price<=0
or sls_quantity is null or sls_sales is null or sls_price is null;




-----------------------------------------------------------------
-- Quality Check: <erp_cust_az12>

-- Remove the beginning extra characters from the cid column
select 
case when cid like 'NAS%' then substring(cid,4,len(cid))
	else cid
end cid
from bronze.erp_cust_az12
where case when cid like 'NAS%' then substring(cid,4,len(cid))
	else cid
end not in (select cst_key from silver.crm_cust_info);


-- Identify out of range dates
select bdate from bronze.erp_cust_az12 where bdate >getdate()

-- Fixing birthdates as set in future
select 
case when bdate > getdate() then null
	else bdate
end bdate
from bronze.erp_cust_az12 order by bdate;

--Checking distinct in gender
select distinct gen from bronze.erp_cust_az12;

-- Processing the Gender Column
select distinct gen from(
select 
case when upper(trim(gen)) in ('F','Female') then 'Female'
	when upper(trim(gen)) in ('M','Male') then 'Male'
	else 'n/a'
end gen
from bronze.erp_cust_az12)t;




-----------------------------------------------------------------
-- Quality Check: <erp_cust_az12>

-- Replacing '-' with empty space in cid column in the table
select
trim(replace(cid,'-','')) cid
from bronze.erp_loc_a101 where trim(replace(cid,'-','')) not in (select cst_key from silver.crm_cust_info);

-- Checking the values in the cntry column
select distinct 
cntry from bronze.erp_loc_a101 order by cntry;


-- Data Standardization & Consistency
select distinct
case when trim(cntry) in ('USA','US') then 'United States'
	 when trim(cntry) is null or trim(cntry)='' then 'n/a'
	 when trim(cntry)='DE' then 'Germany'
	 else trim(cntry)
end cntry
from
bronze.erp_loc_a101 order by cntry;


-----------------------------------------------------------------
-- Quality Check: <erp_px_cat_g1v2>
select 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2

-- Check for unwanted spaces
select 
* from bronze.erp_px_cat_g1v2
where cat!=trim(cat) or subcat!=trim(subcat) or maintenance!=trim(maintenance)

-- Data Standardization & Normalization
select distinct cat from bronze.erp_px_cat_g1v2
select distinct subcat from bronze.erp_px_cat_g1v2
select distinct maintenance from bronze.erp_px_cat_g1v2


