
## Custom monitoring

While we only support Resque, Sidekiq and Delayed Job right now, it's not very difficult to monitor other background processors. For custom monitoring of processors we need to do four things.

* Start a transaction
* Add instrumentation
* Catch exceptions
* Close the transaction

### Start a transaction

A transaction needs an unique id and the environment hash, you can use your background processor's id for that, or generate your own id with `SecureRandom.uuid`

``` ruby
  Appsignal::Transaction.create(SecureRandom.uuid, ENV.to_hash)
```

### Add instrumentation

The gem differentiates background jobs from web requests by listening to certain instrumentation messages. At the mimimum we need at least one message with the fields below. Any other instrumentation message (database calls etc.) will also be added to the transaction, so you can view them in the AppSignal interface.

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

`Appsignal::Transaction.current.add_exception(exception)`

Example:

``` ruby
begin
  # Do stuff
rescue Exception => exception
  unless Appsignal.is_ignored_exception?(exception)
    Appsignal::Transaction.current.add_exception(exception)
  end
  raise exception
end
```

### Close the transaction

At the end of a job, close the transaction so it can be sent to AppSignal.

``` ruby
Appsignal::Transaction.current.complete!
```

A full example from the Sidekiq implemenation:

``` ruby
def call(worker, item, queue)
  Appsignal::Transaction.create(SecureRandom.uuid, ENV.to_hash)

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
  Appsignal::Transaction.current.complete!
end
```
