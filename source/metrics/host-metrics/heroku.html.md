---
title: "Heroku host metrics <sup>beta</sup>"
---

Heroku provides a service to retrieve host metrics from a Dyno through their [Logplex system](https://devcenter.heroku.com/articles/logplex).
 AppSignal provide an endpoint to read these metrics from your app's logs. This is the only way to receive accurate host metrics in AppSignal for Heroku apps. The AppSignal [host metrics](/metrics/host.html) feature does not work reliable on Heroku as it doesn't directly expose runtime metrics for LXC containers in which their Dynos run. Using the normal host metrics collection your Heroku apps will report the host metrics for the parent system on which many Heroku apps run rather than metrics limited to your Dynos.

From the Logplex system we're able to receive the following metrics from your apps per dyno:

* Load average
* Memory total limit
* Memory used

To setup AppSignal to receive these metrics, please follow the guide below.

!> **Note**: This is a beta feature, meaning that the logplex endpoint can change at any time, at which point you will need to re-add the logdrain.

### Disable AppSignal host metrics collection

By default the AppSignal agent will collect host metrics from Heroku Dynos, but since these aren’t accurate, we have to stop collecting them.
This is a counter intuitive step to be sure, but this is necessary to avoid duplicate reporting of host metrics for Heroku apps. We will disable host metrics collection on Heroku by default some time in the future.

Disable AppSignal host metrics collection by configuring the `enable_host_metrics` option.

Either in the `config/appsignal.yml` configuration file:

```
enable_host_metrics: false
```

Or by setting the system environment variable:

```
APPSIGNAL_ENABLE_HOST_METRICS=false
```

### Enable host runtime metrics on Heroku

The Heroku host [runtime metrics](https://devcenter.heroku.com/articles/log-runtime-metrics) feature will log the host metrics for your dynos at set intervals to your app's log.

To enable this feature on your Heroku app, run the following command on your console.

```
heroku labs:enable log-runtime-metrics
heroku restart
```

After restarting the app you should see the following appear in your logs every now and then.

```
$ heroku logs --tail
source=web.1 dyno=heroku.2808254.d97d0ea7-cf3d-411b-b453-d2943a50b456 sample#load_avg_1m=2.46 sample#load_avg_5m=1.06 sample#load_avg_15m=0.99
source=web.1 dyno=heroku.2808254.d97d0ea7-cf3d-411b-b453-d2943a50b456 sample#memory_total=21.00MB sample#memory_rss=21.22MB sample#memory_cache=0.00MB sample#memory_swap=0.00MB sample#memory_pgpgin=348836pages sample#memory_pgpgout=343403pages
```

Please see the [Heroku Logplex documentation](https://devcenter.heroku.com/articles/log-runtime-metrics) for more information on how to set this up if you run into problems.

### Add a Logplex drain

In order to get the Dyno's host metrics to AppSignal you have to create a new Logplex drain.

!> **Warning**: This will send **all** of your app's logs to our endpoint, not just the metrics. Our endpoint only parses the Dyno's host runtime metrics and ignores the rest of your logs.

```
heroku drains:add "https://push.appsignal.com/2/logplex?api_key=<push_api_key>&name=<app_name>&environment=<app_environment>"
```

Replace the `<push_api_key>`, `<app_name>` and `<app_environment>` placeholders with your AppSignal organization's Push API key, your app's name and environment. Make sure your app's name and environment match exactly with your app's AppSignal configuration. These values are case sensitive.

You can find your Push API key, app name and environment on AppSignal.com under "App settings" for an app in the sidebar navigation.

After adding the drain host metrics for your app will appear after a few minutes in the "host metrics" section.
