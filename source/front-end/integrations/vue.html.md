---
title: "@appsignal/vue"
---

## Installation

Add the `@appsignal/vue` and `@appsignal/javascript` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```
yarn add @appsignal/javascript @appsignal/vue
npm install --save @appsignal/javascript @appsignal/vue
```

## Usage

### `Vue.config.errorHandler`

The default Vue integration is a function that binds to the `Vue.config.errorHandler` hook. In a new app created using `@vue/cli`, your `main.js`/`.ts` file would look something like this:

```js
import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

import Appsignal from "@appsignal/javascript"
import { errorHandler } from "@appsignal/vue"

const appsignal = new Appsignal({ 
  key: "YOUR FRONTEND API KEY"
})

Vue.config.errorHandler = errorHandler(appsignal, Vue)

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
```
