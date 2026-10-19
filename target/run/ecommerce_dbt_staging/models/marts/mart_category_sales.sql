
  create or replace   view ECOMMERCE_DB.STAGING_MARTS.mart_category_sales
  
  
  
  
  as (
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
FROM ECOMMERCE_DB.STAGING_STAGING.stg_orders AS o
INNER JOIN ECOMMERCE_DB.STAGING_STAGING.stg_products AS p
    ON o.product_id = p.product_id
GROUP BY p.category
  );

