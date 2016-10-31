---
title: "Webmachine"
---

[Webmachine](https://github.com/webmachine/webmachine-ruby/) works with
AppSignal Ruby gem versions `1.3` and up.

## Installation

A Webmachine application requires a few manual steps to get working.

1. Create a `config/appsignal.yml` configuration file or configure it with
   environment variables. For more information see
   the [Ruby configuration](/ruby/configuration.html) page.
*  Make sure AppSignal is required, `require "appsignal"`.
*  Configure AppSignal using `Appsignal.config`.
*  Start AppSignal using `Appsignal.start`.

An example of a Webmachine `app.rb` file:

```ruby
# app.rb
require "webmachine"
require "appsignal"

Appsignal.config = Appsignal::Config.new(
  Dir.pwd,      # Path to project root directory
  "development" # Environment
)
Appsignal.start_logger
Appsignal.start

class MyResource < Webmachine::Resource
  def to_html
    "<html><body>Hello, world!</body></html>"
  end
end

# Start a web server to serve requests via localhost
MyResource.run
```

After these steps, start your Webmachine app and wait for data to arrive in
AppSignal.
