{{
  config(
    materialized='view',
    tags=['anchor','weekly','users']
  )
}}

with
data as (

  select * from {{ ref('anchor_weekly_unique_wallets') }}
  order by 1

)

select * from data
