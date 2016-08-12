---
title: "Deploy markers"
---

Deploy markers are used to reset notification triggers and to track when an issue was introduced.

## Creating a deploy marker

The endpoint is `https://push.appsignal.com/1/markers?api_key=[push_api_key]&name=[application_name]&environment=[environment]`

A fully generated marker endoint url can be found at: "App settings" > "Push & Deploy" in your site's sidebar.

The post body data format is in JSON.

```
{
  "revision":"git revision hash",
  "repository":"git branch or repo",
  "user":"user triggering the deploy"
}
```

A curl example:

```
  curl -X POST -d "{\"revision\":\"ba70cebcd05d131e00e776b35616d7bc0ba919fb\",\"repository\":\"master\",\"user\":\"test user\"}" "https://push.appsignal.com/1/markers?api_key=abc&name=test&environment=production"
```
