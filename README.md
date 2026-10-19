# E-Commerce Analytics Pipeline with dbt and Snowflake

<img width="1536" height="1024" alt="E-Commerce Data Pipeline Architecture" src="https://github.com/user-attachments/assets/43c697e5-359b-4cb9-88e2-0b38c2762a7a" />

A data engineering project that transforms raw e-commerce data into
clean staging models and analytics-ready marts using **dbt Core** and
**Snowflake**. It demonstrates SQL transformations, model dependencies,
data quality tests, documentation, and a repeatable pipeline workflow.

## Project Goals

-   Load raw customers, products, and orders data into Snowflake.
-   Clean and standardize source data with dbt staging models.
-   Join orders with customer and product details and calculate revenue.
-   Build reporting models for customer and category analysis.
-   Validate data quality with built-in and custom SQL tests.
-   Generate dbt documentation and inspect model lineage.

## Architecture

``` text
Raw CSV data
    |
    v
Snowflake RAW schema
    |-- CUSTOMERS
    |-- PRODUCTS
    `-- ORDERS
          |
          v
      dbt staging
      |-- stg_customers
      |-- stg_products
      `-- stg_orders
          |
          v
      Analytics models
      |-- fct_order_details
      |-- fct_orders
      |-- agg_customer_orders
      |-- agg_category_revenue
      |-- mart_customer_summary
      `-- mart_category_sales
          |
          v
      Reporting and analysis
```

The exact dependencies are defined by `ref()` calls in the SQL models.
Inspect the generated dbt lineage graph for the actual project
dependency structure.

## Technology Stack

-   **dbt Core** --- SQL transformations, testing, and documentation
-   **Snowflake** --- cloud data warehouse
-   **SQL** --- cleaning, joins, aggregations, and business rules
-   **Python virtual environment** --- isolated local tooling
-   **PowerShell** --- local command-line workflow

## Project Structure

``` text
ecommerce_dbt_staging/
├── models/
│   ├── sources.yml
│   ├── staging/
│   │   ├── stg_customers.sql
│   │   ├── stg_products.sql
│   │   └── stg_orders.sql
│   └── marts/
│       ├── fct_order_details.sql
│       ├── fct_orders.sql
│       ├── agg_customer_orders.sql
│       ├── agg_category_revenue.sql
│       ├── mart_customer_summary.sql
│       ├── mart_category_sales.sql
│       └── schema.yml
├── tests/
│   ├── assert_positive_product_prices.sql
│   ├── assert_positive_order_quantities.sql
│   └── assert_completed_revenue_nonnegative.sql
├── dbt_project.yml
├── .gitignore
└── README.md
```

Update this tree if your final filenames or folders differ.

## Data Sources and Models

The source definition points to these raw tables in `ECOMMERCE_DB.RAW`:

-   `CUSTOMERS`
-   `PRODUCTS`
-   `ORDERS`

### Staging models

-   **`stg_customers`** --- standardizes customer attributes and
    identifiers.
-   **`stg_products`** --- standardizes product attributes and prices.
-   **`stg_orders`** --- normalizes order identifiers, quantities,
    dates, and statuses; removes malformed records and orders whose
    customer or product references do not exist in the staging models.

Order statuses are normalized to `completed`, `cancelled`, `pending`,
`shipped`, `processing`, or `returned`. Unrecognized statuses become
`unknown` and should fail the accepted-values test.

### Analytics models

-   **`fct_order_details`** --- joins order lines with customer and
    product details and calculates line-level revenue.
-   **`fct_orders`** --- aggregates order lines into one row per order
    and calculates revenue for completed orders.
-   **`agg_customer_orders`** --- counts completed orders by customer.
-   **`agg_category_revenue`** --- summarizes completed-order revenue by
    category.
-   **`mart_customer_summary`** --- reports total order count and
    spending per customer.
-   **`mart_category_sales`** --- reports order counts and
    completed-order revenue by product category.

**Business rule:** Revenue is counted only for completed orders in the
revenue-oriented models. Check the SQL definitions if changing status or
revenue logic.

## Prerequisites

1.  A Snowflake account with access to the required database, warehouse,
    and schemas.
2.  Python and a virtual environment.
3.  dbt Core and the Snowflake adapter.

The project was developed with dbt Core `1.11.x` and `dbt-snowflake`
`1.11.x`.

Install dbt in your virtual environment:

``` powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install dbt-core dbt-snowflake
dbt --version
```

If the repository includes a pinned `requirements.txt`, use that to
reproduce the intended versions.

## Snowflake Configuration

Never commit credentials, tokens, private keys, or access secrets.

Configure the dbt profile locally, normally in
`%USERPROFILE%\.dbt\profiles.yml`, or follow your project's profile
setup. The profile used in development is named `ecommerce` and uses
Snowflake OAuth authorization-code authentication.

Set environment variables for your own Snowflake account in PowerShell:

``` powershell
$env:SNOWFLAKE_ACCOUNT = "<your-account-identifier>"
$env:SNOWFLAKE_USER = "<your-snowflake-username>"
$env:SNOWFLAKE_ROLE = "<your-role>"
```

Example profile shape (keep it in local dbt configuration, not in a
public repository):

``` yaml
ecommerce:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
      user: "{{ env_var('SNOWFLAKE_USER') }}"
      authenticator: OAUTH_AUTHORIZATION_CODE
      role: "{{ env_var('SNOWFLAKE_ROLE') }}"
      database: ECOMMERCE_DB
      warehouse: ECOMMERCE_WH
      schema: STAGING
      threads: 4
