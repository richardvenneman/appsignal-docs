---
title: "Known issues"
---

This page contains a list of publicly documented known issues for AppSignal
integrations. If you're experiencing any of the listed issues, please follow
the described fixes or workarounds. If none are documented, please contact us
at [support@appsignal.com](mailto:support@appsignal.com).

## DNS timeouts

### Affected versions

- AppSignal for Ruby gem versions 2.1.x
- AppSignal for Elixir package versions 0.10.x - 1.x.x

### Description

In version 2.1.0 AppSignal switched to an agent built against the [musl
libc][musl] implementation to [support Alpine Linux][blog-gem-2.1]. Adding
support for Alpine Linux we switched our agent build over to musl libc. A DNS
issue was fixed in musl libc version 1.1.13, which we included in AppSignal for
Ruby gem 2.1.1.

In Ruby gem version 2.1.1 and Elixir package version 0.11.3 we tried to fix the
["ndots" DNS issue][musl-faq-dns] by hardcoding the DNS servers as a temporary
solution. This caused problems with setups that use an private internal network
that does not allow outgoing DNS requests.

### Symptoms

- No data is being received by AppSignal after an upgrade of our integration to
  one of the affected versions.
- No data is being received by AppSignal after an infrastructure change.
- In our log file, `appsignal.log`, timeouts are being reported.
- The application's host is running a non-musl libc system, anything but Alpine
  Linux.
- The `/etc/resolv.conf` configuration file contains entries that contains more
  than four dots, e.g. `namespace.namespace.cluster.two.local`. This is true
  for systems that use [kubernetes] and similar systems for infrastructure
  management.
- The host's (private) network does not allow outgoing DNS requests. You can
  test this by running `dig @8.8.8.8 NS push.appsignal.com` on the host.

### Solution

No known fix available at this time.

We're reverting the hardcoded DNS servers in future releases for our Ruby gem
and Elixir package.

This won't fix the musl libc "ndots" bug, but we will provide a configuration
option for the DNS servers if an application runs into this problem. This
allows a local DNS server can be set manually if musl libc can't read the DNS
configuration of the host.

### Workaround

Allow outgoing DNS requests from within the private network for the machines
that have AppSignal installed.

Revert back to an older AppSignal integration. Recommended versions:

- AppSignal for Ruby gem: 2.0.6.
- AppSignal for Elixir package: 0.9.2.

[blog-gem-2.1]: http://blog.appsignal.com/2017/01/31/gem-2-1.html
[musl]: https://www.musl-libc.org/
[musl-faq-dns]: http://wiki.musl-libc.org/wiki/Functional_differences_from_glibc#Name_Resolver_.2F_DNS
[kubernetes]: https://kubernetes.io/
