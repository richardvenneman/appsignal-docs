---
title: "Anomaly detection"
---

With [Anomaly detection](https://appsignal.com/redirect-to/app?to=alerts) you can configure Triggers to send notifications when a metric value goes over, or dips below, a threshold value. For example: When the error rate of an application goes over 5 % or free memory dips below 100MB.

Anomaly detection works by detecting changes in metric values on a minutely basis. When a threshold condition is reached we will notify you of the newly alert created by this event, and we'll notify you again when the situation no longer occurs.

Sometimes it's good to know immediately when a threshold is reached, at other times it may be good to wait a few minutes before alerting you. For this you can use [warm-ups and cooldowns](#warm-up-and-cooldown).

## Table of Contents

- [Alert states](#alert-states)
- [Triggers](#setting-up-triggers)
  - [Editing triggers](#editing-triggers)
- [Warm-up and cooldown](#warm-up-and-cooldown)
  - [Warm-up](#warm-up)
  - [Cooldown](#cooldown)
- [Data processing](#data-processing)

## Alert states

Alerts can have four different states:

- **Warming up** means that this Alert is in its warm-up phase. You can configure this per Trigger. It allows you to wait for a condition to be true for a few minutes before you get alerted.
- **Ongoing** means that this Alert is active. Its threshold condition is currently reached.
- **Cooling down** means that an Alert is not over the threshold condition anymore, but will not be closed until the cooldown duration is over. If it reaches its threshold again within the cooldown period, it will move back to the "ongoing" status.
- **Closed** means the Alert is not ongoing and not in the cooling down period. We don't call them "solved" because you still might want to look at what happened here.

    <img src="/assets/images/anomaly_detection_alerts_flow.svg" class="full">

### When will I be notified?

After you've configured notifications, you will be notified when an alert goes into the ongoing phase, for reminders you set up during that phase, and when it's closed again.

### Email alerts

In each email you receive about any alert, we'll send you a full overview of all your alerts. You'll see an overview of new alerts, reminders, ongoing alerts and closed alerts.

## Setting up triggers

Anomaly detection can be configured per app in the ["Anomaly detection" section](https://appsignal.com/redirect-to/app?to=alerts) in the app navigation. By default you will see the latest alerts created by triggers that you've configured for the app.

In the top navigation you can switch to the [triggers page](https://appsignal.com/redirect-to/app?to=triggers) to create new and edit existing triggers.

Triggers can be configured for a variety of metrics, such as, but not limited to:

- Error rates
- Error (absolute) counts
- App throughput
- Performance of actions (slow actions)
- Queue time
- Host metrics
  - CPU load
  - Disk I/O
  - Disk usage
  - Load averages
  - Memory usage
  - Network usage

### Editing triggers

Created Alerts are based on a certain threshold condition from a Trigger. When the Trigger configuration changes, the linked alerts no longer match with the parent Trigger. For this reason it's not possible to directly edit a Trigger's configuration.

Instead, when editing a Trigger, a new Trigger with the new configuration is created while the old Trigger and its linked Alerts are archived. Currently, archived Triggers and Alerts are not visible in the AppSignal web interface.

## Warm-up and cooldown

Warm-up and cooldown settings can be configured on a per Trigger basis. The setting allows you to configure the amount of minutes the system waits before opening an Alert and closing it.

### Warm-up

When a threshold condition is met an Alert is opened, e.g. the error rate is higher than 5%.

When a warm-up duration is configured for a trigger it will wait with opening the alert until after the warm-up time has passed. The threshold condition needs to be met for the entire warm-up duration before the alert is opened.

When an alert's threshold condition is not met for the entire duration of the warm-up time, and thus not opened, the alert is removed. It will also not show as a closed alert in the [alerts table](https://appsignal.com/redirect-to/app?to=alerts). This is to avoid noise in the table from unopened alerts.

Alerts that have only entered the warm-up phase are visible in the AppSignal web interface, but no notification will be send for these alerts.

### Cooldown

When an Alert is opened by a Trigger it will automatically close when the Trigger threshold condition is no longer reached. When the threshold is reached again it will open another Alert. This may result in more notifications than wanted.

In order to not get overwhelmed with notifications about a Trigger threshold condition that constantly dips below and above a certain value you can use Trigger cooldowns.

Triggers with cooldowns wait for the specified amount of time in minutes before closing an Alert. When it doesn't occur again in the cooldown time the Alert is finally closed. If it does occur, the Alert is reopened without an explicit notification.

## Data processing

The metrics used by triggers to create alerts are not instantly processed when the metrics are sent in the app. The metrics data goes through multiple systems before it arrives in our processor. The data may also need to be sent from multiple servers, [sending data at different intervals](/appsignal/how-appsignal-operates.html#agent). The processor then waits* until all the data for a minute has arrived before processing that data and creating/updating alerts.

If you experience problems with the metrics being reported by AppSignal for Anomaly detection, make sure the app's servers are all reporting the same time by configuring them using [NTP](https://en.wikipedia.org/wiki/Network_Time_Protocol). Incorrect or different reported times for data sent by multiple app servers can result in Alerts never being opened or closed.

Learn more about how AppSignal processes data for Anomaly detection and what this means for the alerts on the [data life cycle page][data life cycle].

*: For the specific wait time, consult our [data life cycle page][data life cycle].

[data life cycle]: /appsignal/data-life-cycle.html
