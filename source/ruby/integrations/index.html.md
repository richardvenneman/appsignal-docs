---
title: "Ruby integrations"
---

AppSignal works with most popular Ruby frameworks and gems such as:

* [Capistrano](capistrano.html)
* [DataMapper](datamapper.html)
* [Delayed Job](delayed-job.html)
* [Grape](grape.html)
* [Padrino](padrino.html)
* [MongoDB](mongodb.html)
* [Rack / Other](#rack-other)
* [Rake](rake.html)
* [Resque](resque.html)
* [Ruby on Rails](rails.html)
* [Sequel](sequel.html)
* [Shoryuken](shoryuken.html)
* [Sidekiq](sidekiq.html)
* [Sinatra](sinatra.html)
* [Webmachine](webmachine.html)

We try to make most integrations work out-of-the-box, but some might require
some manual configuration steps.

It's always possible to integrate AppSignal manually in any system.

For a more detailed examples on how to integrate AppSignal, visit our [examples
repository][examples-repo].

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

[gem-configuration]: /gem-settings/configuration.html
[examples-repo]: https://github.com/appsignal/appsignal-examples
