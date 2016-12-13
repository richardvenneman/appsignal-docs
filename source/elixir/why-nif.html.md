---
title: "Why a NIF?"
---

The AppSignal for Elixir integration relies on a NIF that calls out to a library that's written in [Rust](https://www.rust-lang.org) to do the heavy lifting. It's job is to receive data from the Elixir side, normalize and write it to a separate agent process over a Unix socket. The agent then sends the data to AppSignal.com periodically for further processing.

While using NIF's has inherent risks, using one in this case has several advantages:

1. Overhead is very low. The functions in the NIF do nothing more than receiving data and sending it to a worker thread, so that the C function can return immediately. It's designed to be as fast as possible while having very little impact on the calling thread and generating minimal garbage collection load.
2. It allows the use of the same library and agent used by AppSignal for Ruby, which runs on thousands of production servers all over the world. It's battle tested technology, processing a combined 1 billion requests _per day_ at the time of writing.
3. The library and agent are written in Rust, and the primary design considerations were robustness and performance.

Internally, the AppSignal NIF works as follows: it fork/execs a separate agent process, to which a worker thread in the NIF sends its data over a Unix socket. All IO and processing in the NIF is asynchronous so calls to its functions will never hold up the scheduler. In the very unlikely event that something in the extension panics the extension disables itself without bringing down the host process.

While doing native Elixir protobufs to communicate directly with the agent makes more sense from a BEAM standpoint, using a NIF enables the use of a single library and in turn decreases potential issues because of the volume of testing and fine-tuning thas has already happened. By focusing on a single code base, AppSignal can guarantee the highest quality for all of its customers across all supported languages.
