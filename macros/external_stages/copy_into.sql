{% materialization copy_into, adapter='snowflake' %}

    {% set original_query_tag = set_query_tag() %}

    {%- set identifier = model['alias'] -%}

    {%- set old_relation = adapter.get_relation(database=database, schema=schema, identifier=identifier) -%}
    {%- set target_relation = api.Relation.create(identifier=identifier, schema=schema, database=database, type='table') -%}

    {{ run_hooks(pre_hooks) }}

    --recreate a blank table if the stage structure has changed, else skip this step
    {% if old_relation is none or not old_relation.is_table or should_full_refresh() %}
        {{ log("Replacing existing relation " ~ old_relation) }}
        {%- call statement('main') -%}
            {{ create_table_as(false, target_relation, sql ~ '\nlimit 0') }}
        {%- endcall -%}
    {% endif %}

    --DDL to copy staging files into a persisted table
    {%- call statement('main') -%}
        COPY INTO {{target_relation}} 
        FROM ( 
            {{sql}} 
        )
    {%- endcall -%}


    {{ run_hooks(post_hooks) }}

    {% do persist_docs(target_relation, model) %}

    {% do unset_query_tag(original_query_tag) %}

    {{ return({'relations': [target_relation]}) }}

{% endmaterialization %}