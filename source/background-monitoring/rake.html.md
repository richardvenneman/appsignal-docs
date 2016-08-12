
## Rake task monitoring

With AppSignal gem version `0.11.13`, we've added Rake task monitoring.

Simply add `require 'appsignal/integrations/rake'` to your Rakefile like this:

```ruby
#!/usr/bin/env rake
require File.expand_path('../config/application', __FILE__)
require 'appsignal/integrations/rake'

MyApp::Application.load_tasks

```

And every exception in a Rake task will be sent to AppSignal under the "Background" namespace. Note that we only track exceptions in Rake tasks. There is no performance monitoring.

### A more comprehensive example using threads

Add performance monitoring to a continuously running multi-threaded rake task for v1.1.6. (The appsignal gem does error monitoring of rake tasks automatically.) Based on work of leehambley.

```ruby
# do_something.rake
namespace :mycrazyproject do
  task do_something: :environment do
    while true
      User.where(active:true).find_in_batches(batch_size:20).with_index do |batch_of_users, batch_ndx|
        # We collect a bunch of new threads, one for each
        # user, each...
        #
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
              rescue Exception => err
                transaction.set_error(err)
              ensure
                # Complete the transaction
                Appsignal::Transaction.complete_current!
              end
          end
        end
        #
        # Joining threads means waiting for them to finish
        # before moving onto the next batch.
        #
        batch_threads.map(&:join)
      end
    end
  end
end
```
