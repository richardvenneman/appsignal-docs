---
title: "Event names"
---

AppSignal instrumentation creates events for pieces of code that are
instrumented. These events are used to calculate the code execution duration
and Garbage Collection of separate libraries and code blocks.

Instrumenting allows AppSignal to detect problem areas in code. It makes it
possible to see if an application's database queries are slow or if a single
API call is causing the most slow down in a request.

To instrument code accurately every event name follows a very specific naming
method. Picking a good name can help a lot with how AppSignal processes and
displays the incoming data. Naming events can be difficult, but hopefully this
short explanation of how an event name is used will help you with picking a
good one.

For more about instrumentation read more in our [(Custom)
instrumentation](/ruby/instrumentation/index.html) guide.

## Event groups

Every event created by AppSignal instrumentation has a name. In this name the
parent group of an event is also present. This group name allows AppSignal to
group together events from database queries and view rendering. Using this
grouping we can create overviews that show execution times per group as well as
single events.

For example, our Rails integration creates these groups: `active_record`,
`action_view`, `action_controller`, etc.

## Event naming

An event name is a string consisting of alphanumeric characters, underscores
and periods. Spaces and dashes are not accepted. Think of this regex,
`([a-zA-Z0-9_.]+)`, if it is accepted by this regex the event name is accepted.

Let's start with a simple event name.

```
sql.active_record
^   ^
|   second part (group)
first part (action)
```

The action of an event name is everything until the last period `.` in a key.
The group is everything after this period.

The group of an event is the code library it belongs to or the kind of action
it is, such as a database query or HTTP request.

It also works with multiple periods in a key.

```
fetch.partition3.database
^                ^
|                second part (group)
first part (action)
```

We use this last-naming-scheme for the [Ruby method
instrumentation](/tweaks-in-your-code/method-instrumentation.html) ourselves.

When a name with just one part is encountered the event will automatically be
grouped under the `other` group.

## Examples

Some examples of keys that are used by AppSignal integrations:

- ActiveRecord: `sql.active_record`
- Redis: `query.redis`
- Elasticsearch: `search.elasticsearch`
- ActionView: `render_template.action_view` and `render_partial.action_view`
- Ruby's Net::HTTP: `request.net_http`
- Sidekiq: `perform_job.sidekiq`
- [Ruby method instrumentation](/ruby/instrumentation/method-instrumentation.html):
  - `method_name.ClassName.other`, and;
  - `method_name.class_method.NestedClassName.ParentModule.other`
