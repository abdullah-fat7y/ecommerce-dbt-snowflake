SELECT
    order_id,
    quantity
FROM ECOMMERCE_DB.STAGING_STAGING.stg_orders
WHERE quantity IS NULL
   OR quantity <= 0