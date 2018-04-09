---
title: "AppSignal for Ruby: Notify of deploy"
---

!> **Warning**: This method of notifying AppSignal of deploys is **deprecated**. Please use the new `revision` config option instead. Read our [deploy marker](/application/markers/deploy-markers.html) section for more information on how to create deploy markers.

Command line tool to send a "Deploy Marker" for an application to AppSignal.

Deploy markers are used on AppSignal.com to indicate changes in an application,
"Deploy markers" indicate a deploy of an application.

Incidents for exceptions and performance issues will be closed and reopened if
they occur again in the new deploy.

Note: The same logic is used in the Capistrano integration. A deploy marker is
created on each deploy.

This tool is available since version 0.2.5 of the AppSignal Ruby gem.

Please read our documentation on [Deploy markers] for recommended alternative
methods of sending deploy markers to AppSignal.

## Options

- `--environment` required. The environment of the application being deployed.
- `--user` required. User that triggered the deploy.
- `--revision` required. Git commit SHA or other identifiable revision id.
- `--name` If no "name" config can be found in a `config/appsignal.yml`
  file or based on the `APPSIGNAL_APP_NAME` environment variable, this
  option is required.

## Usage

### Basic example

```bash
appsignal notify_of_deploy \
  --user=tom \
  --environment=production \
  --revision=abc1234
```

### Using a custom name

```bash
appsignal notify_of_deploy \
  --user=tom \
  --environment=production \
  --revision=abc1234 \
  --name="My app"
```

### The help command

If you need more help from the command line tool itself, use the `--help`
option.

```bash
appsignal notify_of_deploy --help
```

## Exit codes

- Exits with status code `0` if the deploy marker is sent.
- Exits with status code `1` if the configuration is not valid and active.
- Exits with status code `1` if the required options aren't present.

[Deploy markers]: /application/markers/deploy-markers.html
