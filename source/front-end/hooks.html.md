---
title: "Hooks"
---

In the life cycle of a `Span`, we provide a number of opportunities to update or modify its internal state. Hooks are the mechanism for this. Using specifically formed functions, we are able to augment any outgoing `Span` with additional information before it is sent to the Push API.

Both types of hooks are an array of composed functions that are applied from right to left. In other words, the hooks that are added last are always the first to be applied.

When a `Span` is passed to `appsignal.send()`, or an `Error` is passed to `appsignal.sendError()`, hooks are applied to the `Span` in the following order: 

- Decorators
- Optional `tags` or `namespace` arguments to `appsignal.send()`
- Overrides

Hooks are generally applied in a plugin.

-> When an `Error` is passed to `appsignal.sendError()`, an internal `Span` object is created, meaning that Hooks can still be applied to it as normal.

## Decorators

It may be necessary to add additional context to a `Span` at the global level, so that all requests by default include that information. Decorators can be used to do this.

## Overrides

Overrides are the last possible opportunity to update data in a `Span` before it is sent to the Push API. For example, you may choose to scrub any user data from `Span`s in an override. 

## Writing your own Hook

Hooks are, essentially, functions that take a `Span` as a single argument, and then return the same `Span`. During the execution of the function, modifications can be made to the `Span`, but we suggest that no other side-effects are introduced.

Here's an example of how you can add a Hook to the `Appsignal` object:

```js
appsignal.addDecorator((span) => {
  return span.setTags({ customTag: "value" })
})

appsignal.addOverride((span) => {
  // scrub e-mail addresses
  const { tags } = span.serialize()

  return span.setTags({ 
    text: tags.text.replace(/^[^\s@]+@[^\s@]+\.[^\s@]+$/, "[SCRUBBED]") 
  })
})
```

Plugins can add decorators and overrides, too. If you're looking to create a re-usable hook, that can be packaged in an `npm` module, for instance, we recommend utilizing [the plugin interface](/front-end/plugins/) to register it.
