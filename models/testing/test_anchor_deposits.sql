{{
  config(
    materialized='table'
  )
}}

with
deposits_msgs as (

  select * from {{ ref('int_anchor_earn_deposit_txs') }}

),

deposit_msg_events as (

  select * from {{ ref('int_anchor_earn_deposit_msg_events') }}

),

deposits_msgs_agg as (

  select
    date_trunc('day', block_timestamp) as date,
    sum(amount) as msg_deposit_amount
  from deposits_msgs
  group by 1

),

deposit_msg_events_agg as (

  select
    date_trunc('day',block_timestamp) as date,
    sum(deposit_amount) as msg_events_deposit_amount
  from deposit_msg_events
  group by 1

),

combo as (

  select * from deposits_msgs_agg
  left join deposit_msg_events_agg using (date)

),

final as (

  select

    *,
    msg_deposit_amount - msg_events_deposit_amount as diff

  from combo
  
)

select * from final
