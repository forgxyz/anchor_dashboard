{{
  config(
    materialized='view',
    tags=['borrow','viz']
  )
}}

with
data as (

  select * from {{ ref('anchor_borrow_daily_change') }}
  order by 1
)

select * from data