```

Adjust database, warehouse, role, and authentication for your own
account. Never hardcode passwords or tokens in SQL, YAML, or Git.

## Run the Pipeline

Run commands from the project root (the folder containing
`dbt_project.yml`).

### 1. Validate the connection and project

``` powershell
dbt debug --profiles-dir .
dbt compile --profiles-dir .
```

### 2. Build models

``` powershell
dbt run --profiles-dir .
```

### 3. Run data quality tests

``` powershell
dbt test --profiles-dir .
```

Review the output and resolve failures before claiming that the pipeline
fully passes. Relationship tests can identify orders that reference
missing customer or product records.

### 4. Generate documentation

``` powershell
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
```

Open the local URL printed in the terminal, commonly
`http://localhost:8080`. Use the docs website to inspect model details
and the lineage graph.

## Data Quality Tests

The project includes tests for:

-   Unique and non-null customer identifiers in `stg_customers`.
-   Unique and non-null product identifiers in `stg_products`.
-   Non-null order identifiers in `stg_orders`.
-   Unique and non-null order identifiers in `fct_orders`.
-   Valid customer and product references from orders to staging models.
-   Non-null product prices and order quantities.
-   Accepted order status values.
-   Positive product prices and order quantities using custom SQL tests.
-   Nonnegative revenue for completed orders using a custom SQL
    business-rule test.

A singular SQL test should return **zero rows** to pass.

## Rerunning When New Orders Arrive

1.  Load new records into the Snowflake raw tables.
2.  Run `dbt run --profiles-dir .` to rebuild the configured models.
3.  Run `dbt test --profiles-dir .` to validate the updated data.
4.  Regenerate documentation if model definitions or metadata have
    changed.

Models are configured as views in this project unless overridden.
Queries against views reflect current underlying source data after
ingestion. In production, schedule dbt after ingestion completes using
Airflow, a CI workflow, or a managed orchestration service.

## Notes and Limitations

-   The staging model filters orders with invalid customer or product
    references. This protects downstream analytics, but a production
    pipeline should ideally log or quarantine rejected records for
    investigation.
-   Verify the actual schema names created by `dbt_project.yml` and your
    profile. dbt may combine the target schema and custom model schema
    according to its schema naming convention.
-   Keep local virtual environments, generated artifacts, credentials,
    and unrelated files out of version control.
-   Test results depend on current source data and environment. Report
    the actual result of your latest `dbt test` run.

## Useful Commands

``` powershell
dbt debug --profiles-dir .
dbt compile --profiles-dir .
dbt run --profiles-dir .
dbt test --profiles-dir .
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
```

## Author

**Abdullah Fathy**

Hands-on data engineering project using dbt and Snowflake.
