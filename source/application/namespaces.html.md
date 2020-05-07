---
title: "Namespaces"
---

Namespaces are a way to group error incidents, performance incidents from [actions](/appsignal/terminology.html#actions), and host metrics in your app. By default AppSignal provides three namespaces: the "web", "background" and "frontend" namespaces. You can add your own namespaces to separate parts of your app like the API or Admin panel.

The "web" namespace holds all data for HTTP requests while the "background" namespace contains metrics from background job libraries and tasks. The "frontend" namespace is created by the [JavaScript front-end integration](/front-end).

Namespaces can be used to group together actions that are related to the same part of an application. It's also possible to configure notification settings on a per-namespace level. You can find these settings on the [Notifications settings page](https://appsignal.com/redirect-to/app?to=notifications).

You can add your own namespaces to separate parts of your app like the API and Admin panel.

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

-> Note: When setting custom namespace we only accept letters and underscored for namespace names.

## Ignoring namespaces

-> The `ignore_namespaces` feature was introduced in AppSignal for Ruby gem version 2.3.0 and AppSignal for Elixir package version 1.3.0.

Sometimes you have a certain part of an application that does not need to be monitored by AppSignal. The most common use case is an administration panel that you use internally which doesn't need constant monitoring. By ignoring an entire namespace AppSignal will ignore all transactional data from all actions in the configured namespaces.

To ignore a namespace first make sure to configure AppSignal to report all actions you want to ignore under a certain namespace, as described in the [Custom namespaces](#custom-namespaces) section.

Then configure AppSignal in your app to ignore the namespace, see the documentation for [Ruby](/ruby/instrumentation/namespaces.html#ignore-by-namespace) & [Elixir](/elixir/instrumentation/namespaces.html#ignore-by-namespace) apps.

After restarting your app the actions in the selected namespace should no longer be reported on AppSignal.com.
