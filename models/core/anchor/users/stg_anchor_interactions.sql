{{
  config(
    materialized='incremental',
    cluster_by='block_timestamp',
    tags=['anchor']
  )
}}

with
msgs as (

  select

    *

  from {{ source('terra_sv', 'msgs') }}

  where {{ incremental_load_filter('block_timestamp') }}
  and msg_value:contract::string in (
      select address from flipside.terra_sv.labels where label = 'anchor'
    )
    and msg_value:sender::string NOT IN (SELECT address FROM flipside.terra_sv.labels WHERE label IS NOT NULL)

)

select * from msgs
