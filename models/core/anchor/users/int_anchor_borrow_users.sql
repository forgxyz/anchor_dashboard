{{
  config(
    materialized='table'
  )
}}

with
txs as (

  select * from {{ ref('stg_anchor_interactions') }}

),

borrow_side as (

  select

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

filtered_collateral as (

  select

    block_timestamp,
    msg_value:sender::string as sender

  from txs
  where msg_value:contract in (
    'terra1dzhzukyezv0etz22ud940z7adyv7xgcjkahuun', -- bETH
    'terra1kc87mu460fwkqte29rquh4hc20m54fxwtsx7gp' -- bLUBA
    )
    and (
      msg_value:execute_msg:send:msg like '%deposit_collateral%'
      or msg_value:execute_msg:send:msg like '%eyJkZXBvc2l0X2NvbGxhdGVyYWwiOnt9fQ=='
    )

),

combo as (

  select * from borrow_side
  union
  select * from filtered_collateral

),

unique_wallets as (

  select

    date_trunc('d', block_timestamp) as date,
    count(distinct sender) as unique_borrow_wallet

  from combo
  group by 1
  order by 1

)

select * from unique_wallets
