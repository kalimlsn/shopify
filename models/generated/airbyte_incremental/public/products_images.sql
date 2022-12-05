{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('products_images_ab3') }}
select
    _airbyte_products_hashid,
    {{ adapter.quote('id') }},
    alt,
    src,
    width,
    height,
    {{ adapter.quote('position') }},
    created_at,
    updated_at,
    variant_ids,
    admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_images_hashid
from {{ ref('products_images_ab3') }}
-- images at products/images from {{ ref('products_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

