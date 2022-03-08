# anchor_dashboard
dbt data models for Anchor Protocol's financial health [dashboard](https://forgash.retool.com/embedded/public/e54597fe-837b-4a13-8dbc-332c8226f6f4).  


## structure
 - staging (stg_) models reference raw Flipside tables.
 - intermediate (int_) models transform staging.
 - testing (test_) are for checking data and will not persist.
 - visualizations (viz_) will be final models that can be called by any viz platform. This keeps all compute within snowflake.


## TODO
### viz models

structure should be just a `select *` passthrough:
 - cte named `data`
 - `select * from data`

 - it would make the most sense to materialize these as views as no compute is happening, it's just a labeling schema for ease of use
