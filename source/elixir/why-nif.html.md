---
title: "Why NIF's?"
---

The AppSignal for Elixir integration relies on a NIF to communication with the AppSignal Agent. The agent is a separate Unix process that receives data from an Elixir app through the NIF, normalizes the data and then sends it to AppSignal.com periodically for further processing.

While using NIF's often is a bad idea, using one in this case has several advantages:

1. Overhead is very low. The NIF does nothing more than communicate with the agent, which is a C library that's designed to be as fast as possible while having very little impact on the calling thread.
2. It allows the use of the same agent used by AppSignal for Ruby, which runs on thousands of production servers all over the world. It's battle tested technology, processing a combined 1 billion requests _per day_. The agent is written in Rust, and its primary concerns are robustness and performance.

Internally, the AppSignal NIF works as follows: it fork/execs a separate agent process, to which the NIF sends its data (protobuf) over a Unix socket. This agent process runs in a separate Unix process.

While doing native Elixir protobufs to communicate directly with the agent makes more sense from a BEAM standpoint, using a NIF enables the use of a single library and in turn decreases potential issues. By focusing on a single code base, AppSignal can guarantee the highest quality for all of its customers across all supported languages.
