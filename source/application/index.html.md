---
title: "Applications"
---

Applications (previously known as "sites", also referred to as "apps") are Ruby and Elixir applications monitored by AppSignal. Every application is unique by the combination of its name and environment.

A list of Applications appears on the [Application index] and in the application quick switcher. Every application has a parent [organization](/organization/index.html), which can have multiple applications. (Exception: Organizations created by the Heroku add-on only support one application.)

## Table of Contents

- [Adding applications](#adding-applications)
- [Environments](#environments)
- [Namespaces](namespaces.html)
- [Markers](markers/)
  - [Deploy markers](markers/deploy-markers.html)
  - [Custom markers](markers/custom-markers.html)
- [Settings](settings.html)
- [Link templates](link-templates.html)
- [Integrations (full list)](integrations/)
- [Running multiple applications on one host](#running-multiple-applications-on-one-host)
- [Removing an application](#removing-an-application)

## Adding applications

To add a new Application to AppSignal, please follow the [setup wizard](/getting-started/new-application.html) by pressing the "Add app" button for the organization you wish to add an application to on the [Application index].

AppSignal will detect and register new applications when it receives data from the Application and not before it. Using the [Ruby](/ruby/installation.html) and [Elixir](/elixir/installation.html) installers this should be done automatically. When installing AppSignal manually, please use the demo command line tool ([Ruby](/ruby/command-line/demo.html) / [Elixir](/elixir/command-line/demo.html)) or start your application and perform some requests/jobs.

## Environments

An application can have multiple [environments](/appsignal/terminology.html#environments) as long as every environment uses the same application name. Every environment is currently listed separately on the [Application index].

- "Demo application" - development
- "Demo application" - production
- "Demo application" - staging
- "Demo application" - test

## Namespaces

Namespaces are a way to group error incidents, performance incidents, and host metrics in your app. By default AppSignal provides two namespaces: the "web" and "background" namespaces. You can add your own to separate parts of your app like the API and Admin panel.

Namespaces can be used to group together incidents that are related to the same part of an application. It's also possible to configure notification settings on a per-namespace level.

Read more about [namespaces](namespaces.html) and how to configure them for your app.

## Running multiple applications on one host

When running multiple applications on one host some odd behavior may occur. This is because the default configuration of our AppSignal libraries assume a one application per host setting.

One common problem we've seen is that Applications start reporting under different names and/or environments. Such as an application switching between the staging and production environment after a deploy or restart of an application process or worker.

To allow AppSignal to be used for multiple applications on one host we need to set the `working_directory_path` configuration option ([Ruby](/ruby/configuration/options.html#option-working_directory_path) / [Elixir](/elixir/configuration/options.html#option-working_directory_path)). Using this configuration option, set a working directory path per application so that the AppSignal agent will not stop agents for other Applications that are running.

Read more about the AppSignal [working directory](/appsignal/how-appsignal-operates.html#working-directory).

## Removing an application

An application (app) in AppSignal is the combination of the application name and environment, e.g. "My app - production". You can only delete one environment at a time through the UI.

To remove an app from AppSignal a couple things need to be done to make sure it's removed completely and won't continue to send data to AppSignal's servers.

- First remove the AppSignal integration (Ruby gem / Elixir package) from your app.
- Remove any AppSignal configuration files and system environment variables.
- Redeploy your application. This will make sure the AppSignal servers won't continue to receive data from your app.
  - Make sure all your webservers are restarted.
  - Make sure no `appsignal-agent` processes are running in the background.
- Then, on [AppSignal.com](https://appsignal.com/accounts), open the app you want to delete.
  - Click on "App settings" to open the settings page.
  - Scroll down to the bottom of the page.
  - In the "Delete &lt;app name&gt;" section, click on the "delete &lt;app name&gt;" button and confirm the confirmation prompt.

Your app is now scheduled for deletion. It and all its data will be removed from your organization and our servers. This may take a few minutes, after which it will disappear from your apps list.

**Note**: If your app keeps pushing data, because one or more servers are still pushing app data or host metrics for this app, we will create a new app with the same name and environment. Make sure your servers have restarted and the `appsignal-agent` process is no longer running on any of the hosts.

[Application index]: https://appsignal.com/accounts
