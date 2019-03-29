---
title: "Puma"
---

[Puma](http://puma.io/) was built for speed and parallelism. Puma is a small library that provides a very fast and concurrent HTTP 1.1 server for Ruby web applications.

Support for Puma was added in AppSignal Ruby gem version `1.0`.

## Table of Contents

- [Usage](#usage)
- [Minutely probe](#minutely-probe)
  - [Configuration](#minutely-probe-configuration)

## Usage

The AppSignal Ruby gem automatically inserts a listener into the Puma server. No further action is required.

## Minutely probe

**Note**: Puma 3.11.4 or higher required.

Since AppSignal Ruby gem `2.9.0` and up a [minutely probe](/ruby/instrumentation/minutely-probes.html) is activated by default.

This probe will report the following [metrics](/metrics/custom.html) grouped by `hostname` tag:

- `puma_workers` - [gauge](/metrics/custom.html#gauge)
  - Tag `type`:
      - `count`: number of currently running threads for this server.
      - `booted`: the total number of currently booted workers for this server.
      - `old`: the number of workers running the previous configuration/code of the server at the moment in time. These will be phased out by Puma as new workers start.
- `puma_threads` - [gauge](/metrics/custom.html#gauge)
  - Tag `type`:
      - `running`: number of currently running threads for this server.
      - `max`: maximum number of configured threads for this server.
- `puma_connection_backlog` - [gauge](/metrics/custom.html#gauge)
  - The number of established but unaccepted connections that are in the server backlog queue and still need to be processed.
- `puma_pool_capacity` - [gauge](/metrics/custom.html#gauge)
  - The total thread pool capacity of the Puma server, including the number of threads that are waiting to be booted.

###^minutely-probe Configuration

This probe listens to the [`hostname` config option](/ruby/configuration/options.html#option-hostname) for the hostname tag added to all its metrics. If none is set it will try to detect it automatically. Use the `hostname` config option to set the hostname if you want to change the detected hostname.
