---
title: "Configure filter parameter logging"
---

In most apps at least some of the data that might be posted to the app
is sensitive information that should not leave the network. Luckily
Rails provides a parameter filtering mechanism to scrub this data from
log files.

AppSignal leverages this mechanism so you can centralize this
configuration. Both your logs and the data sent to AppSignal will be
filtered with a single piece of configuration.

## [Filtering specific keys - Blacklisting](#blacklisting)

There are two ways to determine which keys get filtered. The first one
is blacklisting specific keys. In this example the value of `:secret`
in any post in the app will  be replaced with `[FILTERED]`.

```ruby
# config/application.rb
module Blog
  class Application < Rails::Application
    config.filter_parameters << :secrets
  end
end
```

The downside of this approach is that it becomes more difficult when dealing
with larger, more complex applications. Especially when using features
like `accepts_nested_attributes_for`. If we forget to explicitly add
keys they will not be filtered.

## [Allowing specific keys - Whitelisting](#whitelisting)

If you use a lambda instead of a list of keys you get a lot of
flexiblity. In the following example we use a lambda to setup a
whitelist instead of a blacklist.

```ruby
# config/initializers/parameter_whitelisting.rb
WHITELISTED_KEYS_MATCHER = /((^|_)ids?|action|controller|code$)/.freeze
SANITIZED_VALUE = '[FILTERED]'.freeze

config.filter_parameters << lambda do |key, value|
  unless key.match(WHITELISTED_KEYS_MATCHER)
    value.replace(SANITIZED_VALUE)
  end
end
```

You can of course let the lambda do anything you'd like, so you can come
up with your own way of determining what needs to be filtered.

Some further information about filtering parameters can be found in the Rails
guide about [ActionController](http://guides.rubyonrails.org/action_controller_overview.html#parameter-filtering).

## Filter all parameters

To filter all parameters without using the ActionController filtering, set `send_params` to false in your `appsignal.yml`:

```
send_params: false
```

## Skip sending session data

If you don't want to send you session data to AppSignal you can add this to the config in `appsignal.yml`:

```
skip_session_data: true
```
