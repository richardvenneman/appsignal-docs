---
title: "Custom namespaces for Elixir apps"
---

-> **Note**: Support for custom namespaces was added in version 1.3.0 of the
   AppSignal for Elixir package.

For more information about what namespaces are, please see our
[namespaces](/application/namespaces.html) documentation.

## Configuring a namespace

Using the instrumentation decorators and helper functions it's possible to set
a namespace for a [transaction](/appsignal/terminology.html#transactions). This
can currently only be configured when creating the transaction.

Once the namespace is set and the application is sending data to the AppSignal
servers, the new namespace will appear in the navigation on AppSignal.com.
Note: Data previously reported for the same action is not moved to the new
namespace.

Please see the documentation for [decorators][namespace_decorator] or
[instrumentation helpers][namespace_helper] on how to configure a namespace.

## Ignore by namespace

To ignore all actions in a namespace you can configure AppSignal to ignore one or more namespaces in your app's configuration. It's also possible to only [ignore one or more specific actions](/elixir/configuration/ignore-actions.html).

Ignoring actions or namespaces will **ignore all transaction data** from this action or namespace. No errors and performance issues will be reported. [Custom metrics data](/metrics/custom.html) recorded in an action will still be reported.

For more information about this config option, see the [`ignore_namespaces` config option](/elixir/configuration/options.html#appsignal_ignore_namespaces-ignore_namespaces) documentation.

```elixir
# config/appsignal.exs
use Mix.Config

config :appsignal, :config,
  ignore_namespaces: ["admin", "private"]
```

You can also configure ignore actions using an environment variable.

```bash
export APPSIGNAL_IGNORE_NAMESPACES="admin,private"
```

[namespace_decorator]: /elixir/instrumentation/instrumentation.html#decorator-namespaces
[namespace_helper]: /elixir/instrumentation/instrumentation.html#helper-namespaces
