/*
==============================================================
Stored Procedure: Load Bronze Layer (source-> Bronze)
==============================================================
Script Purpose:
    This stored procedure loads the data into the 'BRONZE' schema.
    It performs two things:
    - Truncates the existing tables in the schema.
    - Uses BULK INSERT command to load the CSV files into the schema

Parameters:
  None
  This stored procedure does not take any parameters or return any values

Usage example:
  EXEC bronze.load_bronze;
==============================================================
*/





-- truncate Deletes everything from the table before loading the data into the table
-- create procedure creates a block of code that can be executed using 'exec' <procedure_name> (e.g bronze.load_bronze)
-- The stored procedures are stored in programmability->stored procedures
use DataWareHouse;
create or alter procedure bronze.load_bronze as
begin
begin try
	print '============================='
	print 'Loading Bronze Layer'
	print '============================='

	print '-----------------------------'
	print 'Loading CRM tables'
	print '-----------------------------'

	declare @start_time datetime,@end_time datetime,@batch_start_time datetime,@batch_end_time datetime;

	set @batch_start_time=getdate()
	set @start_time=getdate()
	print '>>Truncating table: bronze.crm_cust_info'
	truncate table bronze.crm_cust_info;
	print '>>Loading Data into: bronze.crm_cust_info'
	bulk insert bronze.crm_cust_info
	from 'C:\Users\Vansh\Downloads\Data Engineering Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with (
		firstrow=2,
		fieldterminator=',',
		tablock
	);
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'
	select count(*) from bronze.crm_cust_info;


	set @start_time=getdate()
	print '>>Truncating table: bronze.crm_prd_info'
	truncate table bronze.crm_prd_info;
	print '>>Loading Data into: bronze.crm_prd_info'
	bulk insert bronze.crm_prd_info
	from 'C:\Users\Vansh\Downloads\Data Engineering Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with (
		firstrow=2,
		fieldterminator=',',
		tablock
	)
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'
	select count(*) from bronze.crm_prd_info;


	set @start_time=getdate()
	print '>>Truncating table: bronze.crm_sales_details'
	truncate table bronze.crm_sales_details;
	print '>>Loading data into: bronze.crm_sales_details'
	bulk insert bronze.crm_sales_details
	from 'C:\Users\Vansh\Downloads\Data Engineering Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with (
		firstrow=2,
		fieldterminator=',',
		tablock
	)
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'
	select count(*) from bronze.crm_sales_details;


	print '-----------------------------'
	print 'Loading ERP tables'
	print '-----------------------------'


	set @start_time=getdate()
	print '>>Truncating table: bronze.erp_cust_az12'
	truncate table bronze.erp_cust_az12;
	print '>>Loading data into: bronze.erp_cust_az12'
	bulk insert bronze.erp_cust_az12
	from 'C:\Users\Vansh\Downloads\Data Engineering Project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	with (
		firstrow=2,
		fieldterminator=',',
		tablock
	)
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'
	select count(*) from bronze.erp_cust_az12;


	set @start_time=getdate()
	print '>>Truncating table: bronze.erp_loc_a101'
	truncate table bronze.erp_loc_a101;
	print '>>Loading data into: bronze.erp_loc_a101'
	bulk insert bronze.erp_loc_a101
	from 'C:\Users\Vansh\Downloads\Data Engineering Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	with (
		firstrow=2,
		fieldterminator=',',
		tablock
	)
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'
	select count(*) from bronze.erp_loc_a101;


	set @start_time=getdate()
	print '>>Truncating table: bronze.erp_px_cat_g1v2'
	truncate table bronze.erp_px_cat_g1v2;
	print '>>Loading data into: bronze.erp_px_cat_g1v2'
	bulk insert bronze.erp_px_cat_g1v2
	from 'C:\Users\Vansh\Downloads\Data Engineering Project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	with (
		firstrow=2,
		fieldterminator=',',
		tablock
	)
	set @end_time=getdate()
	print '>>Load Duration: '+cast(datediff(second,@start_time,@end_time) as nvarchar(50))+' seconds'
	select count(*) from bronze.erp_px_cat_g1v2;

	set @batch_end_time=getdate()
	print '>>Batch Load duration: '+cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar(40))+' seconds'
	end try


	begin catch
	print '------------------------------------------'
	print 'Error Occured while loading Bronze Layer'
	print 'Error Message'+error_message();
	print 'Error Message'+cast(error_number() as nvarchar(50));
	print 'Error Message'+cast(error_state() as nvarchar(50));
	print '------------------------------------------'

	end catch
end
