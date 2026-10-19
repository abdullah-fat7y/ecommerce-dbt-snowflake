
  create or replace   view ECOMMERCE_DB.STAGING.assert_completed_revenue_nonnegative
  
  
  
  
  as (
    SELECT
    order_id,
    order_revenue,
    status
FROM ECOMMERCE_DB.STAGING_MARTS.fct_orders
WHERE LOWER(status) = 'completed'
  AND (
      order_revenue IS NULL
      OR order_revenue < 0
  )
  );

