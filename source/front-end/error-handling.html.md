---
title: "Frontend error catching <sup>beta</sup>"
---

This is a __Beta__ implementation, which means:

* There is no official JavaScript library supported by AppSignal.
* The API might change in the future to support more frameworks.
* This feature is not enabled by default and requires a setup that uses an `appsignal.yml` config file.

Starting with AppSignal for Ruby gem version <strong>0.11.8</strong> and up we've added a frontend error catcher to our gem.

For use with AppSignal for Elixir, there's an unofficial plug available on GitHub at [tombruijn/appsignal-elixir_js_plug](https://github.com/tombruijn/appsignal-elixir_js_plug).

## Table of Contents

- [Installation](#installation)
  - [Ruby](#installation-ruby)
  - [Elixir](#installation-elixir)
- [Configuration](#configuration)
  - [Ruby](#configuration-ruby)
      - [Path](#configuration-ruby-path)
  - [Elixir](#configuration-elixir)
- [Request parameters](#request-parameters)
- [Example of an error JSON POST](#example-of-an-error-json-post)
- [A sample implementation in EcmaScript 2017](#a-sample-implementation-in-ecmascript-2017)

## Installation

###^installation Ruby

If you are using Ruby on Rails, it's included automatically, but still requires some configuration (see below). For Sinatra/Rack apps you need to require the `JSExceptionCatcher` middleware.

```ruby
::Sinatra::Application.use(Appsignal::Rack::JSExceptionCatcher)
```

###^installation Elixir

Add the `appsignal_js_plug` package as a dependency in your `mix.exs` file.

```elixir
# mix.exs
def deps do
  [
    {:appsignal, "~> 1.3"},
    {:appsignal_js_plug, "~> 0.1.0"}
  ]
end
```

Add the following to your `endpoint.ex` file.

```elixir
# lib/your_app/endpoint.ex
plug Plug.Parsers,
  parsers: [:urlencoded, :multipart, :json],
  pass: ["*/*"],
  json_decoder: Poison

use Appsignal.Phoenix # Below the AppSignal (Phoenix) plug
plug Appsignal.JSPlug
```

## Configuration

###^configuration Ruby

Enable frontend error catching by enabling `enable_frontend_error_catching`  in the `appsignal.yml` config file.

```yml
staging:
  <<: *defaults
  active: true
  enable_frontend_error_catching: true
```

####^configuration-ruby Path

The Rack middleware will expose the following error catcher path `/appsignal_error_catcher`. You can change this path by adding `frontend_error_catching_path` to your `appsignal.yml` config file:

```yml
staging:
  <<: *defaults
  active: true
  enable_frontend_error_catching: true
  frontend_error_catching_path: '/foo/bar'
```

This path will accept POST requests that contain frontend errors in a JSON format.
The gem will take care of processing it and sending it to AppSignal.

###^configuration Elixir

See the README at [tombruijn/appsignal-elixir_js_plug](https://github.com/tombruijn/appsignal-elixir_js_plug) for instructions.

## Request parameters

| Param | Type | Description  |
| ------ | ------ | ----- |
|  action  |  string  |   model/view/component that triggered the exception  |
|  message  |  string  |  exception message  |
|  name  |  string  |   exception name  |
|  backtrace  |  array  |   array of backtrace lines (strings)  |
|  path  |  string  |   path where the exception happened  |
|  params  |  hash/object  |   hash/object of request params |
|  tags  |  hash/object  |   hash/object of tags (e.g. logged in user id)  |
|  environment  |  hash/object  |   hash/object of environment variables  |


## Example of an error JSON POST

The `action`, `message`, `name` and `backtrace` field are required. If they are not
set the error will not be processed.

```json
{
  "action": "IncidentIndexComponent",
  "message": "Foo is not defined",
  "name": "ReferenceError",
  "backtrace": [
    "a/backtrace/line.js:10"
  ],
  "path": "/foo/bar",
  "tags": {
    "user_id": 123
  },
  "environment": {
    "agent": "Mozilla Firefox",
    "platform": "OSX",
    "vendor": "",
    "screen_width": 100,
    "screen_height": 100
  }
}
```

## A sample implementation in EcmaScript 2017

Currently we do not provide a JavaScript package that catches frontend errors.
The EcmaScript example below is something we use to test the functionality, use and modify at your own risk.

```javascript
// ES2017 example
//
// appsignal = new Appsignal
// appsignal.tagRequest({ user_id: 123 })
// appsignal.setAction("ErrorTest")
//
// try {
//   adddlert("Welcome guest!")
// } catch (error) {
//   appsignal.sendError(error)
// }
class Appsignal {
  constructor() {
    this.action = null
    this.tags = {}
  }

  setAction(action) {
    this.action = action
  }

  tagRequest(tags) {
    const result = []
    for (const key in tags) {
      const value = tags[key]
      this.tags[key] = value
      result.push(this.tags[key])
    }
    result
  }

  sendError(error) {
    this.pushData({
      action:    this.action,
      name:      error.name,
      message:   error.message,
      backtrace: (error.stack != null ? error.stack.split("\n") : undefined),
      path:      window.location.pathname,
      tags:      this.tags,
      environment: {
        agent:         window.navigator.userAgent,
        platform:      window.navigator.platform,
        vendor:        window.navigator.vendor,
        screen_width:  window.screen.width,
        screen_height: window.screen.height
      }
    })
  }

  pushData(data) {
    const xhr = new XMLHttpRequest()
    xhr.open("POST", "/appsignal_error_catcher", true)
    xhr.setRequestHeader("Content-Type", "application/json; charset=UTF-8")
    xhr.send(JSON.stringify(data))
  }
}

window.appsignal = new Appsignal

window.onerror = function(message, filename, lineno, colno, error) {
  if (error) {
    window.appsignal.sendError(error)
  } else {
    window.appsignal.sendError(new Error("Null error raised, no exception message available"))
  }
}
```

Here at AppSignal we're very keen on "eating our own dogfood". This means we use AppSignal to monitor AppSignal and since we're rewriting most of our frontend code to ReactJS we decided that we need to monitor it.

Once we get a good feel of the requirements for JavaScript error catching we plan on supporting an official library that hopefully will support vanilla JS and all the popular frontend frameworks.

You are welcome to try frontend error catching as well and we really like to hear feedback on our implementation. If you have any questions or suggestions, don't hesitate to contact us on <a href="mailto:contact@appsignal.com">contact@appsignal.com</a>.
