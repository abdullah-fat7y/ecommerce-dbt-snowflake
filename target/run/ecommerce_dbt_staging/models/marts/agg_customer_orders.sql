
  create or replace   view ECOMMERCE_DB.STAGING_MARTS.agg_customer_orders
  
  
  
  
  as (
    -- Summarize completed orders for each customer.

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_completed_orders
FROM ECOMMERCE_DB.STAGING_MARTS.fct_order_details
WHERE LOWER(status) = 'completed'
GROUP BY
    customer_id,
    customer_name
  );

