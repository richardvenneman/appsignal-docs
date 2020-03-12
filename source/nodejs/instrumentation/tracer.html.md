---
title: "The Tracer Object"
---

AppSignal for Node.js contains a new concept that is different to the current Ruby and Elixir implemenetations - the `Tracer` object. The `Tracer` object contains various methods that you might use when creating your own custom instrumentation. Another concept unique to the Node.js integration is the concept of Scopes, which allow `Span`s to be recalled across ansychronous code paths that may not be linked to each other by being on the same direct code path.

## Retrieving the `Tracer`

```js
const tracer = appsignal.tracer()
```

If the agent is currently inactive (you must actively set it as such by setting `active: true`), then the AppSignal client will return an instance of `NoopTracer`, which is safe to call within your code as if the agent were currently active, but does not record any data.

## Scopes

As mentioned in the `Span` documentation, the current active `Span` can be recalled by calling `tracer.currentSpan()` in order to add data to it or create `ChildSpan`s from it.

```js
const span = tracer.currentSpan()
```

Before it can be recalled again, the `Span` must be given a Scope. A Scope is a wrapper for a `Span` that allows it to be recalled across ansychronous code paths that may not directly be directly linked to each other (in an `EventEmitter` or a timer, for example, or even in a completely different file or function scope). This wrapper is invisible to you and is managed internally via the the `Tracer` objects `ScopeManager` and the internal `async_hooks` module. These Scopes are stored in a stack, meaning that the most recent `Span` to be given a scope will be the next `Span` returned by `tracer.currentSpan()`.

A `Span` can be given a Scope like this:

```js
const tracer = appsignal.tracer()
const rootSpan = tracer.createSpan("span_name")

tracer.withContext(rootSpan, span => {
  // the `rootSpan` now has a Scope and will be the next `Span` to be returned
  // by `tracer.currentSpan()`
})

// ...in a different file or function scope...

const tracer = appsignal.tracer()
const rootSpan = tracer.currentSpan() // this is the same span passed to `withContext` above!
const childSpan = rootSpan.child("child_span_name")

tracer.withContext(childSpan, span => {
  // the `childSpan` now has a Scope and will be the next `Span` to be returned
  // by `tracer.currentSpan()`
})
```
