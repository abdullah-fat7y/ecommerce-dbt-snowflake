
  create or replace   view ECOMMERCE_DB.STAGING.assert_positive_product_prices
  
  
  
  
  as (
    SELECT
    product_id,
    price
FROM ECOMMERCE_DB.STAGING_STAGING.stg_products
WHERE price IS NULL
   OR price <= 0
  );

