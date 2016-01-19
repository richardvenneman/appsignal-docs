---
title: "Markers"
---

## Marker index

Endpoint [GET]:

| Endpoint | Description|
| ------ | ------ |
| **/api/[site_id]/markers.json** | Returns a list of markers |


| Param | Type | Description  |
| ------ | ------ | -----: |
|  limit  |  number  |   Limit the  amount of markers returned  |
|  count_only  |  boolean  |   (true/false) To only return a count  |


### Result

This endpoint returns the following JSON

```
{
  "count": 4212,
  "markers": [
    {
      "id":"50a61f1b660cd3677775ccb0",
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

This endpoint returns the following JSON:

```
{
  "id":"50a61f1b660cd3677775ccb0",
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
