{{
    config(
        materialized='incremental',
        tags=['anchor', 'earn', 'deposit', 'users'],
        cluster_by='block_timestamp',
        unique_key='tx_id'
    )
}}

with

deposits as (

  select * from {{ ref('stg_xanchor_earn_deposits') }}
  where {{ incremental_load_filter('block_timestamp') }}

),

deposit_txs as (

  select

    block_timestamp,
    tx_id,
    chain_id,
    event_attributes:"deposit_amount"::float / pow(10,6) as deposit_amount,
    event_attributes:"mint_amount"::float / pow(10,6) as mint_amount,
    event_attributes:"transfer.recipient_chain"::number as recipient_chain_id


  from deposits

)

select * from deposit_txs
