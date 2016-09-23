---
title: "Graphs"
---

Endpoint [GET]: **/api/[site_id]/graphs.json**

| Endpoint | Description|
| ------ | ------ |
| **/api/[site_id]/graphs.json** | Returns graph data |


parameters:

| Param | Type | Description  |
| ------ | ------ | -----: |
|  action_name  |  string  |   Example: BlogPostsController-hash-show  |
|  from  |  timestamp/integer  |  defaults to 1 day ago if nil  |
|  to  |  timetamp/integer  |   faults to now if nil  |
|  timeframe  |  string  |   Can be: [hour, day, month, year]  |
|  field  |  array  |   Can be: [mean, count, ex, ex_rate, pct]  |

Leave the action_name param empty to get aggregated data of all actions in your site.
You can either specify the from an to values, __or__ the timeframe value.

Valid timeframes are: `hour`, `day`, `month` and `year`

valid fields are:

| Field | Description|
| ------ | ------ |
| mean | mean response time |
| count | throughput |
| ex | exception count |
| ex_rate | exception rate (percentage of exceptions from count) |
| pct | 90 percentile (for slow requests only) |

If you want an action and exception, concat the strings with `:|:` as a separator

so `BlogPostsController#show` with `Mongoid::RecordNotFound` becomes:
`BlogPostsController-hash-show:|:Mongoid::RecordNotFound"`


Example request:

```
/api/5534f7e38c5ce90000000000/graphs.json?action_name=BlogPostsController-hash-show&fields[]=mean&fields[]=pct&timeframe=month&token=aaa
```

This endpoint returns a JSON object:

```
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
