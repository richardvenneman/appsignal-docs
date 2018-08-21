---
title: "Custom metrics <sup>Beta</sup>"
---

With AppSignal for both Ruby and Elixir, it's possible to add custom instrumentation to [transactions](/appsignal/terminology.html#transactions) ([Ruby](/ruby/instrumentation/index.html) / [Elixir](/elixir/instrumentation/index.html)) to get more details about your application's performance. This instrumentation is per sample and don't give a complete picture of your application. Instead, you can use custom metrics for application-wide metrics.

To track application-wide metrics, you can send custom metrics to AppSignal. These metrics enable you to track anything in your application, from newly registered users to database disk usage. These are not replacements for custom instrumentation, but provide an additional way to make certain data in your code more accessible and measurable over time.

With different [types of metrics](#metric-types) (gauges, counters and measurements) you can track any kind of data from your apps and [tag](#metric-tags) them with metadata to easily spot the differences between contexts.

![Custom metrics demo dashboard](/images/screenshots/custom_metrics_dashboard.png)

Also see our blog post [about custom metrics](http://blog.appsignal.com/blog/2016/01/26/custom-metrics.html) for more information.

-> **Note**: This feature was introduced with the `1.0` version of the AppSignal for Ruby gem. It is also available in the Elixir package.

## Table of Contents

- [Metric types](#metric-types)
  - [Gauge](#gauge)
  - [Measurement](#measurement)
  - [Counter](#counter)
- [Metric naming](#metric-naming)
- [Metric values](#metric-values)
- [Metric tags](#metric-tags)
- [Dashboards](#dashboards)
  - [Example dashboard](#dashboards-example-dashboard)
  - [Definition YAML](#dashboards-definition-yaml)
  - [Kind](#dashboards-kind)
  - [Fields](#dashboards-fields)
  - [Filter](#dashboards-filter)
  - [Tags](#dashboards-tags)
  - [Value formatting](#dashboards-value-formatting)
  - [Size value format input](#dashboards-size-value-format-input)
  - [Draw NULL as zero](#draw_null_as_zero)

## Metric types

There are three kinds of metrics we collect all with their own purpose.

- [Gauge](#gauge)
- [Measurement](#measurement)
- [Counter](#counter)

### Gauge

A gauge is a metric value at a specific time. If you set more than one gauge with the same key, the latest value for that moment in time is persisted.

Gauges are used for things like tracking sizes of databases, disks, or other absolute values like CPU usage, a numbers of items (users, accounts, etc.). Currently all AppSignal [host metrics](host.html) are stored as gauges.

```ruby
# The first argument is a string, the second argument a number
# Appsignal.set_gauge(metric_name, value)
Appsignal.set_gauge("database_size", 100)
Appsignal.set_gauge("database_size", 10)

# Will create the metric "database_size" with the value 10
```

### Measurement

At AppSignal measurements are used for things like response times. We allow you to track a metric with wildly varying values over time and create graphs based on their average value or call count during that time.

By tracking a measurement, the average and count will be persisted for the metric. A measurement metric creates two metrics, one with the `_count` suffix which counts how many times the helper was called and the `_mean` suffix which contains the average metric value for the point in time.

```ruby
# The first argument is a string, the second argument a number
# Appsignal.add_distribution_value(metric_name, value)
Appsignal.add_distribution_value("memory_usage", 100)
Appsignal.add_distribution_value("memory_usage", 110)

# Will create a metric "memory_usage" with the mean value 105
```

### Counter

The counter metric type stores a number value for a given time frame. These counter values are combined into a total count value for the display time frame resolution. This means that when viewing a graph with a minutely resolution it will combine the values of the given minute, and for the hourly resolution combines the values of per hour.

Counters are good to use to track events. With a [gauge](#gauge) you can track how many of something (users, comments, etc.) there is at a certain time, but with events you can track how many events occurred at a specific time (users signing in, comments being made, etc.).

When the helper is called multiple times, the total/sum of all calls is persisted.

```ruby
# The first argument is a string, the second argument a number
# Appsignal.increment_counter(metric_name, value)
Appsignal.increment_counter("login_count", 1)
Appsignal.increment_counter("login_count", 1)

# Will create the metric "login_count" with the value 2 for a point in the minutely/hourly resolution
```

## Metric naming

We recommend naming your metrics something easily recognizable and without too many dynamic elements. While you can wildcard parts of the metric name for dashboard creation, we recommend you only use this for small grouping and not use IDs for metric names.

Metric names only support numbers, letters, dots and underscores (`[a-z0-9._]`) as valid characters. Any other characters will be replaced with an underscore by our processor. In the "Metrics" feature (as listed in the AppSignal navigation for your app) under "Edit dashboards" a list is displayed with all metrics received in the last hour. In this list you can see their names as sanitized by our processor.

Some examples of good metric names are:

- `database_size`
- `account_count`
- `users.count`
- `notifier.failed`
- `notifier.perform`
- `notifier.success`

By default AppSignal already tracks metrics for your application, such as [host metrics](host.html). See the metrics list on the "Edit dashboards" page for the metrics that are already available for your app.

## Metric values

Metrics only support numbers as valid values. Any other value will be silently ignored or will raise an error as triggered by the implementation language number parser. For Ruby and Elixir we support a [double](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) and [integer](https://en.wikipedia.org/wiki/Integer) as valid values.

```ruby
# Integer
Appsignal.increment_counter("login_count", 1)
# Double
Appsignal.increment_counter("assignment_completed", 0.12)
```

## Metric tags

-> **Note**: Tags for custom metrics are supported since AppSignal for Ruby gem version `2.6.0` and Elixir package `1.6.0`. Please upgrade to use this feature.

Custom metrics sometimes need some context what they're about. This context can be added as tags so it doesn't need to be included in the name and you can use the same metric name for different values.

For example, you have databases running in the EU, US and Asia, you could tag your metrics like so:

```ruby
# Ruby
AppSignal.set_gauge("database_size", 100, :region => "eu")
```

```elixir
# Elixir
AppSignal.set_gauge("database_size", 100, %{region: "eu"})
```

Another example is how AppSignal uses [host metrics](host.html). Every host metric has a tag with a `hostname` to differentiate between different hosts. Some host metrics even have more tags such as the `state` tag for the `cpu` metric, `mountpoint` tag for the `disk_usage`, `disk` tag for `disk_io_read` and `disk_io_written`, etc.

Read about how to use the [`tags`](#dashboards-tags) dashboard config option to customize how tags are used in your graphs and how to use them in your [line labels](#dashboards-line-label-format).

**Note**: We __do not__ recommend adding this context to your metric names like so: `eu.database_size`, `us.database_size` and `asia.database_size`. This creates multiple metrics that serve the same purpose. The same goes for any dynamic string that builds the metric key, e.g. `user_#{user.id}`.

## Dashboards

Custom metrics dashboards are in beta. Dashboards are currently configured using a YAML definition format which will change in the future.

###^dashboards Example dashboard

Below is an example of our YAML structure that will generate a tab on the metrics page with two graphs. This examples a single dashboard with graphs for the error rate and response times grouped by every namespace.

This dashboard **requires** that *some* request or background job data has been received by AppSignal for your app.

```yaml
-
  title: 'Example dashboard'
  graphs:
    -
      title: 'Error rate'
      line_label: '%namespace%'
      kind: gauge
      fields:
        - transaction_exception_rate
      tags:
        namespace: "*"
      format: percent
    -
      title: 'Response time'
      line_label: '%namespace%'
      kind: measurement
      fields:
        - transaction_duration
      tags:
        namespace: "*"
      format: duration
```

###^dashboards Definition YAML

Each dashboard consists of a title and one or more graphs. For each graph the following fields are available.

```yaml
-
  title: 'Dashboard title'
  graphs:
    -
      title: 'Graph title #1'
      line_label: 'Configurable line label for %name%'
      kind: gauge
      fields:
        - my_metric_1
        - my_metric_2
      format: percent
      draw_null_as_zero: true
    -
      title: 'Graph title #2'
      line_label: 'Configurable line label for %name% with %tag_1% %tag_2%'
      kind: gauge
      filter: 'my_metric_*'
      tags:
        tag_1: 'value_1'
        tag_2: 'value_with_wildcard_*'
      format: size
      format_input: kilobyte
      draw_null_as_zero: false
```

###^dashboards Dashboards

```yaml
-
  title: "Dashboard title"
  graphs:
    - <GRAPH>
```

| Field | Type | Description |
| ------ | ------ | ----- |
| title  | String | Title of the dashboard. |
| graphs | `Array<Graph>` | List of [Graphs](#dashboards-graphs) to show on the dashboard. |

###^dashboards Graphs

Per graph the following options can be configured.

```yaml
-
  title: 'Dashboard title'
  graphs:
    -
      title: 'Graph title #1'
      line_label: 'Configurable line label for %name%'
      kind: gauge
      format: percent
      fields:
        - erorr
    -
      title: 'Graph title #2'
      line_label: 'Configurable line label for %name%'
      kind: gauge
      format: size
      filter: transaction_exception_count
```

| Field | Type | Description  |
| ------ | ------ | ----- |
| `title`  | `String`<br>Required. | Title of the graph. Used for naming the dashboard tabs. |
| [`line_label`](#dashboards-line-label-format) | `String`<br>Default: `"%name"` | Line label formatter for this graph. Supports replacements of metric names, kind and tags with percent symbols. |
| [`kind`](#dashboards-kind) | `String`<br>Required. | The kind of metrics to display in this graph. Available options are: `gauge`, `measurement` and `count`. |
| [`fields`](#dashboards-fields) | `Array<String>` | An array of fields to graph. |
| [`filter`](#dashboards-filter) | `String` supporting wildcard symbols (`*`) | Select metric by name using a wildcard symbol (`*`). |
| [`tags`](#dashboards-tags) | `Object<Key, Value>` | Select metric by tags and their values. |
| [`format`](#dashboards-format) | `String`<br>Default: `"number"` | The formatter for the line values. Available options are: number, size, percent, duration and throughput. |
| [`format_input`](#dashboards-size-value-format-input) | `String` (no default) | The format of the input of this metrics when using the size formatter. Available options are: bit, byte, kilobit, kilobyte and megabyte. |
| [`draw_null_as_zero`](#draw-null-as-zero) | `Boolean`<br>Default: `true` | If `true` no data (`NULL`) will be rendered as `0`. If `false` it will repeat the last received value until a new value is registered. |

###^dashboards Kind

For every graph you can specify which type of metric to graph. Only the following values are supported:

- [`gauge`](#gauge)
- [`measurement`](#measurement)
- [`count`](#counter)

###^dashboards Line label format

The `line_label` option allows you to format the label of every line as displayed in the graph legend on mouse over.

- `%name%`: the [metric name](#metric-naming)
- `%field%`: the [`kind`](#dashboards-kind) of the metric. Note: These names ("kind" and "field)" do not match due to legacy reasons. (Expect a rename soon!)
- `%tag%`: every available tag key. Used as `%my_tag_key%`. These are dynamic and can differ per metric.

####^dashboards-line-label-format Example

The following example shows how to send a [counter](#counter) metric with tags and how to create a dashboard graph that uses tags to format line label using the [`line_label` option](#dashboards-line-label-format).

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

- "visits_per_region EU pro"
- "visits_per_region US standard"

```yml
-
  title: "My visits dashboard"
  graphs:
    -
      title: "Visits graph"
      line_label: "%name% %region% %subscription_type%"
      kind: count
      fields:
        - visits_per_region
```

###^dashboards Fields

An array of strings containing [names of metrics](#metric-naming) to be graphed in this graph. You can either use an array of metric names, or [a single filter](#dashboards-filter), to select metrics for a graph.

```yaml
fields:
  - db_users_document_count
  - db_account_document_count
```

**Note**: If the [`filter` option](#dashboards-filter) is specified, the `fields` option is ignored.

###^dashboards Filter

When using a filter, all metric names matching the given wildcard will be graphed. This can be useful if you have a type of grouping metrics by name to compare different kinds of systems.

**Note**: If the `filter` option is specified, the [`fields` option](#dashboards-fields) is ignored.

```yaml
filter: "db_*_size"
```

This filter will match any metric name that begins with `db_` and ends with `_size`, for example:

- `db_graph_collection_size`
- `db_user_collection_size`

###^dashboards Tags

With the `tags` option it's possible to select which tags for the metric to display in the graph. By default, when graphing a metric, all variations of the tags will create their own line in the graph. By omitting the `tags` option it will use this default behavior.

When matching metrics with tags all tags need to be specified, either with a value or a wildcard. For example, when a metric `visits_per_region` has two tags `region` and `subscription_type`, both tags need to be specified in the dashboard YAML definition. If one is omitted the graph will query for a metric only containing the specified tags, thus not finding the metric with more tags.

With the metric `visits_per_region` and the two tags `region` and `subscription_type`, this definition will **not match** the metric:

```yml
tags:
  region: "eu"
```

This definition will match the metric:

```yml
tags:
  region: "eu"
  subscription_type: "*"
```

It is also possible to match partial tag values with the wildcard, for example by specifying the value like so `"tag_value_*"`.

For metrics with tags we recommend customizing the labels used in the graph legend using the [`line_label` option](#dashboards-line-label-format).

####^dashboards-tags Example

The following graph will create two graphs, one that only shows visits in the EU region and another that only shows visits from the "pro" plan. It will draw two lines in each graph based on the wildcard specified in the other tag.

- "EU visits graph"
    - Lines to be drawn:
        1. "visits_per_region EU **pro**"
        1. "visits_per_region EU **standard**"
- "Pro visits graph"
    - Lines to be drawn:
        1. "visits_per_region **EU** pro"
        1. "visits_per_region **US** pro"

```yml
-
  title: "My visits dashboard"
  graphs:
    -
      title: "EU visits graph"
      line_label: "%name% %region% %subscription_type%"
      kind: count
      fields:
        - visits_per_region
      tags:
        region: "eu"
        subscription_type: "*"
    -
      title: "Pro visits graph"
      line_label: "%name% %region% %subscription_type%"
      kind: count
      fields:
        - visits_per_region
      tags:
        region: "*"
        subscription_type: "pro"
```

**Note**: When matching all tags values, the YAML format requires you to escape the wildcard character: `"*"`, otherwise it will try and interpret it as a YAML alias.

###^dashboards Value formatting

The `format` option allows customization of the value type used to display values in the graph and graph legends.

Selecting a value formatter does not affect the data stored in our systems only how its displayed.

| Formatter | Description |
| ------ | ----- |
| `number` | A human readable formatted number. The value `1_000_000` is displayed as `1 M` and `10_000` as `10 K`. |
| `size` | Size formatted as megabytes. `1.0` megabytes is displayed as `1Mb`.  Use the [`format_input` option](#dashboards-size-value-format-input) to specify the unit of the input value. |
| `percent` | A percentage. The value `40` is displayed as "`40 %`". |
| `duration` | A duration of time in milliseconds. The value `100` is displayed as "`100 ms`" and 60_000 as "`60 sec`". Commonly used for [`measurement`](#measurement) metric. |
| `throughput` | Throughput of a metric. It will display the throughput formatted as a number for both the minute and the hour. The value `10_000` is displayed "`10k / hour 166 / min`". Commonly used for [`counter`](#counter) metrics. |

###^dashboards Size value format input

Specify the "size" of the incoming metric value in units of bytes with the `format_input` option. For example, you can either send a value expressed in bytes or megabytes and the formatter will use this as a basis to format the value in a human readable way. This option only works for the [format](#dashboards-value-formatting) option `"size"`.

AppSignal [host metrics](host.html) send sizes in megabytes and won't need the `format_input` option to be configured for graphs, the default option `megabyte` will be used.

Selecting a value formatter input does not affect the data stored in our systems only how its displayed.

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

###^dashboards Draw NULL as zero

Not always does every point in time have a value for a metric, yet the value is not `0`. In our system we do not record a value for this time and treat this point as `NULL` rather than `0`. This means, no value is present and can be interpreted in two ways. Either it was actually `0` (useful for [counter](#counter) metrics) or it retains the value of the previous known point.

The `draw_null_as_zero` option (`true` by default) allows configuration of the draw behavior for a graph. If set to `true` it will treat the `NULL` value as `0`. If set to `false` it will repeat the last known value until a later point in time specifies a new value.

See the difference in the graph below. With `draw_null_as_zero: true` the graph makes a sharp drop to `0` every time the app stopped reporting data. With `draw_null_as_zero: false` the graph looks less volatile in terms of lines moving up and down.

![Draw NULL as zero option graph comparison screenshot](/images/screenshots/draw_null_as_zero.png)

The configuration to generate the graphs above:

```yaml
-
  title: 'draw_null_as_zero example dashboard'
  graphs:
    -
      title: 'draw_null_as_zero: true (default)'
      kind: gauge
      fields:
        - random_number
      format: number
      draw_null_as_zero: true
    -
      title: 'draw_null_as_zero: false'
      kind: gauge
      fields:
        - random_number
      format: number
      draw_null_as_zero: false
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
