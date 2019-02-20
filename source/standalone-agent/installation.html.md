---
title: "Standalone AppSignal Agent installation"
---

When we introduced host metrics we knew that in order to provide a full picture of your infrastructure we needed not only to monitor your application servers, but also any servers your application depends on, for example database servers.

In order to do this we added a standalone mode to our AppSignal agent. You can run the agent without having to start it from a Ruby/Elixir process.

## Installation

We are in the process of testing and packaging the standalone agent on Linux distributions that are most popular with our customers. Let us know if you want to run the agent and your distribution is not available yet.

## Ubuntu

The agent has been tested on LTS 14.04, 16.04 and 18.04. First make sure the following packages are installed. All the following commands need root permissions, you might have to use `sudo`.

```bash
apt-get install curl gnupg apt-transport-https
```

Then import the GPG key from [Packagecloud](https://packagecloud.io). This is a service we use to host the repositories for us.

```bash
curl -L https://packagecloud.io/appsignal/agent/gpgkey | sudo apt-key add -
```

Create a file named /etc/apt/sources.list.d/appsignal_agent.list that contains the repository configuration below. Make sure to replace `trusty` in the config below with your Linux distribution and version. Use `xenial` for 16.04 or `bionic` for 18.04.

```bash
deb https://packagecloud.io/appsignal/agent/ubuntu/ trusty main
deb-src https://packagecloud.io/appsignal/agent/ubuntu/ trusty main
```

Then run an apt update to get the newly added packages and install the agent:

```bash
apt-get update
apt-get install appsignal-agent
```

The agent has now been installed, you still need to edit the configuration file in `/etc/appsignal-agent.conf`. The push api key can be found by clicking `App app` in the [app list](https://appsignal.com/accounts). Pick an app name and environment that works for you. It can either be a separate app or you can group these hosts with an existing one by using the same name and environment.

Once you edit the configuration file you need to restart the agent. On 14.04 use `service appsignal-agent restart`. On 16.04 and up use `systemctl restart appsignal-agent`.

## Collected metrics

The agent collects [host metrics](/metrics/host.html) by default. You can also send [StatsD](/standalone-agent/statsd.html) messages to it that will be processed as custom metrics.

We are eager to get feedback on this, let us know via the chat in the app or [support@appsignal.com](mailto:support@appsignal.com).
