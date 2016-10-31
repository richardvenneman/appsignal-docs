---
title: "Resque"
---

[Resque](https://github.com/resque/resque) Resque is a Redis-backed Ruby
library for creating background jobs, placing them on multiple queues, and
processing them later.

Support for Sidekiq was added in AppSignal Ruby gem version `0.8`.

The AppSignal Ruby gem extends the default job class (`Resque::Job`) if it is
present. If your jobs inherit from this class no further action is required.
If your jobs do not inherit from `Resque::Job` you need to add this line to
your job classes:

```ruby
extend Appsignal::Integrations::ResquePlugin
```

AppSignal will then start monitoring these jobs without further configuration.
