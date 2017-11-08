---
title: Compile errors on Alpine Linux after upgrading
---

## Affected versions

- AppSignal for Ruby gem versions `2.4.x` and higher.
- AppSignal for Elixir package versions `1.4.x` and higher.
- In combination with hosts running Alpine Linux.

## Description

In order to fix another known issue ([DNS timeouts](dns-timeouts.html)) AppSignal Ruby gem `v2.4.x`, AppSignal Elixir package `v1.4.x`, and higher versions started shipping separate builds for Alpine Linux.

When installing an AppSignal integration, the installer will try to detect the system architecture for which it needs to download the [AppSignal extension](/appsignal/terminology.html#extension). If the detection mismatches the wrong extension build will be downloaded and installed. The installation will fail and AppSignal will not work.

Our Ruby gem will not raise error, but log the problem to the `install.log` file in the `ext/` directory in the AppSignal gem directory.

The Elixir package will raise an error and halt any compilation. See [issue #273](https://github.com/appsignal/appsignal-elixir/issues/273) on the [appsignal-elixir](https://github.com/appsignal/appsignal-elixir/) repo for more details on the specific error.

### Mismatching architecture

This problem occurs because the AppSignal system architecture detection mismatches. It will detect, or fall back on, a [`libc`][libc] build, rather than the [`musl`][musl] build for Alpine Linux.

The AppSignal Ruby gem detects the system architecture by asking the [`ldd`](https://linux.die.net/man/1/ldd) program whether it uses `libc` or `musl`. If `ldd` is not available or not allowed to be called by the user installing the AppSignal Ruby gem, it falls back on the `libc` build.

The AppSignal Elixir package detects the system architecture by asking [Erlang](https://www.erlang.org/)'s [`system_info`](http://erlang.org/doc/man/erlang.html#system_info-1) function for which architecture it has been compiled. If this function returns the wrong architecture type, AppSignal will assume the wrong architecture and try to install it for that architecture.

For Elixir this has been reported with the [bitwalker/alpine-elixir](https://github.com/bitwalker/alpine-elixir) Docker image. This Docker image is based on the [bitwalker/alpine-erlang](https://github.com/bitwalker/alpine-erlang) which reports the wrong system architecture. A [fix was submitted](https://github.com/bitwalker/alpine-erlang/pull/16) to have these newer images from this vendor report the correct system architecture.

## Symptoms

- During installation of AppSignal Ruby gem `v2.4.x` or any higher version, on Alpine Linux the installation will log an error. AppSignal will not report any data for your app.
- During installation of AppSignal for Elixir package `v1.4.x`, or any higher version, on Alpine Linux the installation will exit with an error.

## Solution

There is no permanent solution available, as the problem is not entirely the fault of the AppSignal integrations. See [workaround](#workaround).

If you think the system architecture detection for Ruby or Elixir is incomplete or broken for your system, please [let us know](mailto:support@appsignal.com).

## Workaround

### `APPSIGNAL_BUILD_FOR_MUSL` environment variable

Use the `APPSIGNAL_BUILD_FOR_MUSL` environment variable when compiling your app or installing dependencies. This will force the system architecture detection to pick the `musl` build over the `libc` build.

For more information about support for Alpine Linux, please see our [Operating Systems](/support/operating-systems.html#alpine-linux) page for Alpine Linux.

```sh
# For Ruby
export APPSIGNAL_BUILD_FOR_MUSL=1
gem install appsignal
# or with Bundler
bundle install

# For Elixir
export APPSIGNAL_BUILD_FOR_MUSL=1
mix deps.get
mix compile
```

### Downgrading

It's also possible to downgrade to an older version of the AppSignal Ruby gem or Elixir package. Ruby gem versions `2.1.x` - `2.3.x` and Elixir package `v0.10.x` - `v1.3.x` will use a shared extension build for `libc` and `musl` and no system architecture mismatch can occur.

If you do find it necessary to downgrade to an older AppSignal integration version, please [contact us](mailto:support@appsignal.com) so we can fix your issue.


[blog-gem-2.1]: http://blog.appsignal.com/2017/01/31/gem-2-1.html
[libc]: https://www.gnu.org/software/libc/
[musl]: https://www.musl-libc.org/
