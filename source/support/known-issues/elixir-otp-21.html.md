---
title: Apps on Elixir OTP 21 don't report data
---

## Affected components

- AppSignal for Elixir package versions: `v1.6.5` and earlier
- Apps running OTP 21 or higher

## Description

After upgrading to Erlang/OTP 21 and using an older AppSignal for Elixir package, no data is reported from the app. The issue was reported on our [issue tracker](https://github.com/appsignal/appsignal-elixir/issues/365).

The following warning will be printed to the application's log on start up. This indicates that our extension couldn't start AppSignal with the required config and is not starting.

```
WARNING: Error when reading appsignal config, appsignal not starting: Required environment variable '_APPSIGNAL_PUSH_API_KEY' not present
```

This is caused by a change in OTP 21 where the system environment can no longer be modified for processes booted by the application. AppSignal relied on this feature as a configuration method, causing AppSignal to no longer start on OTP 21.

In version 1.6.6 we fixed most config options to be read by our extension in a different way, and in 1.6.7 all options were updated to be configured this way. We do not recommend using version 1.6.6.

## Symptoms

The following warning will be printed to the application's log on start up. This indicates that our extension couldn't start AppSignal with the required config and is not starting.

```
WARNING: Error when reading appsignal config, appsignal not starting: Required environment variable '_APPSIGNAL_PUSH_API_KEY' not present
```

(The underscore prefixed version of the environment variable is the internally used version, do not attempt to configure it instead of `APPSIGNAL_PUSH_API_KEY`.)

## Solution

Upgrade to AppSignal for Elixir package version `1.6.7` or higher. We recommend upgrading to the latest version.
