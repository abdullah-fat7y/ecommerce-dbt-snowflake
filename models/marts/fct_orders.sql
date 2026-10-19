
WITH order_lines AS (
    SELECT
        o.order_id,
        o.customer_id,
        c.customer_name,
        o.product_id,
        p.product_name,
        p.category,
        o.order_date,
        o.quantity,
        p.price AS unit_price,
        o.quantity * p.price AS line_revenue,
        LOWER(o.order_status) AS status
    FROM {{ ref('stg_orders') }} AS o
    INNER JOIN {{ ref('stg_customers') }} AS c
        ON o.customer_id = c.customer_id
    INNER JOIN {{ ref('stg_products') }} AS p
        ON o.product_id = p.product_id
),

order_summary AS (
    SELECT
        order_id,
        customer_id,
        customer_name,
        order_date,
        status,
        COUNT(DISTINCT product_id) AS product_count,
        LISTAGG(DISTINCT product_name, ', ')
            WITHIN GROUP (ORDER BY product_name) AS product_details,
        SUM(quantity) AS total_quantity,
        SUM(
            CASE
                WHEN status = 'completed' THEN line_revenue
                ELSE 0
            END
        ) AS order_revenue
    FROM order_lines
    GROUP BY
        order_id,
        customer_id,
        customer_name,
        order_date,
        status
)

SELECT *
FROM order_summary
