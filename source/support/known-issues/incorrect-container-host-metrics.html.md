---
title: Incorrect container host metrics reported
---

## Affected components

- AppSignal for Ruby gem versions `1.x` - most recent.
- AppSignal for Elixir package versions `0.0.x` - most recent.
- Systems: Containerized systems such as Docker and Heroku (LXC).

## Description

Host metrics reported by AppSignal in the host metrics feature are incorrect, reporting the data for the container's host system instead.

AppSignal uses a library called [probes-rs], created by AppSignal, to report host metrics for the host on which the [AppSignal agent] is running. It does this by reading the `/proc` virtual filesystem. This directory however, always reports data from the parent host rather than the container's constraint resources. This is why the AppSignal agent is reporting the wrong metrics.

## Symptoms

- In the AppSignal host metrics feature the host metrics do not match the container's restraints, reporting resources many times its allowed amount.

## Solution

None complete solution is available at this time. Please try our [alpha release](#alpha-releases) and let us know if it works for you.

### Alpha releases

We've released an alpha for a potential fix for container host metrics. Please try out Ruby gem `2.7.0.alpha.4` and Elixir package `1.7.0-alpha.4` or newer and let us know if it works on [support@appsignal.com].

Note that since this is an alpha release we do not recommend running this on your production system.

Also note that it reads the container runtime metrics. If no limits for your container's memory has been configured, the container will report the maximum possible value. A container without swap (support) will report a 0 value. For more information on how to limit your container's memory see the [Docker documentation](https://docs.docker.com/config/containers/resource_constraints/#memory).

Let us know if it's reporting the memory statistics accurately for your apps or if it doesn't. In which case it would help us a lot if you could send us the `appsignal.log` file and some information about your app's container setup so we can reproduce the issue.

## Workaround

None available at this time.

[probes-rs]: https://github.com/appsignal/probes-rs
[AppSignal agent]: /appsignal/how-appsignal-operates.html#agent
[support@appsignal.com]: mailto:support@appsignal.com
