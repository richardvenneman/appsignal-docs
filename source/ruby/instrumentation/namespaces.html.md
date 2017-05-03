---
title: "Custom namespaces for Ruby apps"
---

-> **Note**: Support for custom namespaces was added in version 2.2.0 of the
   AppSignal for Ruby gem.

For more information about what namespaces are, please see our
[namespaces](/application/namespaces.html) documentation.

## Configuring a namespace

Using the [`Appsignal.set_namespace`][set_namespace] helper method it's
possible to set a namespace for a
[transaction](/appsignal/terminology.html#transactions). This can be done per
transaction with custom instrumentation or added in a `before_action` callback
in Rails to configure it for all requests of a certain Rails controller.

It's also possible to configure the namespace when creating the transaction.
The second argument of
[`Appsignal::Transaction.initialize`][transaction_initialize] accepts the
namespace value.

Once the namespace is set and the application is sending data to the AppSignal
servers, the new namespace will appear in the navigation on AppSignal.com.
Note: Data previously reported for the same action is not moved to the new
namespace.

```ruby
# In a Rails controller
class AdminController < ApplicationController
  before_action :set_appsignal_namespace

  def set_appsignal_namespace
    Appsignal.set_namespace("admin")
  end
end

# Appsignal.set_namespace("admin") is a helper for:
Appsignal::Transaction.current.set_namespace("admin")
```

Or when creating a new transaction. Useful in [custom
integrations](/ruby/instrumentation/integrating-appsignal.html).

```ruby
# When creating a new transaction
transaction = Appsignal::Transaction.create(
  SecureRandom.uuid,
  "admin",
  Appsignal::Transaction::GenericRequest.new({})
)

# When changing the namespace later on for a transaction
transaction.set_namespace("slow_admin")
```

[set_namespace]: http://www.rubydoc.info/gems/appsignal/Appsignal.set_namespace
[transaction_initialize]: http://www.rubydoc.info/gems/appsignal/Appsignal%2FTransaction:initialize
