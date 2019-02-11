---
title: "Ignore errors"
---

Sometimes an error is raised which AppSignal shouldn't send an alert about. It's not desired to capture an exception with a `begin..rescue` block just to prevent AppSignal from alerting you. Instead, the exception should be handled by the framework the application is using.

To prevent AppSignal from picking up these errors and alerting you, you can add exceptions that you want to ignore to the list of ignored errors in your configuration.

More information about the [`ignore_errors`](/ruby/configuration/options.html#option-ignore_errors) configuration option.

```yaml
# config/appsignal.yml
default: &defaults
  ignore_errors:
    - ActiveRecord::RecordNotFound
    - ActionController::RoutingError
```

**Note:** Names set in `ignore_errors` will be matched on String basis and not class inheritance. If you want to match all subclasses of a certain Exception they have to be listed separately.

You can also configure ignore exceptions via an environment variable.

```bash
export APPSIGNAL_IGNORE_ERRORS="ActiveRecord::RecordNotFound,ActionController::RoutingError"
```

Any exceptions defined here will not be sent to AppSignal and will not trigger a notification.

Read more about [Exception handling with AppSignal](/ruby/instrumentation/exception-handling.html).
And read more about `Exception` in the [official Ruby documentation](http://ruby-doc.org/core-2.4.2/Exception.html).
