
## Rake task monitoring

With AppSignal gem version `0.11.13`, we've added Rake task monitoring.

Simply add `require 'appsignal/integrations/rake'` to your RakeFile like this:

```ruby
#!/usr/bin/env rake
require File.expand_path('../config/application', __FILE__)
require 'appsignal/integrations/rake'

MyApp::Application.load_tasks

```

And every exception in a Rake task will be sent to AppSignal under the "Background" namespace. Note that we only track exceptions in Rake tasks. There is no performance monitoring.
