---
title: "Padrino"
---

[Padrino](http://www.padrinorb.com/) is supported by AppSignal, but requires
some manual configuration.

After installing the gem, include the AppSignal Padrino integration.

```ruby
# config/boot.rb
require "rubygems" unless defined?(Gem)
require "bundler/setup"
require "appsignal/integrations/padrino" # Add this line
```

Create an AppSignal configuration file, `config/appsignal.yml` or configure it
through environment variables. See the [Ruby
configuration](/ruby/configration.html) page for more details on how to
configure AppSignal.

After these steps, start your Padrino app and wait for data to arrive in
AppSignal.
