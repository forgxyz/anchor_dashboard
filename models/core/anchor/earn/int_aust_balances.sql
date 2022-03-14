{{
  config(
    materialized='table',
    tags=['aust','users']
  )
}}

with aust_balances as (

  select * from {{ ref('stg_aust_balances') }}

),

aust_price as (

  select * from {{ ref('price_aust') }}

),

daily_avg_price as (

  select

    date_trunc('d', block_timestamp) as date,
    avg(aust_price) as avg_price

  from aust_price
  group by 1

),

balances as (

  select

    a.date as date,
    address,
    balance,
    balance * avg_price as balance_usd,
    currency

  from aust_balances a
  left join daily_avg_price using (date)

)

select * from balances
