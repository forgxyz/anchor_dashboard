{{
    config(
        materialized='table',
        tags=['anchor', 'earn', 'redemption', 'users']
    )
}}

with redemptions as (

    select * from {{ ref('stg_anchor_earn_redemptions') }}

),

final as (

    select

        block_timestamp,
        tx_id,
        chain_id,
        event_attributes:"0_from"::string as user_address,
        event_attributes:redeem_amount::float / pow(10,6) as redemption_amount,
        event_attributes:burn_amount::float / pow(10,6) as burn_amount,
        redemption_amount / burn_amount as aust_price

    from redemptions

)

select * from final
