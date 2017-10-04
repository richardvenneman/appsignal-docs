---
title: "Absinthe <sup>Unoffocial support</sup>"
---

!> **Warning:** Use this solution at your own risk.

-> **Note:** AppSignal for Elixir doesn't officially integrate with Absinthe, please track our progress on adding other integrations in [this GitHub issue](https://github.com/appsignal/appsignal-elixir/issues/176).

We've heard our users ask for support for Absinthe. Although we cannot currently move our focus to Absinthe support we've noticed our normal Plug does not work out-of-the-box for Absinthe apps.


## Problems with Absinthe instrumentation

Absinthe apps in Phoenix do lack a controller and action name registered in the `Plug.Conn` struct, which AppSignal uses to determine the action name of the transaction. When no action name is set on a transaction it's considered invalid and is discarded when the transaction is completed.

## Absinthe Plug

A small fix is required for Absinthe Phoenix apps to set the action name manually for the Absinthe requests. The following plug can be used to set the action name for Absinthe requests. Make sure to specify the correct `request_path` in the `call/2` function.

You'll also be able to configure the action name for these requests yourself by changing the value given to `Appsignal.Transaction.set_action/1`.

!> **Warning**: If AppSignal for Elixir supports Absinthe out-of-the-box in a future release this plug will have to be removed to avoid conflicting action names.

```elixir
# Add this plug to your app
defmodule AppsignalAbsinthePlug do
  alias Appsignal.Transaction

  def init(_), do: nil

  def call(%Plug.Conn{request_path: "/graphql", method: "POST"} = conn, _) do
    Transaction.lookup_or_create_transaction(nil, :http_request)
    |> Transaction.set_action("POST /graphql")

    conn
  end

  def call(conn, _) do
    conn
  end
end
```

Then include the plug in your endpoint file or in your router.

```elixir
# lib/my_app/endpoint.ex
use Appsignal.Phoenix
plug AppsignalAbsinthePlug # Add this line
```
