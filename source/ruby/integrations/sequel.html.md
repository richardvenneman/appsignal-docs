---
title: "Sequel"
---

The [Sequel][sequel] gem is a fast ORM for Ruby. AppSignal supports Sequel
automatically and no manual instrumentation is needed.

## Disable instrumentation

We have a configuration option to disable instrumentation for Sequel.

Read more about [`:instrument_sequel`][instrument-sequel].

## Known issues

When using the [sequel-rails](sequel-rails) gem the instrumentation from the
sequel-rails gem and AppSignal gem can [conflict when running
migrations][instrumentation-issue].

Because both gems are instrumenting sequel you'll get two instrumentation
events and possible an error. [Disable the AppSignal sequel
instrumentation](#disable-instrumentation) is this occurs.

## Example app

We have an [example application][example-app] in our examples repository on
GitHub. The example shows how to set up AppSignal with Sequel and Rails,
without ActiveRecord and using only the sequel gem, not the sequel-rails gem.

[sequel]: http://sequel.jeremyevans.net/
[sequel-rails]: https://github.com/TalentBox/sequel-rails
[instrument-sequel]: /ruby/configuration/options.html#code-appsignal_instrument_sequel-code-code-instrument_sequel-code
[instrumentation-issue]: https://github.com/appsignal/appsignal-ruby/issues/91
[example-app]: https://github.com/appsignal/appsignal-examples/tree/rails-5+sequel
