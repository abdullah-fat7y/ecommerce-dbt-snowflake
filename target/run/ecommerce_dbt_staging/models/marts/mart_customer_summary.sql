
  create or replace   view ECOMMERCE_DB.STAGING_MARTS.mart_customer_summary
  
  
  
  
  as (
    SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.order_revenue) AS total_spending
FROM ECOMMERCE_DB.STAGING_STAGING.stg_customers AS c
LEFT JOIN ECOMMERCE_DB.STAGING_MARTS.fct_orders AS f
    ON c.customer_id = f.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
  );

