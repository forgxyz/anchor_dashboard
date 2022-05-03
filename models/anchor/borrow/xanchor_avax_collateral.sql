{{
  config(
    materialized='table',
    cluster_by='date',
    tags=['anchor', 'collateral', 'avax']
  )
}}

with
daily_agg_dep as (

  select

    date_trunc('d', block_timestamp) as date,
	  sum(amount) as provide_amount,
    sum(amount_usd) as provide_amount_usd

  from {{ source('anchor', 'collateral')}}

  where currency = 'terra1z3e2e4jpk4n0xzzwlkgcfvc95pc5ldq0xcny58'
    and event_type = 'provide'

  group by 1

),

daily_agg_wit as (

  select

    date_trunc('d', block_timestamp) as date,
	  -sum(amount) as withdraw_amount,
    -sum(amount_usd) as withdraw_amount_usd

  from {{ source('anchor', 'collateral')}}

  where currency = 'terra1z3e2e4jpk4n0xzzwlkgcfvc95pc5ldq0xcny58'
    and event_type = 'withdraw'

  group by 1

)


select

  d.date,
  provide_amount,
  withdraw_amount,
  provide_amount + withdraw_amount as net_amount,
  provide_amount_usd,
  withdraw_amount_usd,
  provide_amount_usd + withdraw_amount_usd as net_amount_usd,
  sum(net_amount) over (order by date) as running_total,
  sum(net_amount_usd) over (order by date) as running_total_usd

from daily_agg_dep d
left join daily_agg_wit using (date)
order by 1
