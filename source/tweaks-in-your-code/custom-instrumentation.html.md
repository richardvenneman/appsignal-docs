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

When you instrument your code using `ActiveSupport::Notifications`
AppSignal will pick up on those instruments. For example, you have to work
with an external API that fetches articles for your homepage:

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

Once you add custom instruments like this AppSignal will start picking
up on them and will show you how much time both a category
(`article_fetcher` in this case) and individual events took.

![Event tree with fetcher](/images/screenshots/event_tree_with_fetcher.png)

In this case you'll notice that this API call is a huge influence on the
performance of our homepage, which was hidden before. We might want to consider
caching the articles.

You can use as many instruments in any combination you like. You can
nest instruments and AppSignal will handle the nesting and aggregates of
the measurements nicely. You just have to keep the final segment (after the last
dot) of the key consistent:

```ruby
ActiveSupport::Notifications.instrument('fetch.article_fetcher') do
  10.times do
    ActiveSupport::Notifications.instrument('fetch_single_article.article_fetcher') do
      # Fetch single article
    end
  end
end
```

`ActiveSupport::Notifications` is highly flexible, you can instrument your code any
way you like. More information about `ActiveSupport::Notifications` can be found in the
[Rails api docs](http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html).
