{{
    config(
        materialized='incremental',
        tags=['core', 'anchor', 'earn', 'redemption', 'xanchor'],
        cluster_by=['block_timestamp'],
        unique_key='tx_id',
        full_refresh=true
    )
}}

with redemptions as (

  select * from {{ ref('stg_xanchor_redemptions') }}
  where {{ incremental_load_filter('block_timestamp') }}

),

redemption_txs as (

  select

    block_timestamp,
    tx_id,
    chain_id,
    event_attributes:redeem_amount::float / pow(10,6) as redeem_amount,
    event_attributes:burn_amount::float / pow(10,6) as burn_amount,
    event_attributes:"transfer.recipient_chain" as recipient_chain_id

  from redemptions

)

select * from redemption_txs
