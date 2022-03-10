{{
  config(
    materialized='view',
    tags=['anchor','monthly','users']
  )
}}

with
data as (

  select * from {{ ref('anchor_monthly_unique_wallets') }}
  order by 1

)

select * from data
