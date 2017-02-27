---
title: "AppSignal for Ruby: Diagnose tool"
---

The AppSignal Ruby gem ships with a self diagnostic tool. This tool can be used
to debug your AppSignal installation and is one of the first thing our support
team asks for when there's an issue.

This command line tool is useful when testing AppSignal on a system and
validating the local configuration. It outputs useful information to debug
issues and it checks if AppSignal agent is able to run on the machine's
architecture and communicate with the AppSignal servers.

This diagnostic tool outputs the following:

- Wether AppSignal can run on the host system.
- Wether the configuration is valid and active.
- Wether the Push API key is present and valid (internet connection required).
- Wether the required system paths exist and are writable.
- Outputs AppSignal version information.
- Outputs information about the host system and Ruby.
- Outputs last lines from the available log files.

Read more about how to use the diagnose command on the
[Debugging][debugging] page.

This tool is available since version 1.1.0 of the AppSignal Ruby gem.

## Usage

### On the command line in your project

```bash
appsignal diagnose
```

### With a specific environment

```bash
appsignal diagnose --environment=production
```

## Exit codes

- Exits with status code `0` if the diagnose command has finished.
- Exits with status code `1` if the diagnose command failed to finished.

[debugging]: /support/debugging.html
