---
title: "Host metrics"
---

The AppSignal agent collects various system metrics, which allows you to
correlate performance issues or errors you might have with out of the
ordinary things that were happening on your hosts. We collect the
following metrics:

 * CPU usage: User, nice, system, idle and iowait in percentages.
 * Load average
 * Memory usage: Available and used memory.
 * Disk usage: Percentage of very disk used.
 * Disk IO: Throughput of data read from and written to every disk.
 * Network traffic: Throughput of data received and transmitted through
   every network interface.

This feature is currently in beta. To try it out use gem version
1.2.0.beta.x like this:

`gem 'appsignal', '~> 1.2.0.beta'`

Collecting these metrics is off by default during the beta. If you use
an `appsignal.yml` config file add this line to the defaults segment or
the specific environment you want to enable this for:

`enable_host_metrics: true`

If you configure AppSignal with environment variables add this:

`export APPSIGNAL_ENABLE_HOST_METRICS=true`

The collected host metrics are available in the "Hosts" section you can
reach through the left navigation in an app. Select a host and then
click the "Metrics" tab to see all collected metrics.

If you have any feedback on this new feature we'd love to hear it!
