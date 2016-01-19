---
title: How AppSignal operates
---

Once you boot your application for the first time after installing our gem the AppSignal agent will be started. This agent tries to locate a proper directory
to place it's files. If you use a Capistrano style directory structure it will create a directory in `app/shared`. On Heroku style deployments
it will create the directory in `/app/tmp`. If neither of these can be detected the directory will be created in `/tmp`.

You can override the location of this directory using the `APPSIGNAL_WORKING_DIR_PATH` env var, any path configured this way will have precedence.
The agent's working directory will contain two files and one directory:

`agent.lock` is used by the agent to make sure there's one single agent running with the proper configuration. If you delete this file, or the entire
working directory, the agent will immediately exit.

`agent.socket` is the location where the agent listens for incoming data from the Ruby processes. Whenever a transaction finishes or you send a custom
metric this data is written to this socket. The agent then aggregates this data and sends it to the push API.

`payloads` contains cached payloads if the agent is having trouble connecting to our push API. The amount of payloads is automatically capped so this
will always use very little disk space. This makes sure that we don't lose any of your precious data if your network connection is down for a limited time
or our push API has a hiccup.

The agent will keep running and will handle connections from multiple clients when needed. So if you run Unicorn and Sidekiq for example there will only be
one agent running that uses a very limited amount of resources. If the connection to the agent is lost clients will automatically reconnect and/or start a
new one.
