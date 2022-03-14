{{
  config(
    materialized = 'table',
    tags=['collateral','viz']
  )
}}

with share as (

  select * from {{ ref('anchor_collateral_share') }}
  order by 1
  
)

select * from share
