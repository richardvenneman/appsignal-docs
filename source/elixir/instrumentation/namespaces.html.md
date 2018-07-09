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
servers, the new namespace will appear in the navigation on AppSignal.com.
Note: Data previously reported for the same action is not moved to the new
namespace.

```ruby
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

[set_namespace]: https://hexdocs.pm/appsignal/Appsignal.Transaction.html#set_namespace/2
[namespace_decorator]: /elixir/instrumentation/instrumentation.html#decorator-namespaces
[namespace_helper]: /elixir/instrumentation/instrumentation.html#helper-namespaces
