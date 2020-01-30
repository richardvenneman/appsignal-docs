---
title: "Incident notification settings"
---

Whenever AppSignal detects a new exception or performance issue, we open an incident. You can find the incidents under the "Errors" and "Performance" tabs in the app.

You can be notified whenever we detect a new incident, or new instances of an already existing incident. Notifications can happen by email or by one of our [many integrations](/application/integrations/).


## Notification options.

There are four options for notification settings:

* **Every occurrence**. A notification is sent every time an incident is triggered (see below for what triggers an incident in case of a performance/exception incident). With a cooldown of 5 minutes, meaning if an incident is triggered 20 times a minute, for 20 minutes, you'll receive a notification on minute 0, 5, 10, 15 and 20.

* **First in deploy**. A notification is sent at the first occurrence of an incident after a new deploy marker is received. You'll need to setup [deploy markers](/application/markers/deploy-markers.html) to trigger notifications.

* **First after close**. A notification is sent at the first occurrence of an incident after the incident was previously closed. You can open/close an incident in the sidebar, just above the notification settings. This option is usually used for incidents that aren't triggered by a code bug (e.g. 3rd party has an issue) and can't be closed by deploying a new version of the app.

* **Never notify**. We never send out a notification if the incident occurs. Mostly used for exceptions that happen and you'd like to keep track of, but aren't fixing soon.

If an incident was closed, it will be reopend when a new notification is sent out.

## Performance incident notification settings

Performance incidents are identified by their "action" name, such as `BlogpostsController#show`.

Once we detect a new action we create an incident for it. At this point you can override the default notification settings and change when you'd like to be notified and what threshold the duration of the performance incident has to reach before a notification is sent.

E.g. for actions where response times can be slow, because they interact with 3rd parties, you can set the duration threshold to 10 seconds, while for the homepage you can set a threshold of 200 miliseconds.

The thresold filter is used in combination with the notification settings. E.g. if you have **First in deploy** and **200ms** as the notification settings and threshold, an incident occurrence has to satisfy both in order for a notification to be sent out.

![Performance incident notification options](/assets/images/screenshots/performance_incident_notification_options.png)


## Exception incident notification settings

Exception incidents are identified by the exception (class)name, such as `ActiveRecord::RecordNotFound` and if the exception happened inside of an action, the action name. (e.g. `StandardError` in `BlogpostsController#show`).

![Exception incident notification options](/assets/images/screenshots/exception_incident_notification_options.png)


## Organization and namespace defaults

As described above, you can only adjust the notification settings of an incident after it has occurred at least once. This can be an issue if you never want to be notified, or want ot set a different performance incident threshold than the default 200ms.

To solve this, you can setup defaults per namespace or even for the entire organization.


### Namespace defaults

For each application you can set [namespace defaults](https://appsignal.com/redirect-to/app?to=notifications). Any new incident in the specified namespace will inherit the default settings set on this screen. It's recommended to split up the application in [namespaces](/application/namespaces.html) that group potential incidents by severity. For example webhooks that fail often, you could create a namespace called `webhooks` with a notification setting of "Never notify" as errors here can be expected noise.

![Exception incident notification defaults](/assets/images/screenshots/exception_incident_notification_defaults.png)


### Organization defaults

You can also set the [notification setting defaults](https://appsignal.com/redirect-to/organization?to=admin/notifications/edit) on an organization level. We allow you to set defaults for each namespace detected in any of the applications in your organization.


![Performance incident notification defaults](/assets/images/screenshots/performance_incident_notification_defaults.png)

## Notification settings inheritance.

The notification settings bubble up from the incident settings > namespace settings > organization settings, if the settings aren't changed the defaults are used for the namespace or organization.

* For an incident without any namespace overrides, the incident will use the organization settings.
* For an incident in an app with namespace defaults, the incident will use the namespace defaults.
* For an incident with incident settings, the incident setting is used.
