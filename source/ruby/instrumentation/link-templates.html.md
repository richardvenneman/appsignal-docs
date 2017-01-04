---
title: "Link templates"
---

AppSignal supports tagging of requests, as described in [Tagging]. These tags
make it possible to generate URLs to your own application to deep link to pages
in your own system, such as related user profiles or blog posts.

## Tagging requests

For link templates to work AppSignal needs to have the data necessary to create
the links. Start by adding tags to request in your application.

Add the following code in a location it's executed for the related request,
such as a `before_action` block in a Rails application.

```ruby
Appsignal.tag_request(
  :user_id    => current_user.id
  :account_id => current_account.id
)
```

For more information about tagging requests, please read the [Tagging] page.

## Creating a link template

Link templates can be defined on AppSignal.com per application.

The "Link templates" configuration can be found in the "Configure" section in
the left-hand side navigation under "App settings" for a site.

![link templates](/images/screenshots/link_templates.png)

Link templates can contain variables, defined by wrapping them in curly
brackets `{}`. For example, the `user_id` tag can be used in a link like so:

```
https://yourapp.com/backend/users/{user_id}
```

A link can contain as many variables as you like, but in order for a link to be
generated, all variables need to be present in the tags of a request.

After adding tags in your app and defining link templates, links will be
generated for each request in the "Overview" section.

![link templates](/images/screenshots/link_templates_result.png)

[Tagging]: /ruby/instrumentation/tagging.html
