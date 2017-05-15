---
title: "Rack"
---

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
