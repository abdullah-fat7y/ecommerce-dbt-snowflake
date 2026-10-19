
  create or replace   view ECOMMERCE_DB.STAGING_MARTS.fct_order_details
  
  
  
  
  as (
    -- Combine staged orders, customers, and products.
-- Revenue is calculated for each order line.

WITH orders AS (
    SELECT * FROM ECOMMERCE_DB.STAGING_STAGING.stg_orders
),

customers AS (
    SELECT * FROM ECOMMERCE_DB.STAGING_STAGING.stg_customers
),

products AS (
    SELECT * FROM ECOMMERCE_DB.STAGING_STAGING.stg_products
)

SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    o.product_id,
    p.product_name,
    p.category,
    o.order_date,
    o.quantity,
    p.price AS unit_price,
    o.quantity * p.price AS order_revenue,
    o.order_status AS status
FROM orders AS o
INNER JOIN customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN products AS p
    ON o.product_id = p.product_id
  );

