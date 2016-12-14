---
title: "AppSignal for Ruby"
---

AppSignal supports the [Ruby language][ruby-lang] with a [Ruby
gem][appsignal-gem]. The gem supports many frameworks and gem out-of-the-box,
but some gems and frameworks might require some [custom
instrumentation](/ruby/instrumentation/index.html).

## Integrations

The AppSignal Ruby gem integrates with many frameworks like Rails, Sinatra,
Padrino, Grape, etc.

See our [integrations](/ruby/integrations/index.html) page for the full list
and implementation details.

## Configuration

It's possible to configure the AppSignal Ruby gem using an initializer, a
configuration file or using environment variables. Read more about [configuring
AppSignal](/ruby/configuration/index.html).

## Instrumentation

To make your own integrations with AppSignal or to add custom instrumentation
to your application, see the
[instrumentation](/ruby/instrumentation/index.html) pages.

## Ruby implementation support

### Ruby (MRI)

We currently support Ruby `1.9.3+` for the latest gem version `1.x`. To use
this version add to your `Gemfile`.

```ruby
gem 'appsignal'
```

### jRuby

At the moment please install the `0.11` version of the appsignal gem if you use
jRuby. Add this line to your `Gemfile`:

```ruby
gem 'appsignal', '~> 0.11.17'
```

We are working to support jRuby for the `1.x` release, but cannot provide an
ETA at this time.

[ruby-lang]: https://www.ruby-lang.org/
[appsignal-gem]: https://rubygems.org/gems/appsignal
