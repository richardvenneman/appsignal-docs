---
title: "AppSignal for Ruby"
---

AppSignal supports the [Ruby language][ruby-lang] with a [Ruby
gem][appsignal-gem]. The gem supports many frameworks and gems out-of-the-box.
Some gems and frameworks might require some custom instrumentation.

It's also supported to add custom instrumentation to your application and get
even more insights into the performance of your code.

## Table of Contents

- [Installation](/ruby/installation.html)
- [Configuration](/ruby/configuration/index.html)
- [Integrations](/ruby/integrations/index.html)
- [Custom instrumentation](/ruby/instrumentation/index.html)
- [Command line tools](/ruby/command-line/index.html)
- [Ruby implementation support](#ruby-implementation-support)
  - [Ruby MRI](#ruby-mri)
  - [jRuby](#jruby)

## Configuration

In the configuration topic we'll explain how to configure AppSignal, what can
be configured in the Ruby gem, what's the minimal configuration needed and how
the configuration is loaded.

See our [configuration](/ruby/configuration/index.html) page for the
configuration documentation of the AppSignal gem.

## Integrations

The AppSignal Ruby gem integrates with many frameworks like Rails, Sinatra,
Padrino, Grape, and more.

See our [integrations](/ruby/integrations/index.html) page for the full list
and implementation details.

## Custom instrumentation

Add custom instrumentation to your application or make your own integrations
with AppSignal, see the [instrumentation](/ruby/instrumentation/index.html)
topic for more details.

## Command line tools

The AppSignal Ruby gem ships with several command line tools. These
tools make it easier to install AppSignal in an application, send deploy
notifications and diagnose any problems with the installation.

See our [command line tools](/ruby/command-line/index.html) page for a full
list of all the available commands.

## Ruby implementation support

### Ruby (MRI)

We currently support Ruby `1.9.3+` for the latest gem version `1.x`. To use
this version add to your `Gemfile`.

```ruby
gem 'appsignal'
```

### jRuby

-> ❗️ jRuby support is available in an alpha release of the AppSignal Ruby gem in version `2.5.0.alpha.1`

jRuby support was not available between version `0.11.x` and `2.4.x` of the AppSignal Ruby gem. We've recently started an alpha trial in version `2.5.0.alpha.1` of the AppSignal Ruby gem. Install it by adding the following to your `Gemfile` and running `bundle install`/`bundle update appsignal`.

```ruby
gem "appsignal", "2.5.0.alpha.1"
```

If you want to keep using the latest non-alpha supported release of our gem with jRuby support, please use version `0.11.18`.

[ruby-lang]: https://www.ruby-lang.org/
[appsignal-gem]: https://rubygems.org/gems/appsignal
