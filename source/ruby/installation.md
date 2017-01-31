---
title: "Installing AppSignal for Ruby"
---

## Installation

### Requirements

Before you can compile the AppSignal gem make sure the build/compilation tools
are installed for your system.

**Ubuntu / Debian**

```
sudo apt-get update
sudo apt-get install build-essential
```

**Alpine Linux**

```
apk add --update alpine-sdk coreutils
```

**macOS**

```
xcode-select --install
```

### Installing the gem

We recommend you install and manage the AppSignal gem dependency with
[Bundler](http://bundler.io/).

Add the following line to your `Gemfile`.

```ruby
# Gemfile
source "https://rubygems.org"

gem "appsignal"
```

Then run `bundle install` to instal the gem.

To install AppSignal in your application we recommend you run the `appsignal
install` command.

```
bundle exec appsignal install
```

This will present you with an installation script that can integrate
automatically in some frameworks and gems and will allow you to configure
AppSignal.

For more information on how to integrate AppSignal into your application see
the [integrations documentation](/ruby/integrations/index.html) to see what
steps are necessary.
