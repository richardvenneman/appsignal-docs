---
title: "Supported Operating Systems"
---

## Linux and macOS

The AppSignal integrations for Ruby and Elixir contains native extensions and a
separate light-weight agent process. These native extensions are supported on
most Linux distributions and macOS.

### Alpine Linux

[Alpine Linux] support was added in version `2.1.0` of the AppSignal gem. Our
Elixir package supports Alpine Linux since version `0.10.0`.

Alpine Linux was originally not supported because our agent, which is written in
[Rust], does not fully support Alpine Linux's [musl] C standard library yet.
This has been reported upstream to the Rust team and they are working to improve
support for Alpine Linux.

#### Ruby

For the Ruby gem add this to your `Gemfile`:

```ruby
gem "appsignal", ">= 2.1.0" # or a newer version
```

For the latest available version see the full list on
[RubyGems.org](https://rubygems.org/gems/appsignal/versions) and if you run
into any problems please [let us know](mailto:support@appsignal.com).

#### Elixir

If you're using Elixir, add this to your `mix.exs` file:

```elixir
{:appsignal, ">= 1.0.0"} # or a newer version
```

For the latest available version see the full list on
[Hex.pm](https://hex.pm/packages/appsignal) and if you run
into any problems please [let us know](mailto:support@appsignal.com).

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
