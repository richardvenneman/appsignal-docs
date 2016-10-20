---
title: "Samples"
---

## Samples index

Endpoints [GET]:

| Endpoint | Description|
| ------ | ------ |
| **/api/[site_id]/samples.json** | This returns **ALL** sample types |
| **/api/[site_id]/samples/performance.json** | This returns **performance** samples |
| **/api/[site_id]/samples/errors.json** | This returns **error** samples |

parameters:

| Param | Type | Description  |
| ------ | ------ | -----: |
|  action_name  |  string  |   Example: BlogPostsController-show  |
|  exception  |  string  | Example: NoMethodError    |
|  since  |  timestamp/integer  |  All times are UTC  |
|  count_only  |  boolean  |   (true/false) To only return a count  |

Escape actions by replacing:

* `#` with `-hash-`
* `/` with `-slash-`
* `.` with `-dot-`

so `BlogPostsController#show` becomes: `BlogPostsController-hash-show`

An example of a full request would be:

```
https://appsignal.com/api/5114f7e38c5ce90000000011/samples.json?token=HseUe&action_id=AccountsController-hash-index&exception=ActionView::Template::Error&since=1374843246
```

### Result

This endpoint returns the following JSON (a slow sample and an error sample):

```
{
  "count": 2,
  "log_entries": [
    {
      "id": "51f29e7b183d700800150358_SlowController#show_1476962400",
      "action": "SlowController#show",
      "path": "/slow-request",
      "duration": 3182.545407,
      "status": 200,
      "time": 1476962400,
      "is_exception": false,
      "exception": {
        "name": null
      }
    },
    {
      "id": "57f653fa16b7e24cb0dc9e2b_ErrorController#trigger_1475761080",
      "action": "ErrorController#trigger",
      "path": "/error-request",
      "duration": null,
      "status": null,
      "time": 1475761080,
      "is_exception": true,
      "exception": {
        "name": 'ActionView::Template::Error'
      }
    }
  ]
}

```

## Samples show

Endpoint [GET]: **/api/[site_id]/samples/[id].json**

parameters:

| Param | Type | Description  |
| ------ | ------ | -----: |
|  id  |  string  |   Sample id  |

### Result

This is a __SLOW__ log entry:

```
{
    "id": "50c9d4f9d85a8359d3000009",
    "action": "slow#request",
    "db_runtime": 500.0,
    "duration": 300.0,
    "environment": {},
    "hostname": "app1",
    "is_exception": null,
    "kind": "http_request",
    "params": {},
    "path": "/blog",
    "request_format": "html",
    "request_method": "GET",
    "session_data": {},
    "status": "200",
    "view_runtime": 500.0,
    "time": 1002700800,
    "end": 978339601,
    "allocation_count": 110101,
    "events": [
        {
            "action": "query",
            "duration": 250.0,
            "group": "mongoid",
            "name": "query.mongoid",
            "payload": {
                "query": "this is a mongoid query"
            },
            "time": 0,
            "end": 0
            "digest": 00000,
            "allocation_count": 1010101

        }
    ],
    "exception": null
}
```

This is an __ERROR__ log entry:

```
{
    "id": "50c9d54dd05a03bdc500000b",
    "action": "Error#request",
    "db_runtime": 500.0,
    "duration": null,
    "environment": {
        "HTTP_USER_AGENT": "Mozilla/5.0 (Macintosh"
    },
    "hostname": "app1",
    "is_exception": true,
    "kind": "http_request",
    "params": {
        "id": 1,
        "get": "something"
    },
    "path": "/blog",
    "request_format": "html",
    "request_method": "GET",
    "session_data": {
        "current_user_id": 1
    },
    "status": "200",
    "view_runtime": 500.0,
    "time": 1002700800,
    "end": 978339601,
    "events": [],
    "tags": {
      "user": "john doe",
      "id": 1
    },
    "exception": {
        "message": "The method was not found",
        "name": "NoMethodError",
        "backtrace": [
            "Backtrace line 1",
            "Backtrace line 2",
            "Backtrace line 3"
        ]
    }
}
```
