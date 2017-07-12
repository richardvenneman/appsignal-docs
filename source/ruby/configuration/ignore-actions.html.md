---
title: "Ignore actions"
---

Sometimes you have a certain action (web or background) that you don't need to log to AppSignal. The most common use case is an action that your load balancer uses to check if your app is still responding.

You can ignore these actions from being sent to AppSignal in the Ruby gem configuration. This works both for controller actions and for background workers. The action names listed should match with the action names that are reported in your app in the AppSignal.com UI.

```yaml
default: &defaults
  ignore_actions:
    - "ApplicationController#is_up"
    - "MyBackgroundWorker#perform"
```

If you use Sinatra use the HTTP method and path you used to specify your route, for example:

```yaml
default: &defaults
  ignore_actions:
    - "GET /pages/:id"
    - "POST /pages/create"
```

You can also configure ignore actions via an environment variable.

```bash
export APPSIGNAL_IGNORE_ACTIONS="ApplicationController#is_up,MyBackgroundWorker#perform"
```
