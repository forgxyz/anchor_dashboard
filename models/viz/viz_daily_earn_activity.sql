{{
  config(
    materialized='view',
    tags=['earn','deposit','redemption','viz']
  )
}}

with
data as (

  select * from {{ ref('anchor_daily_earn_activity') }}
  order by 1
  
)

select * from data
