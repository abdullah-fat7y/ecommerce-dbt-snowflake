
-- Calculate completed sales revenue by product category.

SELECT
    category,
    SUM(order_revenue) AS total_revenue
FROM {{ ref('fct_order_details') }}
WHERE LOWER(status) = 'completed'
GROUP BY category
ORDER BY total_revenue DESC
