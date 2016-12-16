---
title: "Integrating AppSignal into Phoenix"
---

The AppSignal for Elixir package integrates with Phoenix. To set up the
integration, please follow our [installation guide](/elixir/installation.html).

This page will describe further ways of configuring AppSignal for the [Phoenix
framework][phoenix].

More information can be found in the [AppSignal Hex package
documentation][hex-appsignal].

## Incoming HTTP requests

To start logging HTTP requests in your Phoenix app, make sure you use the
`Appsignal.Phoenix` module in your `endpoint.ex` file, just **before** the line
where your router module gets called (which should read something like `plug
MyApp.Router`).

```elixir
# lib/my_app/endpoint.ex
# ...
use Appsignal.Phoenix
plug MyApp.Router
```

This will create a transaction for every HTTP request which is performed on the
endpoint.

## Phoenix instrumentation hooks

Phoenix comes with instrumentation hooks built-in. To send Phoenix'
default instrumentation events to AppSignal, add the following to your
`config.exs` (adjusting for your app's name!).

```elixir
# config/config.exs
config :phoenix_app, PhoenixApp.Endpoint,
  instrumenters: [Appsignal.Phoenix.Instrumenter]
```

For more custom configuration, see our [instrumentation
documentation](/elixir/instrumentation/index.html).

## Template rendering

It's possible to instrument how much time it takes each template render,
including subtemplates (partials), in your Phoenix application.

To enable this for AppSignal you need to register the AppSignal template
renderer, which augment the compiled templates with instrumentation hooks.

Put the following in your `config.exs`.

```elixir
# config/config.exs
config :phoenix, :template_engines,
  eex: Appsignal.Phoenix.Template.EExEngine,
  exs: Appsignal.Phoenix.Template.ExsEngine
```

## Queries

To enable query logging, add the following to you Repo configuration in
`config.exs`.

```elixir
# config/config.exs
config :my_app, MyApp.Repo,
  loggers: [Appsignal.Ecto]
```

Note that this is not Phoenix-specific but works for all Ecto queries. The
process that performs the query however, must be associated with an
`Appsignal.Transaction`, otherwise no event will be logged.

## Channels

See the [`Appsignal.Phoenix.Channel`](hex-phoenix-channels) module in the
AppSignal Hex package documentation on how to instrument channel requests.

[phoenix]: http://www.phoenixframework.org/
[hex-appsignal]: https://hexdocs.pm/appsignal/
[hex-phoenix-channels]: https://hexdocs.pm/appsignal/Appsignal.Phoenix.Channel.html
