{%- macro drop_pr_staging_schemas(SCHEMA_ID) %}

    {% set pr_cleanup_query %}
        with pr_staging_schemas as (
            select schema_name
            from information_schema.schemata
            where
            schema_name like 'pr_'||{{ SCHEMA_ID }}||'%'
        )

        select 
            'drop schema '||schema_name||';' as drop_command 
        from pr_staging_schemas
    {% endset %}

{% do log(pr_cleanup_query, info=TRUE) %}

{% set drop_commands = run_query(pr_cleanup_query).columns[0].values() %}

{% if drop_commands %}
  {% for drop_command in drop_commands %}
    {% do log(drop_command, True) %}
      {% do run_query(drop_command) %}
  {% endfor %}
{% else %}
  {% do log('No schemas to drop.', True) %}
{% endif %}

{%- endmacro -%}