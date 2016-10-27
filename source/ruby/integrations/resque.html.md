---
title: "Monitor background jobs"
---

Starting with AppSignal gem version 8.0 or higher we monitor Sidekiq and Delayed Job. We've also added a few hooks to create your own background monitoring for other tools.

## Resque

[Resque](https://github.com/resque/resque) Resque is a Redis-backed Ruby library for creating background jobs, placing them on multiple queues, and processing them later.

The AppSignal gem extends the default job class (`Resque::Job`) if it is present. If your jobs inherit from this class no further action is required.
If your jobs do not inherit from `Resque::Job` you need to add this line to your job classes:

```ruby
extend Appsignal::Integrations::ResquePlugin
```

AppSignal will then start monitoring these jobs without further configuration.

