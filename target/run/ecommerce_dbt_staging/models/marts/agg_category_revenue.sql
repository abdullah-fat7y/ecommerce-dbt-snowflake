
  create or replace   view ECOMMERCE_DB.STAGING_MARTS.agg_category_revenue
  
  
  
  
  as (
    -- Calculate completed sales revenue by product category.

SELECT
    category,
    SUM(order_revenue) AS total_revenue
FROM ECOMMERCE_DB.STAGING_MARTS.fct_order_details
WHERE LOWER(status) = 'completed'
GROUP BY category
ORDER BY total_revenue DESC
  );

