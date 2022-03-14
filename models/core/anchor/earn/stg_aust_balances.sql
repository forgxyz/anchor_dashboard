{{
  config(
    materialized='incremental',
    cluster_by='date',
    tags=['aust','users','earn']
  )
}}

with
aust_holders as (

  select

    *

  from {{ source('terra', 'daily_balances') }}

  where {{ incremental_load_filter('date') }}
    and date > '2021-03-16T23:59:59Z'
    and currency = 'aUST'
    and address != 'terra1q0z524ll2pksvd7ye3v352xcwu3e8ny0cpqnmm' -- oracle feeder
    
)

select * from aust_holders
