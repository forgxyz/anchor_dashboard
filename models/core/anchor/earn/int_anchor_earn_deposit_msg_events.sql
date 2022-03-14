{{
    config(
        materialized='incremental',
        tags=['anchor', 'earn', 'deposit', 'users'],
        cluster_by='block_timestamp',
        unique_key='tx_id'
    )
}}

with deposits as (

    select * from {{ ref('stg_anchor_earn_deposit_msg_events') }}
    where {{ incremental_load_filter('block_timestamp') }}

),

final as (

    select

        block_timestamp,
        tx_id,
        chain_id,
        event_attributes:depositor::string as depositor,
        event_attributes:deposit_amount::float / pow(10,6) as deposit_amount,
        event_attributes:mint_amount::float / pow(10,6) as mint_amount

    from deposits

)

select * from final
