---
title: "@appsignal/angular"
---

## Installation

Add the  `@appsignal/angular` and `@appsignal/javascript` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```
yarn add @appsignal/javascript @appsignal/angular
npm install --save @appsignal/javascript @appsignal/angular
```

## Usage

### `AppsignalErrorHandler`

The default Angular integration is a class that extends the the `ErrorHandler` class provided by `@angular/core`. In a new app created using `@angular/cli`, your `app.module.ts` file might include something like this:

```js
import { ErrorHandler, NgModule } from '@angular/core'
import Appsignal from '@appsignal/javascript'
import { createErrorHandlerFactory } from '@appsignal/angular'

const appsignal = new Appsignal({
  key: '973a461b-2584-4c6a-9ec6-5849a8908fb4',
  uri: 'https://error-tracker.staging.lol/collect',
})

@NgModule({
  // other properties
  providers: [
    {
      provide: ErrorHandler,
      useFactory: createErrorHandlerFactory(appsignal)
    }
  ],
  // other properties
})
export class AppModule {}
```

