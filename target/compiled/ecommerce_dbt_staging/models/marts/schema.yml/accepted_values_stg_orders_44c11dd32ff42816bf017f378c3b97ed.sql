
    
    

with all_values as (

    select
        order_status as value_field,
        count(*) as n_records

    from ECOMMERCE_DB.STAGING_STAGING.stg_orders
    group by order_status

)

select *
from all_values
where value_field not in (
    'completed','cancelled','pending','shipped','processing','returned'
)


