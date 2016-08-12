---
title: "Monitor background jobs"
---

Starting with AppSignal gem version 8.0 or higher we monitor Sidekiq and Delayed Job. We've also added a few hooks to create your own background monitoring for other tools.


## Delayed Job

[Delayed Job](https://github.com/collectiveidea/delayed_job) is created by the excellent folks at Shopify and one of the most popular background processors for Ruby/Rails.

The AppSignal gem has a sidekiq plugin that detects Delayed Job and hooks into the standard Delayed Job callbacks. No further action is required.


## Procs as Jobs with `display_name`

Delayed Job allows any class that responds to `perform` to be queued and processed.

If you use Procs with a perform method and `display_name` that doesn't return the default 'ClassName#method_name' format, AppSignal treats each Job as a separate entity, creating many Incidents and notifications.

To counter this, define an `appsignal_name` method that returns the correct value, this way the Jobs will be grouped correctly.

An example:

```ruby
class StructJobWithName < Struct.new(:id)

  def perform
    return true
  end

  # This wil generate a new incident and graphs for each unique name.
  def display_name
    return "StructJobWithName-#{id}"
  end

  # This will group the jobs back to a single entity, allowing incidents
  # and graphs to work properly.
  def appsignal_name
    "StructJobWithName#perform"
  end

end
```
