{{
  config(
    materialized='incremental',
    cluster_by='block_timestamp',
    tags=['price', 'aust']
  )
}}

with
redemptions as (

  select * from {{ ref('int_anchor_earn_redemption_txs') }}
  where {{ incremental_load_filter('block_timestamp') }}

),

aust_price as (

  select

    date_trunc('hour', block_timestamp) as block_timestamp,
    avg(aust_price) as aust_price

  from redemptions
  group by 1
  order by 1 desc

)

select * from aust_price
