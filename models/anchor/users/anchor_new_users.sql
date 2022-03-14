{{
  config(
    materialized='table'
  )
}}


with
anchor_txs as (

  select * from {{ ref('stg_anchor_interactions') }}

),

first_action as (

  select

    msg_value:sender::string as sender,
    min(block_timestamp) as block_timestamp


  from anchor_txs
  group by 1

),

daily_new as (

  select

    date_trunc('day', block_timestamp) as date,
    count(sender) as new_users

  from first_action
  group by 1

),

aggs as (

  select

    *,
    sum(new_users) over (order by date) as cumulative_users

  from daily_new
  order by 1

)

select * from aggs
