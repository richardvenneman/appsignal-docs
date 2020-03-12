---
title: "Creating and using a Span"
---

Using the new `Span` API, even more insights in your application can be added by adding more instrumentation or tagging the data that appears in the UI at AppSignal.com. 

A `Span` is the name of the object that we use to capture data about your applications performance, any errors and any surrounding context. It is designed to be similar to, but not exactly like, the Span from the [OpenTelemetry](https://github.com/open-telemetry/opentelemetry-specification) standard specification.

## Retrieving the current `Span`

In most cases, a `RootSpan` will be automatically created by one of our automatic instrumentations, e.g. the `http` module integration. You'll need to retrieve that `Span` in order to add data to it and create `ChildSpan`s from it.

```js
const span = tracer.currentSpan()
```

If a current `Span` is not available, `tracer.currentSpan()` will return `undefined`.

## Creating a new `Span`

In the event that a `Span` is not available from `tracer.currentSpan()`, a `Span` can be created by calling `tracer.createSpan()`, which initializes a new `Span` object. A `Span` name is used to identify a certain sample error and performance issues in the relevant tables in our UI.

```js
const rootSpan = tracer.createSpan(spanName)
```

A `ChildSpan` can be created to represent a subdivision of the total length of time represented by the `RootSpan`. This is useful for instrumenting blocks of code that are run inside of the lifetime of a `RootSpan`.

```js
const childSpan = rootSpan.child(spanName)
```

A `ChildSpan` can also be created by passing an optional second argument to `tracer.createSpan()`.

```js
const childSpan = tracer.createSpan(spanName, rootSpan)
```

## Updating a `Span`

After a `Span` is created, you can begin adding data to it using methods on the `Span` object:

```js
const span = tracer.currentSpan()
span.set("name", "value")
```

Each method that modifies the `Span` returns `this`, allowing you to chain methods together:

```js
const span = tracer.currentSpan()

span
  .set("name", "value")
  .addError(new Error("test error"))
```

### `span.set(key: string, value: string | number | boolean)`

Sets arbitary data on a current `Span`. The data can be a `string`, `number` or `boolean` type.

### `span.setNamespace(name: string)`

Sets the `namespace` of the current `Span`. Namespaces are a way to group error incidents, performance incidents, and host metrics in your app.

### `span.addError(error: Error | object)`

Sets the `error` of the current `Span`. When an `Error` object is passed to the `setError` method, the `stack` property is normalised and transformed into an array of strings, with each string representing a line in the stacktrace.

### `span.setSampleData(key: string, data: Array<any> | { [key: string]: any })`

Adds sample data to the current `Span`. The sample data object must not contain any nested objects.

### `span.close(endTime?: number)`

Closes the current `Span`.

## Example instrumentation

A key benefit of the new API is that it works aynchronously. Here's an example of an instrumented function:

```js
async function () {
  // the `RootSpan` represents the top-most level `Span` that
  // contains all others
  const rootSpan = tracer.currentSpan()

  await tracer.withSpan(rootSpan, async span => {
    span
      .set("key", value)
      .setNamespace("namespace")
      .setSampleData("key", value)

    await tracer.withSpan(
      span.child("childSpan1Name"),
      async child => {
        // add code to instrument here!
        // `tracer.withSpan` will return a Promise for any value 
        // that you return in this callback

        // child spans must be closed explicitly!
        child.close()
      }
    )

    tracer.withSpan(
      span.child("childSpan2Name"),
      child => {
        // multiple functions can be intrumented at once, 
        // as well as purely synchrounous functions

        // child spans must be closed explicitly!
        child.close()
      }
    )
  })
}
```
