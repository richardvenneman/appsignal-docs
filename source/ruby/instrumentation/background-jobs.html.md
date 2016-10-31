---
title: "Custom instrumentation for background jobs"
---

While we only support Resque, Sidekiq and Delayed Job right now, it's not very difficult to monitor other background processors. For custom monitoring of processors we need to do four things.

* Start a transaction
* Add instrumentation
* Catch exceptions
* Close the transaction

### Start a transaction

A transaction needs an unique id and the environment hash, you can use your background processor's id for that, or generate your own id with `SecureRandom.uuid`

``` ruby
transaction = Appsignal::Transaction.create(
  SecureRandom.uuid,
  Appsignal::Transaction::BACKGROUND_JOB,
  {}
)
```

### Add instrumentation

The gem differentiates background jobs from web requests by listening to certain instrumentation messages. At the minimum we need at least one message with the fields below. Any other instrumentation message (database calls etc.) will also be added to the transaction, so you can view them in the AppSignal interface.

| Parameter | Description|
| ------ | ------ |
| A name that starts with `perform_job` | This is used to differentiate web requests from background jobs |
| class | The classname that is called in the background job |
| method | The method that is called in the background job |
| queue_time (Float) | Time between the moment a job is placed in the queue and the execution time ***as a float*** |
| queue (optional) | Queue name |
| attempts (optional) | Number of attempts / retries |

For example:

``` ruby
ActiveSupport::Notifications.instrument(
  'perform_job.sidekiq',
  :class => item['class'],
  :method => 'perform',
  :attempts => item['retry_count'],
  :queue => item['queue'],
  :queue_time => (Time.now.to_f - item['enqueued_at'].to_f) * 1000
) do
  yield
end

```

### Catch exceptions

Listen for, and catch exceptions in a background job and add them to the current transaction.
Optionally filter out ignored exceptions (these can be set in the config).

```ruby
transaction = Appsignal::Transaction.create(SecureRandom.uuid, Appsignal::Transaction::BACKGROUND_JOB,{})
transaction.add_exception(exception)
```

Example:

``` ruby
transaction = Appsignal::Transaction.create(SecureRandom.uuid, Appsignal::Transaction::BACKGROUND_JOB,{})
begin
  # Do stuff
rescue Exception => exception
  transaction.add_exception(exception)
  raise exception
end
```

TODO: add `Appsignal::Transaction.is_ignored_exception` to this

### Close the transaction

At the end of a job, close the transaction so it can be sent to AppSignal.

``` ruby
transaction = Appsignal::Transaction.create(SecureRandom.uuid, Appsignal::Transaction::BACKGROUND_JOB,{})
transaction.complete
```


### A full example (1)
A custom instrumented rake task

```ruby
namespace :myproject do
  task bake_bread: :environment do
    # Create a transaction
    transaction = Appsignal::Transaction.create(SecureRandom.uuid,
                                                  Appsignal::Transaction::BACKGROUND_JOB,
                                                  ENV.to_hash)
    ActiveSupport::Notifications.instrument(
      'perform_job.some_name_for_this',
      :class => 'Foo',
      :method => 'bar'
    ) do

      begin
        # Do stuff
        Foo.bar
      rescue Exception => exception
        transaction.add_exception(exception)
        raise exception
      ensure
        transaction.complete
      end
    end
  end
end
```



### A full example (2)
A full example from the Sidekiq implementation (note: does not work with v1.1.2)

``` ruby
def call(worker, item, queue)
  Appsignal::Transaction.create(SecureRandom.uuid, Appsignal::Transaction::BACKGROUND_JOB, ENV.to_hash)

  ActiveSupport::Notifications.instrument(
    'perform_job.sidekiq',
    :class => item['class'],
    :method => 'perform',
    :attempts => item['retry_count'],
    :queue => item['queue'],
    :queue_time => (Time.now.to_f - item['enqueued_at'].to_f) * 1000
  ) do
    yield
  end
rescue Exception => exception
  unless Appsignal.is_ignored_exception?(exception)
    Appsignal::Transaction.current.add_exception(exception)
  end
  raise exception
ensure
  Appsignal::Transaction.current.complete
end
```
