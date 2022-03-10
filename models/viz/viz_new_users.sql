{{
  config(
    materialized='view'
  )
}}

with data as (

  select * from {{ ref('anchor_new_users') }}
  order by 1
  
)

select * from data
