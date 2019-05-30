---
title: Clubhouse
---

Clubhouse describes itself as the first project management platform for software development that brings everyone on every team together to build better products.

The Clubhouse integration is a personal integration, each person with access to an app (who wants to be able to use this feature) has to complete these steps. This integration __does not__ automatically create issues on clubhouse, to prevent story-overload.

Website: [clubhouse.io](https://clubhouse.io/)

## Features

- Create Clubhouse stories for error & performance incidents in AppSignal.
  - On an incident detail page go to the "Issue trackers" box on the right-hand side of the page.
  - Click "Send to Clubhouse"

## Setting up

- Visit your Clubhouse account's API token section: [app.clubhouse.io/settings/account/api-tokens](https://app.clubhouse.io/settings/account/api-tokens)
  - Generate a new API token by entering a name for it, e.g. AppSignal.
  - Click "Generate Token".
  - The generated token will be displayed. Copy it.
    - It will have this format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
- [Visit the AppSignal Clubhouse integration page](https://appsignal.com/redirect-to/app?to=integrations/clubhouse/edit) for the app you want to link.
  - Paste the Clubhouse API token into the "API token" field.
  - Click the "create integration" button.

AppSignal is now set up to use the Clubhouse integration!
