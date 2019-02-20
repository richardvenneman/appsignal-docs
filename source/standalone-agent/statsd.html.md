---
title: "StatsD in Standalone AppSignal Agent"
---

The standalone AppSignal Agent runs a StatsD server over UDP on localhost by default. You can use this to ingest metrics from other components of your infrastructure. Any metrics added are usable as custom metrics within AppSignal.

The StatsD server supports the DogsD extension, so you can use tags. At the moment gauges, counters and timers are supported.

The following example in Ruby demonstrates how this works using the
`statsd-instrument` gem:

```ruby
require 'statsd-instrument'

StatsD.backend = StatsD::Instrument::Backends::UDPBackend.new("localhost:8125", :datadog)

# Gauge
StatsD.gauge 'gauge', 2.0
StatsD.gauge 'gauge_with_tags', 3.0, tags: ['hostname:frontend1'], sample_rate: 0.9

# Counter
10.times do
  StatsD.increment 'counter'
  StatsD.increment 'counter_with_key_value_tags', tags: ['hostname:frontend1']
  StatsD.increment 'counter_with_only_key_tags', tags: ['important']
end

# Timing
10.times do
  StatsD.measure 'timing', 2.55
  StatsD.measure 'timing_with_tags', 3.55, tags: ['hostname:frontend1']
end
```

This is just to demonstrate, it is far more useful to use this from other technologies that are not directly supported by the AppSignal agent. You could use this to collect metrics from a PHP or Python app for example.

There are numerous tools available that can extract StatsD metrics from the JVM or various databases and web servers. We're curious to see what use cases you find, do let us know!
