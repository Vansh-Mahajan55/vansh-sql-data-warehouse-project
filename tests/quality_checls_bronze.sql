-- Quality Check: <Bronze> crm_cust_info

-- Check for NULL or duplicate values in the Primary Key
-- Expectation: No Result
select cst_id,count(*)
from bronze.crm_cust_info 
group by cst_id
having count(*) > 1 or cst_id is null;



select *
from bronze.crm_cust_info
where cst_id = 29449;


-- Selecting only the latest information by ranking individual data based on date
select * from (
select * , row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info
cst_id is not null
)t where flag_last = 1;


-- Checking for unwanted spaces
-- Expectation: No results
select cst_firstname 
from bronze.crm_cust_info
where cst_firstname!= trim(cst_firstname);

-- Checking for unwanted spaces
-- Expectation: No results
select cst_gndr 
from bronze.crm_cust_info
where cst_gndr!= trim(cst_gndr);


-- Checking for unwanted spaces
-- Expectation: No results
select cst_lastname 
from bronze.crm_cust_info
where cst_lastname!= trim(cst_lastname);

-- Checking what's in the cst_marital_status
select distinct cst_marital_status 
from bronze.crm_cust_info;
-- Checking what's in the cst_lastname
select distinct cst_gndr
from bronze.crm_cust_info;




