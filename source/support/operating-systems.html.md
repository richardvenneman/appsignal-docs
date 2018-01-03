---
title: "Supported Operating Systems"
---

The AppSignal integrations for Ruby and Elixir contains native extensions and a separate lightweight agent process. These native extensions are supported on most Linux distributions, FreeBSD and macOS/OSX. If an Operating System you use is not supported, please [get in touch](mailto:support@appsignal.com).

- [Support table](#support-table)
- [Linux](#linux)
  - [Supported versions](#supported-versions)
  - [Alpine Linux](#alpine-linux)
      - [Ruby](#alpine-linux-ruby)
      - [Elixir](#alpine-linux-elixir)
  - [CentOS](#centos)
  - [Debian / Ubuntu](#debian-ubuntu)
  - [Fedora](#fedora)
- [FreeBSD](#freebsd)
- [macOS / OS X](#macos)
- [Microsoft Windows](#microsoft-windows)

## Support table

| Operating System                                     | 32-bit support | 64-bit support |
| ---------------------------------------------------- | -------------- | -------------- |
| macOS/OSX (`darwin`) <sup>1</sup>                    |                | ✓              |
| Linux <sup>2</sup>                                   | ✓              | ✓              |
| &nbsp;&nbsp;&nbsp;&nbsp; - Alpine Linux <sup>3</sup> | ✓              | ✓              |
| &nbsp;&nbsp;&nbsp;&nbsp; - CentOS                    | ✓              | ✓              |
| &nbsp;&nbsp;&nbsp;&nbsp; - Debian                    | ✓              | ✓              |
| &nbsp;&nbsp;&nbsp;&nbsp; - Fedora                    | ✓              | ✓              |
| FreeBSD <sup>1</sup>                                 |                | ✓              |
| Microsoft Windows <sup>4</sup>                       |                |                |

- `1`: Does not support [host metrics][host-metrics] (yet).
- `2`: Depending on the integration version some older versions of the Operating System are supported. See the [Linux](#linux) section for more information.
- `3`: Supported since AppSignal for [Ruby](/ruby) version `2.1.x` and AppSignal for [Elixir](/elixir) version `0.11.0`.
- `4`: Untested with the Windows subsystem for Linux.

## Linux

AppSignal tries to support Linux as best as possible, but some changes in our build process have caused some problems with supporting certain Linux distributions and versions. Our agent and extension are compiled against libc, and based on which version of libc we compile against we support certain older versions of Linux distributions and some not.

### Supported versions

AppSignal support for versions of libc has changed over the past few versions of the Ruby gem and Elixir package.

This is the list of version of libc/musl AppSignal was compiled against over the last version of our integrations:

- AppSignal for Ruby `v1.0.0` - `v2.0.x`  
  AppSignal for Elixir `v0.0.x` - `v0.10.x`
  - libc `v2.5`
  - musl `N/A`
- AppSignal for Ruby `v2.1.x` - `v2.3.x`  
  AppSignal for Elixir `v0.11.x` - `v1.3.x`
  - libc `N/A` - see [DNS timeouts known issue](/support/known-issues/dns-timeouts.html).
  - musl `v1.1.16`
- AppSignal for Ruby `v2.4.x` and higher  
  AppSignal for Elixir `v1.4.x` and higher
  - libc `v2.15`
  - musl `v1.1.16` - see [Alpine Linux install problems after upgrading](/support/known-issues/alpine-linux-ruby-gem-2-4-elixir-package-1-4-upgrade-problems.html).

If your system uses an older libc version than we compile against you will experience problems installing or running the AppSignal agent. If this is the case you can instead opt-in to the musl build, which doesn't have this issue. This should no longer be a problem for AppSignal Ruby gem `v2.4.1` and higher, automatic detection for older libc versions was added and it will automatically switch to the musl build.

To opt-in to the musl build manually, add the `APPSIGNAL_BUILD_FOR_MUSL` environment variable to your system environment before installing AppSignal and compiling your application.

```sh
# For Ruby
export APPSIGNAL_BUILD_FOR_MUSL=1
gem install appsignal
# or with Bundler
bundle install

# For Elixir
export APPSIGNAL_BUILD_FOR_MUSL=1
mix deps.get
mix compile
```

You can see which version of libc your system uses by running the following command: `ldd --version 2>&1`

Example of output on Ubuntu 12.04:

```
$ ldd --version 2>&1
ldd (Ubuntu EGLIBC 2.15-0ubuntu10.18) 2.15
Copyright (C) 2012 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.
```

### Alpine Linux

[Alpine Linux] support was added in version `2.1.0` of the AppSignal for Ruby gem. Our AppSignal for Elixir package supports Alpine Linux since version `0.11.0`.

The following system dependencies are required for Alpine Linux:

```
# Dependencies for the AppSignal Ruby gem
apk add --update alpine-sdk coreutils

# Dependencies for the AppSignal Elixir package
apk add --update alpine-sdk coreutils curl
```

In AppSignal for Ruby version `2.4.0` and AppSignal for Elixir `1.4.0` we started shipping a separate build for Alpine Linux. If you upgraded from an earlier version and are have problems compiling your app, our detection isn't working properly. See our [upgrading issue](/support/known-issues/alpine-linux-ruby-gem-2-4-elixir-package-1-4-upgrade-problems.html) for more information.

For the Ruby gem, detection is based on the output from `ldd --version`. For the Elixir package we listen to the output of `:erlang.system_info(:system_architecture)`.

If your app is unable to call the `ldd` program or the detection is off for some reason, you can force the Alpine Linux compatible build by providing a special environment variable on install.

```sh
# For Ruby
export APPSIGNAL_BUILD_FOR_MUSL=1
gem install appsignal
# or with Bundler
bundle install

# For Elixir
export APPSIGNAL_BUILD_FOR_MUSL=1
mix deps.get
mix compile
```

#### Ruby

For the Ruby gem add this to your `Gemfile`:

```ruby
gem "appsignal", ">= 2.1.0" # or a newer version
```

For the latest available version see the full list on [RubyGems.org](https://rubygems.org/gems/appsignal/versions) and if you run into any problems please [let us know](mailto:support@appsignal.com).

#### Elixir

If you're using Elixir, add this to your `mix.exs` file:

```elixir
{:appsignal, ">= 1.0.0"} # or a newer version
```

For the latest available version see the full list on [Hex.pm](https://hex.pm/packages/appsignal) and if you run into any problems please [let us know](mailto:support@appsignal.com).

### CentOS

CentOS is fully supported by the AppSignal extension. Depending on your CentOS version you may need to select another build type for AppSignal Ruby gem `v2.4.0` and AppSignal for Elixir `v1.4.0` and higher.

The following system dependencies are required for CentOS:

```
# Dependencies for the AppSignal Ruby gem
yum install gcc gcc-c++ make openssl-devel

# Dependencies for the AppSignal Elixir package
yum install gcc gcc-c++ make openssl-devel curl
```

For CentOS 7 and higher there is no problem upgrading to AppSignal for Ruby `v2.4.0` and AppSignal for Elixir `1.4.0` and higher.

For CentOS 6 and older versions you will need to opt-in to the musl build for AppSignal instead. For more information, see the [Linux section](#linux).

### Debian / Ubuntu

The following system dependencies are required for Debian Linux distributions:

```
# Dependencies for the AppSignal Ruby gem
apt-get update
apt-get install build-essential ca-certificates

# Dependencies for the AppSignal Elixir package
apt-get update
apt-get install build-essential ca-certificates curl
```

### Fedora

The following system dependencies are required for Fedora Linux distributions:

```
# Dependencies for the AppSignal Ruby gem
dnf install gcc gcc-c++ make openssl-devel

# Dependencies for the AppSignal Elixir package
dnf install gcc gcc-c++ make openssl-devel curl
```

## FreeBSD

Support for FreeBSD systems was added in AppSignal for Ruby gem `2.4.0` and AppSignal for Elixir package `1.4.0`. It currently does not support the [host metrics][host-metrics] feature.

The following system dependencies are required for FreeBSD Linux distributions:

```
dnf install gcc gcc-c++ make openssl-devel
```

## macOS

macOS (OS X) is supported by AppSignal for Ruby and Elixir. It currently does not support the [host metrics][host-metrics] feature.

Please make sure Xcode is installed with the command line build tools.

```
xcode-select --install
```

## Microsoft Windows

We currently have no plans to support the [Microsoft Windows](https://www.microsoft.com/en-us/windows/) Operating System. We do try to make the AppSignal libraries installable on Microsoft Windows without any errors or build issues so that the app it's installed in continues to operate.

If you use Microsoft Windows and would like us to support it, [send us an e-mail](mailto:support@appsignal.com).

### Ruby

Do make sure you have the [RubyInstaller](https://rubyinstaller.org/) DevKit installed before installing AppSignal. Otherwise there will be the following error during installation of our C-extension.

```
$ gem install appsignal
Fetching appsignal 2.2.1
Installing appsignal 2.2.1 with native extensions
Gem::InstallError: The 'appsignal' native gem requires installed build tools.
Please update your PATH to include build tools or download the DevKit
from 'http://rubyinstaller.org/downloads' and follow the instructions
at 'http://github.com/oneclick/rubyinstaller/wiki/Development-Kit'
```

[Alpine Linux]: https://alpinelinux.org/
[musl]: https://www.musl-libc.org/
[Rust]: https://www.rust-lang.org/en-US/
[host-metrics]: /metrics/host.html
