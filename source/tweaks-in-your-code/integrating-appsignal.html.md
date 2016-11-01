---
title: "Integrating AppSignal"
---

It is possible to integrate AppSignal with a tool we don't support yet or if you have custom code you want to monitor. AppSignal needs to be configured and
started once at the beginning of your process. You can either configure it via a config file, or via the environment variables described earlier. If you use
environment variables just call:

```ruby
Appsignal.start
```

Make sure that at least `APPSIGNAL_PUSH_API_KEY` and `APPSIGNAL_APP_NAME` are filled out.

If you use a config file, you need to initialize the config:

```ruby
Appsignal.config = Appsignal::Config.new(
  current_path,
  'production'
)
Appsignal.start
```

The path you pass as the first argument should point to a path that contains a `config` directory containing an `appsignal.yml` file.

After this AppSignal will be initialized and ready to monitor. You can use [custom metrics](/getting-started/custom-metrics.html). And monitor
transactions by wrapping you transactions in a block like this:

```ruby
Appsignal.monitor_transaction(
  'perform_job.processor',
  :class       => 'EmailWorker',
  :method      => 'perform',
  :metadata    => {},
  :params      => {},
  :queue_start => time
) do
  yield
end
```

If the first argument starts with `perform_job` this will be treated as a background job, if it starts with `perform_action` it will be treated as an
HTTP request.

Before your process exits you should call `Appsignal.stop` to make sure that all data gets flushed to the agent before your process exits. If your process
always runs one job and then exits you can use the `Appsignal.monitor_single_transaction` helper, this will ensure that this happens too.
