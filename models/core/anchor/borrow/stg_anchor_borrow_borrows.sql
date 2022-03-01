{{
  config(
    materialized='incremental',
    cluster_by='block_timestamp',
    tags=['anchor','borrow'],
    unique_key='tx_id'
  )
}}

with
borrow_txs as (

  select * from {{ source('terra_sv', 'msg_events') }}
  where {{ incremental_load_filter('block_timestamp') }}
    and event_type = 'from_contract'
    and event_attributes:action = 'borrow_stable'

)

select * from borrow_txs
