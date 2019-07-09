---
title: "AppSignal for JavaScript"
---

AppSignal now has an amazing solution for catching errors from front-end JavaScript applications and sending them to AppSignal. An `npm` library for catching JavaScript errors is available for that. 

This is a __Beta__ implementation, which means:

* This feature is not yet available for all users.
* Although you should expect few changes, the API may change before public release.

Although this is a beta version, we already use it to monitor errors right here on AppSignal.com! We can say with high confidence that you can safely start using this in your frontend apps today.

## Table of Contents

- [Installation](/front-end/installation.html)
- [Error handling](/front-end/error-handling.html)
- [Integrations](/front-end/integrations/)
  - [React](/front-end/integrations/react.html)
- [Plugins](/front-end/plugins/)
  - [plugin-window-events](/front-end/plugins/plugin-window-events.html)

!> **NOTE:** Uncaught exceptions are **not** captured by default. [Read this section to find out why](/front-end/error-handling.html#uncaught-exceptions). You can enable this functionality by enabling the [`plugin-window-events`](/front-end/plugins/plugin-window-events.html) plugin.

## Creating a Push API Key

Before you begin, you'll need to locate your Push API key. Finding this is easy - look for the ["Push and deploy" section](https://appsignal.com/redirect-to/app?to=info) of your App settings page. You'll be able to find your API key under the "Front-end error monitoring". Once you have your key, follow the instructions under the [Installation](/front-end/installation.html) section to use it in your application.
