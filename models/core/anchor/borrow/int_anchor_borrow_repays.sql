{{
  config(
    materialized='table',
    tags=['anchor','borrow', 'repay']
  )
}}

with
repay_txs as (

  select * from {{ ref('stg_anchor_borrow_repays') }}

),

repays as (

  select

    tx_id,
    block_timestamp,
    chain_id,
    tx_status,
    event_attributes:repay_amount::float / pow(10,6) as repay_amount,
    event_attributes:borrower::string as borrower

  from repay_txs

)

select * from repays
