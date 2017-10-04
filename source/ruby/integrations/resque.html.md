---
title: "Resque"
---

[Resque](https://github.com/resque/resque) is a Redis-backed Ruby library for creating background jobs, placing them on multiple queues, and processing them later.

-> Support for Resque was added in AppSignal for Ruby gem version `0.8`.

## Table of Contents

- [Integration](#integration)
- [Resque with ActiveJob](#resque-with-activejob)
- [Example apps](#example-apps)

## Integration

To enable instrumentation for Resque jobs you need to load in the AppSignal Resque plugin in your job classes. AppSignal will then start monitoring these jobs without further configuration.

```ruby
class MyWorker
  # Add the following line:
  extend Appsignal::Integrations::ResquePlugin

  def self.perform(*args)
    # ...
  end
end
```

## Resque with ActiveJob

When using ActiveJob, include `Appsignal::Integrations::ResqueActiveJobPlugin` instead. AppSignal will then start monitoring these jobs without further configuration.

```ruby
class MyActiveJobWorker < ApplicationJob
  # Add the following line:
  include Appsignal::Integrations::ResqueActiveJobPlugin

  queue_as :default

  def perform(*args)
    # ...
  end
end
```

## Example apps

We've added a Rails 5 + Resque [example app](https://github.com/appsignal/appsignal-examples/tree/rails-5+resque) to our [examples repository](https://github.com/appsignal/appsignal-examples). Please take a look if you're having trouble getting AppSignal for Resque configured.
