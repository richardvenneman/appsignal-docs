---
title: "Custom namespaces for Elixir apps"
---

-> **Note**: Support for custom namespaces was added in version 1.3.0 of the
   AppSignal for Elixir package.

For more information about what namespaces are, please see our
[namespaces](/application/namespaces.html) documentation.

## Configuring a namespace

-> **Note**: `Appsignal.set_namespace/2` was added in version 1.7.0 of the
   AppSignal for Elixir package.

Using the [`Appsignal.set_namespace/2`][set_namespace] function it's possible to
set a namespace for a [transaction](/appsignal/terminology.html#transactions).

This can be done per transaction with custom instrumentation, added in a the
controller in a Phoenix application, or set via a plug to configure it for all
requests of a certain Phoenix controller.

It's also possible to configure the namespace when creating the transaction.
Please see the documentation for [decorators][namespace_decorator] or
[instrumentation helpers][namespace_helper] on how to configure a namespace.

Once the namespace is set and the application is sending data to the AppSignal
servers, the new namespace will appear in the app navigation on AppSignal.com.
Note: Data previously reported for the same action is not moved to the new
namespace.

```elixir
# In a Phoenix controller
defmodule AppsignalPhoenixExampleWeb.AdminController do
  use AppsignalPhoenixExampleWeb, :controller

  plug :set_namespace

  defp set_namespace(conn, _params) do
    Appsignal.Transaction.set_namespace(:admin)
    conn
  end

  # ...
```

## Ignore by namespace

To ignore all actions in a namespace you can configure AppSignal to ignore one or more namespaces in your app's configuration. It's also possible to only [ignore one or more specific actions](/elixir/configuration/ignore-actions.html).

Ignoring actions or namespaces will **ignore all transaction data** from this action or namespace. No errors and performance issues will be reported. [Custom metrics data](/metrics/custom.html) recorded in an action will still be reported.

For more information about this config option, see the [`ignore_namespaces` config option](/elixir/configuration/options.html#option-ignore_namespaces) documentation.

```elixir
# config/appsignal.exs
use Mix.Config

config :appsignal, :config,
  ignore_namespaces: ["admin", "private"]
```

You can also configure ignore namespaces using an environment variable.

```bash
export APPSIGNAL_IGNORE_NAMESPACES="admin,private"
```

[set_namespace]: https://hexdocs.pm/appsignal/Appsignal.Transaction.html#set_namespace/2
[namespace_decorator]: /elixir/instrumentation/instrumentation.html#decorator-namespaces
[namespace_helper]: /elixir/instrumentation/instrumentation.html#helper-namespaces
