---
title: "Ignore actions"
---

Sometimes you have a certain action that you don't need to log to AppSignal.
The most common use case is an action that your load balancer uses to check if
your app is still responding.

You can ignore these actions from being sent to AppSignal in the integration config.
This works both for controller and for background jobs.

```elixir
# config/appsignal.exs
use Mix.Config

config :appsignal, :config,
  name: "appsignal_phoenix_example",
  push_api_key: "00000000-0000-0000-0000-000000000000",
  ignore_actions: ["PingController#is_up", "SecondController#healthcheck"]
```

You can also configure ignore actions via an environment variable.

```bash
export APPSIGNAL_IGNORE_ACTIONS="PingController#is_up,SecondController#healthcheck"
```
