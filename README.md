# anchor_dashboard
dbt data models for Anchor Protocol's financial health [dashboard](https://forgash.retool.com/embedded/public/e54597fe-837b-4a13-8dbc-332c8226f6f4).


## model structure
 - staging (stg_) models reference raw Flipside tables.
 - intermediate (int_) models transform staging.
 - anchor directory contains all 'final' models that are aggregations of intermediate models. These are summary statistics and user behaviors for anchor protocol.
 - visualizations (viz_) will be final models that can be called by any viz platform. This keeps all compute within snowflake.

## contributing
Protocols are constantly evolving and ever intertwined. If you spot any improvements to these data models, contribution is welcome and appreciated.
