---
title: "AppSignal Ruby configuration"
---

Configuration. Important, because without it the AppSignal Ruby gem won't
know which application it's instrumenting or in which environment.

In this topic we'll explain how to configure AppSignal, what can be configured
in the Ruby gem, what's the minimal configuration needed and how the
configuration is loaded.

## Table of Contents

- [Minimal required configuration](#minimal-required-configuration)
- [Configuration options](/ruby/configuration/options.html)
  - [Ignore actions](/ruby/configuration/ignore-actions.html)
  - [Ignore errors](/ruby/configuration/ignore-errors.html)
  - [Parameter filtering](/ruby/configuration/parameter-filtering.html)
- [Configuration load order](/ruby/configuration/load-order.html)
- [Example configuration file](#example-configuration-file)

## Minimal required configuration

```yaml
# config/appsignal.yml
production:
  active: true
  push_api_key: "1234-1234-1234"
  name: "My app"
```

```bash
# Environment variables
export APPSIGNAL_PUSH_API_KEY="1234-1234-1234"
export APPSIGNAL_APP_NAME="My app"
export APPSIGNAL_APP_ENV="production"
```

The above configuration options are the only required options. All other
configuration is optional.

If you use Rails you can even skip the app name, we will use the name of your
Rails application.

If you use a framework that is aware of environments and [is supported by the
AppSignal gem](/ruby/integrations/index.html), the environment is detected
automatically.

## Example configuration file

Here's an example of an `appsignal.yml` configuration file. It's recommended
you only add the configuration you need to your configuration file.

For the full list of options, please see the [configuration
options](/ruby/configuration/options.html) page.

```yaml
# config/appsignal.yml
default: &defaults
  # Your push api key, it is possible to set this dynamically using ERB:
  # push_api_key: "<%= ENV['APPSIGNAL_PUSH_API_KEY'] %>"
  push_api_key: "65c91e2f-c0f2-4005-8064-ffffec5f7b20"

  # Your app's name
  name: "My App"

  # Your server's hostname
  hostname: "frontend1.myapp.com"

  # Add default instrumentation of net/http
  instrument_net_http: true

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
  active: <%= ENV['APPSIGNAL_ACTIVE'] == 'true' %>

production:
  <<: *defaults
  active: <%= ENV['APPSIGNAL_ACTIVE'] == 'true' %>

  # Set different path for the log file
  log_path: '/home/my_app/app/shared/log'

  # Set AppSignal working dir
  working_dir_path: '/tmp/appsignal'

  # When it's not possible to connect to the outside world without a proxy
  http_proxy: 'proxy.mydomain.com:8080'
```
