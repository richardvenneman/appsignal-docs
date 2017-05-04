---
title: "Grape"
---

[Grape](http://www.ruby-grape.org/) support is integrated in AppSignal Ruby gem
versions `1.1` and up.

For older versions of the AppSignal Ruby gem, check [grape-appsignal
gem](https://github.com/aai/grape-appsignal) created by [Mark
Madsen](https://github.com/idyll).

## Installation

A Grape application requires a few manual steps to get working.

1. Create a `config/appsignal.yml` configuration file or configure it with
   environment variables. For more information see
   the [Ruby configuration](/ruby/configuration.html) page.
*  Make sure AppSignal is required, `require "appsignal"`.
*  Require the Grape integration, `require "appsignal/integrations/grape"`.
*  Start AppSignal, `Appsignal.start`.

A Grape `config.ru` file looks something like this:

```ruby
# config.ru
require File.expand_path("../config/environment", __FILE__)
require_relative "./api.rb"

Appsignal.config = Appsignal::Config.new(
  File.expand_path("../", __FILE__), # The root of your app
  ENV["RACK_ENV"] # The environment of your app (development/production)
)

Appsignal.start_logger
Appsignal.start

run Acme::App
```

An example of a Grape `api.rb` file:

```ruby
# api.rb
# require these two files
require "appsignal"
require "appsignal/integrations/grape"

module Acme
  class API < Grape::API
    use Appsignal::Grape::Middleware # Include this middleware

    prefix "api"
    format :json
    get "/" do
      { :message => "Hello world!" }
    end
  end
end
```

After these steps, start your Grape application and wait for data to arrive in
AppSignal.

## Example app

We have an [example application][example-app] in our examples repository on
GitHub. The example shows how to set up AppSignal with Grape.

[example-app]: https://github.com/appsignal/appsignal-examples/tree/grape
