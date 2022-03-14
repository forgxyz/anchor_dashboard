{{
  config(
    materialized='view',
    tags=['anchor','daily','users']
  )
}}

with
data as (

  select * from {{ ref('anchor_daily_unique_wallets') }}
  order by 1

)

select * from data
