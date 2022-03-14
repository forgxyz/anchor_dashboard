{{
  config(
    materialized = 'table',
    tags=['collateral','viz','hardcoded']
  )
}}

with
bluna as (

  select * from {{ ref('anchor_bluna_daily_balance') }}

),

beth as (

    select * from {{ ref('anchor_beth_daily_balance') }}

),

counts as (

  select

    l.date,
    cumulative_bluna,
    coalesce(cumulative_beth, 0) as cumulative_beth

  from bluna l
  left join beth using(date)
  order by 1

)

select * from counts
