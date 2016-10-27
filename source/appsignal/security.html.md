---
title: "Security overview"
---

These are the things we do at AppSignal to keep your data safe.

## Gem
The Rails gem is a piece of public code, hosted on [GitHub.com](https://github.com/appsignal). You can browse the source yourself to see how we handle data transmission.

Built into the gem is a system that allows you to scrub any data you don't want to send over the wire. See the [documentation](/tweaks-in-your-code/filter-parameter-logging.html) on how to do this. The data is sent trough a secure (SSL) connection to our servers.

## Payment information
Payment is handled through [Stripe](https://stripe.com). We do not store or log any credit card information on our servers. The payment provider is PCI compliant, and all credit card and other payment data is also sent over a secure (SSL) connection.

## The application
AppSignal runs exclusively on secure (SSL) connections and is hosted in a top tier datacenter. The datacenter is monitored 24/7, both physically and virtually. Your data is stored redundantly and any sensitive information is stored in separate databases from other customers and long-term data (e.g. graphs). Our systems are kept up-to-date with the latest security patches and our network is locked down with firewalls and limited access.

## Your data
All the data we collect from your application is yours and can be retrieved at any point in time through our API. (see [the docs](/api/overview.html)). You can remove your data at any time in "App Settings > General".

## Incidents
If you think you've found a security issue with regards to our application or network, please let us know immediately by sending an email to security@appsignal.com.
