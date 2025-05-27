/*
======================================================
DDL Script: Create Gold Views
======================================================
Script Purpose: 
  This script creates view for the gold layer in the datawarehouse.
  The Gold layer represents the final dimensions and fact tables (Star Schema) 

  Each view performs transformations and combines data from the silver layer
  to provide a clean, enriched and business-ready dataset.
======================================================
Usage: 
  These views can be directly queried for analytics and reporting
*/

-- ======================================================
-- Create dimension: gold.dim_customers
-- ======================================================
if object('gold.dim_customers','v') is not null
	drop view gold.dim_customers 
create view gold.dim_customers as 
select 
	row_number() over (order by cst_id) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname last_name,
	lo.cntry as country,
	ci.cst_marital_status as marital_status,
	case when ci.cst_gndr!='n/a' then ci.cst_gndr   --CRM is the master for Gender Info
		 else coalesce(ca.gen,'n/a')
	end as gender,
	ca.bdate as birth_date,
	ci.cst_create_date as create_date
from silver.crm_cust_info as ci
left join silver.erp_cust_az12 as ca
on		ci.cst_key= ca.cid
left join silver.erp_loc_a101 lo 
on ci.cst_key = lo.cid;


-- ======================================================
-- Create dimension: gold.dim_products
-- ======================================================
if object('gold.dim_products','v') is not null
	drop view gold.dim_products 
create view gold.dim_products as
select 
	row_number() over (order by pn.prd_start_dt,pn.prd_key) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance,
	pn.prd_cost as product_cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc
	on pn.cat_id=pc.id
where prd_end_dt is null; --filter out historical data


-- ======================================================
-- Create dimension: gold.fact_sales
-- ======================================================
if object('gold.fact_sales','v') is not null
	drop view gold.fact_sales 
create view gold.fact_sales as
select 
  sd.sls_ord_num as order_number,
  pr.product_key,
  cu.customer_key,
  sd.sls_order_dt as order_date,
  sd.sls_ship_dt as shipping_date,
  sd.sls_due_dt as due_date,
  sd.sls_sales as sales_amount,
  sd.sls_quantity as sales_quantity,
  sd.sls_price as price
from silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key=pr.product_number	
left join gold.dim_customers cu
on sd.sls_cust_id=cu.customer_id;
