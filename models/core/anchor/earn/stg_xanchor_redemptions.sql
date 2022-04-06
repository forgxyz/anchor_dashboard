{{
    config(
        materialized='incremental',
        tags=['core', 'anchor', 'earn', 'redemption', 'xanchor'],
        cluster_by=['block_timestamp'],
        unique_key='tx_id'
    )
}}

with redemptions as (

  select * from {{ source('terra_sv', 'msg_events') }}
  where {{ incremental_load_filter('block_timestamp') }}
    and tx_status = 'SUCCEEDED'
    and event_type = 'wasm'
    and event_attributes:"5_action" = 'redeem_stable'
    and event_attributes:recipient = 'terra1pw4qm09m256m3wz25n4whnuqck7rcn6wvvjzyj'
    and block_timestamp >= '2022-03-16'

)

select * from redemptions
