---
title: "Ignore actions"
---

Sometimes you have a certain action that you don't need to log to AppSignal. The most common use case is an action that your loadbalancer uses to check if your app is still responding.

You can ignore these actions from being sent to AppSignal in the gem config. This works both for controller and for background jobs.

```yml
default: &defaults
  push_api_key: "<%= ENV['APPSIGNAL_PUSH_API_KEY'] %>"
  name: "Test"
  ignore_actions:
    - "ApplicationController#isup"
```


If you use Sinatra use the HTTP method and path you used to specify your route, for example:

```yml
default: &defaults
  ignore_actions:
    - "GET /pages/:id"
    - "POST /pages/create"
```

You can also configure ignore actions via the environment:

```bash
export APPSIGNAL_IGNORE_ACTIONS="ApplicationController#isup,SecondController#healthcheck"
```
