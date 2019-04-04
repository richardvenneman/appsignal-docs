---
title: "Rack"
---

To instrument Rack applications AppSignal provides an instrumentation middleware which can be added to any Rack application.

To [integrate AppSignal][integrating] in a Rack application we first need to load, [configure][configuration] and start AppSignal.

```ruby
require 'appsignal'                           # Load AppSignal

Appsignal.config = Appsignal::Config.new(
  File.expand_path('../', __FILE__),          # Application root path
  'development',                              # Application environment
  :name => 'logbrowser'                       # Optional configuration hash
)

Appsignal.start                               # Start the AppSignal integration
Appsignal.start_logger                        # Start logger
```

Lastly we need to add the instrumentation middleware to the application.

```ruby
use Appsignal::Rack::GenericInstrumentation
```

By default all HTTP requests/actions are grouped under the 'unknown' group. You can override this for an action by setting the route in the request environment.

```ruby
env["appsignal.route"] = "GET /homepage"
```

Or by using the `Appsignal.set_action` helper method in your Rack endpoints.

```ruby
Appsignal.set_action("GET /homepage")
```

For better insights it's recommended to [add additional instrumentation][instrumentation] to the Rack application.

[configuration]: /ruby/configuration
[integrating]: /ruby/instrumentation/integrating-appsignal.html
[instrumentation]: /ruby/instrumentation/instrumentation.html
