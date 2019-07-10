---
title: "AppSignal for JavaScript - Vue.js"
---

## Installation

Add the `@appsignal/javascript` package to your `package.json`. Then, run `yarn install`/`npm install`.

There is no plugin available right now, but adding error-tracking in Vue.js is straight forward:

```js
// appsignal.js
import Appsignal from "@appsignal/javascript"
// in case you want to track global js errors:
// import { plugin } from "@appsignal/plugin-window-events"
import Vue from "vue"

// add your frontend key to .env file entry in VUE_APP_APPSIGNAL=XYZ
const appsignal = new Appsignal({ key: process.env.VUE_APP_APPSIGNAL })
// in case you want to track global js errors:
// appsignal.use(plugin({}))

// add the appsignal handling
Vue.config.errorHandler = error => appsignal.sendError(error)

// export the singleton in case you would like to access in your app
export default appsignal
```

Import the code in your App:

```js
// main.js
import "appsignal"
// in case you would like to use the client in your app
// import appsignal from "appsignal"
```
