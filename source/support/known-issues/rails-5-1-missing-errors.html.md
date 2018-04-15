---
title: No errors are reported to AppSignal for Rails 5.1
---

## Affected components

- AppSignal Ruby package versions: `v2.2.1` and earlier
- Apps running Rails 5.1 or higher

## Description

After upgrading to Rails 5.1, or creating a new app with Rails 5.1 and using an older AppSignal gem version, no errors are reported from the app.

In Rails 5.1 some middleware was changed that Rails uses to show error pages with debug information in development and user-facing error pages in production. These changes affected AppSignal so that the errors were no longer reaching the AppSignal middleware and [a change](https://github.com/appsignal/appsignal-ruby/pull/286) in location in the middleware stack was required.

## Solution

Upgrade to AppSignal for Ruby package version `2.2.1` or higher. We recommend upgrading to the latest version.
