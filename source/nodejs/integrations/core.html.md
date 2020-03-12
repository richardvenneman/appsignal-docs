---
title: "Node.js Core"
---

Node.js contains several internal modules designed to enable asynchronous I/O capable APIs for your application. AppSignal provides automatic instrumentation for many of these modules.

## `http`

At this time, Appsignal for Node.js will auto-instrument any incoming HTTP calls (outgoing HTTP calls will be auto-instrumented in a later update). When you create a new `Span`, it will be child of the `Span` created by the core HTTP integration.
