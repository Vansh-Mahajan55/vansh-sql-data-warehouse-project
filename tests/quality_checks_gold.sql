-- Quality Check: <gold> views

-- foreign key integrity (dimensions)
select *
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key=f.customer_key
left join gold.dim_products p
on p.product_key=f.product_key
where c.customer_key is null;
