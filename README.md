# anchor_dashboard
dbt data models for Anchor Protocol's financial health dashboard.  


## structure
 - staging (stg_) models reference raw Flipside tables.
 - intermediate (int_) models transform staging.
 - testing (test_) are for checking data and will not persist.
 - visualizations (viz_) will be final models that can be called by any viz platform. This keeps all compute within snowflake.
 - 
