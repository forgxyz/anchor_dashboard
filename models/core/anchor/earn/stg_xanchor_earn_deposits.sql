{{
    config(
        materialized='incremental',
        tags=['core', 'anchor', 'earn', 'depsoit'],
        cluster_by=['block_timestamp'],
        unique_key='tx_id'
    )
}}

with
deposits as (

    select

        *

    from {{ source('terra_sv', 'msg_events' )}}

    where {{ incremental_load_filter('block_timestamp') }}
      and tx_status = 'SUCCEEDED'
      and event_type = 'wasm'
      and event_attributes:"1_action" = 'deposit_stable'
      and event_attributes:recipient = 'terra1pw4qm09m256m3wz25n4whnuqck7rcn6wvvjzyj' -- anchor wormhole contract
      and block_timestamp >= '2022-03-16'


)

select * from deposits
