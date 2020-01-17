---
title: "About time"
---

This page will explain how AppSignal handles time, why machines may report times that are not accurate, and how to synchronize app servers with NTP servers.

The data that AppSignal collects from your app and app server have a timestamp attached to them. This timestamp is the time at which a HTTP request was made, background job started, metric was set, or an event started in the app. This time is then used to display graphs, sample and event data in chronological order.

__⚠️ The timestamp attached to an app's data is based on the app instance server's date and time.__

If an app server is not reporting approximately the current time, this may cause problems in AppSignal's processing and alerting. When an app has multiple servers, these servers need to report approximately the same time.

A difference of seconds _may_ not a big impact, but a factor of minutes will create undesired effects. This includes inaccurate graphs, metrics and samples, and missed notifications about Anomaly detection alerts.

Read more about how data from your app and servers is sent to AppSignal's servers and how the data is then processed on our [data life cycle page](/appsignal/data-life-cycle.html). In particular for [Anomaly detection alerts][anomaly detection processing] ensuring the correct time is sent from an app is very important, to avoid missing alerts about metrics.

## Clock drift

Computers can experience [clock drift](https://en.wikipedia.org/wiki/Clock_drift), causing it to diverge more and more from the reference clock, the current time. This means that an app server's clock can be several minutes ahead or behind of the actual time. Since the [transaction data] is using the server's timestamp, if the server is out of sync, the data that's being sent is also out of sync.

Inaccurate clock times can cause problems with the reported times for samples, metrics and break reporting for [Anomaly detection triggers][anomaly detection processing]. Samples and metrics will not be shown at the actual time at which they occurred. Anomaly detection will be unable create alerts for metrics reported with inaccurate timestamps.

To minimize clock drift we recommend you set up your servers to [automatically synchronize its current time][ntp sync] with an [NTP][ntp] server.

## About the future

When AppSignal detects [transaction data] with timestamps based in the future (from the perspective of the AppSignal processor's current time), it will send a notification alerting the users of the app about the faulty time sent from the app.

This notification is not available for (custom) metrics send from an app instance, but may be added in the future.

## Setting up NTP synchronization

Synchronizing a server with NTP servers will ensure a server's time is approximately the same as a reference clock. NTP, Network Time Protocol, is the protocol used by computers to synchronize times over networks. In practice servers and personal computers poll one or more servers every so often to fetch the current time. If the returned time is different from the computer's current time, the computer updates its current time to the NTP value. Frequent polling of the NTP servers by an app server will make sure the server will never deviate too much from the reference time.
AppSignal's servers are also configured to synchronize with NTP servers.

The `ntp` package will synchronize a machine with NTP servers on most systems. Ubuntu offers the `timesyncd` package, as part of `systemd` since Ubuntu 16.04. The NTP setup instructions may differ for your Linux distro or Operating System, so please find a guide applicable to your setup.

- [Ubuntu Time Synchronization guide](https://help.ubuntu.com/lts/serverguide/NTP.html)
- [Fedora NTPd guide](https://docs.fedoraproject.org/en-US/fedora/rawhide/system-administrators-guide/servers/Configuring_NTP_Using_ntpd/)

Be sure to verify the NTP installation by checking if the server's current date and time is synced with NTP servers with the `ntpstat` or `timedatectl status` (Ubuntu/systemd) commands.

[ntp sync]: #setting-up-ntp-synchronization
[anomaly detection processing]: /appsignal/data-life-cycle.html#anomaly-detection
[transaction data]: /appsignal/terminology.html#transactions
[ntp]: https://en.wikipedia.org/wiki/Network_Time_Protocol
