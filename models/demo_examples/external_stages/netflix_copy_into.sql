{{ config(materialized='copy_into') }}

select
    --get the parsed columns in the proper sql syntax based on the external stage
    {{ get_stage_columns_from_loading_config(
        stage_name=source('netflix', 'netflix_blob_stage'), 
        config_table=ref('loading_config')
    )}},
    current_timestamp::timestamp_ntz as ingestion_time

from
    --@ symbol used to reference external stage in snowflake
    @{{source('netflix', 'netflix_blob_stage')}}