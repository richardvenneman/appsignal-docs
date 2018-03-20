---
title: Incorrect Docker host metrics reported
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

None available at this time.

We are researching a solution for this issue. If you have a specific container system you are using you want us to support, or to be updated about any change on this issue, please let us know at [support@appsignal.com].

## Workaround

None available at this time.

[probes-rs]: https://github.com/appsignal/probes-rs
[AppSignal agent]: /appsignal/how-appsignal-operates.html#agent
[support@appsignal.com]: mailto:support@appsignal.com
