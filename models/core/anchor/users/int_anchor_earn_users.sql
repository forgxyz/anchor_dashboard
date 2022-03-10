{{
  config(
    materialized='table'
  )
}}

with
txs as (

  select * from {{ ref('stg_anchor_interactions') }}

),

earn_side as (

  select

    block_timestamp,
    msg_value:sender::string as sender

  from txs
  where msg_value:contract in (
    'terra1sepfj7s0aeg5967uxnfk4thzlerrsktkpelm5s', -- anchor market
    'terra1hzh9vpxhsk8253se0vv5jj6etdvxu3nv8z07zu' -- aust redemption
  )

),

unique_wallets as (

  select

    date_trunc('d', block_timestamp) as date,
    count(distinct sender) as unique_earn_wallet

  from earn_side
  group by 1
  order by 1

)

select * from unique_wallets
