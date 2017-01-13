---
title: "Instrumentation for background jobs"
---

While we support Resque, Sidekiq and Delayed Job out-of-the-box, it's not very
difficult to monitor other background processors. For custom monitoring of
processors we need to do four things.

1. Start a transaction
* Add instrumentation
* Catch exceptions
* Complete the transaction

## Start a transaction

A transaction needs an unique id and request details. You can use your
background processor's job id for the transaction id, or generate a custom id
with `SecureRandom.uuid`.

It's recommended you use `Appsignal::GenericRequest` to create a custom
"request" object. A request will contain metadata about the job and the
environment it was performed in.

```ruby
Appsignal::Transaction.create(
  SecureRandom.uuid,
  Appsignal::Transaction::BACKGROUND_JOB,
  Appsignal::Transaction::GenericRequest.new({})
)
```

The `Appsignal::Transaction.create` call returns a transaction object, however,
it's recommend you interface with the helper methods described further in this
document instead.

## Add instrumentation

The gem differentiates background jobs from web requests by listening to
certain instrumentation messages. At the minimum we need at least one message
with the fields below. Any other instrumentation message (database calls etc.)
will also be added to the transaction, so you can view them in the AppSignal
interface.

| Parameter | Type | Description|
| --------- | ---- | ---------- |
| `:name` | String | Instrumentation name that starts with `perform_job`. This is used to differentiate web requests from background jobs. |
| `:class` | String | The class name of the background job. |
| `:method` | String | The method of the background job that is called. |
| `:queue_time` | Float | Time between the moment a job is placed in the queue and the execution time. |
| `:queue` (optional) | String | The background job's queue name. |
| `:attempts` (optional) | Integer | The number of attempts / retries for this job. |

For example:

```ruby
Appsignal.instrument(
  'perform_job.sidekiq',
  :class => item['class'],
  :method => 'perform',
  :queue_time => (Time.now.to_f - item['enqueued_at'].to_f) * 1000,
  :queue => item['queue'],
  :attempts => item['retry_count']
) do
  yield
end
```

## Catch exceptions

By adding exception handling we can listen for, and catch exceptions, in a
background job and add them to the current AppSignal transaction.

Optionally it's possible to filter out ignored exceptions. This can be
configured in the
[configuration](/ruby/configuration/options.html#code-appsignal_ignore_errors-code-code-ignore_errors-code).

```ruby
Appsignal::Transaction.create(
  SecureRandom.uuid,
  Appsignal::Transaction::BACKGROUND_JOB,
  Appsignal::Transaction::GenericRequest.new({})
)
Appsignal.set_error(exception)
```

Example:

```ruby
Appsignal::Transaction.create(
  SecureRandom.uuid,
  Appsignal::Transaction::BACKGROUND_JOB,
  Appsignal::Transaction::GenericRequest.new({})
)
begin
  # Do stuff
rescue => exception
  Appsignal.set_error(exception)
  raise exception # Reraise to let the normal exception handling take over.
end
```

## Complete the transaction

At the end of a job, complete the transaction so it can be sent to AppSignal.

No more data can be added to this transaction. If more information needs to be
send a new transaction needs to be created first.

```ruby
Appsignal::Transaction.create(
  SecureRandom.uuid,
  Appsignal::Transaction::BACKGROUND_JOB,
  Appsignal::Transaction::GenericRequest.new({})
)

# Complete the transaction
Appsignal::Transaction.complete_current!
```

## Examples

### Custom instrumented Rake task

See this example in action in our [examples
repository](https://github.com/appsignal/appsignal-examples/tree/custom-background-job).

Note this is just an example and we provide [Rake
integration](/ruby/integrations/rake.html) out-of-the-box.

```ruby
namespace :my_project do
  task :bake_bread => :environment do
    # Create a transaction
    Appsignal::Transaction.create(
      SecureRandom.uuid,
      Appsignal::Transaction::BACKGROUND_JOB,
      Appsignal::Transaction::GenericRequest.new({})
    )

    # Add instrumentation
    Appsignal.instrument(
      'perform_job.some_name_for_this',
      :class => 'Foo',
      :method => 'bar'
    ) do
      begin
        # Do stuff
        Foo.bar
      rescue => exception
        # Catch exceptions
        Appsignal.set_error(exception)
        raise exception
      ensure
        # Complete transaction
        Appsignal::Transaction.complete_current!
      end
    end
  end
end
```

### Sidekiq implementation

A full example from the Sidekiq implementation (note: does not work with
v1.1.2).

```ruby
def call(worker, item, queue)
  Appsignal::Transaction.create(
    SecureRandom.uuid,
    Appsignal::Transaction::BACKGROUND_JOB,
    Appsignal::Transaction::GenericRequest.new({})
  )

  Appsignal.instrument(
    'perform_job.sidekiq',
    :class => item['class'],
    :method => 'perform',
    :attempts => item['retry_count'],
    :queue => item['queue'],
    :queue_time => (Time.now.to_f - item['enqueued_at'].to_f) * 1000
  ) do
    yield
  end
rescue => exception
  Appsignal.set_error(exception)
  raise exception
ensure
  Appsignal::Transaction.complete_current!
end
```
