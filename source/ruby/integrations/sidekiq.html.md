---
title: "Sidekiq"
---

[Sidekiq](http://sidekiq.org) is a simple and efficient background processor
for Ruby. It's also the processor we use to process jobs in AppSignal.

Support for Sidekiq was added in AppSignal Ruby gem version `0.8`.

The AppSignal Ruby gem automatically inserts a listener into the Sidekiq server
middleware stack if the `Sidekiq` module is present. No further action is
required.
