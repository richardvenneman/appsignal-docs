---
title: "Add custom instrumentation"
---

When you view saved samples of slow requests in AppSignal you'll be able
to see all instrumentations Rails uses internally.
Template renders, `ActiveRecord` queries and caching are instrumented and
will be shown in the sample:

![Default event tree](/images/screenshots/default_event_tree.png)

That's already very useful, but wouldn't it be great if we could see
measurements of specific pieces of code you suspect might influence your
performance? Well, you can!

When you instrument your code with AppSignal we'll pick up on those
instruments. For example, you have to work with an external API that fetches
articles for your homepage:

```ruby
class ArticleFetcher
  def self.fetch(category)
    Appsignal.instrument('fetch.article_fetcher') do
      # Download and process the articles
    end
  end
end

ArticleFetcher.fetch('Latest news')
```

Once you add custom instruments like this AppSignal will start picking them up
and will show you how much time both a category (`article_fetcher` in this
case) and individual events took.

![Event tree with fetcher](/images/screenshots/event_tree_with_fetcher.png)

In this case you'll notice that this API call is a huge influence on the
performance of our homepage, which was hidden before. We might want to consider
caching the articles.

### Instrument nesting

You can use as many instruments in any combination you like. You can
nest instrument calls and AppSignal will handle the nesting and aggregates of
the measurements nicely. You just have to keep the final segment (after the last
dot) of the key consistent. [Read more on key naming](#event_naming).

```ruby
Appsignal.instrument('fetch.article_fetcher') do
  10.times do
    Appsignal.instrument('fetch_single_article.article_fetcher') do
      # Fetch single article
    end
  end
end
```

### Collecting more data

By default AppSignal will collect the duration of an event and send it to our
servers. Since custom instrumentation is not hooked up to any framework
internals you might need to pass along more data if you want event details to
show up in AppSignal. This can be a descriptive title, or more specific
information like the query from a database call. We already do this for
ActiveRecord, Sequel, Redis, MongoDB, Sinatra, Grape,
[and more](/getting-started/supported-frameworks.html).

```ruby
Appsignal.instrument(name, title = nil, body = nil, body_format = Appsignal::EventFormatter::DEFAULT, &block)
```

### `name`

The name of the event that will appear in the event tree in AppSignal.
[Read more on key naming](#event_naming).

### `title`

A more descriptive title of an event, such as `"Load user
hector@appsignal.com"`. This value can be unique per event.

```ruby
Appsignal.instrument('fetch.custom_database', "Load user #{email}") do
  # ...
end
```

### `body`

More details such as a database query that was used by the event.

```ruby
sql = 'SELECT * FROM posts ORDER BY created_at DESC LIMIT 1'
Appsignal.instrument('fetch.custom_database', 'Fetch latest post', sql) do
  # ...
end
```

### `body_format`

TODO: ???

## <a href="#activesupport_notifications" name="activesupport_notifications">ActiveSupport::Notifications</a>

If you're using an older gem version than version 1.3 and you're using Rails
(more specifically ActiveSupport) you can use the built-in
ActiveSupport::Notifications to instrument your code instead.

The method for instrumenting your code using `ActiveSupport::Notifications`
is very similar to how AppSignal does it. Using the article fetcher example
again you can see the differences are quite small.

```ruby
class ArticleFetcher
  def self.fetch(category)
    ActiveSupport::Notifications.instrument('fetch.article_fetcher') do
      # Download and process the articles
    end
  end
end

ArticleFetcher.fetch('Latest news')
```

It works for nested instrumentation calls as well.

```ruby
ActiveSupport::Notifications.instrument('fetch.article_fetcher') do
  10.times do
    ActiveSupport::Notifications.instrument('fetch_single_article.article_fetcher') do
      # Fetch single article
    end
  end
end
```

`ActiveSupport::Notifications` is highly flexible, you can instrument your code
any way you like. More information about `ActiveSupport::Notifications` can be
found in the
[Rails API docs](http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html).

## <a href="#event_naming" name="event_naming">Event name construction</a>

Event names are used for many things in the inner workings of AppSignal.
Picking a good name can help a lot with how AppSignal processes and displays
the incoming data. Naming events can be tricky, but hopefully this short
explanation of what a key name is will help you with picking a good one.

### What is it used for?

The keys used for instrumentation are broken down to be able to group events
together. These groups are then used for the breakdown table on the top of the
performance sample page. This makes it possible to see if it's ActiveRecord or
an API call with Net::HTTP that's causing the most slow down in a request.

A key name is a string consisting of alphanumeric characters, underscores and
periods. Spaces and dashes are not accepted. (`([a-zA-Z0-9_.]+)`)

The first part of a key is everything until the last period `.` in a key. The
second part is everything after this period, this is the group of the event.
The group of an event is the type technology it belongs to or the kind of
action it is, such as a database or HTTP request.

```
sql.active_record
^   ^
|   second part (group)
first part
```

It also works with multiple periods in a key.

```
fetch.partition3.database
^                ^
|                second part (group)
first part
```

We use this last naming scheme for the [method
instrumentation](/tweaks-in-your-code/method-instrumentation.html) ourselves.

When a name with just one part is encountered the event will automatically be
grouped under the `other` group.

### Examples

Some examples of keys that are used by AppSignal integrations:

- ActiveRecord: `sql.active_record`
- Redis: `query.redis`
- Elasticsearch: `search.elasticsearch`
- ActionView: `render_template.action_view` and `render_partial.action_view`
- Ruby's Net::HTTP: `request.net_http`
- Sidekiq: `perform_job.sidekiq`
- [Method instrumentation](/tweaks-in-your-code/method-instrumentation.html):
  `method_name.ClassName.other` and `method_name.class_method.NestedClassName.ParentModule.other`
