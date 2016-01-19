---
title: "Monitor background jobs"
---

Starting with AppSignal gem version 8.0 or higher we monitor Sidekiq and Delayed Job. We've also added a few hooks to create your own background monitoring for other tools.

## Sidekiq

[Sidekiq](http://sidekiq.org) is a simple and efficient background processor for Ruby. It's also the processor we use to process jobs in AppSignal.

The AppSignal gem inserts a listener into the Sidekiq server middlware stack if the `Sidekiq` module is present. No further action is required.

