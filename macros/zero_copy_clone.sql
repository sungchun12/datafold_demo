{% macro clone_prod_to_target(from) %}

    {% set sql -%}
        create schema if not exists {{ target.database }}.{{ target.schema }} clone {{ from }};
    {%- endset %}

    {{ dbt_utils.log_info("Cloning schema " ~ from ~ " into target schema.") }}

    {% do run_query(sql) %}

    {{ dbt_utils.log_info("Cloned schema " ~ from ~ " into target schema.") }}

{% endmacro %}


{% macro destroy_current_env() %}

    {% set sql -%}
        drop schema if exists {{ target.database }}.{{ target.schema }} cascade;
    {%- endset %}

    {{ dbt_utils.log_info("Dropping target schema: " ~ target.schema ~ "") }}

    {% do run_query(sql) %}

    {{ dbt_utils.log_info("Dropped target schema: " ~ target.schema ~ "") }}

{% endmacro %}

{% macro reset_dev_env(from) %}
{#-
This macro destroys your current development environment, and recreates it by cloning from prod.

To run it:
    $ dbt run-operation reset_dev_env --args '{from: analytics}'

-#}
    {% if target.name == 'default' %}

    {{ destroy_current_env() }}

    {{ clone_prod_to_target(from) }}

    {% else %}

    {{ dbt_utils.log_info("No-op: your current target is " ~ target.name ~ ". This macro only works for a default target.") }}

    {% endif %}

{% endmacro %}
