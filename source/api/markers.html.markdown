---
title: "Markers"
---

## marker Create

Endpoint [POST]:

| Endpoint | Description|
| ------ | ------ |
| **/api/[site_id]/markers.json** | Returns created marker (see show for data format) |

Depending on the kind of marker you want to create (custom marker or deploy marker), send the following JSON:

### Deploy marker

Used to signify a deploy, is shown in the "markers" list and uses "revision" field to generate a Diff link to GitHub or GitLab.

| Param | Type | Description  |
| ------ | ------ | -----: |
|  kind  |  string  | The kind of marker to be created (deploy)  |
|  created_at  |  date (iso8601)  | Time to insert the marker, leave empty for current time |
|  repository  | string | Git link or branch ("master") |
|  revision  | string | Git revision, used to create DIFF links in the UI |
|  user  | string | User that has initiated the deploy |


```
{
  "marker": {
    "kind": "deploy",
    "created_at": "2015-07-21T15:06:31.737+02:00",
    "repository": "git@github.com:company/repository.git",
    "revision": "fe001015311af4769a4dad76bdbce4c8f5d022af",
    "user": "user"
  }
}
```

### Custom marker

Used to annotate events that can impact your performance/error rate. Examples are: up/downscale of cloud infrastructure, maintenance on database, cause of error spikes.

| Param | Type | Description  |
| ------ | ------ | -----: |
|  kind  |  string  | The kind of marker to be created (custom)  |
|  created_at  |  date (iso8601)  | Time to insert the marker, leave empty for current time |
|  icon  | string (optional) | Emoji to differentiate between custom markers |
|  message  | string (optional) | Message shown when hovering over the marker in the UI, truncated to 200 characters |


```
{
  "marker": {
    "kind": "custom",
    "icon": "💩",
    "message": "Accidentlly dropped production DB",
    "created_at": "2015-07-21T15:06:31.737+02:00"
  }
}
```

## Marker index

Endpoint [GET]:

| Endpoint | Description|
| ------ | ------ |
| **/api/[site_id]/markers.json** | Returns a list of markers |


| Param | Type | Description  |
| ------ | ------ | -----: |
|  limit  |  number  |   Limit the  amount of markers returned  |
|  count_only  |  boolean  |   (true/false) To only return a count  |
|  kind  | string | "custom" or "deploy", limits the kind of markers returned by the API |

### Result

This endpoint returns the following JSON

```
{
  "count": 4212,
  "markers": [
    {
      "kind": "deploy",
      "id": "50a61f1b660cd3677775ccb0",
      "created_at": "2015-07-21T15:06:31.737+02:00",
      "closed_at": null,
      "live_for": 107413,
      "live_for_in_words": "1d",
      "gem_version": null,
      "repository": "git@github.com:company/repository.git",
      "revision": "fe001015311af4769a4dad76bdbce4c8f5d022af",
      "short_revision": "fe00101",
      "git_compare_url": "https://github.com/company/repository/compare/aaa...bbb"
      "user": "user",
      "exception_count": 200,
      "exception_rate": 8.81
    },
    {
      "kind": "custom",
      "icon": "💩",
      "message": "Accidentlly dropped production DB",
      "created_at": "2015-07-21T15:06:31.737+02:00"
    },
    {
      "kind": "notification",
      "message": "Appsignal API issues.",
      "created_at": "2015-07-21T15:06:31.737+02:00"
    }
  ]
}

```

## marker show

Endpoint [GET]:

| Endpoint | Description|
| ------ | ------ |
| **/api/[site_id]/markers/[id].json** | Returns a list of markers |


| Param | Type | Description  |
| ------ | ------ | -----: |
|  id  |  string, required  |   ID of marker  |


### Result

This endpoint returns one of the following JSON:

Deploy marker:

```
{
  "id": "50a61f1b660cd3677775ccb0",
  "created_at": "2015-07-21T15:06:31.737+02:00",
  "closed_at": null,
  "live_for": 107413,
  "live_for_in_words": "1d",
  "gem_version": null,
  "repository": "git@github.com:company/repository.git",
  "revision": "fe001015311af4769a4dad76bdbce4c8f5d022af",
  "short_revision": "fe00101",
  "git_compare_url": "https://github.com/company/repository/compare/aaa...bbb"
  "user": "user",
  "exception_count": 200,
  "exception_rate": 8.81,
  "apdex": 0.99,
  "apdex_rating": "excellent"
}
```

Custom marker:

```
{
  "kind": "custom",
  "icon": "💩",
  "message": "Accidentlly dropped production DB",
  "created_at": "2015-07-21T15:06:31.737+02:00"
}
```

Notification marker:

```
{
  "kind": "notification",
  "message": "Appsignal API issues.",
  "created_at": "2015-07-21T15:06:31.737+02:00"
}
```
