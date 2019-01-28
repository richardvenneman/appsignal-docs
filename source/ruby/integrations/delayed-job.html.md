---
title: "Delayed Job"
---

[Delayed Job](https://github.com/collectiveidea/delayed_job) is created by the excellent folks at [Shopify](https://shopifyengineering.myshopify.com/) and one of the most popular background processors for Ruby and Rails.

The AppSignal gem detects Delayed Job when it's present and hooks into the standard Delayed Job callbacks. No further action is required to enable integration.

## Procs as Jobs with `display_name`

Delayed Job allows any class that responds to `perform` to be queued and processed.

If you use Procs with a perform method and `display_name` that doesn't return the default 'ClassName#method_name' format, AppSignal treats each Job as a separate entity, creating many Incidents and notifications.

To counter this, define an `appsignal_name` method that returns the correct value, this way the Jobs will be grouped correctly.

### Example

```ruby
class StructJobWithName < Struct.new(:id)
  def perform
    true
  end

  # This wil generate a new incident and graphs for each unique name.
  def display_name
    "StructJobWithName-#{id}"
  end

  # This will group the jobs back to a single entity, allowing incidents
  # and graphs to work properly.
  def appsignal_name
    "StructJobWithName#perform"
  end
end
```

## Changes to the integration

### Queue time

In AppSignal for Ruby gem 2.3.0 a change was made to the queue time registration. In [PR #297](https://github.com/appsignal/appsignal-ruby/pull/297) the start time of the job was used rather than the creation time of the job.

This means that the time from when a job was created until the time it should start is no longer registered as queue time. This will prevent very long queue times from skewing the queue time graphs on AppSignal.com.
