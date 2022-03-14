{{
  config(
    materialized='table',
    tags=['collateral','bluna','beth','hardcoded']
  )
}}

with
total as (

  select * from {{ ref('anchor_collateral_value') }}

),

pcts as (
  select

    date,
    bluna_value / total_value as bluna_pct,
    beth_value / total_value as beth_pct

  from total
  order by 1

),

bluna as (

  select

    date,
    bluna_pct as pct,
    'bluna' as collateral

  from pcts

),

beth as (

  select

    date,
    beth_pct as pct,
    'beth' as collateral

  from pcts

),

combo as (

  select * from bluna
  union
  select * from beth

),

final as (

  select * from combo
  order by 1

)

select * from final
