{{
  config(
    materialized='table',
    tags=['collateral','bluna','beth','hardcoded']
  )
}}

with

bluna as (

  select * from {{ ref('anchor_bluna_daily_balance') }}

),

beth as (

  select * from {{ ref('anchor_beth_daily_balance') }}

),

total as (

  select

  	l.date as date,
    bluna_value,
    coalesce(beth_value,0) as beth_value,
    bluna_value + coalesce(beth_value,0) as total_value

  from bluna l
  left join beth e using (date)

),

final as (

  select * from total
  order by 1

)

select * from final
