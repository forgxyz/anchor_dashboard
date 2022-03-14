{{
  config(
    materialized='view',
    tags=['earn','users']
  )
}}

with
data as (

  select * from {{ ref('anchor_earn_daily_users') }}
  order by 1

)

select * from data
