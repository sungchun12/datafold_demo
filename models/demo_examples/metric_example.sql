
-- force a dependency
-- depends_on: {{ ref('fct_orders') }}


select * 
from {{ metrics.metric(
    metric_name='orders_over_time',
    grain='month',
    dimensions=['status_code']
) }}

where orders_over_time != 0