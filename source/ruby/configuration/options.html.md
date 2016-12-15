---
title: "Ruby gem configuration options"
---

The following list includes all configuration options with the name of the
environment variable and the name of the key in the configuration file.

### `APPSIGNAL_ACTIVE` / `:active`

- Available since gem version `0.3.0`.
- Environment option available since gem version `0.11.6`.
- Value: Boolean `true`/`false`. Default: `false`

Whether AppSignal is active for this environment, can be `true` or `false`.

When the
[`APPSIGNAL_PUSH_API_KEY`](#code-appsignal_push_api_endpoint-code-code-endpoint-code)
environment variable is set, this defaults to `true`.

### `APPSIGNAL_APP_ENV`

- Available since gem version `0.11.8` for Rails.
- Available since gem version `1.3.0` for Padrino.
- Available since gem version `1.3.6` for Sinatra.
- Available since gem version `2.1.0` standardizes the behavior for all config.
- Value: String

This overrides the app's environment. Mostly used on Heroku where all apps run
the `production` environment by default. This setting allows an override to set
it to `staging` for example.

### `APPSIGNAL_APP_NAME` / `:name`

- Available since gem version `1.0.0`.
- Value: String

This app's display name. If you use  Rails the gem will auto-detect the name
and you can leave this empty. For other frameworks setting this is mandatory.

### `APPSIGNAL_CA_FILE_PATH` / `:ca_file_path`

- Available since gem version `1.3.5`.
- Value: String. Default: gem packaged `cacert.pem` file path.

Configure the path of the SSL certificate file. Default points to the AppSignal
gem [vendored `cacert.pem`
file](https://github.com/appsignal/appsignal-ruby/blob/4eed259e122d10df66655098ad0aa8a362f3297d/resources/cacert.pem)
in the gem itself. Use this option to point to another certificate file if
there's a problem connecting to our API.

### `APPSIGNAL_DEBUG` / `:debug`

- Available since gem version `1.0.0`.
- Value: Boolean `true`/`false`. Default: `false`

Enable debug logging, this is usually only needed on request from support.

### `APPSIGNAL_LOG` / `:log`

- Available since gem version `2.0.0`.
- Value: String. Default: `file`

Select which logger to the AppSignal agent should use. Accepted values are
`file` and `stdout`. See also the `log_path` configuration.

- `file` (default)
  - Write all AppSignal logs to the file system.
- `stdout` (default on Heroku)
  - Print AppSignal logs in the parent process' STDOUT instead of to a file.
    Useful with hosting solutions such as container systems and Heroku.

-> At this time only the Ruby agent supports this feature and the system agent
   which is used by the Ruby agent does not yet support this.

### `APPSIGNAL_LOG_PATH` / `:log_path`

- Available since gem version `1.0.0`.
- Value: String. Default: `./log`

Override the location of the path where the appsignal log file can be written
to.

### `APPSIGNAL_ENABLE_ALLOCATION_TRACKING` / `:enable_allocation_tracking`

- Available since gem version `1.0.0`.
- Value: Boolean `true`/`false`. Default: `true`

Set this to `false` to disable tracking of the number of allocated objects in
Ruby.

### `APPSIGNAL_ENABLE_FRONTEND_ERROR_CATCHING` / `:enable_frontend_error_catching`

- Available since gem version `1.0.0`.
- Value: Boolean `true`/`false`. Default: `false`

Enable the experimental frontend error catching system. This will add a route
to your app on `/appsignal_error_catcher` that can be used to catch JavaScript
error and send them to AppSignal. You can configure this route with
`APPSIGNAL_FRONTEND_ERROR_CATCHING_PATH` or `:frontend_error_catching_path`.

### `APPSIGNAL_ENABLE_GC_INSTRUMENTATION` / `:enable_gc_instrumentation`

- Available since gem version `1.0.0`.
- Value: Boolean `true`/`false`. Default: `false`

Set this to `false` to disable garbage collection instrumentation.

### `APPSIGNAL_ENABLE_HOST_METRICS` / `:enable_host_metrics`

- Available since gem version `1.2.0`.
- Value: Boolean `true`/`false`. Default: `true`

Set this to `false` to disable [host metrics](/metrics/host.html).

### `APPSIGNAL_PUSH_API_ENDPOINT` / `:endpoint`

- Available since gem version `0.1.0`.
- Environment variable available since gem version `1.0.0`.
- Value: String. Default: `https://push.appsignal.com`

Configure the endpoint to send data to AppSignal.

### `APPSIGNAL_FILTER_PARAMETERS` / `:filter_parameters`

- Available since gem version `1.3.0`.
- Value: Array<String>. Default: `[]`

List of parameter keys that should be ignored using AppSignal filtering. Their
values will be replaced with `FILTERED` when transmitted to AppSignal. You can
configure this with a list of keys in the configuration file:

Read more about [parameter
filtering](/ruby/configuration/parameter-filtering.html).

### `APPSIGNAL_HOSTNAME` / `:hostname`

- Available since gem version `1.3.6`.
- Value: String. Default: detected from system.

This overrides the server's hostname. Useful for when you're unable to set a
custom hostname or when a nondescript id is generated for you on hosting
services.

### `APPSIGNAL_HTTP_PROXY` / `:http_proxy`

- Available since gem version `0.11.13`.
- Value: String. Default: `""`.

If you require the agent to connect to the Internet via a proxy set the
complete proxy URL in this configuration key.

### `APPSIGNAL_IGNORE_ACTIONS` / `:ignore_actions`

- Available since gem version `0.10.0`.
- Value: Array<String>. Default: `[]`.

List of actions that will be ignored, everything that happens including
exceptions will not be transmitted to AppSignal.

Read more about [ignoring actions](/ruby/configuration/ignore-actions.html).

### `APPSIGNAL_IGNORE_ERRORS` / `:ignore_errors`

- Available since gem version `0.1.0`.
- Value: Array<String>. Default: `[]`.

List of error classes that will be ignored. Any exception raised with this
error class will not be transmitted to AppSignal. Read more about [ignoring
errors](/ruby/configuration/ignore-errors.html).

### `APPSIGNAL_INSTRUMENT_NET_HTTP`/ `:instrument_net_http`

- Available since gem version `0.9.0`.
- Value: Boolean `true`/`false`. Default: `true`

Whether to add instrumentation for `net/http` calls, can be `true` or `false`.
Default is `true`.

### `APPSIGNAL_INSTRUMENT_REDIS`/ `:instrument_redis`

- Available since gem version `1.0.0`.
- Value: Boolean `true`/`false`. Default: `true`

Whether to add instrumentation for `redis` queries using the [Redis
gem](https://github.com/redis/redis-rb), can be `true` or `false`. Default is
`true`.

### `APPSIGNAL_INSTRUMENT_SEQUEL`/ `:instrument_sequel`

- Available since gem version `1.0.0`.
- Value: Boolean `true`/`false`. Default: `true`

Whether to add instrumentation for `sequel` queries using the [Sequel
gem](http://sequel.jeremyevans.net/), can be `true` or `false`. Default is
`true`.

### `APPSIGNAL_PUSH_API_KEY` / `:push_api_key`

- Available since gem version `0.1.0`.
- Value: String. Default: `""`

The key to authenticate with our push API.

Read more about the [AppSignal Push API
key](/appsignal/terminology.html#push-api-key).

### `APPSIGNAL_RUNNING_IN_CONTAINER` / `:running_in_container`

- Available since gem version `1.0.0`.
- Value: Boolean `true`/`false`. Default: detected by Ruby gem.

AppSignal expects to be running on the same machine between different deploys.
Set this key to `true` if you use a container based deployment system such as
Docker.

Since appsignal gem version 2.0 this setting is automatically detected and no
manual configuration is necessary. If you're having trouble with the automatic
detection, please [contact support](mailto:support@appsignal.com).

### `APPSIGNAL_SEND_PARAMS` / `:send_params`

- Available since gem version `0.9.0`.
- The environment variable option is available since gem version `1.3.0`.
- Value: Boolean `true`/`false`. Default: `true`

Whether to skip sending request parameters to AppSignal.

For more information please read about
[send_params](/ruby/configuration/parameter-filtering.html#filter-all-parameters)
in filtering request parameters.

### `APPSIGNAL_SKIP_SESSION_DATA` / `:skip_session_data`

- Available since gem version `0.11.0`.
- Value: Boolean `true`/`false`. Default: `false`

Whether to skip adding session data to exception traces, can be `true` or
`false`. Default is `false`.

### `APPSIGNAL_WORKING_DIR_PATH` / `:working_dir_path`

- Available since gem version `1.0.4`.
- Value: String. Default: detected by Ruby gem.

Override the location where the appsignal Ruby gem can store temporary files.
Use this is if the default location is not suitable.
