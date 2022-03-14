{{
  config(
    materialized='table',
    tags=['anchor','earn']
  )
}}

with
earn as (

  select * from {{ ref('anchor_earn_net_daily_deposits') }}

),

aust as (

  select

    date_trunc('d', block_timestamp) as date,
    avg(aust_price) as price

  from {{ ref('price_aust') }}
  group by 1

),

aust_supply as (

  select

    date,
    earn_balance as v2_bal_est

  from {{ ref('anchor_aust_supply') }}

),

earn_bal_estimate as (

  select
    earn.date,
    earn.cumulative_earn_balance as net_deposit_bal,
    aust.price as price,
    net_deposit_bal * price as v1_bal_est

  from earn
  left join aust using (date)
  order by 1

),

combo as (

  select * from earn_bal_estimate
  left join aust_supply using (date)

),

final as (
  select

    *,
    (v1_bal_est + v2_bal_est) / 2 as v3_bal_est

  from combo
  order by 1

)

select * from final
