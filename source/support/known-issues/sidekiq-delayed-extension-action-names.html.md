---
title: Action names from Sidekiq's delayed extension are incorrect
---

## Affected components

- AppSignal for Ruby package versions: `v2.4.1` - `v2.5.2`
- Integrations: Sidekiq.

## Description

Sidekiq jobs that are created with the [Sidekiq delayed extension](https://github.com/mperham/sidekiq/wiki/Delayed-extensions) get an unique action name for the incident. Parts of the job arguments are used for the action name, resulting in unique action names. The grouping for incidents fails and a new incident is created per job.

```ruby
UserMailer.delay.welcome_email(@user.id)
```

## Symptoms

An incident is created per Sidekiq job. The action name of the incident includes job arguments.

## Solution

Upgrade to a newer version than `v2.5.2` of the AppSignal for Ruby gem.
