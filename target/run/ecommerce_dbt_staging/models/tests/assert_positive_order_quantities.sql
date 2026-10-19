
  create or replace   view ECOMMERCE_DB.STAGING.assert_positive_order_quantities
  
  
  
  
  as (
    SELECT
    order_id,
    quantity
FROM ECOMMERCE_DB.STAGING_STAGING.stg_orders
WHERE quantity IS NULL
   OR quantity <= 0
  );

