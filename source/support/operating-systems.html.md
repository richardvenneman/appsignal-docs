---
title: "Supported Operating Systems"
---

- [Linux](#linux)
  - [Alpine Linux](#alpine-linux)
      - [Ruby](#alpine-linux-ruby)
      - [Elixir](#alpine-linux-elixir)
- [FreeBSD](#freebsd)
- [macOS](#macos)
- [Microsoft Windows](#microsoft-windows)

---

| Operating System                  | 32-bit support | 64-bit support |
| --------------------------------- | -------------- | -------------- |
| macOS/OSX (`darwin`) <sup>1</sup> |                | ✓              |
| Debian                            | ✓              | ✓              |
| Fedora                            | ✓              | ✓              |
| Alpine Linux <sup>2</sup>         | ✓              | ✓              |
| FreeBSD <sup>1</sup>              |                | ✓              |
| Microsoft Windows <sup>3</sup>    |                |                |

- `1`: does not support [host metrics][host-metrics] (yet).
- `2`: Supported since AppSignal for [Ruby](/ruby) version `2.1.x` and AppSignal for [Elixir](/elixir) version `0.11.0`.
- `3`: Untested with the Windows subsystem for Linux.

## Linux

The AppSignal integrations for Ruby and Elixir contains native extensions and a separate lightweight agent process. These native extensions are supported on most Linux distributions. We test on Ubuntu, Fedora and Alpine Linux. If a Linux distribution you use is not supported, please [get in touch](mailto:support@appsignal.com).

### Alpine Linux

[Alpine Linux] support was added in version `2.1.0` of the AppSignal for Ruby gem. Our AppSignal for Elixir package supports Alpine Linux since version `0.11.0`.

In AppSignal for Ruby version 2.4.0 and AppSignal for Elixir we started shipping a separate build for Alpine Linux. Detection is based on the output from `ldd --version`. If your app is unable to call this program you can force the Alpine Linux compatible build by providing a special environment variable on install.

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

## FreeBSD

Support for FreeBSD systems was added in AppSignal for Ruby gem `2.4.0` and AppSignal for Elixir package `1.4.0`.

## macOS

macOS (OSX) is supported by AppSignal for Ruby and Elixir. It currently does not support the [host metrics][host-metrics] feature.

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
