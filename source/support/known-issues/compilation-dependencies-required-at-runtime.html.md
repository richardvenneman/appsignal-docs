---
title: Extension compilation system dependencies are required at runtime
---

## Affected components

- AppSignal for Elixir package versions: Only `v1.8.0`.
  - Linux builds fixed in `v1.8.1`.
- AppSignal for Ruby package versions: `v2.7.0` and `v2.7.1`, but less likely to occur. Read more in the [description](#description).
  - Linux builds fixed in `v2.7.2`.
- Systems:
  - [Linux](/support/operating-systems.html#linux) musl builds.
  - [Linux](/support/operating-systems.html#linux) libc builds. (Less common.)
  - [FreeBSD](/support/operating-systems.html#freebsd) builds. (Less common.)

## Description

After installing AppSignal for Elixir 1.8.0, or AppSignal for Ruby 2.7.0-2.7.1, no more data is being received by AppSignal. During the start of the app that has AppSignal installed an error message is printed. The app itself is otherwise unaffected.

A new build of the AppSignal extension requires compilation dependencies to be installed on the machine the parent app is executed. This change in behavior, this new requirement, was unintentionally introduced in these AppSignal releases.

This issue is most commonly seen with Elixir apps that have a two stage release process as it's more common for Elixir. On one machine the app is compiled and packaged into a release with a tool such as [Distillery](https://github.com/bitwalker/distillery). The first stage has all the [required compilation dependencies](/support/operating-systems.html), but the second stage does not.

In the affected releases not all dependencies are statically linked during installation of the AppSignal package/gem. The extension is instead dynamically linked to a system library (most likely `libgcc_s`) on the compile stage machine, a package that isn't present on the second stage machine. The missing package causes the AppSignal extension to be unable to start and deactivates itself.

The following builds are affected:

- [Linux](/support/operating-systems.html#linux) musl builds. Used by Alpine Linux and older libc versions installed on app hosts.
- [Linux](/support/operating-systems.html#linux) libc builds. Less likely to be affected, required packages are usually available on the host system.
- [FreeBSD](/support/operating-systems.html#freebsd) builds. Less likely to be affected, required packages are usually available on the host system.

## Symptoms

- No data is being received by AppSignal from your app.
- When your application starts AppSignal for Elixir prints the following message:

    ```
    [error] Failed to start AppSignal. Please run the diagnose task (https://docs.appsignal.com/elixir/command-line/diagnose.html) to debug your installation.
    ```
- The `install.log` file in the AppSignal package contains a platform specific error message.

## Workaround

1. Install the system dependencies for your Operating System as listed on the [Supported Operating Systems page](/support/operating-systems.html) on the host your app is running.
2. Downgrade to AppSignal for Elixir version 1.7.2 or AppSignal for Ruby version 2.6.1.

## Solution

The Linux musl and libc builds are fixed in the latest AppSignal packages.

No specific changes were made for the installation of the AppSignal extension for the FreeBSD build. It's less likely to be affected. No complete fix has been be found either to link the required dependencies to the extension package.

- Elixir package
    - For AppSignal for Elixir a new version with a fix for this issue has been released. Please install AppSignal for Elixir version 1.8.1 or higher.
- Ruby gem
    - For AppSignal for Ruby a new version with a fix for this issue will be released. Please install AppSignal for Ruby version 2.7.2 or higher when available.

Please let us know at support@appsignal.com if you are currently experiencing this issue. It would help us a lot if you provide the following information:

- AppSignal diagnose ([Ruby](/ruby/command-line/diagnose.html) / [Elixir](/elixir/command-line/diagnose.html)) report token. (Send the report to us when prompted.)
- A description of your app's build/compile/release process.
