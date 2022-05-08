{{
    config(
        materialized='incremental',
        cluster_by=['block_timestamp::DATE'],
        incremental_strategy='delete+insert',
        tags=['price','beth']
    )
}}

with prices as (

    select *
    from {{ source('terra','oracle_prices') }}
    where {{ incremental_load_filter('block_timestamp') }}
      and currency in (
        'terra1z3e2e4jpk4n0xzzwlkgcfvc95pc5ldq0xcny58', -- wshAVAX
        'terra1dzhzukyezv0etz22ud940z7adyv7xgcjkahuun', -- bETH
        'terra18zqcnl83z98tf6lly37gghm7238k7lh79u4z9a', -- bATOM
        'uluna',
        'terra1kc87mu460fwkqte29rquh4hc20m54fxwtsx7gp' -- bLUNA
      )

)

select * from prices
