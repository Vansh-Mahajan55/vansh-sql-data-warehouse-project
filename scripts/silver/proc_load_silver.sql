



-- Preprocessing and Inserting into Silver Schema

create or alter procedure silver.load_silver as
begin
begin try
	print '============================='
	print 'Loading Silver Layer'
	print '============================='

	print '-----------------------------'
	print 'Loading CRM tables'
	print '-----------------------------'

	declare @start_time datetime,@end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	set @batch_start_time=getdate()
	set @start_time=getdate()
	-- Inserting into silver.crm_cust_info
	print '>> Inserting Data into: silver.crm_cust_info';
	truncate table silver.crm_cust_info;
	insert into silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)
	select 
	cst_id,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	case when upper(trim(cst_marital_status))='S' then 'Single'
			when upper(trim(cst_marital_status))='M' then 'Married'
			else 'n/a'
	end cst_marital_status,
	case when upper(trim(cst_gndr))='F' then 'Female'
			when upper(trim(cst_gndr))='M' then 'Male'
			else 'n/a'
	end cst_gndr,
	cst_create_date
	from 
	(
	select * , row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
	from bronze.crm_cust_info
	where cst_id is not null
	)t where flag_last = 1;
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'





	-- Inserting into silver.crm_prd_info
	-- >> Modifying the silver.crm_sales_info to let new data into the table
	set @start_time=getdate()

	if OBJECT_ID('silver.crm_prd_info','U') is not null
		drop table silver.crm_prd_info;
	create table silver.crm_prd_info(
	prd_id int,
	cat_id	nvarchar(50),
	prd_key	nvarchar(50),
	prd_nm	nvarchar(50),
	prd_cost int,
	prd_line varchar(20),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getdate(),
	);

	-- inserting the preprocessed data into the silver.crm_prd_info
	print '>> Inserting Data into: silver.crm_prd_info';
	truncate table silver.crm_prd_info;
	insert into silver.crm_prd_info
	(
	prd_id,
	cat_id,
	prd_key,
	prd_nm, 
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)
	select
	prd_id,
	replace(substring(prd_key,1,5),'-','_')as cat_id,
	substring(prd_key,7,len(prd_key)) as prd_key,
	prd_nm,
	isnull(prd_cost,0) as prd_cost,
	case when upper(trim(prd_line))='M' then 'Mountain'
			when upper(trim(prd_line))='R' then 'Road'
			when upper(trim(prd_line))='S' then 'Other Sales'
			when upper(trim(prd_line))='T' then 'Touring'
			else 'n/a'
	end as prd_line,
	prd_start_dt,
	cast(dateadd(day,-1,lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)) as date) as prd_end_dt
	from bronze.crm_prd_info 
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'



	-- Inserting into silver.crm_sales_details
	-- >> Modifying the silver.crm_sales_details to let new data into the table

	set @start_time=getdate()

	if OBJECT_ID('silver.crm_sales_details','U') is not null
		drop table silver.crm_sales_details;
	create table silver.crm_sales_details(
	sls_ord_num	nvarchar(40),
	sls_prd_key	nvarchar(40),
	sls_cust_id	int,
	sls_order_dt date,
	sls_ship_dt	date,
	sls_due_dt	date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_create_date datetime2 default getdate(),
	);

	-- inserting the preprocessed data into the silver.crm_sales_details
	print '>> Inserting Data into: silver.crm_sales_details';
	truncate table silver.crm_sales_details;
	insert into silver.crm_sales_details
	(
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
	select 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	case when len(sls_order_dt)<8 or sls_order_dt=0 then null
			else cast(cast(sls_order_dt as varchar) as date)
	end as sls_order_dt,
	case when len(sls_ship_dt)<8 or sls_ship_dt=0 then null
			else cast(cast(sls_ship_dt as varchar) as date)
	end as sls_ship_dt,
	case when len(sls_due_dt)<8 or sls_due_dt=0 then null
			else cast(cast(sls_due_dt as varchar) as date)
	end as sls_due_dt,
	case when sls_sales is null or sls_sales<=0 or sls_sales!=sls_quantity * abs(sls_price)
		then sls_quantity*abs(sls_price)
		else sls_sales
	end sls_sales,
	sls_quantity,
	case when sls_price is null or sls_price<=0 
		then sls_sales/nullif(sls_quantity,0)
		else sls_price
	end sls_price
	from bronze.crm_sales_details;
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'


	print '-----------------------------'
	print 'Loading ERP tables'
	print '-----------------------------'


	-- Inserting into silver.erp_cust_az12
	set @start_time=getdate()
	print '>> Inserting Data into: silver.erp_cust_az12';
	truncate table silver.erp_cust_az12;
	insert into silver.erp_cust_az12 (
	cid,
	bdate,
	gen)
	select 
	case when cid like 'NAS%' then substring(cid,4,len(cid))
		else cid
	end cid,
	case when bdate > getdate() then null
		else bdate
	end bdate,
	case when upper(trim(gen)) in ('F','Female') then 'Female'
		when upper(trim(gen)) in ('M','Male') then 'Male'
		else 'n/a'
	end gen
	from bronze.erp_cust_az12;
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'


	-- Inserting into silver.erp_loc_a101
	set @start_time=getdate()
	print '>> Inserting Data into: silver.erp_loc_a101';
	truncate table silver.erp_loc_a101;
	insert into silver.erp_loc_a101 (
	cid,
	cntry)
	select
	trim(replace(cid,'-','')) cid,
	case when trim(cntry) in ('USA','US') then 'United States'
			when trim(cntry) is null or trim(cntry)='' then 'n/a'
			when trim(cntry)='DE' then 'Germany'
			else trim(cntry)
	end cntry
	from bronze.erp_loc_a101;
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'


	-- Inserting into silver.erp_px_cat_g1v2
	set @start_time=getdate()
	print '>> Inserting Data into: silver.erp_px_cat_g1v2';
	truncate table silver.erp_px_cat_g1v2
	insert into silver.erp_px_cat_g1v2 (
	id,
	cat,
	subcat,
	maintenance)
	select * from bronze.erp_px_cat_g1v2;

	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'

	set @batch_end_time=getdate()
	print '>>Batch Load duration: '+cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar(40))+' seconds'

	end try

	begin catch
	print '------------------------------------------'
	print 'Error Occured while loading Silver Layer'
	print 'Error Message'+ERROR_MESSAGE();
	print 'Error Message'+cast(error_number() as nvarchar(50));
	print 'Error Message'+cast(error_state() as nvarchar(50));
	print '------------------------------------------'
	end catch

end

