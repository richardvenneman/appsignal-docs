---
title: "AppSignal for JavaScript - React"
---

## Installation

Add the  `@appsignal/react` and `@appsignal/javascript` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```
yarn add @appsignal/javascript @appsignal/react
npm install --save @appsignal/javascript @appsignal/react
```

## Usage

### Error Boundary

If you are using React v16 or higher, you can use the `ErrorBoundary` component to catch errors from anywhere in the child component tree.

```jsx
import React from "react"
import ReactDOM from "react-dom"
import Appsignal from "@appsignal/javascript"
import { ErrorBoundary } from "@appsignal/react"

const appsignal = new Appsignal({ 
  key: "YOUR FRONTEND API KEY"
})

const FallbackComponent = () => (
  <div>Uh oh! There was an error :(</div>
)

const App = () => (
  <ErrorBoundary instance={appsignal} fallback={(error) => <FallbackComponent />}>
    { /** Child components here **/}
  </ErrorBoundary>
)

ReactDOM.render(<App />, document.getElementById("root"))
```

### Legacy Boundary

!> The API that this component uses is unstable at this point in React's development. We offer this component as a means to support those running React v15, but do not guarantee its reliablity. You are encouraged to use the `ErrorBoundary` whenever possible.

The `LegacyBoundary` works in almost exactly the same way as the `ErrorBoundary`:

```jsx
import React from "react"
import ReactDOM from "react-dom"
import Appsignal from "@appsignal/javascript"
import { LegacyBoundary } from "@appsignal/react"

const appsignal = new Appsignal({ 
  key: "YOUR FRONTEND API KEY"
})

const FallbackComponent = () => (
  <div>Uh oh! There was an error :(</div>
)

const App = () => (
  <LegacyBoundary instance={appsignal} fallback={(error) => <FallbackComponent />}>
    { /** Child components here **/}
  </LegacyBoundary>
)

ReactDOM.render(<App />, document.getElementById("root"))
```
