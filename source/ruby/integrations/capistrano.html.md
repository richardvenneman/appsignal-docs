---
title: "Capistrano"
---

[Capistrano](http://capistranorb.com/) versions 2 and 3 are officially
supported by the AppSignal Ruby gem, but might require some manual
configuration.

## Installation

Make sure you load the `appsignal/capistrano` file in Capistrano's `Capfile`.
This should be done automatically when you run the `appsignal install` command
during installation.

```ruby
# Capfile
require 'capistrano'
# Other Capistrano requires.
require 'appsignal/capistrano'
```

## Configuration

### appsignal_config

```ruby
# deploy.rb
set :appsignal_config, name: 'My app'
```

`appsignal_config` allows you to override any config loaded from the
`appsignal.yml` configuration file.

### appsignal_env (since gem version 1.3)

```ruby
# deploy.rb
set :stage, :alpha
set :appsignal_env, :staging
```

`appsignal_env` allows you to load a different AppSignal environment when a
stage name doesn't match the AppSignal environment as named in the AppSignal
config file or environment variable.

## Example applications

We have two example applications in our examples repository on GitHub. The
examples show how to set up AppSignal in small Capistrano applications while
loading configuration values from the environment using gems like dotenv and
Figaro.

- [AppSignal + Capistrano + dotenv][example-dotenv-app]
- [AppSignal + Capistrano + Figaro][example-figaro-app]

[example-dotenv-app]: https://github.com/appsignal/appsignal-examples/tree/capistrano+dotenv
[example-figaro-app]: https://github.com/appsignal/appsignal-examples/tree/capistrano+figaro
