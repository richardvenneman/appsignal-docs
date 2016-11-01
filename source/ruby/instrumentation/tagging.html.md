---
title: "Tagging"
---

From Exception handling:

You can use the `Appsignal.tag_request` method to supply extra context on an error.
This can help to add information that is not already part of the request, session or environment parameters.

### Sending personal data
Since the tagged requests will be saved in our systems, you should be mindful of sending us personal data of your users. You can choose to send user data, but a better workflow would be to send us user IDs or hashes and use [link templates](/tweaks-in-your-code/link-templates.html) to link them to your own systems.

You can use `Appsignal.tag_request` wherever the current request is accessible, we
recommend calling it in a `before_action`.

```ruby
Appsignal.tag_request(
   :locale => I18n.locale
)
```

There are a few limitations on tagging:

* The key must be a string or symbol
* The value must be a string, symbol or integer
* The length of the key and value must be less than 100 characters

```ruby
# Good, I18n.locale/default_locale returns a symbol
Appsignal.tag_request(
  locale: I18n.locale
  default_locale: I18n.default_locale
)

# Bad, hash type is not supported
Appsignal.tag_request(
  i18n: {
    locale: I18n.locale
    default_locale: I18n.default_locale
  }
)
```

Tags that do not meet the limitations will be dropped without warning.
Request tagging currently only works for errors.
