---
title: "Integration gems"
---

-> **Deprecated gems**  
-> The gems described on this page are deprecated. They are only used for the
   appsignal gem version 0.x.  
-> When using the gem 1.x release and up no separate gems are required. Please
   consult the
   [supported frameworks](/getting-started/supported-frameworks.html) page what
   configuration integrations might need.

Rails instruments ActiveRecord queries by default. But what if you use
another database, such as MongoDB or Redis?

No worries, we've got you covered. AppSignal won't pick up notifications for
these databases if you only add the AppSignal gem, but we have made it very
easy for you to add instrumentation to some of the most widely used alternative
databases.

Just add one of the following gems to your Gemfile:

## Mongo

Use with with the 10gen Mongo driver that's used in Mongoid 2 and MongoMapper.

```ruby
gem 'appsignal-mongo'
```

## Moped

Use with the Moped driver that's used in Mongoid 3.
Mongoid 4 has it's own instrumentation and this gem is not needed.

```ruby
gem 'appsignal-moped'
```

## Redis

Use with the redis-rb gem.

```ruby
gem 'appsignal-redis'
```

## Tire

Use with the tire gem for elasticsearch. Other elasticsearch gems already have
instrumentation, such as
[elasticsearch-rails](https://github.com/elasticsearch/elasticsearch-rails)
work out-of-the-box.

```ruby
gem 'appsignal-tire'
```

Next deploy your app and we will start receiving data from these
instrumentations straight away.
