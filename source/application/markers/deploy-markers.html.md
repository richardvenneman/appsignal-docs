---
title: "Deploy markers"
---

Markers are little icons used in graphs on AppSignal.com to indicate a change. This can be a code deploy using a "Deploy marker" or a special event with a ["Custom marker"](custom-markers.html). Deploy markers can also be found in the ["Deploys" section](https://appsignal.com/redirect-to/app?to=markers) in the app navigation which provides a performance overview per deploy.

A deploy marker indicates a change in the deployed version of an application. This can be used to group together occurrences of errors and performance issues within a certain time frame. From when the version was deployed until a newer version was deployed.

When a new deploy is detected, the list of incidents is empty for the newest deployment version. When an error, or any other issue, is reported by AppSignal in your application it gets listed for the newest deploy as well. On the sample page for an incident you can see in which deployments an incident occurred with the help of the rocket (🚀) separator icon.

![Deploy markers in samples list](/assets/images/screenshots/app_incident_samples_list.png)

## Table of Contents

- [Deploy methods](#deploy-methods)
  - [Revision config option](#revision-config-option) (recommended method)
      - [Heroku support](#heroku-support)
      - [Config option](#config-option)
      - [System environment variable](#system-environment-variable)
  - [Manually create a Deploy marker](#manually-create-a-deploy-marker)
      - [Ruby CLI tool](#ruby-cli-tool)

## Deploy methods

There are two methods of notifying AppSignal of a new deploy. These two methods cannot be used together.

1. Using the `revision` config option, and;
2. Creating a deploy notification manually with the AppSignal Push API.

The first method (`revision` config option) is our recommended approach, because it's the most reliable method and works better for applications with more than one host. We detect the revision from the application itself so we know which instance is running what version.

The second approach (creating a deploy marker manually) is a method only really useful for small applications that use one host. It creates a new deploy marker at a specific time, regardless of the version the application is actually running. This also means it's also more error prone.

## Revision config option

The recommended approach of letting AppSignal know a new version of your application is deployed is by using the `revision` config option or the `APP_REVISION` environment variable ([Ruby](/ruby/configuration/options.html#option-revision)/[Elixir](/elixir/configuration/options.html#option-revision)). This is automatically detected for [Heroku apps](#heroku-support) using the dyno metadata lab feature.

This config option is set per instance of an application which has the benefit of every version of an application running at the same time reporting the errors under the correct deploy, rather than the latest deploy that [has been reported](#manually-create-a-deploy-marker) to AppSignal.

For example: If one machine is still running an older version of the application all the errors from that instance are reported under the previous deploy marker rather than the last known deploy marker.

### Config option

The `revision` config option has been released in [Ruby](/ruby/configuration/options.html#option-revision) gem version `2.6.1` and [Elixir](/elixir/configuration/options.html#option-revision) package version `1.6.3`.

```yml
# For Ruby
# config/appsignal.yml
production:
  revision: "abcdef12"
```

```elixir
# For Elixir
# config/appsignal.exs
config :appsignal, :config, revision: "abcdef12"
```

If you're running a version in which this config option is not available we recommend using the [`APP_REVISION` environment variable](#system-environment-variable) instead.

### System environment variable

The `APP_REVISION` value can be any value you use to indicate a version/revision. For example: a version number `1.4.2` or a git SHA `cf8bc42`.

The revision value should be set in the application's system environment and updated during a deploy of the application.

```bash
export APP_REVISION="cf8bc42"
# Start your application
# bundle exec rackup app.rb
```

### Heroku support

When using Heroku with the [Heroku Labs: Dyno Metadata](https://devcenter.heroku.com/articles/dyno-metadata) enabled it will automatically set the `revision` config option to the `HEROKU_SLUG_COMMIT` system environment variable. This will automatically report new deploys when the Heroku app gets deployed.

## Manually create a Deploy marker

Manually creating a deploy marker is a method that's only really useful for small applications that use one application instance. It creates a new deploy marker at a specific time, regardless of the version the application is actually running. This also means it's also more error prone.

This method requires that you send a POST request to the AppSignal Push API markers endpoint. This can be done with a CLI tool (for Ruby) or with a manual HTTP POST request. There is no CLI tool available for our Elixir package.

To create a Deploy marker with a HTTP POST request you can use curl or some other tool like it. The payload of the request is a JSON object with data about the marker, such as the revision, user who deployed it and the application's repository.

Read more about how to create Deploy markers with our Push API in our [Push API endpoint](/push-api/deploy-marker.html) documentation.

### Ruby CLI tool

For the AppSignal for Ruby gem we have included a CLI tool to allow creation of deploy markers from your app. See the [`notify_of_deploy` CLI command](/ruby/command-line/notify_of_deploy.html) documentation for more information.
