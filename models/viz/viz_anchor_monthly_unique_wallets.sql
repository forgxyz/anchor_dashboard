{{
  config(
    materialized='table',
    tags=['anchor','users']
  )
}}

with msgs as (

  select * from {{ ref('stg_anchor_interactions') }}

),

unique_wallets as (

  select

    date_trunc('month', block_timestamp) as date,
    count(distinct msg_value:sender::string) as unique_addresses

  from msgs
  group by 1
  order by 1

)

select * from unique_wallets
