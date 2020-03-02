---
title: "Express"
---

Express.js v4+ can be instrumented via a middleware plugin to augment `Span`s with richer data.

```bash
yarn add @appsignal/nodejs @appsignal/express
npm install --save @appsignal/nodejs @appsignal/express
```

You can then import and use the package in your app:

```js

const { Appsignal } = require("@appsignal/nodejs")

const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>"
  apiKey: "<YOUR API KEY>"
})

const express = require("express")
const { expressMiddleware } = require("@appsignal/express")

const app = express()

// ADD THIS BEFORE ANY OTHER EXPRESS MIDDLEWARE!
app.use(expressMiddleware(appsignal))
```
