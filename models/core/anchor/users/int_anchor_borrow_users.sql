{{
  config(
    materialized='table',
    tags=['borrow','users'],
    unique_key='tx_id'

  )
}}

with
txs as (

  select * from {{ ref('stg_anchor_interactions') }}

),

borrow_side as (

  select

    tx_id,
    block_timestamp,
    msg_value:sender::string as sender

  from txs
  where msg_value:contract in (
    'terra10cxuzggyvvv44magvrh3thpdnk9cmlgk93gmx2', -- bETH custody
    'terra1939tzfn4hn960ychpcsjshu8jds3zdwlp8jed9', -- bETH rewards
    'terra1ptjp2vfjrwh0j0faj9r6katm640kgjxnwwq9kn', -- bLUNA custody
    'terra1mtwph2juhj0rvjz7dy92gvl6xvukaxu8rfv8ts', -- bLUNA Hub
    'terra1tmnqgvg567ypvsvk6rwsga3srp7e3lg6u0elp8' -- Overseer
  )

),

-- exclude things like swaps
filtered_collateral as (

  select

    tx_id,
    block_timestamp,
    msg_value:sender::string as sender

  from txs
  where msg_value:contract in (
    'terra1dzhzukyezv0etz22ud940z7adyv7xgcjkahuun', -- bETH
    'terra1kc87mu460fwkqte29rquh4hc20m54fxwtsx7gp' -- bLUNA
    )
    and (
      -- col4
      msg_value:execute_msg:send:msg like '%deposit_collateral%'
      -- col5
      or msg_value:execute_msg:send:msg like '%eyJkZXBvc2l0X2NvbGxhdGVyYWwiOnt9fQ=='
    )

),

combo as (

  select * from borrow_side
  union
  select * from filtered_collateral

)

select * from combo
