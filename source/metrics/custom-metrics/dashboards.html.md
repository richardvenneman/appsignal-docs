---
title: "Custom metric dashboards <sup>Beta</sup>"
---

Custom metrics dashboards are in beta. Dashboards are currently configured using a YAML definition format (which will change in the future) on the ["Add Dashboards"](https://appsignal.com/redirect-to/app?to=metrics/new) page.

These dashboards can be created based on [custom metrics](/metrics/custom.html) sent from apps integrated with AppSignal. Some metrics are automatically created by AppSignal based on request and background job data.

This page describes how to create/edit dashboards for your apps using our YAML definition format.

![Custom metrics demo dashboard](/images/screenshots/custom_metrics_dashboard.png)

## Table of Contents

- [Example dashboard](#example-dashboard)
- [Definition YAML](#definition-yaml)
- [Dashboards](#dashboards)
- [Graphs](#dashboard-graphs)
    - [Description](#dashboard-graphs-description)
    - [Line label format](#dashboard-graphs-line-label)
    - [Value formatting](#dashboard-graphs-format)
    - [Size value format input](#dashboard-graphs-format-input)
    - [Draw NULL as zero](#dashboard-graphs-draw-null-as-zero)
- [Graph metrics](#dashboard-graph-metrics)
    - [Name](#dashboard-graph-metrics-name)
    - [Fields](#dashboard-graph-metrics-fields)
    - [Tags](#dashboard-graph-metrics-tags)

## Example dashboard

Below is an example of our YAML structure that will generate a tab on the metrics page with two graphs. This examples a single dashboard with graphs for the error rate and response times grouped by every namespace.

This dashboard **requires** that *some* request or background job data has been received by AppSignal for your app.

```yaml
title: 'Example dashboard'
graphs:
  -
    title: 'Error rate'
    line_label: '%namespace%'
    format: percent
    metrics:
      -
        name: transaction_exception_rate
        fields:
          - GAUGE
        tags:
          namespace: "*"
  -
    title: 'Response time'
    line_label: '%namespace%'
    format: duration
    metrics:
      -
        name: transaction_duration
        fields:
          - MEAN
          - P90
          - P95
        tags:
          namespace: "*"
```

## Definition YAML

In this definition example some sections are annotated with their types, which correspond to the naming/headings on this page.

```yaml
# Annotated example dashboard YAML definition

# Dashboard
title: 'Dashboard title'
graphs:
  - # Graph
    title: 'Graph title #1'
    line_label: 'Configurable line label for %name%'
    format: percent
    draw_null_as_zero: true
    metrics:
      - # Metric
        name: my_metric_1
        fields:
          - GAUGE
      -
        name: my_metric_2
        fields:
          - GAUGE
  - # Graph
    title: 'Graph title #2'
    line_label: 'Configurable line label for %name% with %tag_1% %tag_2%'
    format: size
    format_input: kilobyte
    draw_null_as_zero: false
    metrics:
      - # Metric
        name: 'my_metric_*'
        fields:
          - GAUGE
        tags:
          tag_1: 'value_1'
          tag_2: 'value_with_wildcard_*'
```

##^dashboards Dashboards

The dashboards editor allows you to create/edit one dashboard at a time.
Each dashboard consists of a title and one or more [graphs](#dashboard-graphs).

```yaml
# Dashboard
title: "Dashboard title"
graphs:
  - <Graph>
```

| Field | Type | Description |
| ------ | ------ | ----- |
| title  | String | Title of the dashboard. |
| [graphs](#dashboard-graphs) | `Array<Graph>` | List of [Graphs](#dashboard-graphs) to show on the dashboard. |

##^dashboard Graphs

Per graph the following options can be configured.

```yaml
# Dashboard
title: 'Dashboard title'
graphs:
  - # Graph
    title: 'Graph title #1'
    description: "My graph description"
    line_label: 'Configurable line label for %name%'
    format: percent
    metrics:
      - <Metric>
  - # Graph
    title: 'Graph title #2'
    line_label: 'Configurable line label for %name%'
    format: size
    metrics:
      - <Metric>
```

| Field | Type | Description |
| ------ | ------ | ----- |
| `title`  | `String`<br>Required. | Title of the graph. Used for naming the dashboard navigation items. |
| [`description`](#dashboard-graphs-description) | `String` | Optional description to show on the graph. |
| [`line_label`](#dashboard-graphs-line-label) | `String`<br>Default: `"%name%"` | Line label formatter for this graph. Supports replacements of metric names, fields and tags with percent symbols. |
| [`format`](#dashboard-graphs-format) | `String`<br>Default: `"number"` | The formatter for the line values. Available options are: number, size, percent, duration and throughput. |
| [`format_input`](#dashboard-graphs-format-input) | `String` (no default) | The format of the input of this metrics when using the size formatter. Available options are: bit, byte, kilobit, kilobyte and megabyte. |
| [`draw_null_as_zero`](#dashboard-graphs-draw-null-as-zero) | `Boolean`<br>Default: `true` | If `true` no data (`NULL`) will be rendered as `0`. If `false` it will repeat the last received value until a new value is registered. |
| [`metrics`](#dashboard-graph-metrics) | `Metric` | Array of each metric that should be graphed. |

###=dashboard-graphs-description Graph description

Sometimes a graph title doesn't tell the whole story. If you need a place for a longer summary of what's being displayed in the graph it's possible to set a graph description.

Set the `description` key with any string value to get a description in the graph as shown below. Multi line descriptions are wrapped on a single line and expanded on hover.

![Graph description example](/images/screenshots/custom_metrics_graph_description.png)

###=dashboard-graphs-line-label Line label format

The `line_label` option allows you to format the label of every line as displayed in the graph legend on mouse over.

- `%name%`: the [metric name](/metrics/custom.html#metric-naming).
- `%field%`: the [`field`](#dashboard-graph-metrics-fields) of the metric.
- `%tag%`: every available [tag](#dashboard-graph-metrics-tags) key. Used as `%my_tag_key%`. These are dynamic and can differ per metric.

####^dashboard-graphs-line-label Example

The following example shows how to send a [counter](/metrics/custom.html#counter) metric with tags and how to create a dashboard graph that uses tags to format line label using the [`line_label` option](#dashboard-graphs-line-label).

```ruby
# Ruby
Appsignal.increment_counter("visits_per_region", 2, :region => "eu", :subscription_type => "pro")
Appsignal.increment_counter("visits_per_region", 1, :region => "us", :subscription_type => "standard")
```

```elixir
# Elixir
Appsignal.increment_counter("visits_per_region", 2, %{region: "eu", subscription_type: "pro"})
Appsignal.increment_counter("visits_per_region", 1, %{region: "us", subscription_type: "standard"})
```

The following graph definition will show two lines with the following labels:

- "visits_per_region - EU - pro"
- "visits_per_region - US - standard"

```yaml
# Dashboard
title: "My visits dashboard"
graphs:
  - # Graph
    title: "Visits graph"
    line_label: "%name% - %region% - %subscription_type%"
    metrics:
      - # Metric
        name: visits_per_region
        fields:
          - COUNTER
        tags:
          region: "*"
          subscription_type: "*"
```

###=dashboard-graphs-format Value formatting

The `format` option allows customization of the value type used to display values in the graph and graph legends.

Selecting a value formatter does not affect the data stored in our systems, only how it's displayed.

| Formatter | Description |
| ------ | ----- |
| `number` | A human readable formatted number. The value `1_000_000` is displayed as `1 M` and `10_000` as `10 K`. |
| `size` | Size formatted as megabytes. `1.0` megabytes is displayed as `1Mb`.  Use the [`format_input` option](#dashboard-graphs-format-input) to specify the unit of the input value. |
| `percent` | A percentage. The value `40` is displayed as "`40 %`". |
| `duration` | A duration of time in milliseconds. The value `100` is displayed as "`100 ms`" and 60_000 as "`60 sec`". Commonly used for [`measurement`](/metrics/custom.html#measurement) metric. |
| `throughput` | Throughput of a metric. It will display the throughput formatted as a number for both the minute and the hour. The value `10_000` is displayed "`10k / hour 166 / min`". Commonly used for [`counter`](/metrics/custom.html#counter) metrics. |

###=dashboard-graphs-format-input Size value format input

Specify the "size" of the incoming metric value in units of bytes with the `format_input` option. For example, you can either send a value expressed in bytes or megabytes and the formatter will use this as a basis to format the value in a human readable way. This option only works for the [format](#dashboard-graphs-format) option `"size"`.

AppSignal [host metrics](/metrics/host.html) send sizes in megabytes and won't need the `format_input` option to be configured for graphs, the default option `megabyte` will be used.

Selecting a value formatter input does not affect the data stored in our systems, only how it's displayed.

The available options are:

- `bit`
- `byte`
- `kilobit`
- `kilobyte`
- `megabyte`

When sending a metric with the following value:

```ruby
Appsignal.set_gauge("database_size", 1024)
```

The graph will render the following values for the specified settings:

- `format_input: bit` will render "128 Bytes"
- `format_input: byte` will render "1 KB"
- `format_input: kilobit` will render "128 KB"
- `format_input: kilobyte` will render "1 MB"
- `format_input: megabyte` will render "1 GB"
- `format_input: ""` will render "1 GB"

###^dashboard-graphs Draw NULL as zero

Not always does every point in time have a value for a metric, yet the value is not `0`. In our system we do not record a value for this time and treat this point as `NULL` rather than `0`. This means, no value is present and can be interpreted in two ways. Either it was actually `0` (useful for [counter](/metrics/custom.html#counter) metrics) or it retains the value of the previous known point.

The `draw_null_as_zero` option (`true` by default) allows configuration of the draw behavior for a graph. If set to `true` it will treat the `NULL` value as `0`. If set to `false` it will repeat the last known value until a later point in time specifies a new value.

See the difference in the graph below. With `draw_null_as_zero: true` the graph makes a sharp drop to `0` every time the app stopped reporting data. With `draw_null_as_zero: false` the graph looks less volatile in terms of lines moving up and down.

![Draw NULL as zero option graph comparison screenshot](/images/screenshots/draw_null_as_zero.png)

The configuration to generate the graphs above:

```yaml
# Dashboard
title: 'draw_null_as_zero example dashboard'
graphs:
  - # Graph
    title: 'draw_null_as_zero: true (default)'
    format: number
    draw_null_as_zero: true
    metrics:
      - # Metric
        name: random_number
        fields:
          - GAUGE
  - # Graph
    title: 'draw_null_as_zero: false'
    format: number
    draw_null_as_zero: false
    metrics:
      - # Metric
        name: random_number
        fields:
          - GAUGE
```

The app used to generate these graphs:

```ruby
# app.rb
# gem install "appsignal"
require "appsignal"
Appsignal.config = Appsignal::Config.new(".", "development", { :name => "My app", :active => true, :push_api_key => "00000000-0000-0000-0000-000000000000" })
Appsignal.start
Appsignal.start_logger

[
  [5, 1],
  [7, 1],
  [3, 3],
  [5, 2],
  [2, 5],
  [10, 2],
  [8, 1],
  [4, 2]
].each do |(value, pause)|
  puts "set_gauge random_number #{value}"
  Appsignal.set_gauge("random_numbers", value)
  pause_in_minutes = pause * 60
  puts "Sleeping #{pause} minute(s)"
  sleep pause_in_minutes
end

Appsignal.stop
```

##^dashboard Graph metrics

The graph metrics section describes which lines should be drawn in a graph based on the (custom) metrics available in AppSignal for an app. It's possible to select one or multiple metrics, specify which metric [field](#dashboard-graph-metrics-fields) and narrow down which [tags](#dashboard-graph-metrics-tags) should be filtered by.

```yaml
# Dashboard
title: 'Dashboard title'
graphs:
  - # Graph
    title: 'Graph title #1'
    line_label: 'Configurable line label for %name%'
    format: percent
    metrics:
      - # Metric
        name: counter_one
        fields:
          - COUNTER
      - # Metric
        name: counter_two
        fields:
          - COUNTER
  - # Graph
    title: 'Graph title #2'
    line_label: 'Configurable line label for %name%'
    format: size
    metrics:
      - # Metric
        name: transaction_exception_count
        fields:
          - GAUGE
```

| Field | Type | Description |
| ------ | ------ | ----- |
| [`name`](#dashboard-graph-metrics-name) | `String` supporting wildcard symbols (`*`).<br>Required. | An array of metric names to graph. Select metric by name using a wildcard symbol (`*`). |
| [`fields`](#dashboard-graph-metrics-fields) | `Array<String>`<br>Required. | The type of metrics to display in this graph. Available options are: `GAUGE`, `COUNTER`, `MEAN`, `P90`, `P95` and `COUNT`. |
| [`tags`](#dashboard-graph-metrics-tags) | `Object<Key, Value>` | Select metric by tags and their values. |

###^dashboard-graph-metrics Name

The [name of the metric](/metrics/custom.html#metric-naming) to be graphed in this graph. You can either use the full metric name to select one metric, or use a [wildcard](#dashboard-graph-metric-name-wildcard) to select multiple metrics at once.

```yaml
# Metric
name: db_users_document_count
```

####=dashboard-graph-metrics-name-wildcard Wildcard support

When using a wildcard, all [metric names](/metrics/custom.html#metric-naming) matching the given wildcard will be graphed. This can be useful if you have a type of grouping metrics by name to compare different kinds of systems.

```yaml
# Metric
name: "db_*_size"
```

This filter will match any metric name that begins with `db_` and ends with `_size`. For example:

- `db_graph_collection_size`
- `db_user_collection_size`

**Note**: We don't recommend using metric names for a lot of variables, instead [use tags](#dashboard-graph-metrics-tags) for this purpose.

###^dashboard-graph-metrics Fields

For every graph you can specify which type of metric to graph. Only the following values are supported:

- [`GAUGE`](/metrics/custom.html#gauge)
- [`COUNTER`](/metrics/custom.html#counter)
- [`MEAN`](/metrics/custom.html#measurement) (Measurement)
- [`P90`](/metrics/custom.html#measurement) (Measurement)
- [`P95`](/metrics/custom.html#measurement) (Measurement)
- [`COUNT`](/metrics/custom.html#measurement) (Measurement)

###^dashboard-graph-metrics Tags

With the `tags` option it's possible to select which tags for the metric to display in the graph. By default, when graphing a metric, all variations of the tags will create their own line in the graph. By omitting the `tags` option it will use this default behavior.

When matching metrics with tags all tags need to be specified, either with a value or a wildcard. For example, when a metric `visits_per_region` has two tags `region` and `subscription_type`, both tags need to be specified in the dashboard YAML definition. If one is omitted the graph will query for a metric only containing the specified tags, thus not finding the metric with more tags.

With the metric `visits_per_region` and the two tags `region` and `subscription_type`, this definition will **not match** the metric:

```yaml
# Metric
tags:
  region: "eu"
```

This definition will match the metric:

```yaml
# Metric
tags:
  region: "eu"
  subscription_type: "*"
```

It is also possible to match partial tag values with the wildcard, for example by specifying the value like so `"tag_value_*"`.

For metrics with tags we recommend customizing the labels used in the graph legend using the [`line_label` option](#dashboard-graphs-line-label).

####^dashboard-graph-metric-tags Example

The following graph will create two graphs, one that only shows visits in the EU region and another that only shows visits from the "pro" plan. It will draw two lines in each graph based on the wildcard specified in the other tag.

- "EU visits graph"
    - Lines to be drawn:
        1. "visits_per_region EU **pro**"
        1. "visits_per_region EU **standard**"
- "Pro visits graph"
    - Lines to be drawn:
        1. "visits_per_region **EU** pro"
        1. "visits_per_region **US** pro"

```yaml
# Dashboard
title: "My visits dashboard"
graphs:
  - # Graph
    title: "EU visits graph"
    line_label: "%name% %region% %subscription_type%"
    metrics:
      - # Metric
        name: visits_per_region
        fields:
          - COUNTER
        tags:
          region: "eu"
          subscription_type: "*"
  - # Graph
    title: "Pro visits graph"
    line_label: "%name% %region% %subscription_type%"
    metrics:
      - # Metric
        name: visits_per_region
        fields:
          - COUNTER
        tags:
          region: "*"
          subscription_type: "pro"
```

**Note**: When matching all tags values, the YAML format requires you to escape the wildcard character: `"*"`, otherwise it will try and interpret it as a YAML alias.
