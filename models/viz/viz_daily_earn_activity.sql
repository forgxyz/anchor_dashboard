{{
  config(
    materialized='table',
    tags=['earn','deposit','redemption','viz']
  )
}}

with
net_deposits as (

  select * from {{ ref('anchor_earn_net_daily_deposits') }}

),

activity as (

  select
    date,
    daily_gross_deposit,
    -daily_gross_redemption as daily_gross_redemption,
    net_depositor_activity

  from net_deposits
  order by 1
  
)

select * from activity
