---
title: Google Hangouts Chat
---

From direct messages to group conversations, Google Hangouts Chat helps teams collaborate easily and efficiently.

Google Hangouts Chat is a global integration set up per App.

Website: [chat.google.com](https://chat.google.com)

## Adding Google Hangouts Chat to your app

Adding the integration consists of two steps, one on Google Hangouts Chat and one on AppSignal.

### Google Hangouts Chat
Head to the chat options and select "Configure webhooks'

<img src="/assets/images/screenshots/hangouts/hangouts_webhook.png" style="max-width: 650px" alt="Hangouts Webhook">

Fill out the fields, for "Avatar url" we suggest: `https://appsignal.com/assets/appsignal-icon-square.png`

<img src="/assets/images/screenshots/hangouts/hangouts_webhook_configure.png" style="max-width: 650px" alt="Configure Hangouts Webhook">

### AppSignal

On the desired app, head to "Notifiers" and select "Google Hangouts"

<img src="/assets/images/screenshots/hangouts/hangouts_appsignal.png" style="max-width: 650px" alt="Hangouts integration on AppSignal">


Fill out the form and paste the webhook url from step one in the "webhook ur" field. Make sure to pick a descriptive name for the integration such as "#errors channel on Hangouts"

<img src="/assets/images/screenshots/hangouts/hangouts_appsignal_form.png" style="max-width: 650px" alt="Hangouts integration on AppSignal">

You can test the integration after saving the form, a message should appear in your Hangouts chat.

If anything went wrong while validating the integration your will be prompted with the error message.
Feel free [contact us](mailto:support@appsignal.com) if you experience any problems while setting up this integration.
