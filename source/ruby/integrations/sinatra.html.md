---
title: "Sinatra"
---

[Sinatra](http://www.sinatrarb.com/) is officially supported, but requires a
bit of manual configuration. Follow the installation steps in AppSignal, start
by clicking 'Add app' on the [accounts screen](https://appsignal.com/accounts).

After installing the gem you need to add the AppSignal integration require
after `sinatra` (or `sinatra/base`).

```ruby
require "sinatra" # or require 'sinatra/base'
require "appsignal/integrations/sinatra"
```

Then create the AppSignal configuration file, `config/appsignal.yml`. See the
[Ruby configuration](/ruby/configuration.html) page for more details on how to
configure AppSignal.

After these steps, start your Sinatra app and wait for data to arrive in
AppSignal.

-> **Recent change**  
   Since AppSignal gem version 1.3 you no longer need to manually include the
   `Appsignal::Rack::SinatraInstrumentation` middleware in your application.
   Please remove it from your application.
