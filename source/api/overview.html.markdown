---
title: "Api overview"
---

## So you want to get some data out of AppSignal?

The eindpoint for all api calls is: `https://appsignal.com/api`

For now we only return json (and jsonp). Make sure you end all requests with .json so  you won't have to change anything in the future.

Default parameters:

| Param | Type | Description  |
| ------ | ------ | -----: |
|  site_id  |  string, required  |   Site id  |
|  token  |  string, required  |   Your personal API key  |

All endpoints require a site id and a token.
You can find the token on your [personal settings screen](https://appsignal.com/users/edit)

And endpoint indicated like this: **/api/[site_id]/samples.json**
Will become:

```
https://appsignal.com/api/5114f7e38c5ce90000000011/samples.json?token=abc
```

