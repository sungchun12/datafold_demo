/*
Step 1: Create a fresh stage
dbt run-operation create_or_replace_netflix_stage --args '{dry_run: False}'

Step 2: Run the below command to create an external table from an already existing stage
dbt run-operation stage_external_sources --args "select: netflix_external_src" --vars "ext_full_refresh: true"

Step 3: Create a downstream model from the external table source
dbt run --select ref_external_table
*/

select *

from

    {{source('netflix_external_src', 'event_ext_tbl')}}