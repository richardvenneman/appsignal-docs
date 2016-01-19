---
title: "Link templates"
---

AppSignal supports tagging of errors, as described in [Handle exceptions](/tweaks-in-your-code/handle-exceptions.html). With these tags it's possible to generate urls to your application/backend for easy customer contact.

Start by adding metadata to an error by tagging it:


```ruby
Appsignal.tag_request(
   :user_id    => current_user.id
   :account_id => current_account.id
)
```


You can define "Link templates" by navigating to the "General" tab for a site.

![link templates](/images/screenshots/link_templates.png)

Link templates can contain variables, defined by wrapping them in `{}`. For example, the `user_id` tag can be used in a link like so:

```
https://yourapp.com/backend/users/{user_id}
```


A link can contain as many variables as you like, but in order for a link to be generated, all variables need to be present in the tags of an error.


After adding tags in your app and defining link templates, Links will be generated for each error in the "Overview" section.

![link templates](/images/screenshots/link_templates_result.png)
