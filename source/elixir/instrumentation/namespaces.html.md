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

[namespace_decorator]: /elixir/instrumentation/instrumentation.html#decorator-namespaces
[namespace_helper]: /elixir/instrumentation/instrumentation.html#helper-namespaces
