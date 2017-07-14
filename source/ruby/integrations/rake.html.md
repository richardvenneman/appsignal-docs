---
title: "Rake task monitoring"
---

The AppSignal gem version supports [Rake][rake] since version `0.11.13` of the gem.

Every exception recorded in a Rake task will be sent to AppSignal and filed under the "Background" [namespace](/application/namespaces.html). Note that we only track exceptions in Rake tasks. There is no performance monitoring for Rake tasks.

(To manually integrate performance monitoring in select Rake tasks please see our [integration guide][integration] and [custom instrumentation guide][custom-instrumentation].)

Depending on what version of the AppSignal gem you use and in what context some manual steps are required.

## Table of Contents

- [Rails applications](#rails-applications)
- [Ruby applications](#ruby-applications)
- [Examples](#examples)

## Rails applications

For Rails applications make sure you depend on the `:environment` task. This loads the Rails application into memory and starts AppSignal as part of the application.

```ruby
# lib/tasks/my_task.rb

task :my_task => :environment do
  # do stuff
end
```

### Rakefile

Your Rails application's `Rakefile` should look something like the example below. This should already be the case, no need to change it.

```ruby
# Rakefile
require File.expand_path("../config/application", __FILE__)

# Only require this file for gem version < 1.0
# require "appsignal/integrations/rake"

Rails.application.load_tasks
```

(For older versions of the AppSignal gem, versions `< 1`, you will need to require the Rake integration manually. It is automatically loaded for version `1.x` and higher.)

## Ruby applications

For pure Ruby applications some extra steps are required to load AppSignal. AppSignal needs to be required, configured and loaded. See the example below.

```ruby
# Rakefile
require "appsignal"

Appsignal.config = Appsignal::Config.new(Dir.pwd, "development")
Appsignal.start
Appsignal.start_logger

task :foo do
  raise "bar"
end
```

When not relying on our automatic exception handling, and instead using `Appsignal.send_error` another step is required. To flush the recorded error to our [agent](/appsignal/terminology.html#agent) it's necessary to call `Appsignal.stop("rake")`. This is normally done for you with the AppSignal exception handling, but is necessary in this scenario.

```ruby
# Rakefile
require "appsignal"

Appsignal.config = Appsignal::Config.new(Dir.pwd, "development")
Appsignal.start
Appsignal.start_logger

task :foo do
  Appsignal.send_error StandardError.new("bar")
  # "rake" is the parent process name which is being stopped and the reason why
  # AppSignal is stopping.
  Appsignal.stop "rake"
end
```

For more information on how to integrate AppSignal in a pure Ruby application, see our [integration guide][integration].

## Examples

### Rake application

See our example repository for a [Ruby + Rake + AppSignal][ruby-rake-example] example application.

### A more comprehensive example using threads

Add performance monitoring to a continuously running multi-threaded Rake task for `v1.1.6`. Based on work of leehambley.

```ruby
# Rakefile
namespace :mycrazyproject do
  task :do_something => :environment do
    while true
      User.where(:active => true).find_in_batches(:batch_size => 20) do |batch_of_users|
        # We collect a bunch of new threads, one for each
        # user, each...
        batch_threads = batch_of_users.collect do |user_outer|
          Thread.new(user_outer) do |u|
            transaction.set_action("name.of.background.action.you.want.in.appsignal")

            begin
              ActiveSupport::Notifications.instrument(
                'perform_job.long_running_task',
                :class => 'User',
                :method => 'long_running_task'
              ) do
                  u.long_running_task
                end
              rescue => err
                transaction.set_error(err)
              ensure
                # Complete the transaction
                Appsignal::Transaction.complete_current!
              end
          end
        end

        # Joining threads means waiting for them to finish
        # before moving onto the next batch.
        batch_threads.map(&:join)
      end
    end
  end
end
```

[rake]: https://github.com/ruby/rake
[integration]: /ruby/instrumentation/integrating-appsignal.html
[custom-instrumentation]: /ruby/instrumentation/instrumentation.html
[ruby-rake-example]: https://github.com/appsignal/appsignal-examples/tree/ruby-rake
