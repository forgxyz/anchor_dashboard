{{
    config(
        materialized='table',
        tags=['anchor', 'borrow', 'collateral', 'liquidate']
    )
}}

with
borrows as (

  select * from {{ ref('int_anchor_borrow_borrows') }}

),

repayments as (

  select * from {{ ref('int_anchor_borrow_repays') }}

),

liquidations as (

  select * from {{ ref('anchor_daily_liquidations') }}

),

daily_borrows as (

  select

    date_trunc('d', block_timestamp) as date,
    sum(borrow_amount) as borrow_amount

  from borrows
  group by 1

),

daily_repayments as (

  select

    date_trunc('d', block_timestamp) as date,
    sum(repay_amount) as repay_amount

  from repayments
  group by 1

),

daily_liquidations as (

  select

    date,
    sum(gross_loan_repaid) as loan_repaid

  from liquidations
  group by 1

),

borrow_combo as (

  select * from daily_borrows
  left join daily_repayments using (date)

),

add_liquidations as (

  select

    c.date as date,
    borrow_amount,
    repay_amount,
    coalesce(loan_repaid,0) as loan_repaid

  from borrow_combo c
  left join daily_liquidations l using (date)

),

net_daily as (

  select

    *,
    borrow_amount - repay_amount - loan_repaid as net_daily_change

  from add_liquidations

),

final as (

  select

    *,
    sum(net_daily_change) over (order by date) as cumulative_borrow_amount

  from net_daily

)

select * from final
