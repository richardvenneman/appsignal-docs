---
title: "Graphs API"
---

Endpoint [GET]:

| Endpoint | Description|
| ------ | ------ |
| **/api/[app_id]/graphs.json** | Returns graph data |

Parameters:

| Param | Type | Description  |
| ------ | ------ | -----: |
| kind | string | Aggregate of provided namespace (web, background, or your own) |
|  action_name  |  string  |   Example: BlogPostsController-hash-show  |
|  from  |  string (ISO8601)  |  defaults to 1 day ago if nil  |
|  to  |  string (ISO8601)  |   defaults to now if nil  |
|  timeframe  |  string  |   Can be: [hour, day, month, year]  |
|  field  |  array  |   Can be: [mean, count, ex_count, ex_rate, pct]  |

Either provide the `action_name` or `kind` parameter.
You can either specify the from an to values, __or__ the timeframe value.

Valid timeframes are: `hour`, `day`, `month` and `year`

Valid fields are:

| Field | Description|
| ------ | ------ |
| mean | mean response time |
| count | throughput |
| ex_count | exception count |
| ex_rate | exception rate (percentage of exceptions from count) |
| pct | 90 percentile (for slow requests only) |

If you want an action and exception, concatenate the strings with `:|:` as a separator

So `BlogPostsController#show` with `Mongoid::RecordNotFound` becomes:
`BlogPostsController-hash-show:|:Mongoid::RecordNotFound"`


Example request:

```
/api/5534f7e38c5ce90000000000/graphs.json?action_name=BlogPostsController-hash-show&fields[]=mean&fields[]=pct&timeframe=month&token=aaa&from=2013-09-03T22:00:00+01:00&to=2013-10-04T00:00:00+01:00
```

This endpoint returns a JSON object:

```json
{
  "from": "2013-09-03T22:00:00Z",
  "to": "2013-10-04T00:00:00Z",
  "resolution": "hourly",
  "data": [
    {
      "timestamp": 1378245600,
      "mean": 13.51942822948383,
      "pct": 13.213056043635918
    }
  ]
}
```
