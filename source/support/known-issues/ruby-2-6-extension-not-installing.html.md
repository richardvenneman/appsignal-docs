---
title: Extension not installing on Ruby 2.6
---

On Ruby 2.6 and higher the AppSignal for Ruby gem does not install and no data is being received by AppSignal.com.

## Affected components

- AppSignal for Ruby package versions: `v2.8.0` and earlier (until `v1.0.0`).
- Systems:
  - [Linux](/support/operating-systems.html#linux) libc builds.
  - [Linux](/support/operating-systems.html#linux) musl builds.

## Description

Upon upgrading to Ruby 2.6 or higher on Linux based hosts AppSignal stops reporting data because the AppSignal extension could not be installed on Ruby 2.6. This is caused by system libraries that are not linked against the Ruby installation being required by the AppSignal gem. The two problematic required libraries are `pthread` and `dl`.

In order to fix the installation issue for the AppSignal extension these libraries need to be statically linked to the extension library created during installation of the AppSignal gem in your app. This was added in [Ruby gem `2.8.1`](#solution).

The following AppSignal extension builds are affected:

- [Linux](/support/operating-systems.html#linux) musl builds. Used by Alpine Linux and older libc versions installed on app hosts.
- [Linux](/support/operating-systems.html#linux) libc builds. Used by most Linux distributions, such as Ubuntu.

## Symptoms

- No data is being received by AppSignal from your app after upgrading your app's Ruby version.
- When your application starts AppSignal for Ruby logs the following message in the [`appsignal.log` file](/support/debugging.html#logs):

    ```
    [<timestamp> (process) #<pid>][ERROR] appsignal: Failed to load extension (cannot load such file -- appsignal_extension), please check the install.log file in the ext directory of the gem and email us at support@appsignal.com
    [<timestamp> (process) #<pid>][INFO] appsignal: Not starting appsignal, extension is not loaded
    ```
- The `install.log` file in the AppSignal for Ruby gem `ext/` directory contains a platform specific error message.

    ```
      E, [<timestamp> #<pid>] ERROR -- : Installation failed: Aborting installation, libappsignal.a or appsignal.h not found
    ```

## Workaround

Downgrade to an earlier Ruby version.

## Solution

Upgrade to AppSignal for Ruby gem version `2.8.1`.

Please let us know at support@appsignal.com if you are currently experiencing this issue and an upgrade did not help.
