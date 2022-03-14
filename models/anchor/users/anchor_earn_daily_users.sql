{{
  config(
    materialized='table',
    tags=['users','daily','earn']
  )
}}

with
txs as (

  select * from {{ ref('int_anchor_earn_users') }}

),

daily as (

  select

    date_trunc('d', block_timestamp) as date,
    count(distinct sender) as unique_earn_wallet

  from txs
  group by 1
  order by 1

)

select * from daily
