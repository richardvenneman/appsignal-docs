---
title: "Custom metrics <sup>Beta</sup>"
---

With AppSignal for both Ruby and Elixir, it's possible to add custom instrumentation to [transactions](/appsignal/terminology.html#transactions) ([Ruby](/ruby/instrumentation/index.html) / [Elixir](/elixir/instrumentation/index.html)) to get more details about your application's performance. This instrumentation is per sample and don't give a complete picture of your application. Instead, you can use custom metrics for application-wide metrics.

To track application-wide metrics, you can send custom metrics to AppSignal. These metrics enable you to track anything in your application, from newly registered users to database disk usage. These are not replacements for custom instrumentation, but provide an additional way to make certain data in your code more accessible and measurable over time.

Also see our blog post [about custom metrics](http://blog.appsignal.com/blog/2016/01/26/custom-metrics.html) for more information.

-> **Note**: This feature was introduced with the `1.0` version of the AppSignal for Ruby gem. It is also available in the Elixir package.

## Table of Contents

- [Metric types](#metric-types)
  - [Gauge](#gauge)
  - [Measurement](#measurement)
  - [Count](#count)
- [Metric naming](#metric-naming)
- [Metric values](#metric-values)
- [Dashboards](#dashboards)

## Metric types

There are three kinds of metrics we collect all with their own purpose.

- [Gauge](#gauge)
- [Measurement](#measurement)
- [Count](#count)

### Gauge

A gauge is a metric value at a specific time. If you set more than one gauge with the same key, the latest value for that moment in time is persisted.

Gauges are used for things like tracking sizes of databases, disks, or other absolute values like CPU usage, a numbers of items (users, accounts, etc.). Currently all AppSignal [host metrics](host.html) are stored as gauges.

```ruby
# The first argument is a string, the second argument a number
# Appsignal.set_gauge(metric_name, value)
Appsignal.set_gauge("database_size", 100)
Appsignal.set_gauge("database_size", 10)

# Will yield a graph where the `database_size` is 10
```

### Measurement

At AppSignal measurements are used for things like response times. We allow you to track a metric with wildly varying values over time and create graphs based on their average value or call count during that time.

By tracking a measurement, the average and count will be persisted for the metric. A measurement metric creates two metrics, one with the `_count` suffix which counts how many times the helper was called and the `_mean` suffix which contains the average metric value for the point in time.

```ruby
# The first argument is a string, the second argument a number
# Appsignal.add_distribution_value(metric_name, value)
Appsignal.add_distribution_value("memory_usage", 100)
Appsignal.add_distribution_value("memory_usage", 110)

# Will yield a graph where the `memory_usage_count` metric is 2 and the `memory_usage_mean` metric is 105
```

### Count

The count metric type stores a number value for a given time frame. These count values are combined into a total count value for the display time frame resolution. This means that when viewing a graph with a minutely resolution it will combine the values of the given minute, and for the hourly resolution combines the values of per hour.

Counts are good to use to track events. With a [gauge](#gauge) you can track how many of something (users, comments, etc.) there is at a certain time, but with events you can track how many events occurred at a specific time (users signing in, comments being made, etc.).

When the helper is called multiple times, the total/sum of all calls is persisted.

```ruby
# The first argument is a string, the second argument a number
# Appsignal.increment_counter(metric_name, value)
Appsignal.increment_counter("login_count", 1)
Appsignal.increment_counter("login_count", 1)

# Will yield a graph where the `login_count` is 2 for a point in the minutely/hourly resolution
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


## Dashboards

This feature is in beta. This means there isn't a UI to configure dashboards,
and this syntax _will_ change in the (near) future. Below is an example of our
YAML structure that will generate a tab on the metrics page with two graphs:

```yaml
-
  title: "Data growth"
  graphs:
    -
      title: "Database size"
      kind: "measurement"
      format: "size"
      filter: "db_*_size"
    -
      title: "MongoDB collection count"
      kind: "gauge"
      format: "number"
      fields:
        - db_users_document_count
        - db_account_document_count
```

Each dashboard consists of a title and one or more graphs. For each graph the
following fields are available:

| Field | Type | Description  |
| ------ | ------ | ----- |
| title  | String | Title of the graph. |
| [kind](#kind) | string | The kind of metrics to display, available options are: gauge, measurement and count. This determines the group of metrics where data can be graphed. See the "Sample fields from the last five minutes" section of the metrics editor to see what groups and fields are available.  |
| [format](#format) | String | The formatter for the data, options are: "number, size, percent, duration, throughput. |
| format_input | String | The format of the input of this metrics when usizing the size formatter, options are: "bit, byte, kilobit, kilobyte, megabyte" |
| [fields](#fields) | Array<String> | An array of fields to graph. |
| [filter](#filter) | String with wildard (*) | Filter out metrics by wildcard (`*`), matching fields will be graphed. |
| [draw_null_as_zero](#draw-null-as-zero) | Boolean, defaults: true | Graphs have two render options, if `draw_null_as_zero` is true (default) then if no value is received it will draw that point as 0, if `draw_null_as_zero` is set to false, then the previous value will be used, until a new value is received. |

### Kind

There are three kinds of metrics we collect: gauge, measurement and count.

| Field |  Description  |
| ------ | ----- |
| gauge | A gauge is a number. If you set more than one gauge with the same key, the latest value for that moment in time is persisted. |
| measurement | A measurement contains a duration of time, when multiple measurements with the same key are set, the average will be persisted. |
| count | A count is a number that can be incremented, when multiple counts with the same key are set, the count is incremented by the value of each key. |

### Format

For the graphs we have a number of formatters available for the data.

| Format |  Description  |
| ------ | ----- |
| number | A formatted number, by default 1_000_000 will become `1M` 10_000 will become `10K`. Use `format_input` to specify the input format. |
| size | Size formatted from megabytes. 1.0 megabytes will become `1Mb`. |
| percent | A percentage, 40 will become `40%`. |
| duration | A duration of time in milliseconds. 100 will become `100ms` 60_000 will become `60sec`. Mostly used for measurements. |
| throughput | Throughput of a metric. It will display the throughput formatted as a number for both the minute and the hour. 10_000 will become `10k / hour 166/min`, Mostly used for count fields. |

### Fields

An array of fields to be graphed. You can either use an array of fields, or a
filter.

```yaml
fields:
  - db_users_document_count
  - db_account_document_count
```
A list of available fields per group can be found on the metric editor page.

### Filter

When using a filter, all fields matching the given wildcard will be
graphed. You can either use an array of fields, or a filter.

```yaml
filter: "db_*_size"
```

This filter will match any field that begins with `db_` and ends with `_size`,
for example:

* `db_graph_collection_size`
* `db_user_collection_size`

### Draw NULL as zero

There are two options to render lines, if `draw_null_as_zero` is `true`
(default) then if no value is received it will draw that point as 0, if
`draw_null_as_zero` is set to `false`, then the previous value will be used,
until a new value is received.

![draw null as zero](/images/screenshots/draw_null_as_zero.png)

The configuration to generate the graphs above:

```yaml
-
  title: 'draw_null_as_zero: true (default)'
  kind: measurement
  format: duration
  draw_null_as_zero: true
  fields:
    - random_numbers
-
  title: 'draw_null_as_zero: false'
  kind: measurement
  format: duration
  draw_null_as_zero: false
  fields:
    - random_numbers
```
