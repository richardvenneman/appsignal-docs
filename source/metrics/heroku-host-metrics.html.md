---
title: "Heroku host metrics"
---

Recently Heroku introduced a way to retrieve accurate host metrics from a dyno through their [Logplex system](https://devcenter.heroku.com/articles/logplex).

We’re able to receive the following metrics:

* Load average
* Memory limit
* Memory used

To setup AppSignal to receive these metrics follow the guide below.

!> This is a beta feature, meaning that the logplex endpoint can change at any time, at which point you’d have to re-add the logdrain.

### Stop our host metrics retrieval

> By default our agent will collect host metrics from the Dyno, since these aren’t accurate, we have to stop collecting them.

You can do this by adding the following line to your `appsignal.yml` config file:

```
enable_host_metrics: false
```

Or set the env var:

```
APPSIGNAL_ENABLE_HOST_METRICS=false
```

### Enable host metrics on Heroku

These are called [runtime metrics](https://devcenter.heroku.com/articles/log-runtime-metrics) and we need to enable logging for them. Run the following command on your console.

```
heroku labs:enable log-runtime-metrics
heroku restart
```

After restarting the app you should see the following appear in your logs every now and then.

```
source=web.1 dyno=heroku.2808254.d97d0ea7-cf3d-411b-b453-d2943a50b456 sample#load_avg_1m=2.46 sample#load_avg_5m=1.06 sample#load_avg_15m=0.99
source=web.1 dyno=heroku.2808254.d97d0ea7-cf3d-411b-b453-d2943a50b456 sample#memory_total=21.00MB sample#memory_rss=21.22MB sample#memory_cache=0.00MB sample#memory_swap=0.00MB sample#memory_pgpgin=348836pages sample#memory_pgpgout=343403pages
```
If it doesn’t check the [Heroku documentation for help](https://devcenter.heroku.com/articles/log-runtime-metrics).


### Add a Logplex drain

In order to get the metrics to AppSignal you have to create a new Logplex drain

-> Note that this will send _all_ logs to our endpoint, not just  the metrics.

```
heroku drains:add "https://push.appsignal.com/2/logplex?api_key=<push_api_key>&name=<site_name>&environment=<site_environment>"
```

Make sure the variables are replaced with your `push_api_key`, `site_name` and `site_environment` and match any capitalisation.

You can find these under “App settings” for an app in the sidebar on Appsignal.

After adding the drain host metrics should appear after a few minutes.
