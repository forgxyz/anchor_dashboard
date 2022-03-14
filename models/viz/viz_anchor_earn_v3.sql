{{
  config(
    materialized='view'
  )
}}

with data as (

  select

    date,
    v3_bal_est as est_earn

  from {{ ref('anchor_earn_est_v3') }}

)

select * from data
