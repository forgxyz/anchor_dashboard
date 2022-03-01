{{
  config(
    materialized='table',
    tags=['anchor','borrow']
  )
}}

with
borrow_txs as (

  select * from {{ ref('stg_anchor_borrow_borrows') }}

),

borrows as (

  select

    tx_id,
    block_timestamp,
    chain_id,
    tx_status,
    event_attributes:borrow_amount::float / pow(10,6) as borrow_amount,
    event_attributes:borrower::string as borrower

  from borrow_txs

)

select * from borrows
