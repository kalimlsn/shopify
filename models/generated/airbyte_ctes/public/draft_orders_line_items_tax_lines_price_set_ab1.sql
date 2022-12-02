{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('draft_orders_line_items_tax_lines') }}
select
    _airbyte_tax_lines_hashid,
    {{ json_extract('table_alias', 'price_set', ['shop_money'], ['shop_money']) }} as shop_money,
    {{ json_extract('table_alias', 'price_set', ['presentment_money'], ['presentment_money']) }} as presentment_money,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('draft_orders_line_items_tax_lines') }} as table_alias
-- price_set at draft_orders/line_items/tax_lines/price_set
where 1 = 1
and price_set is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

