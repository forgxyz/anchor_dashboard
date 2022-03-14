{{
  config(
    materialized='table',
    tags=['borrow','users','daily']
  )
}}

with
txs as (

  select * from {{ ref('int_anchor_borrow_users') }}

),

daily as (

  select

    date_trunc('d', block_timestamp) as date,
    count(distinct sender) as unique_borrow_wallet

  from txs
  group by 1
  order by 1

)

select * from daily
