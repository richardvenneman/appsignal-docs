---
title: Discord
description: "Learn more about how to set up the AppSignal Discord integration."
---

Discord is the easiest way to communicate over voice, video, and text, whether you’re part of a school club, a nightly gaming group, a worldwide art community, or just a handful of friends that want to hang out.

With this integration you will be able to receive notifications for deploys, errors, performance issues and alerts from AppSignal on Discord.

Website: [Discordapp.com](https://discordapp.com)

## On Discordapp.com

To create a webhook, click the Settings cog for the desired channel and navigate to the "webhooks" section of the settings page.

![Screenshot of Discord webhooks page](/assets/images/screenshots/discord/discord-screenshot1.png)

Click "Create webhook" to add a new webhook. You can use the following icon: [AppSignal logo](/assets/images/screenshots/discord/appsignal-logo-square.png) (right click and save-as).

Copy the webhook URL and save the integration.

## On Appsignal.com

[On AppSignal navigate to the "integrations" page (or click this link).](https://appsignal.com/redirect-to/app?to=notifiers).

Select the "Discord" integration from the "Add integration" dropdown and fill out the form.

Our Discord integration relies on the `slack` compatible webhook endpoint on Discord, for the webhook, paste the webhook from the Discord integration screen **and append** `/slack` to the url.

![Screenshot of Discord notifier page on AppSignal.com](/assets/images/screenshots/discord/discord-screenshot3.png)

Save the integration and when succesfully saved, click the "test hook" button to verify the integration is working.

You are now ready to receive notifications for deploys, errors, performance issues and alerts from AppSignal on Discord!
