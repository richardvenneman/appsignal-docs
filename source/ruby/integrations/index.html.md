---
title: "Ruby integrations"
---

## Supported frameworks

AppSignal works with most popular Ruby frameworks such as:

* [Ruby on Rails](#ruby-on-rails)
* [Sinatra](#sinatra)
* [Padrino](#padrino)
* [Grape](#grape)
* [Webmachine](#webmachine)
* [DataMapper](#datamapper)
* [Rack / Other](#rack-other)
* [Capistrano](#capistrano)

For a more detailed examples on how to integrate AppSignal, visit our [examples
repository][examples-repo].

<a name="ruby-on-rails"></a>
# Ruby on Rails

[Ruby on Rails](http://rubyonrails.org/) is supported out-of-the-box by
AppSignal. To install follow the installation steps in AppSignal, start by
clicking 'Add app' on the [accounts screen][appsignal-accounts].

<a name="sinatra"></a>
# Sinatra

[Sinatra](http://www.sinatrarb.com/) is officially supported, but requires a
bit of manual configuration. Follow the installation steps in AppSignal, start
by clicking 'Add app' on the [accounts screen][appsignal-accounts].

After installing the gem you need to add the AppSignal integration require
after `sinatra` (or `sinatra/base`).

```ruby
require 'sinatra' # or require 'sinatra/base'
require 'appsignal/integrations/sinatra'
```

Then create the AppSignal configuration file, `config/appsignal.yml`. See the
[Configuration][gem-configuration] page for more details on how to configure
AppSignal.

After these steps, start your Sinatra app and wait for data to arrive in
AppSignal.

-> **Recent change**  
   Since AppSignal gem version 1.3 you no longer need to manually include the
   `Appsignal::Rack::SinatraInstrumentation` middleware in your application.
   Please remove it from your application.

<a name="padrino"></a>
# Padrino

[Padrino](http://www.padrinorb.com/) is supported by AppSignal, but requires
some manual configuration.

After installing the gem, include the AppSignal Padrino integration.

```ruby
# config/boot.rb
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'appsignal/integrations/padrino' # Add this line
```

Create a AppSignal configuration file, `config/appsignal.yml` or configure it
through environment variables. See the [Configuration][gem-configuration] page
for more details on how to configure AppSignal.

After these steps, start your Padrino app and wait for data to arrive in
AppSignal.

<a name="grape"></a>
# Grape

[Grape](http://www.ruby-grape.org/) works with AppSignal gem version `1.1` and
up.

For older versions of AppSignal, check [grape-appsignal
gem](https://github.com/aai/grape-appsignal) created by [Mark
Madsen](https://github.com/idyll).

## Standalone

A standalone Grape app requires a few manual steps to get working.

* Create a `config/appsignal.yml` configuration file or configure it with
  environment variables. For more information see
  the [Configuration][gem-configuration] page.
* Make sure AppSignal is required, `require 'appsignal'`.
* Require the grape integration, `require 'appsignal/integrations/grape'`.
* Start AppSignal, `Appsignal.start`.

A Grape `config.ru` file looks something like this:

```ruby
# config.ru
require File.expand_path('../config/environment', __FILE__)
require_relative './api.rb'

Appsignal.config = Appsignal::Config.new(
  File.expand_path('../', __FILE__), # The root of your app
  ENV['RACK_ENV'] # The environment of your app (development/production)
)

Appsignal.start_logger
Appsignal.start

run Acme::App
```

An example of a Grape `api.rb` file:

```ruby
# api.rb
# require these two files
require 'appsignal'
require 'appsignal/integrations/grape'

module Acme
  class API < Grape::API
    use Appsignal::Grape::Middleware # Include this middleware

    prefix 'api'
    format :json
    get '/' do
      { :message => 'Hello world!' }
    end
  end
end
```

After these steps, start your Grape app and wait for data to arrive in
AppSignal.

A simple example on integrate AppSignal with Grape can be found in our
[examples repository][examples-repo]. A more complex demo project for Grape can
be found on
[AppSignal/grape-on-rack](https://github.com/appsignal/grape-on-rack)

<a name="webmachine"></a>
# Webmachine

[Webmachine](https://github.com/webmachine/webmachine-ruby/) works with
AppSignal gem version `1.3` and up.

A Webmachine app requires a few manual steps to get working.

* Create a `config/appsignal.yml` configuration file or configure it with
  environment variables. For more information see
  the [Configuration][gem-configuration] page.
* Make sure AppSignal is required, `require 'appsignal'`.
* Configure AppSignal, `Appsignal.config`.
* Start AppSignal, `Appsignal.start`.

An example of a Webmachine `app.rb` file:

```ruby
# app.rb
require 'webmachine'
require 'appsignal'

Appsignal.config = Appsignal::Config.new(
  Dir.pwd,      # Path to project root directory
  'development' # Environment
)
Appsignal.start_logger
Appsignal.start

class MyResource < Webmachine::Resource
  def to_html
    '<html><body>Hello, world!</body></html>'
  end
end

# Start a web server to serve requests via localhost
MyResource.run
```

After these steps, start your Webmachien app and wait for data to arrive in
AppSignal.

<a name="datamapper"></a>
# DataMapper

[DataMapper](http://datamapper.org/) is supported since AppSignal gem version
`1.3`.

The AppSignal gem works out of the box with DataMapper! Nothing to do. Lucky!

<a name="rack-other"></a>
# Rack / Other

The AppSignal gem has a few requirements for it to work properly.

The gem needs the following information:

* A Push API key.
* Application details:
  * root path
  * environment
  * name
* [Middleware that receives instrumentation](https://github.com/appsignal/appsignal-ruby/blob/master/lib/appsignal/rack/generic_instrumentation.rb)

You can configure AppSignal with either a `config/appsignal.yml` configuration
file or using environment variables. For more information, see the
[Configuration][gem-configuration] page.

An example application:
```ruby
require 'appsignal'

root_path = File.expand_path('../', __FILE__)  # Application root path
Appsignal.config = Appsignal::Config.new(
  root_path,
  'development',                               # Application environment
  name: 'logbrowser'                           # Application name
)

Appsignal.start_logger                         # Start logger
Appsignal.start                                # Start the AppSignal agent
use Appsignal::Rack::GenericInstrumentation    # Listener middleware
```

By default all actions are grouped under 'unknown'. You can override this for
every action by setting the route in the environment.

```ruby
env['appsignal.route'] = '/homepage'
```

<a name="capistrano"></a>
# Capistrano

[Capistrano](http://capistranorb.com/) version 2 and 3 are officially supported
by AppSignal, but might require some manual configuration.

Make sure you load the `appsignal/capistrano` file in Capistrano's `Capfile`.
This should be done automatically when you run `appsignal install [YOUR KEY]`.

```ruby
# Capfile
require 'capistrano'
# Other capistrano requires
require 'appsignal/capistrano'
```

## Configuration

### appsignal_config

```ruby
# deploy.rb
set :appsignal_config, { name: 'My app' }
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

[appsignal-accounts]: https://appsignal.com/accounts
[gem-configuration]: /gem-settings/configuration.html
[examples-repo]: https://github.com/appsignal/appsignal-examples
