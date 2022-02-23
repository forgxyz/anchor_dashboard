{{
  config(
    materialized='table',
    tags=['collateral','bluna','beth','viz']
  )
}}

with
collateral as (

  select * from {{ ref('anchor_collateral_value') }}
  order by 1
)

select * from collateral
