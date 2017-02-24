---
title: "Ignore errors"
---

Sometimes an error is raised which AppSignal shouldn't send alert about. It's
not desired to capture an exception with a `try..rescue` block just to
prevent AppSignal from alerting you. Instead, the exception should be handled
by the framework the application is using.

To prevent AppSignal from picking up these errors and alerting you, you can add
exceptions that you want to ignore to the list of ignored errors in your
configuration.

```elixir
# config/appsignal.exs
use Mix.Config

config :appsignal, :config,
  name: "appsignal_phoenix_example",
  push_api_key: "00000000-0000-0000-0000-000000000000",
  ignore_errors: ["VerySpecificError", "AnotherError"]
```

You can also configure ignore exceptions via an environment variable.

```bash
export APPSIGNAL_IGNORE_ERRORS="VerySpecificError,AnotherError"
```

Any exceptions defined here will not be sent to AppSignal and will not trigger
a notification.

Read more about [Exception
handling](/elixir/instrumentation/exception-handling.html).
