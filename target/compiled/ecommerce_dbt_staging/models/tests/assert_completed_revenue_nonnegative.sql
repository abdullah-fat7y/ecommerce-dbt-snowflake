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