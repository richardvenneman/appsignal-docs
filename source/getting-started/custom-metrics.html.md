---
title: "Custom metrics"
---

This feature was introduced with the `1.0` version of the AppSignal gem.
It allows sending various metrics to AppSignal where they can be graphed.

# Sending custom metrics

There are three kinds of metrics we collect: _gauge_, _measurement_ and _count_.

## Gauge

A gauge is a number. If you set more than one gauge with the same key, the latest value for that moment in time is persisted:

```ruby
# The key should be a string, the value a number
# Appsignal.set_gauge(key, val)
Appsignal.set_gauge('database_size', 100)
Appsignal.set_gauge('database_size', 10)

# Will yield a graph where the `database_size` is 100
```

## Measurement

With a measurement, the average and count will be persisted:

```ruby
# The key should be a string, the value a number
# Appsignal.add_distribution_value(key, val)
Appsignal.add_distribution_value('memory_usage', 100)
Appsignal.add_distribution_value('memory_usage', 110)

# Will yield a graph where the `memory_usage_count` is 2 and the `memory_usage_mean` is 105
```

## Count

When set multiple times, the sum will be persisted:

```ruby
# The key should be a string, the value a number
# Appsignal.increment_counter(key, val)
Appsignal.increment_counter('login_count', 1)
Appsignal.increment_counter('login_count', 1)

# Will yield a graph where the `login_count` is 2
```
-> Only numbers, letters and underscores (<code>[a-z0-9_]</code>) are allowed as metric keys. Other values will be replaced with an underscore.

# Displaying custom metrics

Right now this feature is in beta. This means there isn't a UI to configure dashboards, and this syntax will change in the (near) future. Below is an example of our YAML structure that will generate a tab on the metrics page with two graphs:

```yaml
-
    title: "Data growth"
    graphs:
        -
              title: "Database size"
              kind: "measurement"
              format: "size"
              filter: "db_[a-z]+._size"
        -
              title: "MongoDB collection count"
              kind: "gauge"
              format: "number"
              fields:
                  - db_users_document_count
                  - db_account_document_count
```

Each dashboard consists of a title and one or more graphs. For each graph the following fields are available:

| Field | Type | Description  |
| ------ | ------ | ----- |
|  title  |  string  |  title of the graph  |
|  [kind](#kind)  |  string  |  the kind of metrics to display, available options are "gauge, measurement and count". This determins the group of metrics where data can be graphed. See the "Sample fields from the last five minutes" section of the metrics editor to see what groups and fields are available.  |
|  [format](#format)  |  string  |  the formatter for the data, options are "number, size, percent, duration, throughput"  |
|  [fields](#fields)  |  array (strings)  |  an array of fields to graph |
|  [filter](#filter)  |  string (Regex)  |  a regex, maching fields will be graphed  |
|  [`draw_null_as_zero`](#draw_null_as_zero) | boolean (true/false), defaults to true | Graphs have two render options, if `draw_null_as_zero` is true (default) then if no vaule is received it will draw that point as 0, if `draw_null_as_zero` is set to false, then the previous value will be used, until a new value is received.

## Kind <a name="kind"></a>

There are three kinds of metrics we collect, "gauge, measurement and count".

| Field |  Description  |
| ------ | ----- |
|  gauge  | A gauge contains a number, if another gauge with the same key is set, the highest number will be persisted. |
|  measurement  |  A measurement contains a duration of time, when multiple measurements with the same key are set, the average will be persisted. |
|  count  | A count is a number that can be incremented, when multiple counts with the same key are set, the count is incremented by the vaule of each key. |


## Format <a name="format"></a>

For the graphs we have a number of formatters available for the data.

| Format |  Description  |
| ------ | ----- |
|  number  | A formatted number, 1_000_000 wil become `1M` 10_000 will become `10K` |
|  size  |  Size formatted from megabytes. 1.0 megabytes will become `1Mb` |
|  percent  | A percentage, 40 will become `40%` |
|  duration  | A duration of time in miliseconds. 100 will become `100ms` 60_000 will become `60sec` Mosly used for measurements. |
|  throughput  | Throughput of a metric. It will display the troughput formatted as a number for both the minute and the hour. 10_000 will become `10k / hour 166/min`, Mostly used for count fields. |

##  Fields <a name="fields"></a>

An array of fields to be graphed. You can either use an array of fields, or a filter

```yaml
fields:
  - db_users_document_count
  - db_account_document_count
```
A list of available fields per group can be found on the metric editor page.

## Filter <a name="filter"></a>

When using a filter, all fields matching the given (Javascript)regex will be graphed. You can either use an array of fields, or a filter.

```yaml
filter: "db_[a-z]+._size"
```

This filter will match any field that begins with `db_` and ends with `_size`, for example:

* `db_graph_collection_size`
* `db_user_collection_size`


## Draw NULL as zero <a name="draw_null_as_zero"></a>

There are two options to render lines, if `draw_null_as_zero` is `true` (default) then if no vaule is received it will draw that point as 0, if `draw_null_as_zero` is set to `false`, then the previous value will be used, until a new value is received.

![draw null as zero](/images/screenshots/draw_null_as_zero.png)

Code to generate the graphs above:

```
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
