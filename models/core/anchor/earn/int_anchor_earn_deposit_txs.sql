{{
    config(
        materialized='incremental',
        tags=['anchor', 'earn', 'deposit', 'users'],
        cluster_by='block_timestamp',
        unique_key='tx_id'
    )
}}

with deposits as (

    select * from {{ ref('stg_anchor_earn_deposits') }}
    where {{ incremental_load_filter('block_timestamp') }}

),

final as (

    select

        block_timestamp,
        tx_id,
        chain_id,
        msg_value:coins[0]:amount::float / pow(10,6) as amount,
        msg_value:sender::string as user_address

    from deposits

)

select * from final
