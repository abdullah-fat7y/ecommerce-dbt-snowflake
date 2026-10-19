
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_id
from ECOMMERCE_DB.STAGING_STAGING.stg_products
where product_id is null



  
  
      
    ) dbt_internal_test