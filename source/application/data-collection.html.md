---
title: "Data collection"
---

By default AppSignal gathers the relevant data for errors and performance measurements to help you find the cause of the issue. Sometimes you need more information, app specific data or a custom request header your app uses.

You can configure AppSignal to gather more, or less, information than it does by default by tagging your transactions and configuring the request headers, parameter filtering, etc.

## Table of Contents

- [Request headers](#request-headers)
- [Parameters](#parameters)

## Request headers

By default AppSignal does not gather all request headers from a request. This is so you and AppSignal are [GDPR compliant by default](/appsignal/gdpr.html#allowed-request-headers-only). If you are missing some headers you really need for your app you can customize the request headers config option in [Ruby](/ruby/configuration/options.html#option-request_headers) / [Elixir](/elixir/configuration/options.html#option-request_headers).

## Parameters

If you use any framework with automatic parameter filtering, AppSignal will use the parameter filtering of the framework to filter the parameters. This can be further customized with our parameter filtering in [Ruby](/ruby/configuration/parameter-filtering.html) / [Elixir](/elixir/configuration/parameter-filtering.html).
