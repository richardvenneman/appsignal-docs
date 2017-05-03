---
title: "Namespaces"
---

Namespaces are a way to group error incidents, performance incidents, and host
metrics in your app. By default AppSignal provides two namespaces: the "web"
and "background" namespaces.

The "web" namespace holds all data for HTTP requests while the "background"
namespace contains metrics from background job libraries and tasks.

Namespaces can be used to group together incidents that are related to the same
part of an application. It's also possible to configure notification settings
on a per-namespace level. You can find these settings under "App settings" ->
"Notifications".

## Custom namespaces

-> The custom namespaces feature was introduced in AppSignal for Ruby gem
   version 2.2.0 and AppSignal for Elixir package version 1.3.0.

Using more than one namespace makes it easier to group metrics belonging to the
same part of an application together. In AppSignal we use custom namespaces to
accomplish this.

The advantage of custom namespaces is the ability to group together error and
performance incidents from separate parts of the same application. Think of an
administration panel, public homepage versus private back-end, etc.

The metrics from these three parts in one namespace can clutter the "web"
namespace with incidents of varying importance. For example, when something in
the administration panel breaks it's not as big of a problem when the sign up
page breaks on the public front-end.

The metrics from separate parts of an application can be grouped together in
their own namespace. By using the AppSignal instrumentation helpers for
setting a namespaces it's possible to assign
[transactions](/appsignal/terminology.html#transactions) to a certain
namespace.

Once the namespace is configured and the application is sending data to the
AppSignal, the new namespace will appear in the navigation on AppSignal.com.
Note: Data previously reported for the same action is not moved to the new
namespace.

For more documentation on how to configure a namespace please see the
documentation for our [Ruby](/ruby/instrumentation/namespaces.html) and
[Elixir](/elixir/instrumentation/namespaces.html) packages.
