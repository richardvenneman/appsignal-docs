---
title: Container host metrics
---

Host metrics for containerized systems are fully supported since AppSignal for Ruby gem 2.9.11 and Elixir package 1.10.11. All earlier versions are affected by the [incorrect container host metrics reported](/support/known-issues/incorrect-container-host-metrics.html) issue.

!> **Warning**: To get accurate metrics from your containers, container limits are required for your monitored containers. See the [container limits](#container-limits) section for more information.

-> **Note**: While Heroku also runs on a containerized system (LXC), we do not support host metrics in the same way. Instead, please see the [Heroku support][heroku support] section.

-> **Note**: This page is part of the [host metrics section](/metrics/host.html).

## Table of Contents

- [Container limits](#container-limits)
- [Supported metrics](#supported-metrics)
  - [About CPU metrics](#cpu-metrics)

## Container limits

For container host metrics to be accurate, limits need to be set for every container. This means, configuring your container to have a limited number of CPUs and memory allocated to it. Without these limits the container reports the maximum possible value of these metrics, resulting in the host reporting Terabytes of available memory for example. A container without swap configured, or unsupported on the host system, will report a `0` value. For more information on how to limit your container's CPU and memory, please read the documentation on:

- Docker
  - [CPU](https://docs.docker.com/config/containers/resource_constraints/#cpu)
  - [memory](https://docs.docker.com/config/containers/resource_constraints/#memory)
- Kubernetes
  - [CPU](https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/)
  - [memory](https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/)

## Supported metrics

On systems that expose the `/sys/fs` virtual file system the following metrics are supported.

<table>
  <thead>
    <tr>
      <th>Metric</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>CPU usage</td>
      <td>
        User and system in percentages.
        <br>
        Read more about <a href="https://blog.appsignal.com/2018/03/06/understanding-cpu-statistics.html">CPU metrics</a> in our academy article.
      </td>
    </tr>
    <tr>
      <td>Load average</td>
      <td>1 minute load average on the host.</td>
    </tr>
    <tr>
      <td>Memory usage</td>
      <td>Available, free and used memory. Also includes swap total and swap used.</td>
    </tr>
    <tr>
      <td>Disk usage</td>
      <td>Percentage of every disk used.</td>
    </tr>
    <tr>
      <td>Disk IO</td>
      <td>Throughput of data read from and written to every disk.</td>
    </tr>
    <tr>
      <td>Network traffic</td>
      <td>Throughput of data received and transmitted through every network interface.</td>
    </tr>
    </tr>
  </tbody>
</table>

###=cpu-metrics About CPU metrics

- AppSignal reports the same metrics as the [`docker stats`](https://docs.docker.com/engine/reference/commandline/stats/) command.
- It has totals of more than 100%. 100% being the total of 1 (virtual) CPU. Multiple CPUs can result in CPU usage of more than 100%. This is different from the [normal host metrics](/metrics/host.html) where 100% is the maximum.
- Other containers on the system impact the total CPU usage available to the container. [Limits](#container-limits) will help maintain a better balance of CPU usage between containers so the averages fluctuate less depending on busy neighbors.

[heroku support]: /metrics/host-metrics/heroku.html
