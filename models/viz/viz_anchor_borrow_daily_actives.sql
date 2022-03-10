{{
  config(
    materialized='view',
    tags=['borrow','users']
  )
}}

with
data as (

  select * from {{ ref('anchor_borrow_daily_users') }}
  order by 1

)

select * from data
