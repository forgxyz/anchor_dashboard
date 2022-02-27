{{
  config(
    materialized='view'
  )
}}

with data as (

  select * from {{ ref('anchor_new_users') }}

)

select * from data
