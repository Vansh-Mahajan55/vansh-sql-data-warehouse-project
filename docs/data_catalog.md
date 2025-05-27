# Overview:
The Gold layer is the business representation of the data. It contains dimension and fact tables for specific business metrics.

## 1. gold.dim_customers
- **Purpose:** Stores customer details enriched with demographic and geographical data.
- **Columns:**
  
  |Column name|Data Type|Description|
  |----------|-----------|-------------|
  | customer_key | INT | Surrogate key uniquely identifying each customer record in the dimension table. |
  | customer_id | INT | Unique numerical identifier assigned to each customer. |
  | customer_number | NVARCHAR(50) | Alphanumeric identifier representing each customer used for tracking and referencing. |
  | first_name | NVARCHAR(50) | The customer's first name as recorded in the system. |
  | country | NVARCHAR(50) | The country of residence for the customer (e.g 'Australia'). |
  | marital_status | NVARCHAR(50) | The marital status of the customer (e.g 'Married', 'Single'). |
  | gender | NVARCHAR(50) | The gender of the customer (e.g 'Male','Female'.'n/a'). |
  | birth_date | DATE | The birth date of the customer, formatted as YYYY-MM-DD (e.g 1971-05-21). |
  | create_date | DATE | The date and time of creation of the customer record in the table. |

## 2. gold.dim_products
- **Purpose:** Provides information about the products and their attributes.
- **Columns:**

|Column name|Data Type|Description|
|----------|-----------|-------------|
| product_key | INT | Surrogate key uniquely identifying each product in the product dimension table. |
| product_id | INT | A unique identifier assigned to each product for reference and tracking. |
| product_number | NVARCHAR(50) | A structured alphanumeric code representing the product, often used for categorization or inventory. |
| product_name | NVARCHAR(50) | Descriptive name of the product representing size, color or type. |
| category | NVARCHAR(50) | The broader classification of the product within the category such as product type. |
| subcategory | NVARCHAR(50) | A more detailed classification of the product within the category such as product type. |
| maintenance | NVARCHAR(50) | Indicates whether the product requires maintenance (e.g 'Yes','No'). |
| cost | INT | The cost or base price of the product, measured in monetary units. | 
| product_line | NVARCHAR(50) | The base line to which the product belongs (e.g 'Road','Mountains',etc.). |
| start_date | DATE | The date when the product became available for sale,use or stored in. |

## 1. gold.fact_sales
- **Purpose:** Stores transactional sales data for analytical purposes.
- **Columns:**
  
  |Column name|Data Type|Description|
  |----------|-----------|-------------|
  | order_number | NVARCHAR(50) | A unique alphanumeric identifier for each sales order (e.g,'SO54496'). |
  | product_key | INT | Surrogate key linking the order to the product dimension table. |
  | customer_key | INT | Surrogate key linking the order to the customer dimension table. |
  | order_date | DATE | The date when the order was placed. |
  | shipping_date | DATE | The date when the order was shipped to the customer. |
  | due_date | DATE | The date when the order payment was due. |
  | sales_amount | INT | The total monetary value for the line item, in whole currency units. (e.g 25). |
  | quantity | INT | The number of units of the product ordered for the line item (e.g 1) |
  | price | INT | The price per unit of the product for the line item in whole currency units (e.g 25) |
