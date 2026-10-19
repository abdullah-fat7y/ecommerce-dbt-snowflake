WITH source_data AS (

    SELECT
        TRIM(ORDER_ID) AS ORDER_ID,
        TRIM(CUSTOMER_ID) AS CUSTOMER_ID,
        TRIM(PRODUCT_ID) AS PRODUCT_ID,
        TRIM(QUANTITY) AS QUANTITY,
        TRIM(ORDER_DATE) AS ORDER_DATE,
        LOWER(TRIM(ORDER_STATUS)) AS ORDER_STATUS
    FROM ECOMMERCE_DB.RAW.ORDERS

),

cleaned AS (

    SELECT
        TRY_TO_NUMBER(ORDER_ID) AS ORDER_ID,
        TRY_TO_NUMBER(CUSTOMER_ID) AS CUSTOMER_ID,
        TRY_TO_NUMBER(PRODUCT_ID) AS PRODUCT_ID,
        TRY_TO_NUMBER(QUANTITY) AS QUANTITY,
        COALESCE(
            TRY_TO_DATE(ORDER_DATE, 'YYYY-MM-DD'),
            TRY_TO_DATE(ORDER_DATE, 'MM/DD/YYYY'),
            TRY_TO_DATE(ORDER_DATE, 'DD/MM/YYYY')
        ) AS ORDER_DATE,
        CASE
            WHEN ORDER_STATUS IN ('complete', 'completed') THEN 'completed'
            WHEN ORDER_STATUS IN ('cancel', 'canceled', 'cancelled') THEN 'cancelled'
            WHEN ORDER_STATUS = 'pending' THEN 'pending'
            WHEN ORDER_STATUS = 'shipped' THEN 'shipped'
            WHEN ORDER_STATUS IN ('processing', 'in progress') THEN 'processing'
            WHEN ORDER_STATUS IN ('returned', 'refunded') THEN 'returned'
            ELSE 'unknown'
        END AS ORDER_STATUS
    FROM source_data

)

SELECT
    o.*
FROM cleaned AS o
WHERE o.ORDER_ID IS NOT NULL
  AND o.CUSTOMER_ID IS NOT NULL
  AND o.PRODUCT_ID IS NOT NULL
  AND o.QUANTITY > 0
  AND o.ORDER_DATE IS NOT NULL

  -- Keep only orders with valid customer references.
  AND EXISTS (
      SELECT 1
      FROM ECOMMERCE_DB.STAGING_STAGING.stg_customers AS c
      WHERE c.CUSTOMER_ID = o.CUSTOMER_ID
  )

  -- Keep only orders with valid product references.
  AND EXISTS (
      SELECT 1
      FROM ECOMMERCE_DB.STAGING_STAGING.stg_products AS p
      WHERE p.PRODUCT_ID = o.PRODUCT_ID
  )