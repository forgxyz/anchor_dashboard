{{
  config(
    materialized='view',
    tags=['anchor','yield']
  )
}}

with
data as (

  select * from {{ ref('stg_balance_anchor_yield_reserve') }}
  order by 1

)

select * from data
