---
title: "AppSignal for Elixir load order"
---

The AppSignal Elixir can be configured in a couple different ways. Through mix
configuration or through environment variables.

The configuration is loaded in a four step process. Starting with the package
defaults and ending with reading environment variables. The configuration
options can be mixed without losing configuration from a different option.
Using an initializer, a configuration file and environment variables together
will work.

## Load order

- 1. [Package defaults - `default`](#default)
- 2. [System detected settings - `system`](#system)
- 4. [Mix app config file - `file`](#file)
- 5. [Environment variables - `env`](#env)

##=default 1. Package defaults

The AppSignal package starts with loading its default configuration, setting
paths and enabling certain features.

The agent defaults can be found in the [package source]
(https://github.com/appsignal/appsignal-elixir/blob/master/lib/appsignal/config.ex)
as `Appsignal.Config.default_config`.

This source is listed as `default` in the [diagnose](/elixir/command-line/diagnose.html) output.

##=system 2. System detected settings

The package detects what kind of system it's running on and configures itself
accordingly.

For example, when it's running on Heroku it sets the configuration option
`:running_in_container` to `true` and `:log` to `"stdout"`.

This source is listed as `system` in the [diagnose](/elixir/command-line/diagnose.html) output.

##=file 3. Mix configuration

The AppSignal package is most commonly configured with configuration in the Mix
configuration file.

```elixir
# config/config.exs
# or config/prod.exs
config :appsignal, :config,
  name: :my_app,
  push_api_key: "your-push-api-key"
```

This step will override all given options from the defaults or system
detected configuration.

This source is listed as `file` in the [diagnose](/elixir/command-line/diagnose.html) output.

##=env 4. Environment variables

Lastly AppSignal will look for its configuration in environment variables.
When found these will override all given configuration options from
previous steps.

```bash
export APPSIGNAL_APP_NAME="my custom app name"
# start your app here
```

This source is listed as `env` in the [diagnose](/elixir/command-line/diagnose.html) output.
