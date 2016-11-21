---
title: "Tagging"
---

Use the `Appsignal.tag_request` method to supply extra context on errors and
performance issues. This can help to add information that is not already part of
the request, session or environment parameters.

You can use `Appsignal.tag_request` wherever the current request is accessible,
we recommend calling it before you application code runs in the request, such
as in a `before_action` using Rails.

```ruby
Appsignal.tag_request(
   :locale => I18n.locale
)
```

## Tags

Using tags you can easily add more information to errors and performance issues
tracked by AppSignal. There are a few limitations on tagging though.

- The tag key must be a `String` or `Symbol`.
- The tagged value must be a `String`, `Symbol` or `Integer`.
- The length of the tag key and tagged value must be less than 100 characters.

Tags that do not meet these limitations are dropped without warning.

```ruby
# Good, I18n.locale/default_locale returns a symbol
Appsignal.tag_request(
  user: current_user.id,
  locale: I18n.locale,
  default_locale: I18n.default_locale
)

# Bad, hash type is not supported
Appsignal.tag_request(
  i18n: {
    locale: I18n.locale,
    default_locale: I18n.default_locale
  }
)
```

## Sending personal data

Please be mindful of sending personal data about your users to AppSignal. You
can choose to send user data, but a better workflow would be to send user
IDs or hashes and use [link
templates](/ruby/instrumentation/link-templates.html) to link them back to your
own system.
