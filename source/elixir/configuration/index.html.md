---
title: "AppSignal Elixir configuration"
---

Configuration. Important, because without it the AppSignal Elixir package won't
know which application it's instrumenting or in which environment.

On this topic we'll explain how to configure AppSignal, what can be configured
in the Elixir package and what the minimal configuration needed is.

## Table of Contents

- [Minimal required configuration](#minimal-required-configuration)
- [Configuration options](/elixir/configuration/options.html)
  - [Parameter filtering](/elixir/configuration/parameter-filtering.html)
  - [Application environment and version](#application-environment-and-version)
- [Disable AppSignal for tests](#disable-appsignal-for-tests)

## Minimal required configuration

```elixir
# config/config.exs
config :appsignal, :config,
  name: :my_app,
  push_api_key: "your-hex-appsignal-key"
```

Alternatively, you can configure the agent using OS environment variables.

```elixir
export APPSIGNAL_PUSH_API_KEY=your-hex-appsignal-key
export APPSIGNAL_APP_NAME=my_app
```

## Configuration options

Read about all the configuration options on the [options
page](/ruby/configuration/options.html).

## Application environment and version

Running your application you want to let AppSignal know what state your
application is in.

This includes information about the version (revision) of your application and
what environment it's running in.

A typical environment configuration file would contain the following.

```elixir
# config/prod.exs
config :appsignal, :config,
  name: :my_app,
  push_api_key: "your-hex-appsignal-key",
  env: :prod,
  revision: Mix.Project.config[:version]
```

## Disable AppSignal for tests

If you put your entire AppSignal configuration in the `config.exs`
instead of `prod.exs` (e.g. for having AppSignal enabled during
development), make sure to put `active: false` in your test configuration
unless you want to submit all your test results.

```elixir
# config/test.exs
config :appsignal, :config,
  active: false
```
