{{
    config(
        materialized='incremental',
        tags=['core', 'anchor', 'earn', 'depsoit'],
        cluster_by=['block_timestamp'],
        unique_key='tx_id'
    )
}}

with
anchor_deposits as (

  select

    *

  from {{ source('terra_sv', 'msg_events') }}

  where {{ incremental_load_filter('block_timestamp') }}
    and event_type = 'from_contract'
    and tx_status = 'SUCCEEDED'
    and event_attributes:"0_action" = 'deposit_stable'
    and event_attributes:"0_contract_address" = 'terra1sepfj7s0aeg5967uxnfk4thzlerrsktkpelm5s' -- anchor market contract

)

select * from anchor_deposits
