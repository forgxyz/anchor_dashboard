{{
  config(
    materialized='table',
    tags=['earn','users'],
    unique_key='tx_id'
  )
}}

with
txs as (

  select * from {{ ref('stg_anchor_interactions') }}

),

earn_side as (

  select
    tx_id,
    block_timestamp,
    msg_value:sender::string as sender

  from txs
  where msg_value:contract in (
    'terra1sepfj7s0aeg5967uxnfk4thzlerrsktkpelm5s', -- anchor market
    'terra1hzh9vpxhsk8253se0vv5jj6etdvxu3nv8z07zu' -- aust redemption
  )

)

select * from earn_side
