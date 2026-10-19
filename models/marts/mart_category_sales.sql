
SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(
        CASE
            WHEN LOWER(o.order_status) = 'completed'
                THEN o.quantity * p.price
            ELSE 0
        END
    ) AS total_revenue
FROM {{ ref('stg_orders') }} AS o
INNER JOIN {{ ref('stg_products') }} AS p
    ON o.product_id = p.product_id
GROUP BY p.category
