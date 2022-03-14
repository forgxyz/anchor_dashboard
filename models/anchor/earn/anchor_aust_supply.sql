{{
  config(
    materialized='table',
    tags=['aust', 'earn']
  )
}}

with
mint as (

  select

    date_trunc('day', block_timestamp) as date,
    sum(mint_amount) as daily_mint_amount

  from {{ ref('int_anchor_earn_deposit_msg_events') }}
  group by 1

),

burn as (

  select

    date_trunc('day', block_timestamp) as date,
    sum(burn_amount) as daily_burn_amount

  from {{ ref('int_anchor_earn_redemption_txs') }}
  group by 1

),

aust_price as (

  select

    date_trunc('day', block_timestamp) as date,
    avg(aust_price) as daily_price_aust

  from {{ ref('price_aust') }}
  group by 1

),

combo as (

  select * from mint
  left join burn using (date)

),


add_price as (

  select * from combo
  left join aust_price using (date)
  order by 1

),

net_change as (

  select

    date,
    daily_mint_amount - daily_burn_amount as net_change,
    daily_price_aust,
    net_change * daily_price_aust as net_earn

  from add_price

),

final as (

  select

    *,
    sum(net_change) over (order by date) as circulating_aust,
    sum(net_earn) over (order by date) as earn_balance

  from net_change

)

select * from final
