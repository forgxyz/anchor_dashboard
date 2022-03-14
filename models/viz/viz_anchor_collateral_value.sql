{{
  config(
    materialized='view',
    tags=['collateral','bluna','beth','viz']
  )
}}

with
data as (

  select * from {{ ref('anchor_collateral_value') }}
  order by 1

)

select * from data
