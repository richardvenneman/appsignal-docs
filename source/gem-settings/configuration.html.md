---
title: "AppSignal configuration"
---

There are several ways to configure the AppSignal gem. The most common are the
configuration file `apsignal.yml` and through environment variables.

On this page we'll explain what the minimal configuration is you need, how the
configuration is loaded, which options there are, and give some examples.

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
```

The above configuration options are the only required options. All other
configuration is optional.

If you use Rails you can even skip the app name, we will use the name of your
Rails application.

## How the configuration is loaded

The AppSignal gem can be configured in a couple different ways. Through an
initializer, with a configuration file or through environment variables.

-> In gem version 1.4 the load order changed! Step 4 and 5 were swapped, making
   sure that environment variables are loaded after the `appsignal.yml`
   configuration file. Read more about it in the [Pull Request on
   GitHub](https://github.com/appsignal/appsignal-ruby/pull/180).

The configuration is loaded in a five step process. Starting with the defaults
and ending with reading environment variables. The configuration options can be
mixed without losing configuration from a different option. Using an
initializer, a configuration file and environment variables together will work.

### 1. Agent defaults

The AppSignal gem starts with loading its default configuration, setting paths
and enables certain features.

The agent defaults can be found in the [gem source]
(https://github.com/appsignal/appsignal-ruby/blob/master/lib/appsignal/config.rb)
as `Appsignal::Config::DEFAULT_CONFIG`.

### 2. System detected settings

The gem detects what kind of system it's active in and configures itself
accordingly.

For example, when it's running inside a container based system (such as Docker
and Heroku) it sets `:running_in_container` to `true`.

### 3. Initial configuration given to `Config` initializer

When manually creating a `Appsignal::Config` class you can pass in the
initial configuration you want to apply. This is a hash of any of the
options described below.

```ruby
Appsignal.config = Appsignal::Config.new(Dir.pwd, "production", {
  active: true,
  name: "My app!",
  push_api_key: "e55f8e96-62df-4817-b672-d10c8d924065"
})
```

This step will override all given options from the defaults or system
detected configuration.

### 4. `appsignal.yml` config file

The most common way to configure your application is using the `appsignal.yml`
file. When you use the `appsignal install` command the gem will create on for
you.

The path of this configuration file is `{project_root}/config/appsignal.yml`.

This step will override all given options from the defaults, system
detected and initializer configuration.

### 5. Environment variables

Lastly AppSignal will look for its configuration in environment variables.
When found these will override all given configuration options from
previous steps.

## Configuration options

The following list includes all configuration options with the name of the
environment variable and the name of the key in the configuration file.

### `APPSIGNAL_ACTIVE` / `:active`

Whether AppSignal is active for this environment, can be `true` or `false`.

### `APPSIGNAL_RUNNING_IN_CONTAINER` / `:running_in_container`

AppSignal expects to be running on the same machine between different deploys.
Set this key to `true` if you use a container based deployment system such as
Docker.

Since appsignal gem version 2.0 this setting is automatically detected and no
manual configuration is necessary. If you're having trouble with the automatic
detection, please [contact support](mailto:support@appsignal.com).

### `APPSIGNAL_PUSH_API_KEY` / `:push_api_key`

The key to authenticate with our push API.

### `APPSIGNAL_APP_NAME` / `:name`

This app's display name. If you use  Rails the gem will auto-detect the name and you can leave this empty. For other frameworks setting this is mandatory.

### `APPSIGNAL_APP_ENV`

This overrides the app's environment. Mostly used on Heroku where all apps run the `production` environment by default. This setting allows an override to set it to `staging` for example.

### `APPSIGNAL_HOSTNAME` / `:hostname` (since version 1.3)

This overrides the server's hostname. Useful for when you're unable to set a custom hostname or when a nondescript id is generated for you on hosting services.

<a id="config-filter_parameters"></a>
### [`APPSIGNAL_FILTER_PARAMETERS` / `:filter_parameters` (since version 1.3)](#config-filter_parameters)

List of parameter keys that should be ignored, their values will be replaced with `FILTERED` when transmitted to AppSignal. You can configure this with a list of keys in the configuration file:

```yml
filter_parameters:
  - password
  - confirm_password
```

Or by setting the environment variable like this:

```bash
export APPSIGNAL_FILTER_PARAMETERS="password,confirm_password"
```

### `APPSIGNAL_DEBUG` / `:debug`

Enable debug logging, this is usually only needed on request from support. Default is `false`.

### `APPSIGNAL_LOG` / `:log` (since version 2.0)

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

Override the location of the path where the appsignal log file can be written to.

### `APPSIGNAL_WORKING_DIR_PATH` / `:working_dir_path`

Override the location where appsignal can store temporary files. Use
this is if the default location is not suitable.

### `APPSIGNAL_INSTRUMENT_NET_HTTP`/ `:instrument_net_http`

Whether to add instrumentation for `net/http` calls, can be `true` or `false`. Default is `true`.

### `APPSIGNAL_SEND_PARAMS` / `:send_params` (environment variable since version 1.3)

Whether to skip sending request parameters to AppSignal, can be `true` or `false`. Default is `false`.

For more information please read about [send_params](/tweaks-in-your-code/filter-parameter-logging.html#appsignal-send_params) in filtering request parameters.

### `APPSIGNAL_SKIP_SESSION_DATA` / `:skip_session_data`

Whether to skip adding session data to exception traces, can be `true` or `false`. Default is `false`.

### `APPSIGNAL_ENABLE_FRONTEND_ERROR_CATCHING` / `:enable_frontend_error_catching`

Enable the experimental frontend error catching system. This will add a route to your app on `/appsignal_error_catcher` that can be used to
catch JavaScript error and send them to AppSignal. You can configure this route with `APPSIGNAL_FRONTEND_ERROR_CATCHING_PATH` or `:frontend_error_catching_path`.

This configuration key can be `true` or `false`. Default is `false`.

### `APPSIGNAL_IGNORE_ERRORS` / `:ignore_errors`

List of classes that should be ignored, they will not be transmitted to AppSignal. You can configure this with a list of errors in the configuration file:

```yml
ignore_errors:
  - SystemExit
  - ActiveRecord::NotFound
```

Or by setting the environment variable like this:

```bash
export APPSIGNAL_IGNORE_ERRORS="SystemExit,ActiveRecord::NotFound"
```

### `APPSIGNAL_IGNORE_ACTIONS` / `:ignore_actions`

List of actions that should be ignored, everything that happens including exceptions will not be transmitted to AppSignal.
You can configure this with a list of errors in the configuration file:

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

### `APPSIGNAL_HTTP_PROXY` / `:http_proxy`

If you require the agent to connect to the Internet via a proxy set the complete proxy URL in this configuration key.

The minimum configuration to activate AppSignal via environment variables is:

### `APPSIGNAL_ENABLE_ALLOCATION_TRACKING` / `:enable_allocation_tracking`

Set this to `false` to disable tracking of the number of allocated objects in Ruby.

### `APPSIGNAL_ENABLE_GC_INSTRUMENTATION` / `:enable_gc_instrumentation`

Set this to `false` to disable garbage collection instrumentation.

## Example `appsignal.yml` configuration file

Here's an example of an `appsignal.yml` configuration file. It's recommended
you only add the configuration you need to your configuration file.

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
