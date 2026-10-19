# E-commerce dbt Staging Models

This folder contains the dbt files for Task 2: staging models for customers, products, and orders in Snowflake.

## Files
- `dbt_project.yml` — dbt project configuration.
- `profiles.yml.example` — example Snowflake profile. Copy this to your dbt profiles directory and set credentials securely.
- `models/sources.yml` — declarations for the three raw Snowflake tables.
- `models/staging/stg_customers.sql` — cleans customer data.
- `models/staging/stg_products.sql` — cleans product data.
- `models/staging/stg_orders.sql` — cleans order data.

## Before running
1. Install dbt's Snowflake adapter:
   ```bash
   python -m pip install dbt-snowflake
   ```
2. Review the raw table names and column names in Snowflake. These models assume:
   - `ECOMMERCE_DB.RAW.CUSTOMERS(CUSTOMER_ID, NAME, EMAIL, CITY, SIGNUP_DATE)`
   - `ECOMMERCE_DB.RAW.PRODUCTS(PRODUCT_ID, PRODUCT_NAME, CATEGORY, PRICE)`
   - `ECOMMERCE_DB.RAW.ORDERS(ORDER_ID, CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE, ORDER_STATUS)`
3. Configure `profiles.yml` using your Snowflake account, username, role, and password. Do not commit credentials.
4. Ensure the warehouse `ECOMMERCE_WH` exists and your role can use it.
5. From this folder, run:
   ```bash
   dbt debug --profiles-dir .
   dbt run --profiles-dir .
   ```

## Notes
- The profile name is `ecommerce`; it must match `profile: ecommerce` in `dbt_project.yml`.
- `profiles.yml.example` uses environment variables for credentials. Set `SNOWFLAKE_ACCOUNT`, `SNOWFLAKE_USER`, `SNOWFLAKE_PASSWORD`, and `SNOWFLAKE_ROLE` in your shell, or adjust the profile to your preferred secure credential method.
- The models use `TRY_TO_NUMBER`, `TRY_TO_DECIMAL`, and `TRY_TO_DATE` so malformed values do not fail the entire model.
- The order status mapping converts common variants to standardized values and maps unrecognized values to `unknown`.
- The date parsing assumes common ISO (`YYYY-MM-DD`), US (`MM/DD/YYYY`), or day-first (`DD/MM/YYYY`) formats. If your CSV uses ambiguous dates, confirm the intended format before running.
- Invalid records are filtered from staging models; they are not currently written to a quarantine table.
- These are views, not tables, to keep this assignment's staging layer simple.
