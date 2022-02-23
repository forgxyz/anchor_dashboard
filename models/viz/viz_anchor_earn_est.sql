{{
  config(
    materialized='table',
    tags=['viz','anchor','earn']
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

final as (

  select
    earn.date,
    earn.cumulative_earn_balance as earn_bal,
    aust.price as price,
    earn_bal * price as est_earn

  from earn
  left join aust using (date)
  order by 1
  
)

select * from final
