---
title: "Ignore errors"
---

Sometimes an error is raised which AppSignal shouldn't send alert about. It's
not desired to capture an exception with a `begin..rescue` block just to
prevent AppSignal from alerting you. Instead, the exception should be handled
by the framework the application is using.

To prevent AppSignal from picking up these errors and alerting you, you can add
exceptions that you want to ignore to the list of ignored errors in your
configuration.

```yaml
# config/appsignal.yml
default: &defaults
  ignore_errors:
    - ActiveRecord::RecordNotFound
    - ActionController::RoutingError
```

You can also configure ignore exceptions via an environment variable.

```bash
export APPSIGNAL_IGNORE_ERRORS="ActiveRecord::RecordNotFound,ActionController::RoutingError"
```

Any exceptions defined here will not be sent to AppSignal and will not trigger
a notification.

Read more about [Exception
handling](/ruby/instrumentation/exception-handling.html).
