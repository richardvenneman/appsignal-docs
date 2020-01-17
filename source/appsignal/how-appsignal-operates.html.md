---
title: How AppSignal integrations operate
---

AppSignal consists of many different systems working together. This page will explain what systems are part of the integrations we ship for [Ruby](/ruby) and [Elixir](/elixir), and how they work together.

- [Language libraries](#language-libraries)
- [Extension](#extension)
- [Agent](#agent)
    - [Working directory](#working-directory)
        - [Location](#working-directory-location)
        - [Permissions](#working-directory-permissions)

## Language libraries

The AppSignal [Ruby gem](https://rubygems.org/gems/appsignal) and [Elixir package](https://hex.pm/packages/appsignal) provide integration for their respective programming language and popular libraries (for [Ruby](/ruby/integrations) and [Elixir](/elixir/integrations)) from its ecosystem, to provide error reporting and performance insights. It is currently required to use one of these libraries to integrate AppSignal into your app and collect [host metrics](/metrics/host.html) from its host.

When you install the AppSignal Ruby gem and Elixir package in your app, a native [extension](#extension) for the programming language is compiled alongside it. This extension communicates with the [agent](#agent) to efficiently process your data and sent it to the AppSignal [Push API](/appsignal/terminology.html#push-api).

When you boot your application with AppSignal installed, the AppSignal agent will be started in the background. It will only start one agent per configuration, if a new configuration is found a new agent will start and the agents for other versions will be shutdown.

## Extension

The AppSignal extension communicates between the programming language and the AppSignal agent. One part is written in Rust and the other in the C programming language. The host machine on which AppSignal is installed therefore need a working [C compiler](https://en.wikipedia.org/wiki/C_%28programming_language%29) present. Usually this is already installed on the host machine, but for a lot of Docker images this is often not the case in order to keep the images small. The required packages for your Operating System are listed on our [supported Operating Systems](/support/operating-systems.html) page.

There are two parts to AppSignal extension, the C-extension and the static/dynamic library written in [Rust](https://www.rust-lang.org/en-US/). The C-extension for [Ruby](https://github.com/appsignal/appsignal-ruby/blob/master/ext/appsignal_extension.c) and the [Nif](/elixir/why-nif.html) for [Elixir](https://github.com/appsignal/appsignal-elixir/blob/develop/c_src/appsignal_extension.c) will implement the AppSignal library interface so the AppSignal language library can communicate with it. A separate library is used so the implementation can be shared between AppSignal [libraries](#language-libraries).

The extension communicates with the agent over a socket, for which the pointer is stored in the agent's [working directory](#working-directory). This communication is one way only, the extension sends the recorded data to the agent and the agent sends this to the AppSignal servers.

## Agent

Once started by the [extension](#extension), the AppSignal agent will keep running in the background of your application as a daemonized process. It will handle connections from multiple clients (app processes through the [extension](#extension)) when needed. For example, if you run both Unicorn (web server) and Sidekiq (background job library) at the same time, there will only be one AppSignal agent running for both processes. If the connection to the agent is lost clients will automatically reconnect and/or start a new agent. (Restart behavior added in Ruby gem version `2.4.0` and Elixir package version `1.4.0`).

 On boot the agent will try to locate a proper [working directory](#working-directory) in which it can store some of its temporary operating files. It needs to create and write files to the working directory and create the `appsignal.log` file before it can boot properly. If it fails to do so, it will not properly boot and exit. The agent requires a location to store the `appsignal.log` file as the `stdout` value for the `log` config option (for [Ruby](/ruby/configuration/options.html#option-log) and [Elixir](/elixir/configuration/options.html#option-log)) will not apply to the agent. The agent cannot communicate its logs back over the socket with the extension.

The agent itself is a lightweight process written in [Rust](https://www.rust-lang.org/en-US/), that uses very little resources. It only keeps your data in memory for a very short time until it sends it to the AppSignal Push API, after which it flushes the data. If it cannot connect to the AppSignal Push API it will temporarily store the data to disk, see [working directory](#working-directory).

Over time the agent will receive monitoring data from your apps and start to aggregate them. After a 30 second transmission interval it will push the aggregated data to the AppSignal Push API. Here it will be processed, incidents and Anomaly detection alerts are created, and eventually notifications are sent to you, the user.

Periodically the agent will also read the system stats from the machine its running on to collect [host metrics](/metrics/host.html). This is done with help of the [probes-rs](https://github.com/appsignal/probes-rs) library written by AppSignal. The host metrics data is used for the host metrics feature to provide graphs and to show host metrics data for [samples](/appsignal/terminology.html#samples) at that time.

If a request to our [Push API](/appsignal/terminology.html#push-api) has failed, the payload of that request is written to disk in the [working directory](#working-directory) and it will retry to send the payload at the next transmission interval.

### Working directory

The working directory is used for several things that the AppSignal agent needs to keep operating. It's a required part of being able to run the AppSignal agent. If no suitable place for the working directory can be found, the agent will shutdown and the extension in your app will disable itself. It will no longer report any data to the AppSignal servers.

The working directory's responsibilities:

- `appsignal.log` fallback location
  - The working directory functions as the fallback location for the `appsignal.log` file when no valid path can be detected and the given `log_path` location is unusable (config option for [Ruby](/ruby/configuration/options.html#option-log_path) and [Elixir](/elixir/configuration/options.html#option-log_path)). If not suitable location is found, such as in your project's `log/` directory, it will be stored in `{working_directory}/appsignal.log`. Read more about the [AppSignal logs](/support/debugging.html#logs).
- `agent.socket` file storage
  - The AppSignal agent stores a socket file in `{working_directory}/agent.socket`, which is used by the AppSignal extension in your application to communicate with the agent. Whenever an AppSignal transaction finishes or you send a custom metric, this data is written to the socket and received by the agent. It will then aggregates this data and transmit it to the AppSignal Push API.
- `agent.lock` file storage
  - The AppSignal agent stores a lock file (`agent.lock`) to ensure there's only one instance of the agent running with your app's configuration. If a new version of the agent is started, older versions will shutdown when they detect a newer version is running, allowing the newly started agent to handle all incoming data from that point on.
  - Using one working directory, and lock file, for multiple apps running on the same machine this can create some odd behavior. For this reason we recommend using one working directory location per app. Read more about [running multiple applications on one host](/application/#running-multiple-applications-on-one-host).
  - If you delete this file, or the entire working directory, the agent will shutdown immediately.
- `payloads` storage
  - The payloads directory contains cached payloads written to disk for when the agent is having trouble connecting to our Push API. To avoid the agent's memory footprint increasing over time, this data is stored on disk temporarily. This allows us to make sure we don't lose any of your precious data if your network connection is down for a limited time or our Push API has a small hiccup. The amount of payloads that is stored on disk is automatically limited to the last couple of payloads, so this will always use a small disk space.

####^working-directory Location

The default location of the working directory is `/tmp/appsignal`. If you use a [Capistrano](http://capistranorb.com/) style directory structure it will create a directory named `appsignal` in `app/shared`. On [Heroku](https://heroku.com) style deployments it will create the directory in `/app/tmp`. If neither of these paths are detected, the AppSignal directory will be created in the default location.

The location of the working directory can be customized with the `working_directory_path` config option ([Ruby](/ruby/configuration/options.html#option-working_directory_path) / [Elixir](/elixir/configuration/options.html#option-working_directory_path)). Any path configured this way will have precedence over any path it can detect.

####^working-directory Permissions

By default the working directly is writable for everyone (Unix permissions `0666`). This is the default, because over time we've seen many support requests that originated from the working directory existing, but not being writable by the AppSignal agent. For example: when the app is started by the deploy user on deploy of the app, but by another user during a host restart. This gives directory ownership to one of the user accounts, while making it unwritable for the other user.

It's possible to disable the global read and write permissions (and give the working directory Unix permissions `0644`) by setting the `files_world_accessible` config option ([Ruby](/ruby/configuration/options.html#option-files_world_accessible) / [Elixir](/elixir/configuration/options.html#option-files_world_accessible)) to `false` for your apps.
