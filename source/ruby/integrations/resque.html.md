---
title: "Resque"
---

[Resque](https://github.com/resque/resque) is a Redis-backed Ruby library for creating background jobs, placing them on multiple queues, and processing them later.

Support for Resque was added in AppSignal Ruby gem version `0.8`.

To enable instrumentation for Resque jobs you need to load in the AppSignal Resque plugin in your job classes.

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

When using ActiveJob, include `Appsignal::Integrations::ResqueActiveJobPlugin` instead:

```ruby
class BrokenJob < ApplicationJob
  # Add the following line:
  include Appsignal::Integrations::ResqueActiveJobPlugin

  queue_as :default

  def perform(*args)
    # ...
  end
end
```

AppSignal will then start monitoring these jobs without further configuration.
