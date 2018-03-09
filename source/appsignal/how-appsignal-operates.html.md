---
title: How AppSignal operates
---

When you install the `appsignal` [Ruby gem](https://rubygems.org/gems/appsignal) or [Elixir package](https://hex.pm/packages/appsignal), a native extension is compiled alongside it. You therefore need a working [C compiler](https://en.wikipedia.org/wiki/C_%28programming_language%29) on the machine you install AppSignal on. Most of the times this is already present on the host machine, but for a lot of Docker images this is often not the case. The required packages for your machine are listed on our [supported Operating Systems](/support/operating-systems.html) page.

Once you boot your application with AppSignal installed for the first time, the AppSignal agent will be started in the background. On boot it try to locate a proper working directory in which it can store some of its temporary operating files. If it cannot, it will not boot properly. Read more about the [working directory](#working-directory).

The AppSignal agent will keep running in the background and will handle connections from multiple clients (app processes) when needed. For example, if you run both Unicorn and Sidekiq at the same time, there will only be one AppSignal agent running for both processes that uses a limited amount of resources. If the connection to the agent is lost clients will automatically reconnect and/or start a new agent. (Restart behavior added in Ruby gem version `2.4.0` and Elixir package version `1.4.0`).

Over time the agent will receive monitoring data from your apps and start to aggregate them. After a certain interval it will push the aggregated data to the AppSignal Push API. Here it will be processed, incidents and Anomaly detection alerts are created, and eventually notifications are sent to you, the user.

## Working directory

The working directory is used for several things that the AppSignal agent needs to keep operating. It's a required part of being able to run the AppSignal agent. If no suitable place for the working directory can be found, the agent will shutdown and the extension in your app will disable itself. It will no longer report any data to the AppSignal servers.

The working directory's responsibilities:

- `appsignal.log` fallback location
  - The working directory functions as the fallback location for the `appsignal.log` file. If not suitable location is found, such as in your project's `log/` directory, it will be stored in `{working_directory}/appsignal.log`. Read more about the [AppSignal logs](/support/debugging.html#logs).
- `agent.socket` file storage
  - The AppSignal agent stores a socket file in `{working_directory}/agent.socket`, which is used by the AppSignal extension in your application to communicate with the agent. Whenever an AppSignal transaction finishes or you send a custom metric, this data is written to the socket and received by the agent. It will then aggregates this data and transmit it to the AppSignal Push API.
- `agent.lock` file storage
  - The AppSignal agent stores a lock file (`agent.lock`) to ensure there's only one instance of the agent running with your app's configuration. If a new version of the agent is started, older versions will shutdown when they detect a newer version is running, allowing the newly started agent to handle all incoming data from that point on.
  - Using one working directory, and lock file, for multiple apps running on the same machine this can create some odd behavior. For this reason we recommend using one working directory location per app. Read more about [running multiple applications on one host](/application/#running-multiple-applications-on-one-host).
  - If you delete this file, or the entire working directory, the agent will shutdown immediately.
- `payloads` storage
  - The payloads directory contains cached payloads written to disk for when the agent is having trouble connecting to our Push API. To avoid the agent's memory footprint increasing over time, this data is stored on disk temporarily. This allows us to make sure we don't lose any of your precious data if your network connection is down for a limited time or our Push API has a small hiccup. The amount of payloads that is stored on disk is automatically limited to the last couple of payloads, so this will always use a small disk space.

###^working-directory Location

The default location of the working directory is `/tmp/appsignal`. If you use a [Capistrano](http://capistranorb.com/) style directory structure it will create a directory named `appsignal` in `app/shared`. On Heroku style deployments it will create the directory in `/app/tmp`. If neither of these paths are detected, the AppSignal directory will be created in `/tmp/appsignal`.

The location of the working directory can be customized with the `working_dir_path` config option ([Ruby](/ruby/configuration/options.html#appsignal_working_dir_path-working_dir_path) / [Elixir](/elixir/configuration/options.html#appsignal_working_dir_path-working_dir_path)). Any path configured this way will have precedence over any path it can detect.

###^working-directory Permissions

By default the working directly is writable for everyone (Unix permissions `0666`). This is the default, because over time we've seen many support requests that originated from the working directory existing, but not being writable by the AppSignal agent. For example: when the app is started by the deploy user on deploy of the app, but by another user using during a host restart. This gives directory ownership to one of the user accounts, while making it unwritable for the other user.

It's possible to disable the global read and write permissions (and give the working directory Unix permissions `0644`) by setting the `files_world_accessible` config option ([Ruby](/ruby/configuration/options.html#appsignal_files_world_accessible-files_world_accessible) / [Elixir](/elixir/configuration/options.html#appsignal_files_world_accessible-files_world_accessible)) to `false` for your apps.
