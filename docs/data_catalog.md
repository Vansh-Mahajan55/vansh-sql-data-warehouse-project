# Overview:
The Gold layer is the business representation of the data. It contains dimension and fact tables for specific business metrics.

## 1. gold.dim_customers
- **Purpose:** Stores customer details enriched with demographic and geographical data.
- **Columns:**
  |Column name|Data Type|Description|
  ----------------------------------
  | customer_key | INT | Surrogate key uniquely identifying each customer record in the dimension table. |
  | customer_id | INT | Unique numerical identifier assigned to each customer. |
  | customer_number | NVARCHAR(50) | Alphanumeric identifier representing each customer used for tracking and referencing. |
  | first_name | NVARCHAR(50) | The customer's first name as recorded in the system. |
  | country | NVARCHAR(50) | The country of residence for the customer (e.g 'Australia'). |
  | marital_status | NVARCHAR(50) | The marital status of the customer (e.g 'Married', 'Single'). |
  | gender | NVARCHAR(50) | The gender of the customer (e.g 'Male','Female'.'n/a'). |
  | birth_date | DATE | The birth date of the customer, formatted as YYYY-MM-DD (e.g 1971-05-21). |
  | create_date | DATE | The date and time of creation of the customer record in the table. |
