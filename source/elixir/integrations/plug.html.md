---
title: "Integrating AppSignal into Plug"
---

-> **Note**: Support for custom namespaces was added in version 1.3.0 of the
   AppSignal for Elixir package.

The AppSignal for Elixir package integrates with Plug. To set up the
integration, please follow our [installation guide](/elixir/installation.html).

This page describes how to set up AppSignal in a Plug application, and how to
add instrumentation for events within requests. For more information about
custom instrumentation, read the [Elixir
instrumentation](/elixir/instrumentation/index.html) documentation.

More information can be found in the [AppSignal Hex package
documentation][hex-appsignal].

## Table of Contents

- [Incoming HTTP requests](#incoming-http-requests)
- [Custom instrumentation](#custom-instrumentation)

## Incoming HTTP requests

We'll start out with a small Plug app that accepts `GET` requests to `/` and
returns a welcome message. To start logging HTTP requests in this app, we'll 
use the `AppSignal.Plug` module to the end of our app.

``` elixir
defmodule AppsignalPlugExample do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  use Appsignal.Plug # <-- Add this
end
```

This will create a transaction for every HTTP request which is performed on the 
endpoint.

## Custom instrumentation

Although `Appsignal.Plug` will start transactions for you, it won't instrument
events in your app just yet. To do that, we need to add some custom
instrumentation.

This example app looks like the one we used before, but it has a slow function
(aptly named `slow/0`) we'd like to add instrumentation for. To do that, we need
to 

1. `use Appsignal.Instrumentation.Decorators` to allow us to use AppSignal's
   instrumentation decorators
2. Decorate the function we want to instrument with the `transaction_event/0`
   decorator

``` elixir
defmodule AppsignalPlugExample do
  use Plug.Router
  use Appsignal.Instrumentation.Decorators # <-- 1

  plug :match
  plug :dispatch

  get "/" do
    slow()
    send_resp(conn, 200, "Welcome")
  end

  @decorate transaction_event() # <-- 2
  defp slow do
    :timer.sleep(1000)
  end

  use Appsignal.Plug
end
```

This will add an event for the `slow/0` function to the current transaction
whenever it's called. For more information about custom instrumentation, read
the [Elixir instrumentation](/elixir/instrumentation/index.html) documentation.

[hex-appsignal]: https://hexdocs.pm/appsignal/
