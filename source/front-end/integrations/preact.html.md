---
title: "@appsignal/preact"
---

!> This integration is for Preact v10.0.0-rc.0+ (Preact X). As Preact X is currently pre-release, you should also consider this pre-release functionality.

## Installation

Add the  `@appsignal/preact` and `@appsignal/javascript` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```
yarn add @appsignal/javascript @appsignal/preact
npm install --save @appsignal/javascript @appsignal/preact
```

## Usage

### Error Boundary

If you are using Preact v10.0.0-rc.0+ or higher, you can use the `ErrorBoundary` component to catch errors from anywhere in the child component tree.

```jsx
import { Component } from 'preact'

import Appsignal from "@appsignal/javascript"
import { ErrorBoundary } from "@appsignal/preact"

const appsignal = new Appsignal({ 
  key: "YOUR FRONTEND API KEY"
})

const FallbackComponent = () => (
  <div>Uh oh! There was an error :(</div>
)

export default class App extends Component {
	render() {
    return (
      <ErrorBoundary 
        instance={appsignal} 
        tags={{ tag: "value" }} {/* Optional */}
        fallback={(error) => <FallbackComponent />} {/* Optional */}
      >
        { /** Child components here **/}
      </ErrorBoundary>
    )
  }
)
```
