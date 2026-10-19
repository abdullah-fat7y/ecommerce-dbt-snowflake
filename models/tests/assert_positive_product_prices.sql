
SELECT
    product_id,
    price
FROM {{ ref('stg_products') }}
WHERE price IS NULL
   OR price <= 0
