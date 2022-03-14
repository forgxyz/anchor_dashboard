{{
  config(
    materialized = 'view',
    tags=['collateral','viz','hardcoded']
  )
}}

with
data as (

  select * from {{ ref('anchor_collateral_count') }}
  order by 1

)

select * from data
