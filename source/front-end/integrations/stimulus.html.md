---
title: "@appsignal/stimulus"
---

## Installation

Add the  `@appsignal/stimulus` and `@appsignal/javascript` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```
yarn add @appsignal/javascript @appsignal/stimulus
npm install --save @appsignal/javascript @appsignal/stimulus
```

## Usage

### `Application.handleError`

The default Stimulus integration is a function that binds to the `Application.handleError` property. In a new app created using `rails new $APP_NAME --webpack=stimulus`, for example, your `javascript/controllers/index.js` file would look something like this:

```js
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

import Appsignal from "@appsignal/javascript"
import { installErrorHandler } from "@appsignal/stimulus"

const appsignal = new Appsignal({ 
  key: "YOUR FRONTEND API KEY"
})

const application = Application.start()
installErrorHandler(appsignal, application)
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))
```
