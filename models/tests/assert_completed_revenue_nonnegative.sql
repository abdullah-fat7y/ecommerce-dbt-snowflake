
SELECT
    order_id,
    order_revenue,
    status
FROM {{ ref('fct_orders') }}
WHERE LOWER(status) = 'completed'
  AND (
      order_revenue IS NULL
      OR order_revenue < 0
  )
