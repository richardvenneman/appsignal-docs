---
title: "AppSignal configuration"
---

The AppSignal gem can be configured with a configuration file or through environment variables. The default location for the config file
is `config/appsignal.yml`. If you follow the installation wizard in the app one will be created by default.

The following list includes all configuration options with the name of the environment variable and the name of the key in the config file.

## `APPSIGNAL_ACTIVE` / `:active`
Whether AppSignal is active for this environment, can be `true` or `false`.

## `APPSIGNAL_RUNNING_IN_CONTAINER` / `:running_in_container`
By default AppSignal expects to be running on the same machine between different deploys. Set this key to `true` if you use a container based deployment system
such as Docker.

## `APPSIGNAL_PUSH_API_KEY` / `:push_api_key`
The key to authenticate with our push API.

## `APPSIGNAL_APP_NAME` / `:name`
This app's display name. If you use  Rails the gem will auto-detect the name and you can leave this empty. For other frameworks setting this is mandatory.

## `APPSIGNAL_APP_ENV`
This overrides the app's environment. Mostly used on Heroku where all apps run the `production` environment by default. This setting allows an override to set it to `staging` for example.

## `APPSIGNAL_HOSTNAME` / `:hostname` (since version 1.3)

This overrides the server's hostname. Useful for when you're unable to set a custom hostname or when a nondescript id is generated for you on hosting services.

<a id="config-filter_parameters"></a>
## [`APPSIGNAL_FILTER_PARAMETERS` / `:filter_parameters` (since version 1.3)](#config-filter_parameters)

List of parameter keys that should be ignored, their values will be replaced with `FILTERED` when transmitted to AppSignal. You can configure this with a list of keys in the config file:

```yml
filter_parameters:
  - password
  - confirm_password
```

Or by setting the environment variable like this:

```bash
export APPSIGNAL_FILTER_PARAMETERS="password,confirm_password"
```

## `APPSIGNAL_DEBUG` / `:debug`
Enable debug logging, this is usually only needed on request from support. Default is `false`.

## `APPSIGNAL_LOG_PATH` / `:log_path`
Override the location of the path where the appsignal log file can be written to.

## `APPSIGNAL_WORKING_DIR_PATH` / `:working_dir_path`
Override the location where appsignal can store temporary files. Use
this is if the default location is not suitable.

## `APPSIGNAL_INSTRUMENT_NET_HTTP`/ `:instrument_net_http`

Whether to add instrumentation for `net/http` calls, can be `true` or `false`. Default is `true`.

## `APPSIGNAL_SKIP_SESSION_DATA` / `:skip_session_data`

Whether to skip adding session data to exception traces, can be `true` or `false`. Default is `false`.

## `APPSIGNAL_ENABLE_FRONTEND_ERROR_CATCHING` / `:enable_frontend_error_catching`

Enable the experimental frontend error catching system. This will add a route to your app on `/appsignal_error_catcher` that can be used to
catch JavaScript error and send them to AppSignal. You can configure this route with `APPSIGNAL_FRONTEND_ERROR_CATCHING_PATH` or `:frontend_error_catching_path`.

This configuration key can be `true` or `false`. Default is `false`.

## `APPSIGNAL_IGNORE_ERRORS` / `:ignore_errors`

List of classes that should be ignored, they will not be transmitted to AppSignal. You can configure this with a list of errors in the config file:

```yml
ignore_errors:
  - SystemExit
  - ActiveRecord::NotFound
```

Or by setting the environment variable like this:

```bash
export APPSIGNAL_IGNORE_ERRORS="SystemExit,ActiveRecord::NotFound"
```

## `APPSIGNAL_IGNORE_ACTIONS` / `:ignore_actions`

List of actions that should be ignored, everything that happens including exceptions will not be transmitted to AppSignal.
You can configure this with a list of errors in the config file:

```yml
ignore_actions:
  - ApplicationController#isup
  - SecondController#healthcheck
```

Or by setting the environment variable like this:

```bash
export APPSIGNAL_IGNORE_ACTIONS="ApplicationController#isup,SecondController#healthcheck"
```

See [ignore actions](/gem-settings/ignore-actions.html) for details.

## `APPSIGNAL_HTTP_PROXY` / `:http_proxy`

If you require the agent to connect to the Internet via a proxy set the complete proxy URL in this config key.

The minimum configuration to activate AppSignal via environment variables is:

## `APPSIGNAL_ENABLE_ALLOCATION_TRACKING` / `:enable_allocation_tracking`
Set this to `false` to disable tracking of the number of allocated objects in Ruby.

## `APPSIGNAL_ENABLE_GC_INSTRUMENTATION` / `:enable_gc_instrumentation`
Set this to `false` to disable garbage collection instrumentation.

```bash
export APPSIGNAL_PUSH_API_KEY=1234-1234-1234
export APPSIGNAL_APP_NAME=App name
```

All other configuration is optional. If you use Rails you can even skip the app name, we will use the name of your Rails application.


Here's an example of an `appsignal.yml` config file with all options:

```yaml
default: &defaults
  # Your push api key, it is possible to set this dynamically using ERB:
  # push_api_key: "<%= ENV['APPSIGNAL_PUSH_API_KEY'] %>"
  push_api_key: "65c91e2f-c0f2-4005-8064-ffffec5f7b20"

  # Enable when using docker, by default AppSignal will keep running
  # this prevents docker containers from shutting down. Enabling this feature
  # stops AppSignal when there are no more connections open.
  running_in_container: false

  # Your app's name
  name: "AppSignal"

  # Your server's hostname
  hostname: "frontend1.myapp.com"

  # The cuttoff point in ms above which a request is considered slow,
  # default is 200.
  slow_request_threshold: 200

  # Add default instrumentation of net/http
  instrument_net_http: true

  # Enable (beta) version of our frontend error catcher.
  enable_frontend_error_catching: true

  # Skip session data, it contains private information.
  skip_session_data: true

  # Ignore these errors.
  ignore_errors:
    - SystemExit

  # Ignore these actions, used by our Loadbalancer.
  ignore_actions:
    - IsUpController#index

  # Enable allocation tracking for memory metrics:
  enable_allocation_tracking: true

  # Enable Garbage Collection instrumentation
  enable_gc_instrumentation: true

# Configuration per environment, leave out an environment or set active
# to false to not push metrics for that environment.
development:
  <<: *defaults
  active: true
  debug: true

staging:
  <<: *defaults
  active: <%= ENV['APPSIGNAL_ENABLED'] == 'true' %>

production:
  <<: *defaults
  active: <%= ENV['APPSIGNAL_ENABLED'] == 'true' %>

  # Set different path for log
  log_path: '/home/my_app/app/shared/log'

  # Set AppSignal working dir
  working_dir_path: '/tmp/appsignal'

  # We can't connect to the outside world without this proxy
  http_proxy: 'proxy.mydomain.com:8080'
```
