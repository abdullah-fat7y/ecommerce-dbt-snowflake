
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.order_revenue) AS total_spending
FROM {{ ref('stg_customers') }} AS c
LEFT JOIN {{ ref('fct_orders') }} AS f
    ON c.customer_id = f.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
