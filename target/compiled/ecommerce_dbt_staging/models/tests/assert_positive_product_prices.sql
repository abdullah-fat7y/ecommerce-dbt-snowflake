SELECT
    product_id,
    price
FROM ECOMMERCE_DB.STAGING_STAGING.stg_products
WHERE price IS NULL
   OR price <= 0