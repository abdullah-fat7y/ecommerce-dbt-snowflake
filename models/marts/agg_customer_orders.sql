
-- Summarize completed orders for each customer.

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_completed_orders
FROM {{ ref('fct_order_details') }}
WHERE LOWER(status) = 'completed'
GROUP BY
    customer_id,
    customer_name
